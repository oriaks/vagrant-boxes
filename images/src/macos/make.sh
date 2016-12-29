#!/bin/sh

###

#SOURCE='/Applications/Install macOS Sierra.app'
SOURCE='/Applications/Install macOS Sierra.app/Contents/SharedSupport/InstallESD.dmg'

#TARGET='/dev/disk0'
#TARGET="../../macos-10.12-amd64.dmg"
TARGET="../../macos-10.12-amd64.iso"

###

if ! which hdiutil; then
  echo "Requires macOS"
  exit 1
fi

if [ -f "${SOURCE}/Contents/SharedSupport/InstallESD.dmg" ]; then
  SOURCE="${SOURCE}/Contents/SharedSupport/InstallESD.dmg"
elif [ ! -f "${SOURCE}" ]; then
  exit 1
fi

if [ -b "${TARGET}" ]; then
  TARGET_TYPE='dev'
elif [ "${TARGET##*.}" = 'dmg' ]; then
  TARGET_TYPE='dmg'
  TARGET_NAME=`basename "${TARGET}" .dmg`
elif [ "${TARGET##*.}" = 'iso' ]; then
  TARGET_TYPE='iso'
  TARGET_NAME="$(basename '${TARGET}' .iso)"
else
  exit 1
fi

SOURCE_VOLNAME='OS X Install ESD'
TARGET_VOLNAME='OS X Base System'

TMPDIR=`mktemp -d -t "macos-installer"`
TMPDST="${TMPDIR}/${TARGET_NAME}"

PKG_ROOT="${TMPDIR}/vagrant-package/root"
PKG_SCRIPTS="${TMPDIR}/vagrant-package/scripts"
PKG_COMPONENT="${TMPDIR}/Vagrant.component.pkg"

cp 'rc.cdrom.local' "${TMPDIR}/"
cp 'minstallconfig.xml' "${TMPDIR}/"
cp 'OSInstall.collection' "${TMPDIR}/"
cp -rp 'vagrant-package' "${TMPDIR}/"

SOURCE_VOLUME=`hdiutil attach "${SOURCE}" -nobrowse -noverify -readonly | grep 'Apple_HFS' | cut -f 3-`
if [ "${TARGET_TYPE}" = 'dev' ]; then
  diskutil eraseDisk HFS+ "${TARGET_VOLNAME}" "${TARGET}"
  TARGET_VOLUME=`hdiutil attach "${TARGET}" | grep 'Apple_HFS' | cut -f 3-`
else
  hdiutil create -fs HFS+J -layout SPUD -size 8g -type SPARSE -volname "${TARGET_VOLNAME}" "${TMPDST}"
  TARGET_VOLUME=`hdiutil attach "${TMPDST}.sparseimage" -nobrowse -noverify | grep 'Apple_HFS' | cut -f 3-`
fi
PKG_PRODUCT="${TARGET_VOLUME}/System/Installation/Packages/Vagrant.pkg"

asr restore -erase -noprompt -noverify -source "${SOURCE_VOLUME}/BaseSystem.dmg" -target "${TARGET_VOLUME}"
rm -f "${TARGET_VOLUME}/System/Installation/Packages"
cp -rp "${SOURCE_VOLUME}/Packages" "${TARGET_VOLUME}/System/Installation/"
cp "${SOURCE_VOLUME}/BaseSystem.chunklist" "${TARGET_VOLUME}/"
cp "${SOURCE_VOLUME}/BaseSystem.dmg" "${TARGET_VOLUME}/"

cp "${TMPDIR}/rc.cdrom.local" "${TARGET_VOLUME}/etc/rc.cdrom.local"
chmod +x "${TARGET_VOLUME}/etc/rc.cdrom.local"

mkdir -p "${TARGET_VOLUME}/System/Installation/Packages/Extras"
cp "${TMPDIR}/minstallconfig.xml" "${TARGET_VOLUME}/System/Installation/Packages/Extras/minstallconfig.xml"
cp "${TMPDIR}/OSInstall.collection" "${TARGET_VOLUME}/System/Installation/Packages/OSInstall.collection"

chmod -R +x "${PKG_SCRIPTS}"
pkgbuild --identifier com.vagrantup.config --nopayload --root "${PKG_ROOT}" --scripts "${PKG_SCRIPTS}" --version 1 "${PKG_COMPONENT}"
productbuild --package "${PKG_COMPONENT}" "${PKG_PRODUCT}"

hdiutil detach "${SOURCE_VOLUME}"
hdiutil detach "${TARGET_VOLUME}"

if [ ! "${TARGET_TYPE}" = 'dev' ]; then
  hdiutil compact "${TMPDST}.sparseimage"
  hdiutil resize -size min "${TMPDST}.sparseimage"
  if [ "${TARGET_TYPE}" = 'dmg' ]; then
    hdiutil convert "${TMPDST}.sparseimage" -format UDZO -o "${TMPDST}"
    mv "${TMPDST}.dmg" "${TARGET}"
  elif [ "${TARGET_TYPE}" = 'iso' ]; then
    hdiutil convert "${TMPDST}.sparseimage" -format UDTO -o "${TMPDST}"
    hdiutil makehybrid -o "${TMPDST}.iso" "${TMPDST}.cdr"
    mv "${TMPDST}.iso" "${TARGET}"
  fi
fi

rm -rf "${TMPDIR}"
