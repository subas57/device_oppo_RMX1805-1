NAME=dap
UUID=9d4921da-8225-4f29-aefa-39537a04bcaa
LIBPATH=/vendor/lib/soundfx/libswdap.so
patch_cfgs $NAME $UUID $NAME $LIBPATH

MODDIR=${0%/*}
MAEC=`find $MODDIR/system -type f -name *audio*effects*.conf`
MAEX=`find $MODDIR/system -type f -name *audio*effects*.xml`
sed -i "/^        ring_helper {/ {;N s/        ring_helper {\n        }/#        ring_helper {\n#        }/}" $MAEC
sed -i "/^        alarm_helper {/ {;N s/        alarm_helper {\n        }/#        alarm_helper {\n#        }/}" $MAEC
sed -i "/^        music_helper {/ {;N s/        music_helper {\n        }/#        music_helper {\n#        }/}" $MAEC
sed -i "/^        voice_helper {/ {;N s/        voice_helper {\n        }/#        voice_helper {\n#        }/}" $MAEC
sed -i "/^        notification_helper {/ {;N s/        notification_helper {\n        }/#        notification_helper {\n#        }/}" $MAEC
sed -i "1,/^            <apply effect=\"ring\_helper\"\/>/s/^            <apply effect=\"ring\_helper\"\/>/            <!-- apply effect=\"ring\_helper\"\/ -->/" $MAEX
sed -i "1,/^            <apply effect=\"alarm\_helper\"\/>/s/^            <apply effect=\"alarm\_helper\"\/>/            <!-- apply effect=\"alarm\_helper\"\/ -->/" $MAEX
sed -i "1,/^            <apply effect=\"music\_helper\"\/>/s/^            <apply effect=\"music\_helper\"\/>/            <!-- apply effect=\"music\_helper\"\/ -->/" $MAEX
sed -i "1,/^            <apply effect=\"voice\_helper\"\/>/s/^            <apply effect=\"voice\_helper\"\/>/            <!-- apply effect=\"voice\_helper\"\/ -->/" $MAEX
sed -i "1,/^            <apply effect=\"notification\_helper\"\/>/s/^            <apply effect=\"notification\_helper\"\/>/            <!-- apply effect=\"notification\_helper\"\/ -->/" $MAEX


