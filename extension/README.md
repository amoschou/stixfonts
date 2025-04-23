# Polytonic extension

This `git` repository is a fork from `stix/stipub` (`v2.14`), with the addition of the folder `extension` containing everything that is necessary to extend STIX Two Text to support Polytonic Greek.

Get the built fonts from [https://github.com/amoschou/polytonic-extension](https://github.com/amoschou/polytonic-extension).

## Process

The extension has been carefully constructed so that the new fonts can be automatically generated from the original source. When STIX Two is updated ([version 2.25 is coming soon](https://github.com/stipub/stixfonts/milestones)), this modified version can follow quite quickly.

If the build process is cleaned up and abstracted, it could be adapted to generally extend any monotonic Greek font to support polytonic fairly easily.

## Build instructions

From the repository root, run the following:
```bash
cd extension
bash ./run.sh
```

The `run.sh` script will:
* prepare the Python environment
* extract information from the FontLab JSON source file
* build new glyphs for Regular and Bold weights in Roman style (Italic is not yet ready)
* alter font information (naming, copyright)
* prepare new `.ren`, `.input.ttf` and `.vtp` files

This script will create the folder `extension/target` (deleting it if it already exists first) and create all new files here.

There are already existing `.input.ttf` files which have been shipped from VOLT with the polytonic Greek additions in the `extension/volt` folder. These will be used by the build script next. However, if there are further changes to the extension which the existing `.input.ttf` files do not reflect, at this point you must recreate the `.input.ttf` files shipped fresh from VOLT.

Next, run:
```bash
bash ./bin/tiro-build.sh
```

The `tiro-build.sh` script will:
* alter `STIXbuild.yml` and the `.designspace` files with new font information (naming); mathematics build information is removed
* merge the newly built `.ufo` and `.ren` files into the source
* run `tirobyild.py`
* roll back the source to the original state

I recommend still keeping the Italic build, even though there is no functional difference to the official build, so that the *Italic* button in word processers will continue to work if you are typing in Latin, Cyrillic or monotonic Greek.

## Copyright and license

```
Copyright 2001-2021 The STIX Fonts Project Authors (https://github.com/stipub/stixfonts), with Reserved Font Name "TM Math". STIX Fonts™ is a trademark of The Institute of Electrical and Electronics Engineers, Inc.

Additions for polytonic Greek © Andrew Moschou 2025.

This Font Software is licensed under the SIL Open Font License, Version 1.1.
```
