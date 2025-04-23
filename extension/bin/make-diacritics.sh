#!/bin/shell

folder=$1
extensionsourcefolder=$2
targetufo=$3
weight=$4
metrics=$5

greekdiacritics=`cat ./source/greek-diacritics.json | jq -c .`

## The Greek diacritic marks are put into several groups here.
##   - Independent .glif files. There are four of these in the source folder.
##   - Group A. These are identical to an existing monotonic mark or one of the above marks, possibly flipped horizontally
##   - Group B. These are the vertically stacked composite marks (something + perispomeni)
##   - Group C. These are the horizontally stacked composite marks (breath + shortaccent)
## The spacing marks are also generated from the corresponding combining marks
## Finally, the iota adscript. 

# Independent .glif files
for glyphname in `python3 ./bin/readplist.py keys ${extensionsourcefolder}/STIXTwoText-${folder}.ufo/glyphs/contents.plist`
do
    filename=`python3 ./bin/readplist.py val -i $glyphname ${extensionsourcefolder}/STIXTwoText-${folder}.ufo/glyphs/contents.plist`
    cp ${extensionsourcefolder}/STIXTwoText-${folder}.ufo/glyphs/${filename} ${targetufo}/glyphs
    python3 bin/updateplist.py ${targetufo}/glyphs/contents.plist $glyphname $filename
    unicodes=`python3 bin/glyphjson.py  ${extensionsourcefolder}/STIXTwoText-${folder}.ufo/glyphs $glyphname | jq -rc '.unicodes | @sh'`
    if [[ $unicodes != null ]]
    then
        for unicode in $unicodes
        do
            volt=`python3 ./bin/appendglyph.py ${targetufo}/lib.plist ${glyphname} -u $unicode MARK`
            echo $volt >> ./patch/volt-${folder}.middle.cat

            Unicode=`printf '%04x' $unicode | tr '[:lower:]' '[:upper:]'`
            echo uni${Unicode} $glyphname >> ${targetufo}/../STIX2-Post2Dev.pg.unsorted.ren
            echo $glyphname uni${Unicode} >> ${targetufo}/../STIX2-Dev2Post.pg.unsorted.ren
        done
    else
        volt=`python3 ./bin/appendglyph.py ${targetufo}/lib.plist ${glyphname} MARK`
        echo $volt >> ./patch/volt-${folder}.middle.cat

        echo $glyphname $glyphname >> ${targetufo}/../STIX2-Post2Dev.pg.unsorted.ren
        echo $glyphname $glyphname >> ${targetufo}/../STIX2-Dev2Post.pg.unsorted.ren
    fi
done

