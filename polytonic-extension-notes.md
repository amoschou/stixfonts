# Design notes for the polytonic Greek extension

## How to generate the `eta` forms:

Given the 25 `pg.alpha*.glif` files in a temporary folder, run the following commands:

```
rename alpha eta *.glif
rm pg.etabreve.glif pg.etamacron.glif
sed -i -e 's/alpha/eta/g' *.glif
sed -i -e 's/x="280" y="699" name="top.mkmk"/x="306" y="699" name="top.mkmk"/g' *.glif
sed -i -e 's/x="280" y="652" name="top.mkmk"/x="306" y="652" name="top.mkmk"/g' *.glif
sed -i -e 's/x="280" y="866" name="top.mkmk"/x="306" y="866" name="top.mkmk"/g' *.glif
sed -i -e 's/x="271" y="652" name="top.mkmk"/x="296" y="652" name="top.mkmk"/g' *.glif
sed -i -e 's/x="271" y="473" name="top"/x="296" y="473" name="top"/g' *.glif
sed -i -e 's/x="257" y="0" name="bottom"/x="266" y="0" name="bottom"/g' *.glif
sed -i -e 's/x="257" y="0" name="cedilla"/x="266" y="0" name="cedilla"/g' *.glif
sed -i -e 's/x="402" y="0" name="ogonek"/x="266" y="0" name="ogonek"/g' *.glif
sed -i -e 's/x="257" y="-220" name="bottom.mkmk"/x="266" y="-220" name="bottom.mkmk"/g' *.glif
sed -i -e 's/width="561"/width="510"/g' *.glif
sed -i -e 's/xOffset="510"/xOffset="536"/g' *.glif
sed -i -e 's/xOffset="501"/xOffset="526"/g' *.glif
sed -i -e 's/base="pg.iotasubscriptcomb" xOffset="487"/base="pg.iotasubscriptcomb" xOffset="357"/g' *.glif
sed -i -e 's/unicode hex="1F0/unicode hex="1F2/g' *.glif
sed -i -e 's/unicode hex="1F70"/unicode hex="1F74"/g' *.glif
sed -i -e 's/unicode hex="1F71"/unicode hex="1F75"/g' *.glif
sed -i -e 's/unicode hex="1F8/unicode hex="1F9/g' *.glif
sed -i -e 's/unicode hex="1FB/unicode hex="1FC/g' *.glif
```

It it converts them into the 23 `pg.eta*.glif` files.

## How to generate the `omega` forms:

Given the 25 `pg.alpha*.glif` files in a temporary folder, run the following commands:

```
rename alpha omega *.glif
rm pg.omegabreve.glif pg.omegamacron.glif
sed -i -e 's/alpha/omega/g' *.glif
sed -i -e 's/x="280" y="699" name="top.mkmk"/x="347" y="699" name="top.mkmk"/g' *.glif
sed -i -e 's/x="280" y="652" name="top.mkmk"/x="347" y="652" name="top.mkmk"/g' *.glif
sed -i -e 's/x="280" y="866" name="top.mkmk"/x="347" y="866" name="top.mkmk"/g' *.glif
sed -i -e 's/x="271" y="652" name="top.mkmk"/x="347" y="652" name="top.mkmk"/g' *.glif
sed -i -e 's/x="271" y="473" name="top"/x="347" y="473" name="top"/g' *.glif
sed -i -e 's/x="257" y="0" name="bottom"/x="330" y="0" name="bottom"/g' *.glif
sed -i -e 's/x="257" y="0" name="cedilla"/x="331" y="0" name="cedilla"/g' *.glif
sed -i -e 's/x="402" y="0" name="ogonek"/x="331" y="0" name="ogonek"/g' *.glif
sed -i -e 's/x="257" y="-220" name="bottom.mkmk"/x="330" y="-220" name="bottom.mkmk"/g' *.glif
sed -i -e 's/width="561"/width="660"/g' *.glif
sed -i -e 's/xOffset="510"/xOffset="577"/g' *.glif
sed -i -e 's/xOffset="501"/xOffset="577"/g' *.glif
sed -i -e 's/base="pg.iotasubscriptcomb" xOffset="487"/base="pg.iotasubscriptcomb" xOffset="560"/g' *.glif
sed -i -e 's/unicode hex="1F0/unicode hex="1F6/g' *.glif
sed -i -e 's/unicode hex="1F70"/unicode hex="1F7C"/g' *.glif
sed -i -e 's/unicode hex="1F71"/unicode hex="1F7D"/g' *.glif
sed -i -e 's/unicode hex="1F8/unicode hex="1FA/g' *.glif
sed -i -e 's/unicode hex="1FB/unicode hex="1FF/g' *.glif
```

