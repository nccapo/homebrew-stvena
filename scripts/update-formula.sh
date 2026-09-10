#!/usr/bin/env bash
#
# Point Formula/stvena.rb at a stvena release.
#
#   scripts/update-formula.sh            # latest non-prerelease
#   scripts/update-formula.sh v0.1.4     # a specific tag
#
# Checksums come from the checksums.txt published with the release, so the
# formula never carries a hash this script computed itself.

set -euo pipefail

repo="nccapo/stvena"
formula="$(cd "$(dirname "$0")/.." && pwd)/Formula/stvena.rb"
archives="stvena_darwin_arm64.tar.gz stvena_darwin_amd64.tar.gz stvena_linux_arm64.tar.gz stvena_linux_amd64.tar.gz"

tag="${1:-}"
if [[ -z "${tag}" ]]
then
  tag="$(curl -fsSL -H "Accept: application/vnd.github+json" \
    "https://api.github.com/repos/${repo}/releases/latest" |
    sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -n 1)"
fi
[[ -n "${tag}" ]] || {
  echo "update-formula: could not determine the release tag" >&2
  exit 1
}
case "${tag}" in v*) ;; *) tag="v${tag}" ;; esac

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT HUP INT TERM

echo "Updating $(basename "${formula}") to ${tag}"
curl -fsSL --retry 3 "https://github.com/${repo}/releases/download/${tag}/checksums.txt" -o "${work}/checksums.txt"

for archive in ${archives}
do
  sum="$(awk -v file="${archive}" '$2 == file { print $1 }' "${work}/checksums.txt")"
  if [[ -z "${sum}" ]]
  then
    echo "update-formula: ${tag} has no checksum for ${archive}" >&2
    exit 1
  fi
  printf '%s %s\n' "${archive}" "${sum}" >>"${work}/sums"
  echo "  ${archive}  ${sum}"
done

awk -v tag="${tag}" -v sums="${work}/sums" '
  BEGIN {
    while ((getline line < sums) > 0) {
      split(line, f, " ")
      sha[f[1]] = f[2]
    }
  }
  /^ *url "https:\/\/github.com\/nccapo\/stvena\/releases\/download\// {
    match($0, /stvena_[a-z0-9]+_[a-z0-9]+\.tar\.gz/)
    pending = substr($0, RSTART, RLENGTH)
    sub(/\/download\/v[^\/]+\//, "/download/" tag "/")
    print
    next
  }
  /^ *sha256 "/ && pending != "" {
    match($0, /^ */)
    print substr($0, RSTART, RLENGTH) "sha256 \"" sha[pending] "\""
    pending = ""
    next
  }
  { print }
' "${formula}" >"${work}/stvena.rb"

# Every archive must have been rewritten, or the formula layout drifted.
for archive in ${archives}
do
  sum="$(awk -v file="${archive}" '$1 == file { print $2 }' "${work}/sums")"
  grep -q "\"${sum}\"" "${work}/stvena.rb" || {
    echo "update-formula: ${archive} was not updated; check the formula layout" >&2
    exit 1
  }
done

mv "${work}/stvena.rb" "${formula}"
echo "Formula now tracks ${tag}"