# Group A
for glyphname in `echo $greekdiacritics | jq -r '."group-a" | keys | @sh' | sed "s/'//g"`
do
    unicode=`echo $greekdiacritics | jq -r --arg g $glyphname '."group-a".[$g].unicode'`
    derivedfrom=`echo $greekdiacritics | jq -r --arg g $glyphname '."group-a".[$g].derivedfrom'`
    hflip=`echo $greekdiacritics | jq -r --arg g $glyphname '."group-a".[$g].hflip'`

    gliffile=${targetufo}/glyphs/${glyphname}.glif
    cp ./source/.glif.stub $gliffile

    sed -i -e "s/%GLYPH-NAME%/${glyphname}/g" $gliffile
    sed -i -e "s/%ADVANCE%//g" $gliffile

    if [[ $unicode == null ]]
    then
        sed -i -e "s/%UNICODE%//g" $gliffile
    else
        sed -i -e "s/%UNICODE%/  <unicode hex=\"$unicode\"\/>\n/g" $gliffile
    fi

    if [[ $hflip == true ]]
    then
        case $weight in
            regular )
                sed -i -e "s/%COMPONENTS%/    <component base=\"$derivedfrom\" xScale=\"-1\" xOffset=\"-460\"\/>/g" $gliffile
            ;;
            bold )
                sed -i -e "s/%COMPONENTS%/    <component base=\"$derivedfrom\" xScale=\"-1\" xOffset=\"-400\"\/>/g" $gliffile
            ;;
        esac
    else
        sed -i -e "s/%COMPONENTS%/    <component base=\"$derivedfrom\"\/>/g" $gliffile
    fi

    monotonicjson=`python3 ./bin/glyphjson.py ${targetufo}/glyphs ${derivedfrom} | jq -c .`

    for anchorjson in `echo $monotonicjson | jq -c '.anchors | .[]'`
    do
        x=`echo $anchorjson | jq .x`
        y=`echo $anchorjson | jq .y`
        name=`echo $anchorjson | jq -r .name`
        sed -i -e "s/%ANCHORS%/  <anchor x=\"$x\" y=\"$y\" name=\"$name\"\/>\n%ANCHORS%/g" $gliffile
    done
    sed -i -e "s/%ANCHORS%//g" $gliffile

    for guidelinejson in `echo $monotonicjson | jq -c '.guidelines | .[]'`
    do
        angle=`echo $guidelinejson | jq .angle`
        x=`echo $guidelinejson | jq .x`
        y=`echo $guidelinejson | jq .y`
        sed -i -e "s/%GUIDELINES%/  <guideline angle=\"$angle\" x=\"$x\" y=\"$y\"\/>%GUIDELINES%/g" $gliffile
    done
    sed -i -e "s/%GUIDELINES%/\n/g" $gliffile

    numlibkeys=`echo $monotonicjson | jq '.lib | length'`
    if [[ $numlibkeys == 0 ]]
    then
        sed -i -e "s/%LIB%//g" $gliffile
    else
        sed -i -e "s/%LIB%/  <lib>\n  <dict>\n%LIB%/g" $gliffile
        for libkey in `echo $monotonicjson | jq -r '.lib | keys | @sh' | sed -e "s/'//g"`
        do
            string=`echo $monotonicjson | jq -r --arg k $libkey '.lib.[$k]'`
            sed -i -e "s/%LIB%/  <key>${libkey}<\/key>\n  <string>${string}<\/string>\n%LIB%/g" $gliffile
        done
        sed -i -e "s/%LIB%/  <\/dict>\n  <\/lib>\n/g" $gliffile
    fi

    python3 bin/updateplist.py ${targetufo}/glyphs/contents.plist ${glyphname} ${glyphname}.glif
    if [[ $unicode == null ]]
    then
        volt=`python3 ./bin/appendglyph.py ${targetufo}/lib.plist ${glyphname} MARK`
        echo $volt >> ./patch/volt-${folder}.middle.cat
        echo $glyphname $glyphname >> ${targetufo}/../STIX2-Post2Dev.pg.unsorted.ren
        echo $glyphname $glyphname >> ${targetufo}/../STIX2-Dev2Post.pg.unsorted.ren
    else
        volt=`python3 ./bin/appendglyph.py ${targetufo}/lib.plist ${glyphname} -u $unicode MARK`
        echo $volt >> ./patch/volt-${folder}.middle.cat
        echo uni${unicode} $glyphname >> ${targetufo}/../STIX2-Post2Dev.pg.unsorted.ren
        echo $glyphname uni${unicode} >> ${targetufo}/../STIX2-Dev2Post.pg.unsorted.ren
    fi
done