It it converts them into the 23 `pg.omega*.glif` files.

## How to generate the `epsilon` forms:

Given the 25 `pg.alpha*.glif` files in a temporary folder, run the following commands:

```
rename alpha epsilon *.glif
rm -f pg.epsilonbreve.glif pg.epsilonmacron.glif pg.epsilon*iotasubscript.glif pg.epsilon*perispomeni*.glif
sed -i -e 's/alpha/epsilon/g' *.glif
sed -i -e 's/x="280" y="699" name="top.mkmk"/x="258" y="699" name="top.mkmk"/g' *.glif
sed -i -e 's/x="280" y="652" name="top.mkmk"/x="258" y="652" name="top.mkmk"/g' *.glif
sed -i -e 's/x="280" y="866" name="top.mkmk"/x="258" y="866" name="top.mkmk"/g' *.glif
sed -i -e 's/x="271" y="473" name="top"/x="258" y="473" name="top"/g' *.glif
sed -i -e 's/x="257" y="0" name="bottom"/x="198" y="0" name="bottom"/g' *.glif
sed -i -e 's/x="257" y="0" name="cedilla"/x="199" y="0" name="cedilla"/g' *.glif
sed -i -e 's/x="402" y="0" name="ogonek"/x="199" y="0" name="ogonek"/g' *.glif
sed -i -e 's/x="257" y="-220" name="bottom.mkmk"/x="198" y="-220" name="bottom.mkmk"/g' *.glif
sed -i -e 's/width="561"/width="381"/g' *.glif
sed -i -e 's/xOffset="510"/xOffset="488"/g' *.glif
sed -i -e 's/xOffset="501"/xOffset="488"/g' *.glif
sed -i -e 's/unicode hex="1F0/unicode hex="1F1/g' *.glif
sed -i -e 's/unicode hex="1F70"/unicode hex="1F72"/g' *.glif
sed -i -e 's/unicode hex="1F71"/unicode hex="1F73"/g' *.glif
```

It it converts them into the 10 `pg.epsilon*.glif` files.

## How to generate the `omicron` forms:

Given the 25 `pg.alpha*.glif` files in a temporary folder, run the following commands:

```
rename alpha omicron *.glif
rm -f pg.omicronbreve.glif pg.omicronmacron.glif pg.omicron*iotasubscript.glif pg.omicron*perispomeni*.glif
sed -i -e 's/alpha/omicron/g' *.glif
sed -i -e 's/x="280" y="699" name="top.mkmk"/x="283" y="699" name="top.mkmk"/g' *.glif
sed -i -e 's/x="280" y="652" name="top.mkmk"/x="283" y="652" name="top.mkmk"/g' *.glif
sed -i -e 's/x="280" y="866" name="top.mkmk"/x="283" y="866" name="top.mkmk"/g' *.glif
sed -i -e 's/x="271" y="473" name="top"/x="283" y="473" name="top"/g' *.glif
sed -i -e 's/x="257" y="0" name="bottom"/x="230" y="0" name="bottom"/g' *.glif
sed -i -e 's/x="257" y="0" name="cedilla"/x="230" y="0" name="cedilla"/g' *.glif
sed -i -e 's/x="402" y="0" name="ogonek"/x="245" y="0" name="ogonek"/g' *.glif
sed -i -e 's/width="561"/width="475"/g' *.glif
sed -i -e 's/xOffset="510"/xOffset="513"/g' *.glif
sed -i -e 's/xOffset="501"/xOffset="513"/g' *.glif
sed -i -e 's/unicode hex="1F0/unicode hex="1F4/g' *.glif
sed -i -e 's/unicode hex="1F70"/unicode hex="1F78"/g' *.glif
sed -i -e 's/unicode hex="1F71"/unicode hex="1F79"/g' *.glif
```

