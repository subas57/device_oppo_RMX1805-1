if [ -d /sbin/.magisk ]; then
  MAGISKTMP=/sbin/.magisk
else
  MAGISKTMP=`find /dev -mindepth 2 -maxdepth 2 -type d -name .magisk`
fi
if [ -d $MAGISKTMP/mirror/system_root ]; then
  SYSTEM=$MAGISKTMP/mirror/system_root
else
  SYSTEM=$MAGISKTMP/mirror/system
fi
MFX=$MAGISKTMP/mirror/system/etc/vintf/manifest.xml
mount -o rw,remount $SYSTEM
mv -f $MFX.orig $MFX
mount -o ro,remount $SYSTEM

UIAPK=DolbyAtmos
SERVAPK=DolbyService
PKGCACHE=/data/system/package_cache
rm -f `find /data/dalvik-cache -type f -name *$UIAPK*`
rm -f `find /data/dalvik-cache -type f -name *$SERVAPK*`
rm -f `find $PKGCACHE -type f -name $UIAPK*`
rm -f `find $PKGCACHE -type f -name $SERVAPK*`
rm -f `find $PKGCACHE -type f -name com.dolby.daxappui*`
rm -f `find $PKGCACHE -type f -name com.dolby.daxservice*`
rm -rf /data/vendor/dolby

