#!/usr/bin/env bash
cd /usr/src

:>logs/build_${HOSTNAME}.log
:>logs/install_${HOSTNAME}.log
:>logs/patches_${HOSTNAME}.log

filenames=($(ls ./files/*.patch))

if [ ${#filenames[@]} -gt 0 ]; then
    for file in "${filenames[@]}"; do
        echo "apply patch file ${file}" | tee >> logs/patches_${HOSTNAME}.log
        echo "patch -d / -p0 < $file"
        patch -d / -p0 < "$file"
    done

    cpu_count=`sysctl hw.ncpu | awk '{print $2*2}'`

    command="make buildkernel -j$cpu_count"

    echo ${command}
    ${command} >>logs/build_${HOSTNAME}.log

    echo "build result $?"

    if [ $? -ne 0 ]; then
        echo "build kernel is not success!"
    else
        command="make installkernel -j$cpu_count"
        echo ${command}
        ${command} >>logs/install_${HOSTNAME}.log
    fi
else
    echo "kernel will not be rebuilt"
fi