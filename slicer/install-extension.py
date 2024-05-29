#!/usr/bin/env python3
import os

directory = os.environ['EXTENSION_DIR']
manager = slicer.app.extensionsManagerModel()
for filename in os.listdir(directory):
    if filename.endswith(".tar.gz"):
        extensionPackageFilename = os.path.join(directory, filename)
        print(f"installing {extensionPackageFilename}")
        if os.path.exists(extensionPackageFilename):
            manager.installExtension(extensionPackageFilename)

exit()
