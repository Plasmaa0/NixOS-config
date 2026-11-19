# ASUS aura LED colour derived from the stylix base03 accent (used by the
# niri session's spawn-at-startup).
{
  lib,
  colors,
}: let
  inherit (builtins) floor fromJSON;
  inherit (lib) toHexString stringLength min max;

  r = fromJSON colors.base03-rgb-r;
  g = fromJSON colors.base03-rgb-g;
  b = fromJSON colors.base03-rgb-b;

  min-val = min (min r g) b;
  max-val = max (max r g) b;
  range = max-val - min-val;

  mid-val = r + g + b - min-val - max-val;

  sat-mid =
    if range == 0
    then 0
    else floor (255.0 * (mid-val - min-val) / range);

  saturate = ch:
    if ch == max-val
    then 255
    else if ch == min-val
    then 0
    else sat-mid;

  sat-r =
    if range == 0
    then 148
    else saturate r;
  sat-g =
    if range == 0
    then 103
    else saturate g;
  sat-b =
    if range == 0
    then 189
    else saturate b;

  pad2 = s:
    if stringLength s == 1
    then "0${s}"
    else s;
  toHex = n: pad2 (toHexString n);
in "${toHex sat-r}${toHex sat-g}${toHex sat-b}"
