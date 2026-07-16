### AnyKernel custom methods
## dereference23@github.com
## edited by nullptr@singkolab.my.id

check_patches() {
  local vendor_mounted=0;
  if grep -q "/vendor " /proc/mounts; then
    vendor_mounted=1;
  else
    mount /vendor 2>/dev/null;
    if [ $? -eq 0 ]; then
      vendor_mounted=1;
    else
      for block in /dev/block/mapper/vendor$SLOT /dev/block/mapper/vendor /dev/block/by-name/vendor$SLOT /dev/block/by-name/vendor; do
        if [ -e "$block" ]; then
          mount -o ro "$block" /vendor 2>/dev/null && vendor_mounted=1 && break;
        fi;
      done;
    fi;
  fi;

  if [ "$vendor_mounted" -eq 1 ]; then
    if grep -qs displayfeature /vendor/bin/hw/vendor.qti.hardware.display.composer-service; then
      fdtput $AKHOME/dtb /soc/qcom,mdss_mdp@5e00000/qcom,mdss_dsi_m17_38_0c_0a_fhdp_dsc_vid qcom,mdss-pan-physical-width-dimension 695;
      fdtput $AKHOME/dtb /soc/qcom,mdss_mdp@5e00000/qcom,mdss_dsi_m17_38_0c_0a_fhdp_dsc_vid qcom,mdss-pan-physical-height-dimension 1546;
      dtb_patched=1;
    fi;
    if [ -e /vendor/lib64/hw/consumerir.default.so -o -e /vendor/lib64/hw/consumerir.holi.so ]; then
      fdtput $AKHOME/dtb /soc/spi@4a88000/irled@0 compatible ir-spi -t s;
      dtb_patched=1;
    fi;
  fi;
}

inject_spoof_cmdline() {
  local ZIPNAME ZIP_LOWER
  ZIPNAME=$(basename "$ZIPFILE")
  ZIP_LOWER=$(echo "$ZIPNAME" | tr '[:upper:]' '[:lower:]')

  if echo "$ZIP_LOWER" | grep -q "miui14"; then
    patch_cmdline femboy.fs femboy.fs=1
  elif echo "$ZIP_LOWER" | grep -q "miui12"; then
    patch_cmdline femboy.selinux femboy.selinux=1
    patch_cmdline femboy.bl femboy.bl=1
  else
    patch_cmdline femboy.selinux femboy.selinux=1
  fi
}

flash_dtbo_manual() {
  local DTBO_BLOCK=/dev/block/by-name/dtbo$SLOT;
  if [ -f $AKHOME/dtbo.img ]; then
    cat $AKHOME/dtbo.img > $DTBO_BLOCK;
  fi;
}
