#!/bin/bash
make ARCH=arm CROSS_COMPILE="ccache /opt/arm-2011.03/bin/arm-none-eabi-" $1 $2