# Group B
for glyphname in `echo $greekdiacritics | jq -r '."group-b" | keys | @sh' | sed "s/'//g"`
do
    lower=`echo $greekdiacritics | jq -r --arg g $glyphname '."group-b".[$g].vstack[0]'`
    upper=`echo $greekdiacritics | jq -r --arg g $glyphname '."group-b".[$g].vstack[1]'`

    gliffile=${targetufo}/glyphs/${glyphname}.glif
    cp ./source/.glif.stub $gliffile

    lowerjson=`python3 ./bin/glyphjson.py ${targetufo}/glyphs ${lower} | jq -c .`
    upperjson=`python3 ./bin/glyphjson.py ${targetufo}/glyphs ${upper} | jq -c .`
    loweranchory=`echo $lowerjson | jq -c '.anchors | map({(.name): {"x": .x, "y": .y, "name": .name}}) | add | ."top.mkmk".y'`
    upperanchory=`echo $upperjson | jq -c '.anchors | map({(.name): {"x": .x, "y": .y, "name": .name}}) | add | ."_top.mkmk".y'`
    yoffset=$(( loweranchory - upperanchory ))
    sed -i -e "s/%GLYPH-NAME%/${glyphname}/g" $gliffile
    sed -i -e "s/%ADVANCE%//g" $gliffile
    sed -i -e "s/%UNICODE%//g" $gliffile
    sed -i -e "s/%COMPONENTS%/    <component base=\"$lower\"\/>\n%COMPONENTS%/g" $gliffile
    sed -i -e "s/%COMPONENTS%/    <component base=\"$upper\" yOffset=\"$yoffset\"\/>/g" $gliffile

    ## To do:
    ## Take the "_top", "_top.mkmk" anchors from the lower
    ## Take the "top.mkmk" anchor from the upper (with yoffset)
    for anchorjson in `echo $lowerjson | jq -c '.anchors | .[] | select(.name[0:1] == "_")'`
    do
        x=`echo $anchorjson | jq .x`
        y=`echo $anchorjson | jq .y`
        name=`echo $anchorjson | jq -r .name`
        sed -i -e "s/%ANCHORS%/  <anchor x=\"$x\" y=\"$y\" name=\"$name\"\/>\n%ANCHORS%/g" $gliffile
    done
    for anchorjson in `echo $upperjson | jq -c '.anchors | .[] | select(.name[0:1] != "_")'`
    do
        x=`echo $anchorjson | jq .x`
        y=`echo $anchorjson | jq .y`
        name=`echo $anchorjson | jq -r .name`
        sed -i -e "s/%ANCHORS%/  <anchor x=\"$x\" y=\"$(( $y + $yoffset ))\" name=\"$name\"\/>\n%ANCHORS%/g" $gliffile
    done
    sed -i -e "s/%ANCHORS%//g" $gliffile

    ## Take any guidelines from the lower
    ## Discard any guidelines from the upper. Hopefully, this isn't any trouble
    for guidelinejson in `echo $lowerjson | jq -c '.guidelines | .[]'`
    do
        angle=`echo $guidelinejson | jq .angle`
        x=`echo $guidelinejson | jq .x`
        y=`echo $guidelinejson | jq .y`
        sed -i -e "s/%GUIDELINES%/  <guideline angle=\"$angle\" x=\"$x\" y=\"$y\"\/>%GUIDELINES%/g" $gliffile
    done
    sed -i -e "s/%GUIDELINES%/\n/g" $gliffile

    ## Take any lib from the lower
    ## Discard any lib from the upper. Hopefully this isn't any trouble.
    numlibkeys=`echo $lowerjson | jq '.lib | length'`
    if [[ $numlibkeys == 0 ]]
    then
        sed -i -e "s/%LIB%//g" $gliffile
    else
        sed -i -e "s/%LIB%/  <lib>\n  <dict>\n%LIB%/g" $gliffile
        for libkey in `echo $lowerjson | jq -r '.lib | keys | @sh' | sed -e "s/'//g"`
        do
            string=`echo $lowerjson | jq -r --arg k $libkey '.lib.[$k]'`
            sed -i -e "s/%LIB%/  <key>${libkey}<\/key>\n  <string>${string}<\/string>\n%LIB%/g" $gliffile
        done
        sed -i -e "s/%LIB%/  <\/dict>\n  <\/lib>\n/g" $gliffile
    fi

    python3 bin/updateplist.py ${targetufo}/glyphs/contents.plist ${glyphname} ${glyphname}.glif
    volt=`python3 ./bin/appendglyph.py ${targetufo}/lib.plist ${glyphname} MARK`
    echo $volt >> ./patch/volt-${folder}.middle.cat
    echo $glyphname $glyphname >> ${targetufo}/../STIX2-Post2Dev.pg.unsorted.ren
    echo $glyphname $glyphname >> ${targetufo}/../STIX2-Dev2Post.pg.unsorted.ren
done

