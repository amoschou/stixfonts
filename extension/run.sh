#!/bin/bash

cd ..

python3 -m venv venv
source venv/bin/activate
pip3 install --upgrade pip
pip3 install -r requirements.txt
pip3 install defcon

cd extension

targetfolder=./target
extensionsourcefolder=./source
stixfontssourcefolder=../source

rm -rf $targetfolder
mkdir $targetfolder

touch ${targetfolder}/STIX2-Post2Dev.pg.unsorted.ren
touch ${targetfolder}/STIX2-Dev2Post.pg.unsorted.ren

echo -e '\n' > ${targetfolder}/STIX2-Post2Dev.pg.unsorted.ren
echo -e '\n' > ${targetfolder}/STIX2-Dev2Post.pg.unsorted.ren

for Style in Roman # Italic
do
    metrics=${targetfolder}/STIXTwoTextVF-${Style}.metrics.json

    rm -f $metrics
    bash ./bin/compile-metrics-${Style}.sh ${stixfontssourcefolder}/STIXTwoTextVF-${Style}.vfj $metrics

    for Weight in Regular Bold
    do
        weight=`echo $Weight | tr '[:upper:]' '[:lower:]'`

        folder=$Weight
        spacedfolder=$Weight
        if [[ $Style == Italic ]]
        then
            if [[ $Weight == Regular ]]
            then
                folder=Italic
                spacedfolder=Italic
            else
                folder=${folder}Italic
                spacedfolder="${folder} Italic"
            fi
        fi

        targetufo=${targetfolder}/STIXTwoText-${folder}.ufo
        rm -rf $targetufo
        cp -r ${stixfontssourcefolder}/STIXTwoText-${folder}.ufo $targetufo

        touch ./patch/volt-${folder}.middle.cat

        copyright2='Additions for polytonic Greek © Andrew Moschou 2025'
        python3 ./bin/updateplist.py ${targetufo}/fontinfo.plist copyright --append "${copyright2}"
        python3 ./bin/updateplist.py ${targetufo}/fontinfo.plist familyName "Polytonic Extension"
        python3 ./bin/updateplist.py ${targetufo}/fontinfo.plist openTypeNamePreferredFamilyName "Polytonic Extension"
        python3 ./bin/updateplist.py ${targetufo}/fontinfo.plist postscriptFontName "PolytonicExtension-${folder}"
        python3 ./bin/updateplist.py ${targetufo}/fontinfo.plist postscriptFullName "Polytonic Extension ${spacedfolder}"
        python3 ./bin/updateplist.py ${targetufo}/fontinfo.plist styleMapFamilyName "Polytonic Extension"
        python3 ./bin/updateplist.py ${targetufo}/fontinfo.plist openTypeOS2VendorID AGM

        patch ${targetufo}/features.fea ./patch/features-${Style}.fea.patch

        bash ./bin/make-diacritics.sh $folder $extensionsourcefolder $targetufo $weight $metrics
        bash ./bin/make-lowercase-and-simple-uppercase.sh $folder $extensionsourcefolder $targetufo $weight $metrics
        bash ./bin/make-complex-uppercase.sh $folder $extensionsourcefolder $targetufo $weight $metrics

        # Generate new .input.ttf and volt project files
        python3 ./bin/ufo2ttf.py ${targetufo} ${targetfolder}/STIXTwoText-${folder}.input.ttf
        cp ${stixfontssourcefolder}/STIXTwoText-${folder}.vtp ${targetfolder}
        mac2unix ${targetfolder}/STIXTwoText-${folder}.vtp
        patch ${targetfolder}/STIXTwoText-${folder}.vtp ./patch/STIXTwoText-${Style}.vtp.patch

        head -n $((`sed -n '/%%__EXTENSION_GLYPHS__%%/=' ${targetfolder}/STIXTwoText-${folder}.vtp` - 1)) ${targetfolder}/STIXTwoText-${folder}.vtp > ./patch/volt-${folder}.top.cat
        # cat ./patch/volt-${folder}.middle.cat
        tail -n $(( `wc -l < ${targetfolder}/STIXTwoText-${folder}.vtp` - `sed -n '/%%__EXTENSION_GLYPHS__%%/=' ${targetfolder}/STIXTwoText-${folder}.vtp` )) ${targetfolder}/STIXTwoText-${folder}.vtp > ./patch/volt-${folder}.bottom.cat

        cat ./patch/volt-${folder}.top.cat ./patch/volt-${folder}.middle.cat ./patch/volt-${folder}.bottom.cat > ${targetfolder}/STIXTwoText-${folder}.vtp
        rm ./patch/volt-${folder}.top.cat ./patch/volt-${folder}.middle.cat ./patch/volt-${folder}.bottom.cat

        unix2mac ${targetfolder}/STIXTwoText-${folder}.vtp
        # Remember to open VOLT, import project, ship the font.
    done
done

# sort -u ${targetfolder}/STIX2-Post2Dev.pg.unsorted.ren > ${targetfolder}/STIX2-Post2Dev.pg.ren
# sort -u ${targetfolder}/STIX2-Dev2Post.pg.unsorted.ren > ${targetfolder}/STIX2-Dev2Post.pg.ren
awk '!seen[$0]++' ${targetfolder}/STIX2-Post2Dev.pg.unsorted.ren > ${targetfolder}/STIX2-Post2Dev.pg.ren
awk '!seen[$0]++' ${targetfolder}/STIX2-Dev2Post.pg.unsorted.ren > ${targetfolder}/STIX2-Dev2Post.pg.ren
rm -f ${targetfolder}/STIX2-Post2Dev.pg.unsorted.ren
rm -f ${targetfolder}/STIX2-Dev2Post.pg.unsorted.ren

# bash ./bin/tiro-build.sh

# rm -rf $targetfolder

# deactivate
