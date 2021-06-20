resetprop ro.product.model "Phone 2"
resetprop ro.product.brand razer
resetprop ro.product.device bolt
resetprop ro.product.manufacturer Razer

killall audioserver

SELINUX=`getenforce`
if [ "$SELINUX" == Enforcing ]; then
  setenforce 0
fi
/vendor/bin/hw/vendor.dolby.hardware.dms@1.0-service&

