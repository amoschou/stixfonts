#!/bin/bash

folder=$1
extensionsourcefolder=$2
targetufo=$3
weight=$4
metrics=$5

echo "Generating ${folder} upper case glyphs"

for unicodehex in `cat ${extensionsourcefolder}/greek-extended.json | jq -rc 'with_entries(select(.value[0] == "uc")) | keys | @sh' | sed -e "s/'//g"`
do
    read case base topmark bottommark suffix <<< `cat ${extensionsourcefolder}/greek-extended.json | jq -r --arg h $unicodehex '.[$h] | @sh' | sed -e "s/'//g"`
    if [[ $topmark == "null" ]]
    then
        topmark=""
    fi
    if [[ $bottommark == "null" ]]
    then
        bottommark=""
    fi
    if [[ $suffix == "null" ]]
    then
        suffix=""
    fi

    glyphname=${base}${topmark}${bottommark}
    filename=${glyphname}.glif
    
    if [[ $bottommark != "" ]]
    then
        hasbottommark=1
        if [[ $topmark != "" ]]
        then
            hastopmark=1
            component1="${base}${bottommark}"
            component2="${topmark}comb${suffix}"
        else
            hastopmark=0
            component1=${base}
            component2="${bottommark}comb"
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
                component2="${topmark}comb${suffix}"
            ;;
            * )
                component2="${topmark}comb${suffix}"
            ;;
        esac
    fi

    gliffile=${targetufo}/glyphs/${filename}

    case $base in
        Rho )
            case $weight in
                regular )
                    phi=17
                ;;
                bold )
                    phi=5
                ;;
            esac
        ;;
        * )
            basetonosadvancewidth=`cat $metrics | jq --arg b $base --arg w $weight '.[$b].basetonos.[$w]."advance-width"'`
            basetonosanchorx=`cat $metrics | jq --arg b $base --arg w $weight '.[$b].basetonos.[$w].anchors."top.mkmk"[0]'`
            tonosadvancewidth=`cat $metrics | jq --arg w $weight '.tonos.[$w]."advance-width"'`
            tonosanchorx=`cat $metrics | jq --arg w $weight '.tonos.[$w].anchors."top.mkmk"[0]'`
            baseadvancewidth=`cat $metrics | jq --arg b $base --arg w $weight '.[$b].base.[$w]."advance-width"'`
            phi=`jq -n $baseadvancewidth-$basetonosadvancewidth+$basetonosanchorx+$tonosadvancewidth-$tonosanchorx`
        ;;
    esac

    # if [[ -f ${targetufo}/glyphs/${topmark}.cap ]]
    # then
        # suffix=.cap
    # else
        # suffix=""
    # fi

    ## These values below, although calculated from metrics,
    ## could actually be arbitrary by optical inspection.
    ## Except in the case of "oxia/psilioxia/dasiaoxia" because
    ## these match "tonos" which already exists in monotonic.
    case $weight in
        regular )
            case ${topmark}${suffix} in
                oxia | psilioxia | dasiaoxia )
                    psi9=0
                    psi10=0
                ;;
                varia | psilivaria | dasiavaria )
                    psi9=0
                    psi10=21
                ;;
                psili | psiliperispomeni.cap )
                    psi9=0
                    psi10=0
                ;;
                dasia | dasiaperispomeni.cap )
                    psi9=14
                    psi10=14
                ;;
                * )
                    psi9=0
                    psi10=0
                ;;
            esac
        ;;
        bold )
            case ${topmark}${suffix} in
                oxia | psilioxia | dasiaoxia )
                    psi9=0
                    psi10=0
                ;;
                varia | psilivaria | dasiavaria )
                    psi9=0
                    psi10=36
                ;;
                psili | psiliperispomeni.cap )
                    psi9=0
                    psi10=0
                ;;
                dasia | dasiaperispomeni.cap )
                    psi9=24
                    psi10=24
                ;;
                * )
                    psi9=0
                    psi10=0
                ;;
            esac
        ;;
    esac

    case $base in
        Epsilon | Eta | Iota | Rho | Upsilon )
            psi=$psi9
        ;;
        Alpha | Omicron | Omega )
            psi=$psi10
        ;;
    esac

    case $weight in
        regular )
            sidebearing=30
            markyoffset=-42
        ;;
        bold )
            sidebearing=25
            markyoffset=-47
        ;;
    esac

    topmarkadvancewidth=`python3 ./bin/glyphjson.py ${targetufo}/glyphs ${topmark}${suffix} | jq .width`
    pretendmark=`cat ${extensionsourcefolder}/greek-diacritics.json | jq -r --arg t "${topmark}${suffix}" '.fromcomb.[$t][2]'`
    if [[ $pretendmark == null ]]
    then
        topmarkboxleft=`python3 ./bin/glyphjson.py ${targetufo}/glyphs ${topmark}comb${suffix} | jq .box.left`
    else
        topmarkboxleft=`python3 ./bin/glyphjson.py ${targetufo}/glyphs ${pretendmark} | jq .box.left`
    fi

    mu=`jq -n $phi-$psi-$topmarkadvancewidth+$sidebearing`

    case $base in
        Upsilon )
            boundary=-33
        ;;
        * )
            boundary=-13
        ;;
    esac

    if [[ $mu -lt $boundary ]]
    then
        baseoffset=`jq -n $boundary-$mu`
        markxoffset=`jq -n $boundary-$topmarkboxleft`
    else
        baseoffset=0
        markxoffset=`jq -n $mu-$topmarkboxleft`
    fi

    advancewidth=`jq -n $baseadvancewidth+$baseoffset`

    cp ${extensionsourcefolder}/.glif.stub $gliffile

    sed -i -e "s/%GLYPH-NAME%/$glyphname/g" $gliffile
    sed -i -e "s/%ANCHORS%/\n/g" $gliffile
    sed -i -e "s/%UNICODE%/  <unicode hex=\"${unicodehex}\"\/>/g" $gliffile
    sed -i -e "s/%COMPONENTS%/    <component base=\"${component2}\" xOffset=\"${markxoffset}\" yOffset=\"${markyoffset}\"\/>\n%COMPONENTS%/g" $gliffile
    sed -i -e "s/%COMPONENTS%/    <component base=\"${component1}\" xOffset=\"${baseoffset}\"\/>/g" $gliffile
    sed -i -e "s/%ADVANCE%/  <advance width=\"${advancewidth}\"\/>\n/g" $gliffile
    sed -i -e "s/%GUIDELINES%%LIB%//g" $gliffile

    python3 bin/updateplist.py ${targetufo}/glyphs/contents.plist $glyphname $filename
    volt=`python3 ./bin/appendglyph.py ${targetufo}/lib.plist ${glyphname} -u $unicodehex BASE`
    echo $volt >> ./patch/volt-${folder}.middle.cat
    echo uni${unicodehex} $glyphname >> ${targetufo}/../STIX2-Post2Dev.pg.unsorted.ren
    echo $glyphname uni${unicodehex} >> ${targetufo}/../STIX2-Dev2Post.pg.unsorted.ren
done
