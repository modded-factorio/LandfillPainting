#!/bin/bash
FACTORIO=~/factorio18

mkdir -p graphics/icons

for s in dry-dirt dirt-4 red-desert-1 sand-3 landfill; do
  convert $FACTORIO/data/base/graphics/icons/landfill.png -background transparent -extent 64x64 \
    \( $FACTORIO/data/base/graphics/terrain/$s.png -extent 64x64+20+64 \) \
    \( -clone 0 -alpha extract -threshold 0 \) \
    \( -clone 1,2 -compose multiply -composite \) -delete 1,2 \
    \( -clone 0 -fill "#323232" -colorize 100 \) \
    \( -clone 0 -colorspace HSL -channel Hue -separate +colorspace +channel \) \
    \( -clone 2,3 -channel R -separate -compose difference -composite -negate -level 90%,100% \) -delete 2,3 \
    \( -clone 0,1,2 -compose src-over -composite \) -delete 1,2 \
    +swap -compose copy-opacity -composite \
    \( -clone 0 -scale '50%' \) \
    \( -clone 1 -scale '50%' \) \
    \( -clone 2 -scale '50%' \) \
    +append graphics/icons/landfill-$s.png
done

cp $FACTORIO/data/base/graphics/icons/landfill.png graphics/icons/landfill-grass-1.png
