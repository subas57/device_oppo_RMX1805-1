ui_print " "

# check magisk manager
if [ "$BOOTMODE" != true ]; then
  ui_print "- Please flash via Magisk Manager only!"
  abort
fi

# check android
if [ "$API" -lt 28 ]; then
  ui_print "- ! Unsupported sdk: $API. You have to upgrade your"
  ui_print "    Android version at least Pie SDK API 28 to use this"
  ui_print "    module."
  abort
else
  ui_print "- Device SDK: $API"
  ui_print " "
fi

# 32 bit
if [ "$IS64BIT" != true ]; then
  ui_print "- Adjusting for 32 bit device..."
  rm -rf `find $MODPATH/system -type d -name *64`
  ui_print " "
fi

# cleaning
ui_print "- Cleaning..."
UIAPK=DolbyAtmos
SERVAPK=DolbyService
PKGCACHE=/data/system/package_cache
rm -f `find /data/dalvik-cache -type f -name *$UIAPK*`
rm -f `find /data/dalvik-cache -type f -name *$SERVAPK*`
rm -f `find $PKGCACHE -type f -name $UIAPK*`
rm -f `find $PKGCACHE -type f -name $SERVAPK*`
rm -f `find $PKGCACHE -type f -name com.dolby.daxappui*`
rm -f `find $PKGCACHE -type f -name com.dolby.daxservice*`
ui_print " "

# setting permission, owner, and se context
ui_print "- Setting permission, owner, and se context..."
SERVICE=vendor.dolby.hardware.dms@1.0-service
chmod 0755 $MODPATH/system/vendor/bin/hw/$SERVICE
chown -R 0.2000 $MODPATH/system/vendor
chown 0.0 `find $MODPATH/system/vendor -type f -name *.xml`
chown 0.0 `find $MODPATH/system/vendor -type f -name *.so`
chcon -R u:object_r:vendor_file:s0 $MODPATH/system/vendor
chcon -R u:object_r:vendor_configs_file:s0 $MODPATH/system/vendor/etc
# actually, below is not needed
# chcon u:object_r:hal_dms_default_exec:s0 $MODPATH/system/vendor/bin/hw/$SERVICE
ui_print " "

# patch manifest.xml
MFX=${MAGISKTMP}/mirror/system/etc/vintf/manifest.xml
if [ -d ${MAGISKTMP}/mirror/system_root ]; then
  SYSTEM=${MAGISKTMP}/mirror/system_root
else
  SYSTEM=${MAGISKTMP}/mirror/system
fi
if ! grep -Eq "@1.0::IDms/default" $MFX; then
  ui_print "- Patching $MFX"
  ui_print "  directly..."
  mount -o rw,remount $SYSTEM
  cp -f $MFX $MFX.orig
  sed -i '$d' $MFX
  echo '    <hal format="hidl">' >> $MFX
  echo '        <name>vendor.dolby.hardware.dms</name>' >> $MFX
  echo '        <transport>hwbinder</transport>' >> $MFX
  echo '        <version>1.0</version>' >> $MFX
  echo '        <interface>' >> $MFX
  echo '            <name>IDms</name>' >> $MFX
  echo '            <instance>default</instance>' >> $MFX
  echo '        </interface>' >> $MFX
  echo '        <fqname>@1.0::IDms/default</fqname>' >> $MFX
  echo '    </hal>' >> $MFX
  echo '</manifest>' >> $MFX
  mount -o ro,remount $SYSTEM
  ui_print " "
else
  ui_print "- $MFX"
  ui_print "  is already patched."
  ui_print " "
  if [ -f $MFX.bak ]; then
    ui_print "- Renaming manifest.xml.bak to manififest.xml.orig..."
    mount -o rw,remount $SYSTEM
    mv -f $MFX.bak $MFX.orig
    mount -o ro,remount $SYSTEM
    ui_print " "
    ui_print "- If you encounter Dolby force close, reinstall again!"
    ui_print " "
  fi
fi

# attention
ui_print "- Rei Ryuki the Fixer"
ui_print " "