It it converts them into the 10 `pg.omicron*.glif` files.

## How to generate the `iota` forms:

Given the 25 `pg.alpha*.glif` files in a temporary folder, run the following commands (These could possibly be made more efficient, but they work as they are):

```
rename alpha iota *.glif
rm -f pg.iota*iotasubscript.glif
sed -i -e 's/alpha/iota/g' *.glif
sed -i -e 's/x="280" y="699" name="top.mkmk"/x="140" y="699" name="top.mkmk"/g' *.glif
sed -i -e 's/x="280" y="652" name="top.mkmk"/x="140" y="652" name="top.mkmk"/g' *.glif
sed -i -e 's/x="280" y="866" name="top.mkmk"/x="140" y="866" name="top.mkmk"/g' *.glif
sed -i -e 's/x="271" y="652" name="top.mkmk"/x="125" y="652" name="top.mkmk"/g' *.glif
sed -i -e 's/x="271" y="473" name="top"/x="125" y="473" name="top"/g' *.glif
sed -i -e 's/x="257" y="0" name="bottom"/x="142" y="0" name="bottom"/g' *.glif
sed -i -e 's/x="257" y="0" name="cedilla"/x="152" y="0" name="cedilla"/g' *.glif
sed -i -e 's/x="402" y="0" name="ogonek"/x="145" y="0" name="ogonek"/g' *.glif
sed -i -e 's/x="257" y="-220" name="bottom.mkmk"/x="142" y="-220" name="bottom.mkmk"/g' *.glif
sed -i -e 's/width="561"/width="259"/g' *.glif
sed -i -e 's/xOffset="510"/xOffset="370"/g' *.glif
sed -i -e 's/xOffset="501"/xOffset="355"/g' *.glif
sed -i -e 's/unicode hex="1F0/unicode hex="1F3/g' *.glif
sed -i -e 's/unicode hex="1F70"/unicode hex="1F76"/g' *.glif
sed -i -e 's/unicode hex="1F71"/unicode hex="1F77"/g' *.glif
sed -i -e 's/unicode hex="1FB/unicode hex="1FD/g' *.glif
sed -i -e 's/x="271" y="610" name="top.mkmk"/x="125" y="610" name="top.mkmk"/g' pg.iotamacron.glif
sed -i -e 's/x="271" y="683" name="top.mkmk"/x="125" y="683" name="top.mkmk"/g' pg.iotabreve.glif

cp pg.iotaoxia.glif pg.iotadialytikaoxia.glif
sed -i -e 's/iota/iotadialytika/g' pg.iotadialytikaoxia.glif
sed -i -e 's/hex="1F77"/hex="1FD3"/g' pg.iotadialytikaoxia.glif
sed -i -e 's/x="140" y="699" name="top.mkmk"/x="125" y="699" name="top.mkmk"/g' pg.iotadialytikaoxia.glif

cp pg.iotabreve.glif pg.iotadialytikavaria.glif
sed -i -e 's/breve/dialytikavaria/g' pg.iotadialytikavaria.glif
sed -i -e 's/dialytikavariacomb/pg.dialytikavariacomb/g' pg.iotadialytikavaria.glif
sed -i -e 's/hex="1FD0"/hex="1FD2"/g' pg.iotadialytikavaria.glif
sed -i -e 's/x="125" y="683" name="top.mkmk"/x="125" y="699" name="top.mkmk"/g' pg.iotadialytikavaria.glif

cp pg.iotabreve.glif pg.iotadialytikaperispomeni.glif
sed -i -e 's/breve/dialytikaperispomeni/g' pg.iotadialytikaperispomeni.glif
sed -i -e 's/dialytikaperispomeni/pg.dialytikaperispomeni/g' pg.iotadialytikaperispomeni.glif
sed -i -e 's/hex="1FD0"/hex="1FD7"/g' pg.iotadialytikaperispomeni.glif
sed -i -e 's/x="125" y="683" name="top.mkmk"/x="125" y="828" name="top.mkmk"/g' pg.iotadialytikaperispomeni.glif

```

