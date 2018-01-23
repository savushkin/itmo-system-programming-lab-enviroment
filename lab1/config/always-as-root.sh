#!/usr/bin/env sh
cd /usr/src
cpu_count=`sysctl hw.ncpu | awk '{print $2*2}'`

command="make buildkernel -j$cpu_count"

if [ -d '/usr/obj/usr/src/sys/GENERIC' ]; then
    command="$command -DKERNFAST"
else
	echo "'/usr/obj/usr/src/sys/GENERIC' not found"
fi

:>logs/build.log
echo ${command}
${command} >>logs/build.log

echo "build result $?"


:>logs/install.log
if [ $? -ne 0 ]; then
	echo "build kernel is not success!"
else
    command="make installkernel -j$cpu_count"
    echo ${command}
    ${command} >>logs/install.log
fi