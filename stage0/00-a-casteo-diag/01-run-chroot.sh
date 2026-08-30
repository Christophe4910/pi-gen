#!/bin/bash
set +e   # DIAGNOSTIC : ne jamais abort, quoi qu'il arrive
echo "########## CASTEO DIAG (chroot, rootfs=/) ##########"
echo "### [1] ls -la /etc/apt/trusted.gpg.d/ ###"; ls -la /etc/apt/trusted.gpg.d/ 2>&1
echo "### [2] ls -la /usr/share/keyrings/ ###"; ls -la /usr/share/keyrings/ 2>&1
echo "### [3-5] stat debian-archive-keyring.gpg ###"; stat /usr/share/keyrings/debian-archive-keyring.gpg 2>&1
echo "### [6] id _apt ###"; id _apt 2>&1
echo "### [7] apt-config (trusted/keyring/signed) ###"; apt-config dump 2>&1 | grep -iE "trusted|keyring|signed"; echo "(fin apt-config)"
echo "### [8-9] sources APT ###"; ls -la /etc/apt/sources.list /etc/apt/sources.list.d/ 2>&1
echo "--- sources.list ---"; cat /etc/apt/sources.list 2>&1
echo "--- sources.list.d/* ---"; for f in /etc/apt/sources.list.d/*; do echo ">>> $f"; cat "$f" 2>&1; done
echo "--- Signed-By / deb.debian.org dans /etc/apt ---"; grep -rIn "Signed-By\|deb.debian.org" /etc/apt/ 2>&1; echo "(fin grep sources)"
echo "### [10] _apt peut-il LIRE les keyrings ? (runuser test -r, AUCUNE modif) ###"
for k in /usr/share/keyrings/debian-archive-keyring.gpg /etc/apt/trusted.gpg.d/*.gpg; do
  [ -e "$k" ] || continue
  if runuser -u _apt -- test -r "$k" 2>/dev/null; then echo "_apt LISIBLE    : $k"; else echo "_apt NON-LISIBLE : $k"; fi
done
echo "### clés dans debian-archive-keyring.gpg (si gpg présent) ###"
if command -v gpg >/dev/null 2>&1; then gpg --no-default-keyring --keyring /usr/share/keyrings/debian-archive-keyring.gpg --list-keys 2>&1 | grep -iE "^pub|6ED0E7|54404762"; else echo "(gpg absent au stage0)"; fi
echo "########## FIN CASTEO DIAG ##########"
exit 0