# Group C
for glyphname in `echo $greekdiacritics | jq -r '."group-c" | keys | @sh' | sed "s/'//g"`
do
    left=`echo $greekdiacritics | jq -r --arg g $glyphname '."group-c".[$g].hstack[0]'`
    right=`echo $greekdiacritics | jq -r --arg g $glyphname '."group-c".[$g].hstack[1]'`
    deltax=`echo $greekdiacritics | jq -r --arg g $glyphname --arg w $weight '."group-c".[$g].deltax.[$w]'`
    # deltax calculated manually, and put in json file. Is there a way to do this automatically?

    gliffile=${targetufo}/glyphs/${glyphname}.glif
    cp ./source/.glif.stub $gliffile

    leftjson=`python3 ./bin/glyphjson.py ${targetufo}/glyphs ${left} | jq -c .`
    rightjson=`python3 ./bin/glyphjson.py ${targetufo}/glyphs ${right} | jq -c .`

    sed -i -e "s/%GLYPH-NAME%/${glyphname}/g" $gliffile
    sed -i -e "s/%ADVANCE%//g" $gliffile
    sed -i -e "s/%UNICODE%//g" $gliffile
    sed -i -e "s/%COMPONENTS%/    <component base=\"$left\" xOffset=\"-${deltax}\"\/>\n%COMPONENTS%/g" $gliffile
    sed -i -e "s/%COMPONENTS%/    <component base=\"$right\" xOffset=\"${deltax}\"\/>/g" $gliffile

    ## Take any marks from the right
    ## Discard any marks from the left. Hopefully, this isn't any trouble.
    ## Ideally, the left and right marks would be identical anyway.
    for anchorjson in `echo $leftjson | jq -c '.anchors | .[]'`
    do
        x=`echo $anchorjson | jq .x`
        y=`echo $anchorjson | jq .y`
        name=`echo $anchorjson | jq -r .name`
        sed -i -e "s/%ANCHORS%/  <anchor x=\"$x\" y=\"$y\" name=\"$name\"\/>\n%ANCHORS%/g" $gliffile
    done
    sed -i -e "s/%ANCHORS%//g" $gliffile

    ## Take any guidelines from the right
    ## Discard any guidelines from the left. Hopefully, this isn't any trouble
    for guidelinejson in `echo $rightjson | jq -c '.guidelines | .[]'`
    do
        angle=`echo $guidelinejson | jq .angle`
        x=`echo $guidelinejson | jq .x`
        y=`echo $guidelinejson | jq .y`
        sed -i -e "s/%GUIDELINES%/  <guideline angle=\"$angle\" x=\"$x\" y=\"$y\"\/>%GUIDELINES%/g" $gliffile
    done
    sed -i -e "s/%GUIDELINES%/\n/g" $gliffile

    ## Take any lib from the right
    ## Discard any lib from the left. Hopefully this isn't any trouble.
    numlibkeys=`echo $rightjson | jq '.lib | length'`
    if [[ $numlibkeys == 0 ]]
    then
        sed -i -e "s/%LIB%//g" $gliffile
    else
        sed -i -e "s/%LIB%/  <lib>\n  <dict>\n%LIB%/g" $gliffile
        for libkey in `echo $rightjson | jq -r '.lib | keys | @sh' | sed -e "s/'//g"`
        do
            string=`echo $rightjson | jq -r --arg k $libkey '.lib.[$k]'`
            sed -i -e "s/%LIB%/  <key>${libkey}<\/key>\n  <string>${string}<\/string>\n%LIB%/g" $gliffile
        done
        sed -i -e "s/%LIB%/  <\/dict>\n  <\/lib>\n/g" $gliffile
    fi

    python3 bin/updateplist.py ${targetufo}/glyphs/contents.plist ${glyphname} ${glyphname}.glif
    volt=`python3 ./bin/appendglyph.py ${targetufo}/lib.plist ${glyphname} MARK`
    echo $volt >> ./patch/volt-${folder}.middle.cat
    echo $glyphname $glyphname >> ${targetufo}/../STIX2-Post2Dev.pg.unsorted.ren
    echo $glyphname $glyphname >> ${targetufo}/../STIX2-Dev2Post.pg.unsorted.ren
done

