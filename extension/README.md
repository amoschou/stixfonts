# Polytonic extension

This `git` repository is a fork from `stix/stipub` (`v2.14`), with the addition of the folder `extension` containing everything that is necessary to extend STIX Two Text to support Polytonic Greek.

# Build instructions

From the repository root, run the following:
```bash
cd extension
bash ./run.sh
```

The `run.sh` script will extract some information from the FontLab JSON source file, and build diacritic and miscellaneous characters, lower case characters and upper case letters for Regular and Bold weights in Roman style (Italic is not yet ready).

This script will create the folder `extension/target` (deleting it if it already exists first), copy over `STIXTwoText-Regular.ufo` and `STIXTwoText-Bold.ufo` from the original source, and insert the `*.glif` files for polytonic Greek. These UFO folders are then copied back to where the Tiro builder process will expect to find them (backing up the originals).

Before building, `STIXbuild.yml` has already been edited, removing the Mathematics build information, and updating names. I recommend still keeping the Italic build, even though there is no functional difference to the official build, so that the *Italic* button in word processers will continue to work if you are typing in Latin, Cyrillic or monotonic Greek.

The script then runs the Tiro build process.
