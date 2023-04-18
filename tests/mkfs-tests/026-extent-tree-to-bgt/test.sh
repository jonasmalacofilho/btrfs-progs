#!/bin/bash
# Test back and forth conversion from extent tree to block-group-tree

source "$TEST_TOP/common"

setup_root_helper
prepare_test_dev

run_check_mkfs_test_dev -O ^block-group-tree
run_check_mount_test_dev
run_check $SUDO_HELPER dd if=/dev/zero of="$TEST_MNT"/file bs=1M count=1
run_check_umount_test_dev

run_check "$TOP/btrfs" inspect-internal dump-tree "$TEST_DEV"
run_check "$TOP/btrfs" inspect-internal dump-super "$TEST_DEV"
run_check "$TOP/btrfstune" --enable-block-group-tree "$TEST_DEV"
_log "=== AFTER CONVERSION ==="
run_check "$TOP/btrfs" inspect-internal dump-tree "$TEST_DEV"
run_check "$TOP/btrfs" inspect-internal dump-super "$TEST_DEV"
run_check "$TOP/btrfs" check "$TEST_DEV"
_log "=== BACK CONVERSION ==="
run_check "$TOP/btrfstune" --disable-block-group-tree "$TEST_DEV"
run_check "$TOP/btrfs" inspect-internal dump-tree "$TEST_DEV"
run_check "$TOP/btrfs" inspect-internal dump-super "$TEST_DEV"
run_check "$TOP/btrfs" check "$TEST_DEV"
