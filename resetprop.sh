#!/bin/sh

IMG=$1
MNT=/mnt/system
mkdir $MNT
resize2fs "$IMG" 10G
e2fsck -E unshare_blocks "$IMG"
mount -t ext4 -o loop,rw "$IMG" $MNT
cp resetprop_phh $MNT/system/bin/
chown 0:2000 $MNT/system/bin/resetprop_phh
chmod 0755 $MNT/system/bin/resetprop_phh
chcon u:object_r:system_file:s0 $MNT/system/bin/resetprop_phh
umount $MNT
echo -e "set_super_value last_mounted /\nquit" | debugfs -w "$IMG"
e2fsck -fy "$IMG"
resize2fs -M "$IMG"
