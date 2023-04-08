#include <detpic32.h>

#define DFMS 20000
#define MILIS 500

void delay(unsigned int);


int main (void) {
    // declare variables
    unsigned char segment;
    int i;

    // setup do TRISB 14-8 (para modo de output)
    TRISB = TRISB & 0x80FF;
    // setup do TRISD 5 e 6 (para modo de output)
    TRISD = TRISD & 0xFF9F;

    // reset aos bits 14-8 do LATB
    LATB = LATB & 0x80FF;

    // enable less / disable more
    LATDbits.LATD5 = 1;
    LATDbits.LATD6 = 0;

    
    // loop
    while(1) {
        segment = 1;
        for(i = 0; i < 7; i++) {
            // faz o reset a todos os bits relevantes 8 - 14
            LATB = LATB & 0x80FF;
            // desloca os bits da variavel 8 casas a esquerda
            // para os colocar alinhados com o bit 8
            // faz o set desses bits com o or
            LATB = LATB | (segment << 8);
            delay(MILIS);
            // desloca o bit da variavel segment para a esquerda
            segment = segment << 1;
        }
        
        // change digit to output
        LATDbits.LATD5 = !LATDbits.LATD5;
        LATDbits.LATD6 = !LATDbits.LATD6;
    }

    return 0;
}

void delay(unsigned int ms) {
    resetCoreTimer();
    while(readCoreTimer() < ms * DFMS);
}
