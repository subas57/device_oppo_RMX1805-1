if [ -d /sbin/.magisk ]; then
  MAGISKTMP=/sbin/.magisk
else
  MAGISKTMP=`find /dev -mindepth 2 -maxdepth 2 -type d -name .magisk`
fi
MFX=$MAGISKTMP/mirror/system/etc/vintf/manifest.xml
if ! grep -Eq "@1.0::IDms/default" $MFX; then
  if [ -d $MAGISKTMP/mirror/system_root ]; then
    SYSTEM=$MAGISKTMP/mirror/system_root
  else
    SYSTEM=$MAGISKTMP/mirror/system
  fi
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
fi

MODDIR=${0%/*}
ACDB=/data/adb/modules/acdb
rm -f `find $MODDIR/system -type f -name *audio*effects*`
if [ ! -d $ACDB ] || [ -f $ACDB/disable ]; then
  NAME=dap
  LIBPATH="\/vendor\/lib\/soundfx"
  LIB=libswdap.so
  UUID=9d4921da-8225-4f29-aefa-39537a04bcaa
  ETC=$MAGISKTMP/mirror/system/etc
  VETC=$MAGISKTMP/mirror/vendor/etc
  AEC=`find $ETC -type f -name *audio*effects*.conf`
  VAEC=`find $VETC -type f -name *audio*effects*.conf`
  AEX=`find $ETC -type f -name *audio*effects*.xml`
  VAEX=`find $VETC -type f -name *audio*effects*.xml`
  METC=$MODDIR/system/etc
  MVETC=$MODDIR/system/vendor/etc
  cp -f $AEC $METC
  cp -f $VAEC $MVETC
  cp -f $AEX $METC
  cp -f $VAEX $MVETC
  MAEC=`find $MODDIR/system -type f -name *audio*effects*.conf`
  MAEX=`find $MODDIR/system -type f -name *audio*effects*.xml`
  sed -i "s/^libraries {/libraries {\n  $NAME {\n    path $LIBPATH\/$LIB\n  }/" $MAEC
  sed -i "s/^effects {/effects {\n  $NAME {\n    library $NAME\n    uuid $UUID\n  }/" $MAEC
  sed -i "/^        ring_helper {/ {;N s/        ring_helper {\n        }/#        ring_helper {\n#        }/}" $MAEC
  sed -i "/^        alarm_helper {/ {;N s/        alarm_helper {\n        }/#        alarm_helper {\n#        }/}" $MAEC
  sed -i "/^        music_helper {/ {;N s/        music_helper {\n        }/#        music_helper {\n#        }/}" $MAEC
  sed -i "/^        voice_helper {/ {;N s/        voice_helper {\n        }/#        voice_helper {\n#        }/}" $MAEC
  sed -i "/^        notification_helper {/ {;N s/        notification_helper {\n        }/#        notification_helper {\n#        }/}" $MAEC
  sed -i "1,/^    <\/libraries>/s/^    <\/libraries>/        <library name=\"$NAME\" path=\"$LIB\"\/>\n    <\/libraries>/" $MAEX
  sed -i "1,/^    <\/effects>/s/^    <\/effects>/        <effect name=\"$NAME\" library=\"$NAME\" uuid=\"$UUID\"\/>\n    <\/effects>/" $MAEX
  sed -i "1,/^            <apply effect=\"ring\_helper\"\/>/s/^            <apply effect=\"ring\_helper\"\/>/            <!-- apply effect=\"ring\_helper\"\/ -->/" $MAEX
  sed -i "1,/^            <apply effect=\"alarm\_helper\"\/>/s/^            <apply effect=\"alarm\_helper\"\/>/            <!-- apply effect=\"alarm\_helper\"\/ -->/" $MAEX
  sed -i "1,/^            <apply effect=\"music\_helper\"\/>/s/^            <apply effect=\"music\_helper\"\/>/            <!-- apply effect=\"music\_helper\"\/ -->/" $MAEX
  sed -i "1,/^            <apply effect=\"voice\_helper\"\/>/s/^            <apply effect=\"voice\_helper\"\/>/            <!-- apply effect=\"voice\_helper\"\/ -->/" $MAEX
  sed -i "1,/^            <apply effect=\"notification\_helper\"\/>/s/^            <apply effect=\"notification\_helper\"\/>/            <!-- apply effect=\"notification\_helper\"\/ -->/" $MAEX
  if [ -d /data/adb/modules/aml ]; then
    AML=/data/adb/aml/DolbyAtmos/system
    if [ ! -d $AML/etc ]; then
      mkdir -p $AML/etc
    fi
    if [ ! -d $AML/vendor/etc ]; then
      mkdir -p $AML/vendor/etc
    fi
  fi
else
  MAEC=`find $ACDB/system -type f -name *audio*effects*.conf`
  MAEX=`find $ACDB/system -type f -name *audio*effects*.xml`
  sed -i "/^        voice_helper {/ {;N s/        voice_helper {\n        }/#        voice_helper {\n#        }/}" $MAEC
  sed -i "1,/^            <apply effect=\"voice\_helper\"\/>/s/^            <apply effect=\"voice\_helper\"\/>/            <!-- apply effect=\"voice\_helper\"\/ -->/" $MAEX
fi

if [ ! -d /data/vendor/dolby ]; then
  mkdir -p /data/vendor/dolby
fi
chmod 0770 /data/vendor/dolby
chown 1013.1013 /data/vendor/dolby

if [ -f $MODDIR/cleaner.sh ]; then
  sh $MODDIR/cleaner.sh
  rm -f $MODDIR/cleaner.sh
fi


