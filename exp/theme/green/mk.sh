#!/bin/sh

function cut() {
    cNAME=$1
    cPART=$2
    cL=$3
    cT=$4
    cW=$5
    cH=$6

    echo convert skin/$cNAME.png -crop "${cW}x${cH}+${cL}+${cT}" skin/$cNAME.$cPART.png
    convert skin/$cNAME.png -crop "${cW}x${cH}+${cL}+${cT}" skin/$cNAME.$cPART.png
}

function cutLine() {
    lNAME=$1
    lPART=$2
    lT=$3
    lH=$4
    lL=$5
    lR=$6
    lW=$7
    IW=$(expr $W - $(expr $L + $R))
    
    cut $lNAME l$lPART 0  $lT $lL $lH
    cut $lNAME  $lPART $lL $lT $IW $lH
    cut $lNAME r$lPART $(expr $lL + $IW) $lT $lL $lH
}

function make9Grid() {
    NAME=$1
    SRC=$2
    YOFS=$3
    W=$4
    H=$5
    L=$6
    T=$7
    R=$8
    B=$9
    
    DST=skin/$NAME.

    IH=$(expr $H - $(expr $T + $B))


    inkscape -e skin/$NAME.png -a 0:$YOFS:$W:$(expr $YOFS + $H) $SRC
 
    cutLine $NAME t 0 $T $L $R $W
    cutLine $NAME c $T $IH $L $R $W
    cutLine $NAME b $(expr $T + $IH) $B $L $R $W
}



SKINS=$*
if [ -z $SKINS ]; then
    SKINS="BevelInFocus BevelIn BevelOutFocus BevelOut"
fi
BGS="FieldBg BevelInBg BevelOutBg"
ICONS="Dropdown Thumb ListCursor"

mkdir skin/

#function foo() {

# border 9slices
Y=0
for name in $SKINS; do
    echo ///////// Building image border $name
    make9Grid $name borders.svg $Y 20 20 5 5 5 5
    Y=$(expr $Y + 20)
done

# backgrounds
Y=0
for NAME in $BGS; do
    echo ///////// Building image background $NAME
    inkscape -e skin/$NAME.png -a 0:$Y:100:$(expr $Y + 100) backgrounds.svg
    Y=$(expr $Y + 100)
done

# icons
for NAME in $ICONS; do
    echo ///////// Building image icon $NAME
    inkscape -e skin/$NAME.png -j -i $NAME icons.svg
done

#}



# swfmill simple source
echo "<movie version=\"9\"><library>" > assets.swfml
for NAME in $SKINS $BGS $ICONS; do
    echo "  <clip id=\"skin.${NAME}_png\" import=\"skin/${NAME}.png\"/>" >> assets.swfml
done
echo "<frame/></library></movie>" >> assets.swfml

swfmill simple assets.swfml skin.swf


# haXe asset classes
echo "package skin;" > skin/Skin.hx
for NAME in $SKINS $BGS $ICONS; do
    echo "class ${NAME}_png extends flash.display.MovieClip { }" >> skin/Skin.hx
done
