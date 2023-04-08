#include <detpic32.h>


#define KFMS 20000
#define MILIS 500

void delay(unsigned int);

int main(void) {
    // configure port RE14 as output
    TRISCbits.TRISC14 = 0;
    while(1) {
        delay(MILIS);
        LATCbits.LATC14 = !LATCbits.LATC14;
    }   
    return 0;
}

void delay(unsigned int ms) {
    resetCoreTimer();
    unsigned int ticks = ms * KFMS;
    while(readCoreTimer() < ticks);
}