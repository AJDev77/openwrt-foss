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

# Use OpenSSL as the preferred SSL library
echo CONFIG_PACKAGE_libustream-openssl=y >> .config
echo CONFIG_PACKAGE_libustream-mbedtls=n >> .config
echo CONFIG_PACKAGE_libopenssl=y >> .config
echo CONFIG_LUA_ECO_OPENSSL=y >> .config
echo CONFIG_LUA_ECO_MBEDTLS=n >> .config
# Optimize OpenSSL for speed over size
echo CONFIG_OPENSSL_OPTIMIZE_SPEED=y >> .config
echo CONFIG_PACKAGE_luci-app-firewall=y >> .config
# - SQM: Smart Queue Management for bufferbloat control.
echo CONFIG_PACKAGE_luci-app-sqm=y >> .config
# - Statistics: Monitor your router’s performance (CPU, memory, bandwidth).
echo CONFIG_PACKAGE_luci-app-statistics=y >> .config
# - ACME: Automated SSL cert management. If you want to access your router via HTTPS and have a domain.
echo CONFIG_PACKAGE_luci-app-acme=y >> .config
# - Watchcat: Automate reboots on connection loss.
echo CONFIG_PACKAGE_luci-app-watchcat=y >> .config
# - WireGuard: VPN support. Will also select the kernel module.
echo CONFIG_PACKAGE_luci-proto-wireguard=y >> .config
# - NLBWMon: Network usage monitoring to track bandwidth by host.
echo CONFIG_PACKAGE_luci-app-nlbwmon=y >> .config
echo CONFIG_PACKAGE_kmod-nft-bridge=y >> .config
# - curl: CLI tool to transfer data with URLs. Useful for scripting, and supperior to wget.
echo CONFIG_PACKAGE_curl=y >> .config
echo CONFIG_LIBCURL_OPENSSL=y >> .config
echo CONFIG_LIBCURL_MBEDTLS=n >> .config
# - rsync: Efficient file transfers and backups.
echo CONFIG_PACKAGE_rsync=y >> .config
# - jq: Parse JSON data from the command line. Useful for scripting, and WAY better than `jsonfilter`.
echo CONFIG_PACKAGE_jq=y >> .config
# - pigz: Parallel gzip for faster compression.
echo CONFIG_PACKAGE_pigz=y >> .config
# - tar: Archiving utility. The default busybox tar is very limited.
echo CONFIG_PACKAGE_tar=y >> .config
# - tcpdump: Capture and analyze network traffic.
echo CONFIG_PACKAGE_tcpdump=y >> .config
# - htop: CLI tool to monitor system resource usage.
echo CONFIG_PACKAGE_htop=y >> .config
# lm-sensors isn't needed for IPQ807x devices.
echo CONFIG_HTOP_LMSENSORS=n >> .config

#####################################################################
# Wireless Configuration
#####################################################################
# Enable WPA3 and Mesh support
echo CONFIG_PACKAGE_wpad-mesh-openssl=y >> .config
# Avoid using mbedTLS for consistency across packages and to avoid mixed SSL libraries.
echo CONFIG_PACKAGE_wpad-basic-mbedtls=n >> .config

#####################################################################
# Library Optimization
#####################################################################
# Optimize common libraries (zlib, zstd) for speed, improving performance on compression tasks.
echo CONFIG_ZLIB_OPTIMIZE_SPEED=y >> .config
echo CONFIG_ZSTD_OPTIMIZE_O3=y >> .config


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


