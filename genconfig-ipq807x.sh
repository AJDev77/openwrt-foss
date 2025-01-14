#!/bin/sh

arch=qualcommax
target=ipq807x
version=releases/24.10.0-rc5
wget https://downloads.openwrt.org/${version}/targets/${arch}/${target}/config.buildinfo -O config.buildinfo
cat config.buildinfo | grep -v CONFIG_TARGET_DEVICE_ | grep -v CONFIG_TARGET_ALL_PROFILES | grep -v CONFIG_TARGET_MULTI_PROFILE > .config
echo CONFIG_TARGET_DEVICE_qualcommax_ipq807x_DEVICE_linksys_mx4300=y >> .config
echo CONFIG_TARGET_qualcommax_ipq807x_DEVICE_linksys_mx4300=y >> .config
echo CONFIG_TARGET_PROFILE="DEVICE_linksys_mx4300" >> .config

#add luci
echo CONFIG_PACKAGE_luci=y >> .config
echo CONFIG_TARGET_OPTIMIZATION='-O2 -pipe -mcpu=cortex-a53+crc+crypto' >> .config
echo CONFIG_DEVEL=y >> .config
echo CONFIG_EXPERIMENTAL=y >> .config
echo CONFIG_TOOLCHAINOPTS=y >> .config
echo CONFIG_TARGET_OPTIONS=y >> .config
echo CONFIG_USE_GC_SECTIONS=y >> .config


# Kernel Config
echo CONFIG_COLLECT_KERNEL_DEBUG=y >> .config
echo CONFIG_KERNEL_PERF_EVENTS=y >> .config
echo CONFIG_KERNEL_DYNAMIC_DEBUG=y >> .config
echo CONFIG_KERNEL_ARM_PMU=y >> .config
echo CONFIG_KERNEL_ARM_PMUV3=y >> .config
echo CONFIG_KERNEL_PREEMPT_NONE=y >> .config
echo CONFIG_KERNEL_PREEMPT_NONE_BUILD=y >> .config
cat .config
make defconfig

#skip xdp
cat .config | grep -v "CONFIG_PACKAGE.*xdp" > .config.tmp
cp .config.tmp .config


