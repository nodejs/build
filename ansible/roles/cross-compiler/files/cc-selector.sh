# create CC, CXX, CC_host and CXX_host environment variables appropriate for the
# worker label in use. Of the form: cross-compiler-(armv[67])-gcc-(4.[89](\.4)?)
# e.g. cross-compiler-armv6-gcc-4.8, or cross-compiler-armv7-gcc-4.9.4

rpi_tools_base="/opt/raspberrypi/tools/"
rpi_newer_tools_base="/opt/raspberrypi/rpi-newer-crosstools/"
base_4_8_armv6="${rpi_tools_base}arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/arm-linux-gnueabihf-"
base_4_8_armv7="${rpi_tools_base}arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/arm-linux-gnueabihf-"
base_4_9_armv6="${rpi_tools_base}arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/bin/arm-linux-gnueabihf-"
base_4_9_armv7="${rpi_tools_base}arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/bin/arm-linux-gnueabihf-"
base_4_9_4_armv6="${rpi_newer_tools_base}x64-gcc-4.9.4-binutils-2.28/arm-rpi-linux-gnueabihf/bin/arm-rpi-linux-gnueabihf-"
base_4_9_4_armv7="${rpi_newer_tools_base}x64-gcc-4.9.4-binutils-2.28/arm-rpi-linux-gnueabihf/bin/arm-rpi-linux-gnueabihf-"
flags_armv6="-march=armv6zk"
flags_armv7="-march=armv7-a"

export arm_type=$(echo $1 | sed -E 's/^cross-compiler-(armv[67])-gcc-(4.[89](\.4)?)/\1/')
export gcc_version=$(echo $1 | sed -E 's/^cross-compiler-(armv[67])-gcc-4\.([89](\.4)?)/4.\2/')
export git_branch="cc-${arm_type}"

if [[ ! "$arm_type" =~ ^armv[67]$ ]]; then
  echo "Could not determine ARM type from '$1'"
  exit 1
fi
if [[ ! "$gcc_version" =~ ^4\.[89](\.4)?$ ]]; then
  echo "Could not determine ARM type from '$1'"
  exit 1
fi

gcc_version_safe="$(echo $gcc_version | sed -E 's/\./_/g')"
gcc_host_version="$(echo $gcc_version | sed -E 's/\.4//g')" # 4.9.4 -> 4.9

echo "ARM type: $arm_type, GCC version: $gcc_version"

base_varname="base_${gcc_version_safe}_${arm_type}"
flags_varname="flags_${arm_type}"

export ARCH="${arm_type}l"
export DESTCPU=arm
export CC_host="ccache gcc-${gcc_host_version} -m32"
export CXX_host="ccache g++-${gcc_host_version} -m32"
export CC="ccache ${!base_varname}gcc ${!flags_varname}"
export CXX="ccache ${!base_varname}g++ ${!flags_varname}"
