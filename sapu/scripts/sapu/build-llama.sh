#!/usr/bin/env bash

set -euo pipefail

log()   { printf "\033[1;34minfo    \033[0m %s\n" "$*"; }
error() { printf "\033[1;31merror   \033[0m %s\n" "$*" >&2; }

ARCHIVE="${1:?Path to llama.cpp source archive is required}"
WORKERS="${2:-32}"
ARCHITECTURES="${CUDA_ARCHITECTURES:-100}"
SOURCE="$(realpath -ms -- "${LLAMA_SOURCE_DIR:-${HOME}/git/llama.cpp}")"
BUILD="${SOURCE}/build"

if [[ "$SOURCE" == / || "$SOURCE" == "$(realpath -ms -- "$HOME")" ]]; then
    error "refusing to replace $SOURCE"
    exit 1
fi

if [[ ! -f "$ARCHIVE" ]]; then
    error "source archive not found: $ARCHIVE"
    exit 1
fi

ARCHIVE="$(cd "$(dirname "$ARCHIVE")" && pwd)/$(basename "$ARCHIVE")"

log "loading CUDA..."
module load cuda
export LD_LIBRARY_PATH="$CUDA_HOME/lib64:${LD_LIBRARY_PATH:-}"

mkdir -p "$(dirname "$SOURCE")"
TEMP_SOURCE="$(mktemp -d "$(dirname "$SOURCE")/.llama.cpp.XXXXXXXX")"
trap 'rm -rf "$TEMP_SOURCE"' EXIT

log "unpacking llama.cpp..."
tar -xzf "$ARCHIVE" --strip-components=1 -C "$TEMP_SOURCE"
rm -rf -- "$SOURCE"
mv -- "$TEMP_SOURCE" "$SOURCE"

log "configuring llama.cpp for CUDA architectures $ARCHITECTURES..."
cmake -S "$SOURCE" -B "$BUILD" \
    -DGGML_CUDA=ON \
    -DGGML_NATIVE=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CUDA_ARCHITECTURES="$ARCHITECTURES"

log "building llama.cpp..."
cmake --build "$BUILD" --config Release -j "$WORKERS"
log "llama.cpp binaries are in ${BUILD}/bin"