It it converts them into the 16 `pg.iota*.glif` files.

## How to generate the `upsilon` forms:

Given the 25 `pg.alpha*.glif` files in a temporary folder, run the following commands (These could possibly be made more efficient, but they work as they are):

```
rename alpha upsilon *.glif
rm -f pg.upsilon*iotasubscript.glif
sed -i -e 's/alpha/upsilon/g' *.glif
sed -i -e 's/x="280" y="699" name="top.mkmk"/x="260" y="699" name="top.mkmk"/g' *.glif
sed -i -e 's/x="280" y="652" name="top.mkmk"/x="260" y="652" name="top.mkmk"/g' *.glif
sed -i -e 's/x="280" y="866" name="top.mkmk"/x="260" y="866" name="top.mkmk"/g' *.glif
sed -i -e 's/x="271" y="652" name="top.mkmk"/x="225" y="652" name="top.mkmk"/g' *.glif
sed -i -e 's/x="271" y="473" name="top"/x="225" y="473" name="top"/g' *.glif
sed -i -e 's/x="257" y="0" name="bottom"/x="234" y="0" name="bottom"/g' *.glif
sed -i -e 's/x="257" y="0" name="cedilla"/x="235" y="0" name="cedilla"/g' *.glif
sed -i -e 's/x="402" y="0" name="ogonek"/x="246" y="0" name="ogonek"/g' *.glif
sed -i -e 's/width="561"/width="491"/g' *.glif
sed -i -e 's/xOffset="510"/xOffset="490"/g' *.glif
sed -i -e 's/xOffset="501"/xOffset="455"/g' *.glif
sed -i -e 's/unicode hex="1F0/unicode hex="1F5/g' *.glif
sed -i -e 's/unicode hex="1F70"/unicode hex="1F7A"/g' *.glif
sed -i -e 's/unicode hex="1F71"/unicode hex="1F7B"/g' *.glif
sed -i -e 's/unicode hex="1FB/unicode hex="1FE/g' *.glif
sed -i -e 's/x="271" y="610" name="top.mkmk"/x="225" y="610" name="top.mkmk"/g' pg.upsilonmacron.glif
sed -i -e 's/x="271" y="683" name="top.mkmk"/x="225" y="683" name="top.mkmk"/g' pg.upsilonbreve.glif

cp pg.upsilonoxia.glif pg.upsilondialytikaoxia.glif
sed -i -e 's/upsilon/upsilondialytika/g' pg.upsilondialytikaoxia.glif
sed -i -e 's/hex="1F7B"/hex="1FE3"/g' pg.upsilondialytikaoxia.glif
sed -i -e 's/x="260" y="699" name="top.mkmk"/x="225" y="699" name="top.mkmk"/g' pg.upsilondialytikaoxia.glif

cp pg.upsilonbreve.glif pg.upsilondialytikavaria.glif
sed -i -e 's/breve/dialytikavaria/g' pg.upsilondialytikavaria.glif
sed -i -e 's/dialytikavariacomb/pg.dialytikavariacomb/g' pg.upsilondialytikavaria.glif
sed -i -e 's/hex="1FE0"/hex="1FE2"/g' pg.upsilondialytikavaria.glif
sed -i -e 's/x="225" y="683" name="top.mkmk"/x="225" y="699" name="top.mkmk"/g' pg.upsilondialytikavaria.glif

cp pg.upsilonbreve.glif pg.upsilondialytikaperispomeni.glif
sed -i -e 's/breve/dialytikaperispomeni/g' pg.upsilondialytikaperispomeni.glif
sed -i -e 's/dialytikaperispomeni/pg.dialytikaperispomeni/g' pg.upsilondialytikaperispomeni.glif
sed -i -e 's/hex="1FE0"/hex="1FE7"/g' pg.upsilondialytikaperispomeni.glif
sed -i -e 's/x="225" y="683" name="top.mkmk"/x="225" y="828" name="top.mkmk"/g' pg.upsilondialytikaperispomeni.glif

```

It it converts them into the 16 `pg.upsilon*.glif` files.
