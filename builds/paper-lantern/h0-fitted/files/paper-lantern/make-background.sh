#!/bin/bash
# Regenerates backgrounds/1-paper-lantern.jpg (needs ImageMagick 7).
set -euo pipefail
OUT=${1:-"$(dirname "$0")/backgrounds/1-paper-lantern.jpg"}
W=3840; H=2160; T=$(mktemp -d); trap 'rm -rf "$T"' EXIT
CX=2600; CY=1060
LX=$((CX-260)); LY=$((CY-350))

# Washi paper: fibrous streaks plus fine grain
magick -size ${W}x${H} xc:'#F4EDDF' \
  \( -size ${W}x${H} xc:gray50 +noise Gaussian -colorspace gray -blur 0x1.2 -motion-blur 0x18+20 \
     -auto-level -colorspace sRGB +level 97%,103% \) \
  -compose multiply -composite \
  \( -size ${W}x${H} xc:gray50 +noise Random -colorspace gray -blur 0x0.6 \
     -auto-level -colorspace sRGB +level 98%,101.5% \) \
  -compose multiply -composite "$T/paper.png"

# Warm lantern glow and soft vignette
magick -size 2600x2600 radial-gradient:'rgba(236,128,78,0.38)'-'rgba(244,237,223,0)' "$T/glow.png"
magick -size ${W}x${W} radial-gradient:white-'#F0E8DC' -gravity center -crop ${W}x${H}+0+0 +repage "$T/vig.png"
magick "$T/paper.png" "$T/glow.png" -geometry +$((CX-1300))+$((CY-1300)) -compose over -composite \
  "$T/vig.png" -compose multiply -composite "$T/base.png"

# Lantern body: shaded red ellipse with paper ribs
magick -size 520x700 xc:black -fill white -draw "ellipse 260,350 258,348 0,360" "$T/mask.png"
magick -size 520x700 radial-gradient:'#F0623C'-'#8A1D16' "$T/mask.png" \
  -alpha off -compose copyopacity -composite "$T/body.png"
ribs=()
for i in $(seq 1 11); do y=$((i*58)); ribs+=(-draw "line 0,$y 520,$y"); done
magick -size 520x700 xc:none -fill none -stroke 'rgba(80,15,10,0.55)' -strokewidth 4 "${ribs[@]}" \
  -stroke 'rgba(80,15,10,0.30)' -strokewidth 3 -draw "ellipse 260,350 130,348 0,360" -draw "line 260,0 260,700" \
  "$T/ribs.png"
magick "$T/ribs.png" "$T/body.png" -compose dstin -composite "$T/ribsin.png"
magick "$T/body.png" "$T/ribsin.png" -compose over -composite "$T/lantern.png"

# Ink string, caps and tassel
tassel=()
for dx in -36 -18 0 18 36; do tassel+=(-draw "line $((CX+dx/2)),$((LY+750)) $((CX+dx)),$((LY+920))"); done
magick "$T/base.png" \
  -stroke '#1C1915' -strokewidth 5 -draw "line $CX,0 $CX,$((LY-40))" -stroke none \
  "$T/lantern.png" -geometry +$LX+$LY -compose over -composite \
  -fill '#1C1915' -draw "roundrectangle $((CX-120)),$((LY-50)) $((CX+120)),$((LY+28)) 14,14" \
  -draw "roundrectangle $((CX-120)),$((LY+672)) $((CX+120)),$((LY+750)) 14,14" \
  -fill none -stroke '#1C1915' -strokewidth 4 "${tassel[@]}" \
  -quality 92 "$OUT"
