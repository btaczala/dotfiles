#!/bin/bash

cd $HOME/vms/
qemu-system-x86_64 \
    -enable-kvm -m 4G \
    -machine type=q35,accel=kvm \
    -cpu host -smp 4 \
    -vga qxl \
    -device virtio-serial-pci -spice port=5930,disable-ticketing \
    -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 -chardev spicevmc,id=spicechannel0,name=vdagent \
    -hda /home/bartek/vms/windows10.qcow2 \
    -cdrom Win10_1909_EnglishInternational_x64.iso \
    -net nic -net user,hostname=windowsvm \
    -display gtk \
    -usb -device usb-tablet,bus=usb-bus.0 \
    -soundhw hda \
    -audiodev id=pa,driver=pa,server=/run/user/1000/pulse/native \
    $@

