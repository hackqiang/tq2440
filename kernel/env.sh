# set cross compile
export ARCH=arm
export CROSS_COMPILE="ccache /opt/arm-2011.03/bin/arm-none-eabi-"
ccache -M 2G

alias flashkernel='sudo dnw2 arch/arm/boot/zImage' 
