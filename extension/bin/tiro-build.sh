#!/bin/bash

# Apply correction
cp STIXbuild.yml STIXbuild.yml.original
sed -i -e 's/Brill/STIXTwoText/g' STIXbuild.yml

# We do not build STIX Two Math, comment it out
sed -i -e '/^  STIXTwoMath:/,/\$/ s/^/#/' STIXbuild.yml

# Rename all mentions
sed -i -e 's/STIXTwoText/PolytonicExtension/g' STIXbuild.yml
sed -i -e 's/STIX Two Text/Polytonic Extension/g' STIXbuild.yml
sed -i -e 's/STIX Two Text/Polytonic Extension/g' source/STIXTwoTextVF-Roman.designspace
sed -i -e 's/STIX Two Text/Polytonic Extension/g' source/STIXTwoTextVF-Italic.designspace

# Except filenames
sed -i -e 's/source\/PolytonicExtension/source\/STIXTwoText/g' STIXbuild.yml

# Merge extensions into the source for building
# Including the new .input.ttf files shipped from VOLT
for folder in Regular Bold # Italic BoldItalic
do
    mv source/STIXTwoText-${folder}.ufo source/STIXTwoText-${folder}.ufo.original
    cp -r extension/target/STIXTwoText-${folder}.ufo source/STIXTwoText-${folder}.ufo

    mv source/STIXTwoText-${folder}.input.ttf source/STIXTwoText-${folder}.input.ttf.original
    cp extension/volt/PolytonicExtension-${folder}.shipped.input.ttf source/STIXTwoText-${folder}.input.ttf
done
cp source/STIX2-Dev2Post.ren source/STIX2-Dev2Post.ren.original
cp source/STIX2-Post2Dev.ren source/STIX2-Post2Dev.ren.original
cat extension/target/STIX2-Dev2Post.pg.ren >> source/STIX2-Dev2Post.ren
cat extension/target/STIX2-Post2Dev.pg.ren >> source/STIX2-Post2Dev.ren

# Build
python tools/tirobuild.py STIXbuild.yml

# And roll back the above changes to STIXbuild.yml and the *.designspace files
rm source/STIX2-Dev2Post.ren
rm source/STIX2-Post2Dev.ren
mv source/STIX2-Dev2Post.ren.original source/STIX2-Dev2Post.ren
mv source/STIX2-Post2Dev.ren.original source/STIX2-Post2Dev.ren
for folder in Regular Bold # Italic BoldItalic
do
    rm source/STIXTwoText-${folder}.input.ttf
    rm -rf source/STIXTwoText-${folder}.ufo
    mv source/STIXTwoText-${folder}.input.ttf.original source/STIXTwoText-${folder}.input.ttf
    mv source/STIXTwoText-${folder}.ufo.original source/STIXTwoText-${folder}.ufo
done
sed -i -e 's/Polytonic Extension/STIX Two Text/g' source/STIXTwoTextVF-Italic.designspace
sed -i -e 's/Polytonic Extension/STIX Two Text/g' source/STIXTwoTextVF-Roman.designspace
rm STIXbuild.yml
mv STIXbuild.yml.original STIXbuild.yml
