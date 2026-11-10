#!/bin/bash
# Regenerates backgrounds/1-harbour-fog.jpg (needs ImageMagick 7). Run from the theme directory.
set -euo pipefail

W=3840
H=2160
HZ=1300 # horizon line
T=$(mktemp -d)
trap 'rm -rf "$T"' EXIT

# Sky and water gradients
magick -size ${W}x${HZ} gradient:'#1b2026-#3a4550' "$T/sky.png"
magick -size ${W}x$((H - HZ)) gradient:'#323c46-#161a1f' "$T/water.png"
magick "$T/sky.png" "$T/water.png" -append "$T/base.png"

# Hazy far hills (left) and a darker headland (right)
magick -size ${W}x${H} xc:none -fill '#2f3842' \
  -draw "polygon 0,1300 0,1205 300,1170 620,1190 900,1140 1250,1185 1500,1175 1800,1215 2050,1300" \
  -blur 0x6 "$T/hills1.png"
magick -size ${W}x${H} xc:none -fill '#262e36' \
  -draw "polygon 2300,1300 2550,1240 2900,1215 3200,1160 3500,1150 3840,1120 3840,1300" \
  -blur 0x3 "$T/hills2.png"

# Lighthouse on the headland
magick -size ${W}x${H} xc:none -fill '#20272e' \
  -draw "polygon 3268,1166 3276,1080 3290,1080 3298,1166" \
  -draw "rectangle 3264,1072 3302,1082" "$T/tower.png"

# Teal harbour light and its reflection on the water
magick -size ${W}x${H} xc:black -fill '#6e9e9b' -draw "circle 3283,1064 3283,1078" -blur 0x30 \
  -fill '#9cc7c3' -draw "circle 3283,1064 3283,1068" -blur 0x2 "$T/glow.png"
magick -size ${W}x${H} xc:black -fill '#3f605e' -draw "rectangle 3272,1310 3294,1900" \
  -blur 14x40 "$T/streak.png"

# Jetty in the foreground, plus a faint mirrored reflection
magick -size ${W}x${H} xc:none -fill '#13171b' \
  -draw "rectangle 0,1555 1180,1580" \
  -draw "rectangle 120,1580 140,1760" -draw "rectangle 400,1580 420,1740" \
  -draw "rectangle 680,1580 700,1720" -draw "rectangle 960,1580 978,1700" \
  -draw "rectangle 1160,1540 1180,1690" "$T/jetty.png"
magick "$T/jetty.png" -flip -roll +0+$((2 * 1580 - H)) \
  -channel A -evaluate multiply 0.35 +channel -blur 0x5 "$T/jettyr.png"

# Fog: soft plasma noise concentrated in a band around the horizon
magick -seed 7 -size 960x540 plasma:'#3a444e-#58646f' -colorspace gray -blur 0x24 \
  -resize ${W}x${H}! -level 35%,85% -fill '#5a6772' -colorize 60% "$T/fog.png"
magick -size ${W}x${H} xc:black -fill white -draw "rectangle 0,980 ${W},1460" -blur 0x160 "$T/fogmask.png"
magick "$T/fog.png" "$T/fogmask.png" -alpha off -compose copy_opacity -composite \
  -channel A -evaluate multiply 0.55 +channel "$T/fogl.png"

magick "$T/base.png" \
  "$T/hills1.png" -compose over -composite \
  "$T/hills2.png" -compose over -composite \
  "$T/tower.png" -compose over -composite \
  "$T/glow.png" -compose screen -composite \
  "$T/streak.png" -compose screen -composite \
  "$T/fogl.png" -compose over -composite \
  "$T/jettyr.png" -compose over -composite \
  "$T/jetty.png" -compose over -composite \
  -attenuate 0.2 +noise gaussian -quality 92 backgrounds/1-harbour-fog.jpg
