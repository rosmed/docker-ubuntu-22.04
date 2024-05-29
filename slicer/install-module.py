#!/usr/bin/env python3
import os

directory = os.environ['MODULE_DIR']
settings = slicer.app.revisionUserSettings()
if os.path.exists(directory):
    modules = settings.value('Modules/AdditionalPaths')
    modulesList = list(modules)
    modulesList.append(directory)
    modules = tuple(modulesList)
    settings.setValue('Modules/AdditionalPaths', modules)

exit()
