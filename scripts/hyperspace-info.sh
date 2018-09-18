#!/bin/bash
# summary of a hyperspace node
# 
clear
cd ~/go/bin
echo
echo '                 .:/-                        '
echo '                -yyyy:                       '
echo '                :yyyy/         -oyy+`        '
echo '         `:+/-  :yyyy/  -+o+-  +dddd:        '
echo '         sssss. :yyyy/ `yhhhh` +dddd:        '
echo '    `   `sssss. :yyyy/ .yyhhh` +hddd:  -+o:` '
echo '  :///- `sssss. :yyyy: .yyyhh` +hhdd: -ddddo '
echo '  +++++  oosss. :syyy: .yyyyh` +hhhh: -dddds '
echo '  /++++  oooss. :ssyy: .yyyyh` +hhhh: -dddds '
echo '  -:::-  ooooo. `-++:` .yyyyy` +hhhh: -dddds '
echo '         ooooo.  `...  .yyyyy` +hhhh:  /sso. '
echo '         /++oo` -osss- `oyyyo  /yhhh:        '
echo '          `..`  -ssss:   .-.   /yyhh:        '
echo '                `+oso.         .+oo/`        '
echo
./hsc consensus
echo
./hsc host
echo
./hsc gateway list
echo
./hsc wallet balance
echo
echo "System uptime: " ; uptime -p
echo
