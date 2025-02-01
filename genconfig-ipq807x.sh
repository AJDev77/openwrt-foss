#!/bin/sh

arch=qualcommax
target=ipq807x
version=releases/24.10.0-rc7
wget https://downloads.openwrt.org/${version}/targets/${arch}/${target}/config.buildinfo -O config.buildinfo
cat config.buildinfo | grep -v CONFIG_TARGET_DEVICE_ | grep -v CONFIG_TARGET_ALL_PROFILES | grep -v CONFIG_ALL_KMODS | grep -v CONFIG_TARGET_MULTI_PROFILE > .config
echo CONFIG_TARGET_DEVICE_qualcommax_ipq807x_DEVICE_linksys_mx4300=y >> .config
echo CONFIG_TARGET_qualcommax_ipq807x_DEVICE_linksys_mx4300=y >> .config
echo CONFIG_TARGET_PROFILE=\"DEVICE_linksys_mx4300\" >> .config

#####################################################################
# Compiler Optimization
#####################################################################
echo CONFIG_BUILD_PATENTED=y >> .config
echo CONFIG_DEVEL=y >> .config
echo CONFIG_EXPERIMENTAL=y >> .config
echo CONFIG_TOOLCHAINOPTS=y >> .config
echo CONFIG_TARGET_OPTIONS=y >> .config
echo CONFIG_TARGET_OPTIMIZATION=\"-O2 -pipe -mcpu=cortex-a53+crc+crypto\" >> .config
echo CONFIG_USE_GC_SECTIONS=y >> .config


# Kernel Config
echo CONFIG_COLLECT_KERNEL_DEBUG=y >> .config
echo CONFIG_KERNEL_PERF_EVENTS=y >> .config
echo CONFIG_KERNEL_DYNAMIC_DEBUG=y >> .config
echo CONFIG_KERNEL_ARM_PMU=y >> .config
echo CONFIG_KERNEL_ARM_PMUV3=y >> .config
echo CONFIG_KERNEL_PREEMPT_NONE=y >> .config
echo CONFIG_KERNEL_PREEMPT_NONE_BUILD=y >> .config

# Reduce kernel module size
# Disable unnecessary debugging for Wi-Fi driver.
echo CONFIG_ATH11K_DEBUGFS_HTT_STATS=n >> .config
echo CONFIG_ATH11K_DEBUGFS_STA=n >> .config
# Disables thermal throttling support for ath11k.
echo CONFIG_ATH11K_THERMAL=n >> .config

#####################################################################
# SSL Configuration
#####################################################################
# Use OpenSSL as the preferred SSL library
echo CONFIG_PACKAGE_libustream-openssl=y >> .config
echo CONFIG_PACKAGE_libustream-mbedtls=n >> .config
echo CONFIG_PACKAGE_libopenssl=y >> .config
echo CONFIG_LUA_ECO_OPENSSL=y >> .config
echo CONFIG_LUA_ECO_MBEDTLS=n >> .config
# Optimize OpenSSL for speed over size
echo CONFIG_OPENSSL_OPTIMIZE_SPEED=y >> .config

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

# --- Essential Packages ---

#####################################################################
# LUCI (the web interface)
#####################################################################
echo CONFIG_PACKAGE_luci=y >> .config
# Enable HTTPS support
echo CONFIG_PACKAGE_luci-ssl-openssl=y >> .config

#####################################################################
# LUCI Applications
#####################################################################
# - Firewall: Manage firewall rules via LUCI.
echo CONFIG_PACKAGE_luci-app-firewall=y >> .config
# - Package manager for OpenWRT, manage installed packages via LUCI.
echo CONFIG_PACKAGE_luci-app-package-manager=y >> .config

# - iperf3: CLI tool to measure network performance.
#           This is essential to test WiFi speeds,
#           as posting speedtest.net results is useless
#           without knowing the network conditions.
echo CONFIG_PACKAGE_iperf3=y >> .config

# --- Optional Packages --- #

#### EVERYTHING BELOW THIS SECTION IS OPTIONAL!!

#### You can delete or comment out with '#' any package you don't want to install.

#####################################################################
# LUCI Applications
#####################################################################

# - SQM: Smart Queue Management for bufferbloat control.
echo CONFIG_PACKAGE_luci-app-sqm=y >> .config
# - Statistics: Monitor your router’s performance (CPU, memory, bandwidth).
echo CONFIG_PACKAGE_luci-app-statistics=y >> .config
# - Watchcat: Automate reboots on connection loss.
echo CONFIG_PACKAGE_luci-app-watchcat=y >> .config
# - WireGuard: VPN support. Will also select the kernel module.
echo CONFIG_PACKAGE_luci-proto-wireguard=y >> .config
# - NLBWMon: Network usage monitoring to track bandwidth by host.
echo CONFIG_PACKAGE_luci-app-nlbwmon=y >> .config
echo CONFIG_PACKAGE_socat=y >> .config

#####################################################################
# Kernel Modules
#####################################################################
# Filesystem support for USB storage:
# FAT32: Useful to load recovery or new images that can be booted by u-boot
echo CONFIG_PACKAGE_kmod-fs-vfat=y >> .config
# NTFS: Mostly useful for Windows users.
echo CONFIG_PACKAGE_kmod-fs-ntfs3=y >> .config

# Network
# Bridge module support for working with nftables for more complex firewall setups.
echo CONFIG_PACKAGE_kmod-nft-bridge=y >> .config

# USB Storage
# NOTE: Not all IPQ807x devices have USB ports, so this is optional.
echo CONFIG_PACKAGE_kmod-usb-storage=y >> .config

# Logging/Debugging

# ramoops: kernel module that logs crashes to RAM which can be read after a reboot.
# Check '/sys/fs/pstore' for logs after a crash.
echo CONFIG_PACKAGE_kmod-ramoops=y >> .config

#####################################################################
# Packages
#####################################################################

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

cat .config
make defconfig

#skip xdp
cat .config | grep -v "CONFIG_PACKAGE.*xdp" > .config.tmp
cp .config.tmp .config


