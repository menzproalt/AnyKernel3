### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=MiHoli Kernel for POCO X5 5G, Redmi Note 12 5G, and Redmi Note 12R Pro 5G
do.devicecheck=0
do.cleanup=1
device.name1=moonstone
device.name2=sunstone
device.name3=stone
device.name4=gemstone
'; } # end properties

# boot shell variables
BLOCK=boot;
IS_SLOT_DEVICE=auto;
NO_BLOCK_DISPLAY=0;
RAMDISK_COMPRESSION=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;
. tools/ak3-custom.sh;

# boot install
split_boot;
inject_spoof_cmdline;
flash_boot;
## end boot install

# dtbo install
flash_dtbo_manual
## end dtbo install

# vendor_boot shell variables
BLOCK=vendor_boot;

# reset for vendor_boot patching
reset_ak;

# vendor_boot install
split_boot;
inject_spoof_cmdline;
check_patches;
flash_boot;
## end vendor_boot install
