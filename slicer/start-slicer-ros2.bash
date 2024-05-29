#!/usr/bin/env bash

source /root/ros2_ws/install/setup.bash

# if the file exists, then run it
if [ -f /root/slicer/Slicer-5.2/Slicer ]; then
    /root/slicer/Slicer-5.2/Slicer
elif [ -f /root/slicer/Slicer-SuperBuild-Release/Slicer-build/Slicer ]; then
    /root/slicer/Slicer-SuperBuild-Release/Slicer-build/Slicer
fi
