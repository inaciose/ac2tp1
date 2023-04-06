pcompile prog1.s
ldpic32 prog1.hex
pterm

cat /opt/pic32mx/include/detpic32.h


pcompile prog1.s && ldpic32 prog1.hex && pterm
