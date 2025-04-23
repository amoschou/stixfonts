#!/bin/bash

folder=$1
extensionsourcefolder=$2
targetufo=$3
weight=$4
metrics=$5

echo "Generating ${folder} lower case glyphs and simple uppercase glyphs"

for unicodehex in `cat ${extensionsourcefolder}/greek-extended.json | jq -rc 'with_entries(select(.value[0] == ("lc", "uc-simple"))) | keys | @sh' | sed -e "s/'//g"`
do
    read case base topmark bottommark <<< `cat ${extensionsourcefolder}/greek-extended.json | jq -r --arg h $unicodehex '.[$h] | @sh' | sed -e "s/'//g"`
    if [[ $topmark == "null" ]]
    then
        topmark=""
    fi
    if [[ $bottommark == "null" ]]
    then
        bottommark=""
    fi

    glyphname=${base}${topmark}${bottommark}
    filename=${glyphname}.glif
    
    if [[ $bottommark != "" ]]
    then
        hasbottommark=1
        if [[ $topmark != "" ]]
        then
            hastopmark=1
            component1=${base}${bottommark}
            component2=${topmark}comb
        else
            hastopmark=0
            component1=${base}
            component2=${bottommark}comb
        fi
    else
        hasbottommark=0
        component1=${base}
        hastopmark=1
        case $topmark in
            "" )
                hastopmark=0
            ;;
            breve | macron )
                component2=${topmark}comb
                if [[ $case == uc-simple ]]
                then
                    component2=${topmark}comb.cap
                fi
            ;;
            * )
                component2=${topmark}comb
            ;;
        esac
    fi

    gliffile=${targetufo}/glyphs/${filename}

    advancewidth=`cat $metrics | jq --arg b $base --arg w $weight '.[$b].base.[$w]."advance-width"'`

    case $component2 in
        variacomb )
            offsetname=variaoffset
        ;;
        psilivariacomb | dasiavariacomb )
            offsetname=breathvariaoffset
        ;;
        psilioxiacomb | dasiaoxiacomb )
            offsetname=breathoxiaoffset
        ;;
        oxiacomb )
            offsetname=oxiaoffset
        ;;
        iotasubscriptcomb )
            offsetname=iotaoffset
        ;;
        * )
            offsetname=axisoffset
        ;;
    esac

    component2offset=`cat $metrics | jq --arg b $base --arg w $weight --arg o $offsetname '.[$b].coordinates.[$w].[$o]'`

    cp ${extensionsourcefolder}/.glif.stub $gliffile

    sed -i -e "s/%GLYPH-NAME%/$glyphname/g" $gliffile
    sed -i -e "s/%ADVANCE%/  <advance width=\"$advancewidth\"\/>\n/g" $gliffile
    sed -i -e "s/%UNICODE%/  <unicode hex=\"$unicodehex\"\/>/g" $gliffile
    sed -i -e "s/%COMPONENTS%/    <component base=\"$component1\"\/>\n%COMPONENTS%/g" $gliffile
    sed -i -e "s/%COMPONENTS%/    <component base=\"$component2\" xOffset=\"$component2offset\"\/>/g" $gliffile
    
    for anchorname in `cat $metrics | jq -r --arg b $base --arg w $weight '.[$b].base.[$w].anchors | keys | @sh' | sed -e "s/'//g"`
    do
        case $anchorname in
            bottom )
                anchorx=`cat $metrics | jq --arg b $base --arg w $weight '.[$b].base.[$w].anchors.bottom[0]'`
                case $hasbottommark in
                    0 )
                        anchory=`cat $metrics | jq --arg b $base --arg w $weight '.[$b].base.[$w].anchors.bottom[1]'`
                        newanchorname=$anchorname
                    ;;
                    1 )
                        case $bottommark in
                            * )
                                anchory=-220
                            ;;
                        esac
                        newanchorname=${anchorname}.mkmk
                    ;;
                esac
                sed -i -e "s/%ANCHORS%/\n  <anchor x=\"$anchorx\" y=\"$anchory\" name=\"$newanchorname\"\/>%ANCHORS%/g" $gliffile
            ;;
            cedilla | ogonek )
                anchorx=`cat $metrics | jq --arg b $base --arg w $weight --arg n $anchorname '.[$b].base.[$w].anchors.[$n][0]'`
                anchory=`cat $metrics | jq --arg b $base --arg w $weight --arg n $anchorname '.[$b].base.[$w].anchors.[$n][1]'`
                newanchorname=$anchorname
                sed -i -e "s/%ANCHORS%/\n  <anchor x=\"$anchorx\" y=\"$anchory\" name=\"$newanchorname\"\/>%ANCHORS%/g" $gliffile
            ;;
            top )
                anchorx=`cat $metrics | jq --arg b $base --arg w $weight '.[$b].base.[$w].anchors.top[0]'`
                case $hastopmark in
                    0 )
                        anchory=`cat $metrics | jq --arg b $base --arg w $weight '.[$b].base.[$w].anchors.top[1]'`
                        newanchorname=$anchorname
                    ;;
                    1 )
                        case $topmark in
                            dialyttikaperispomeni )
                                anchory=`cat $metrics | jq --arg b $base --arg w $weight '.[$b].basedialytika.[$w].anchors."top.mkmk"[1]'`
                            ;;
                            perispomeni )
                                anchory=485
                            ;;
                            breve )
                                case $case in
                                    lc )
                                        anchory=`cat $metrics | jq --arg w $weight '.common.coordinates.[$w].brevecomb."top.mkmk"[1]'`
                                    ;;
                                    uc-simple )
                                        anchory=`cat $metrics | jq --arg w $weight '.common.coordinates.[$w]."brevecomb.cap"."top.mkmk"[1]'`
                                    ;;
                                esac
                            ;;
                            macron )
                                case $case in
                                    lc )
                                        anchory=`cat $metrics | jq --arg w $weight '.common.coordinates.[$w].macroncomb."top.mkmk"[1]'`
                                    ;;
                                    uc-simple )
                                        anchory=`cat $metrics | jq --arg w $weight '.common.coordinates.[$w]."macroncomb.cap"."top.mkmk"[1]'`
                                    ;;
                                esac
                            ;;
                            "" )
                                anchory=`cat $metrics | jq --arg b $base --arg w $weight '.[$b].base.[$w].anchors."top"[1]'`
                            ;;
                            * )
                                anchory=`cat $metrics | jq --arg b $base --arg w $weight '.[$b].basetonos.[$w].anchors."top.mkmk"[1]'`
                            ;;
                        esac
                        
                        case $topmark in
                            psiliperispomeni | dasiaperispomeni | perispomeni )
                                case $weight in
                                    regular )
                                        deltay=167
                                    ;;
                                    bold )
                                        deltay=179
                                    ;;
                                esac
                            ;;
                            dialytikaperispomeni )
                                case $weight in
                                    regular )
                                        deltay=129
                                    ;;
                                    bold )
                                        deltay=158
                                    ;;
                                esac
                            ;;
                            * )
                                deltay=0
                            ;;
                        esac
                        
                        anchory=$(( $anchory + $deltay ))
                        newanchorname=${anchorname}.mkmk
                    ;;
                esac
                sed -i -e "s/%ANCHORS%/\n  <anchor x=\"$anchorx\" y=\"$anchory\" name=\"$newanchorname\"\/>%ANCHORS%/g" $gliffile
            ;;
        esac
    done

    sed -i -e "s/%ANCHORS%/\n/g" $gliffile
    
    basejson=`python3 ./bin/glyphjson.py ${targetufo}/glyphs $base | jq -c .`

    sed -i -e "s/%GUIDELINES%//g" $gliffile

    numlibkeys=`echo $basejson | jq '.lib | length'`
    if [[ $numlibkeys == 0 ]]
    then
        sed -i -e "s/%LIB%//g" $gliffile
    else
        sed -i -e "s/%LIB%/  <lib>\n  <dict>\n%LIB%/g" $gliffile
        for libkey in `echo $basejson | jq -r '.lib | keys | @sh' | sed -e "s/'//g"`
        do
            string=`echo $basejson | jq -r --arg k $libkey '.lib.[$k]'`
            sed -i -e "s/%LIB%/  <key>${libkey}<\/key>\n  <string>${string}<\/string>\n%LIB%/g" $gliffile
        done
        sed -i -e "s/%LIB%/  <\/dict>\n  <\/lib>\n/g" $gliffile
    fi

    python3 bin/updateplist.py ${targetufo}/glyphs/contents.plist $glyphname $filename
    volt=`python3 ./bin/appendglyph.py ${targetufo}/lib.plist ${glyphname} -u $unicodehex BASE`
    echo $volt >> ./patch/volt-${folder}.middle.cat
    echo uni${unicodehex} $glyphname >> ${targetufo}/../STIX2-Post2Dev.pg.unsorted.ren
    echo $glyphname uni${unicodehex} >> ${targetufo}/../STIX2-Dev2Post.pg.unsorted.ren
done