# Spacing marks from combining marks
for glyphname in `echo $greekdiacritics | jq -r '."fromcomb" | keys | @sh' | sed "s/'//g"`
do
    unicodehex=`echo $greekdiacritics | jq -r --arg g $glyphname '.fromcomb.[$g][0]'`
    componentbase=`echo $greekdiacritics | jq -r --arg g $glyphname '.fromcomb.[$g][1]'`
    metricalbase=`echo $greekdiacritics | jq -r --arg g $glyphname '.fromcomb.[$g][2]'`

    if [[ $metricalbase == null ]]
    then
        metricalbase=$componentbase
    fi

    gliffile=${targetufo}/glyphs/${glyphname}.glif
    cp ${extensionsourcefolder}/.glif.stub $gliffile

    basejson=`python3 ./bin/glyphjson.py ${targetufo}/glyphs $metricalbase | jq -c .`
    left=`echo $basejson | jq '.box.left'`
    width=`echo $basejson | jq '.box.width'`
    case $weight in
        regular )
            xoffset=`jq -n 30-$left`
            advancewidth=`jq -n $width+60`
        ;;
        bold )
            xoffset=`jq -n 25-$left`
            advancewidth=`jq -n $width+50`
        ;;
    esac

    sed -i -e "s/%GLYPH-NAME%/${glyphname}/g" $gliffile
    sed -i -e "s/%ADVANCE%/  <advance width=\"${advancewidth}\"\/>\n/g" $gliffile
    if [[ $unicodehex == null ]]
    then
        sed -i -e "s/%UNICODE%//g" $gliffile
    else
        sed -i -e "s/%UNICODE%/  <unicode hex=\"${unicodehex}\"\/>/g" $gliffile
    fi

    if [[ $glyphname == iotasubscript ]]
    then
        anchory=`echo $basejson | jq '.anchors | map({(.name): {"x": .x, "y": .y, "name": .name}}) | add | ."bottom.mkmk".y'`
        anchorx=`jq -n $xoffset-230`
        sed -i -e "s/%ANCHORS%/\n  <anchor x=\"${anchorx}\" y=\"${anchory}\" name=\"bottom.mkmk\"\/>\n/g" $gliffile
    else
        anchory=`echo $basejson | jq '.anchors | map({(.name): {"x": .x, "y": .y, "name": .name}}) | add | ."top.mkmk".y'`
        anchorx=`jq -n $xoffset-230`
        sed -i -e "s/%ANCHORS%/\n  <anchor x=\"${anchorx}\" y=\"${anchory}\" name=\"top.mkmk\"\/>\n/g" $gliffile
    fi

    sed -i -e "s/%COMPONENTS%/    <component base=\"$componentbase\" xOffset=\"${xoffset}\"\/>/g" $gliffile
    sed -i -e "s/%GUIDELINES%//g" $gliffile
    sed -i -e "s/%LIB%/<lib>\n  <dict>\n  <key>public.markColor<\/key>\n  <string>0.604,0.6,1,1<\/string>\n  <\/dict>\n  <\/lib>\n/g" $gliffile

    python3 ./bin/updateplist.py ${targetufo}/glyphs/contents.plist ${glyphname} ${glyphname}.glif
    if [[ $unicodehex == null ]]
    then
        volt=`python3 ./bin/appendglyph.py ${targetufo}/lib.plist ${glyphname} BASE`
        echo $volt >> ./patch/volt-${folder}.middle.cat
        echo $glyphname $glyphname >> ${targetufo}/../STIX2-Post2Dev.pg.unsorted.ren
        echo $glyphname $glyphname >> ${targetufo}/../STIX2-Dev2Post.pg.unsorted.ren
    else
        volt=`python3 ./bin/appendglyph.py ${targetufo}/lib.plist ${glyphname} -u $unicodehex BASE`
        echo $volt >> ./patch/volt-${folder}.middle.cat
        echo uni${unicodehex} $glyphname >> ${targetufo}/../STIX2-Post2Dev.pg.unsorted.ren
        echo $glyphname uni${unicodehex} >> ${targetufo}/../STIX2-Dev2Post.pg.unsorted.ren
    fi
done

# Finally handle U+1FBE as an exception

gliffile=${targetufo}/glyphs/iotaadscript.glif
cp ${extensionsourcefolder}/.glif.stub $gliffile
advancewidth=`cat $metrics | jq --arg w $weight '.iota.base.[$w]."advance-width"'`
sed -i -e "s/%GLYPH-NAME%/iotaadscript/g" $gliffile
sed -i -e "s/%ADVANCE%/  <advance width=\"${advancewidth}\"\/>\n/g" $gliffile
sed -i -e "s/%UNICODE%/  <unicode hex=\"1FBE\"\/>/g" $gliffile
sed -i -e "s/%ANCHORS%/\n/g" $gliffile
sed -i -e "s/%COMPONENTS%/    <component base=\"iota\"\/>/g" $gliffile
sed -i -e "s/%GUIDELINES%//g" $gliffile
sed -i -e "s/%LIB%/  <lib>\n  <dict>\n  <key>public.markColor<\/key>\n  <string>0.6,1,0.602,1<\/string>\n  <\/dict>\n  <\/lib>\n/g" $gliffile
python3 bin/updateplist.py ${targetufo}/glyphs/contents.plist iotaadscript iotaadscript.glif
volt=`python3 ./bin/appendglyph.py ${targetufo}/lib.plist iotaadscript -u 1FBE BASE`
echo $volt >> ./patch/volt-${folder}.middle.cat
echo uni1FBE iotaadscript >> ${targetufo}/../STIX2-Post2Dev.pg.unsorted.ren
echo iotaadscript uni1FBE >> ${targetufo}/../STIX2-Dev2Post.pg.unsorted.ren
