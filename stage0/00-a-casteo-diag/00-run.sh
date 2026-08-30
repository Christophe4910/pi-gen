#!/bin/bash
echo "########## CASTEO DIAG (host) — ROOTFS_DIR=${ROOTFS_DIR} ##########"
echo "### [1] ls -la /etc/apt/trusted.gpg.d/ ###"
ls -la "${ROOTFS_DIR}/etc/apt/trusted.gpg.d/" 2>&1
echo "### [2] ls -la /usr/share/keyrings/ ###"
ls -la "${ROOTFS_DIR}/usr/share/keyrings/" 2>&1
echo "### [3-5] stat debian-archive-keyring.gpg ###"
stat "${ROOTFS_DIR}/usr/share/keyrings/debian-archive-keyring.gpg" 2>&1
echo "### [8-9] sources APT ###"
ls -la "${ROOTFS_DIR}/etc/apt/sources.list" 2>&1
ls -la "${ROOTFS_DIR}/etc/apt/sources.list.d/" 2>&1
echo "--- sources.list ---"; cat "${ROOTFS_DIR}/etc/apt/sources.list" 2>&1
echo "--- sources.list.d/* ---"
for f in "${ROOTFS_DIR}"/etc/apt/sources.list.d/*; do echo ">>> $f"; cat "$f" 2>&1; done
echo "--- recherche Signed-By / deb.debian.org dans /etc/apt ---"
grep -rIn "Signed-By\|deb.debian.org" "${ROOTFS_DIR}/etc/apt/" 2>&1
echo "########## FIN DIAG host ##########"
