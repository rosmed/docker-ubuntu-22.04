#!/usr/bin/env bash

export MODULE_DIR=/root/slicer/modules/aigt/SlicerExtension/LiveUltrasoundAi/SegmentationUNet

# if the file exists, then run it
if [ -f /root/slicer/Slicer-5.2/Slicer ]; then
    /root/slicer/Slicer-5.2/Slicer  --no-main-window --no-splash --python-script /root/slicer/install-module.py
elif [ -f /root/slicer/Slicer-SuperBuild-Release/Slicer-build/Slicer ]; then
    /root/slicer/Slicer-SuperBuild-Release/Slicer-build/Slicer  --no-main-window --no-splash --python-script /root/slicer/install-module.py
fi
