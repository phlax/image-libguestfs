#!/bin/bash -e

NAME="$1"
COMMIT_HASH="$2"
TARGET="${3:-/home/pyuser}"

. ./install

TARGET_FILENAME="${COMMIT_HASH}_${NAME}.qcow2"
TARGET_FILE="${TARGET}/${TARGET_FILENAME}"
TARGET_HASH_FILE="${TARGET}/hash"

echo "Customizing virtual image (${NAME}): ${COMMIT_HASH} ..."

if [[ -n "$RESIZE" ]]; then
    echo "Resizing image -> ${RESIZE}"
    qemu-img resize src.qcow2 "$RESIZE"
    RESIZE_ARGS=(
        --run-command 'growpart /dev/sda 1'
        --run-command 'resize2fs /dev/sda1')
    ls -lh src.qcow2
fi

if [[ -n "$DEBUG" ]]; then
    DEBUG_ARGS=(-v -x)
fi

echo "Customizing image: src.qcow2 ..."
virt-customize \
    "${DEBUG_ARGS[@]}" \
    -a src.qcow2 \
    "${RESIZE_ARGS[@]}" \
    "${VIRT_CUSTOMIZE_ARGS[@]}" \
    --run "/cleanup.sh"
ls -lh src.qcow2

echo "Squashing qcow2: ${TARGET_FILE} ..."
# qemu-img convert -O qcow2 -c src.qcow2 "$TARGET_FILE"

virt-sparsify --compress src.qcow2  "$TARGET_FILE"
ls -lh "$TARGET_FILE"

rm src.qcow2
