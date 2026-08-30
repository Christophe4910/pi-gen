#!/bin/bash
echo "########## CASTEO DIAG (chroot) ##########"
echo "### [6] id _apt ###"; id _apt 2>&1
echo "### [7] apt-config (trusted/keyring/signed) ###"; apt-config dump 2>&1 | grep -iE "trusted|keyring|signed"
echo "### [10] _apt peut-il LIRE les keyrings ? (runuser, AUCUNE modif) ###"
for k in /usr/share/keyrings/debian-archive-keyring.gpg /etc/apt/trusted.gpg.d/*.gpg; do
  [ -e "$k" ] || continue
  if runuser -u _apt -- test -r "$k" 2>/dev/null; then echo "_apt LISIBLE   : $k"; else echo "_apt NON-LISIBLE: $k"; fi
done
echo "### clés dans debian-archive-keyring.gpg ###"
gpg --no-default-keyring --keyring /usr/share/keyrings/debian-archive-keyring.gpg --list-keys 2>&1 | grep -iE "^pub|6ED0E7|54404762|debian"
echo "### keyrings debian dans /etc/apt/trusted.gpg.d/ ? ###"
ls -la /etc/apt/trusted.gpg.d/ 2>&1
echo "########## FIN DIAG chroot ##########"
