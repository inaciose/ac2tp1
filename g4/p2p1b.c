#include <detpic32.h>

int main(void) {
    // setup segment ports
    // configure RB8 - RB14 as output
    TRISB = TRISB & 0x80FF;

    // setup digit selector
    // configure RD5 as output
    // TRISD = TRISD & 0xFFDF
    TRISDbits.TRISD5 = 0;
    TRISDbits.TRISD6 = 0;

    // activate the less significative digit
    LATDbits.LATD5 = 0;
    LATDbits.LATD6 = 1;

    // reset all segments 
    LATB = LATB & 0x80FF;

    char c;
    // loop
    while(1) {
        c = getChar();
        if(c < 'A' || c > 'g') continue;
        if(c > 'G' && c < 'a') continue;

        // reset all segments 
        LATB = LATB & 0x80FF;

        switch(c) {
            case 'a':
            case 'A':
                LATBbits.LATB8 = 1;
            break;

            case 'b':
            case 'B':
                LATBbits.LATB9 = 1;
            break;

            case 'c':
            case 'C':
                LATBbits.LATB10 = 1;
            break;

            case 'd':
            case 'D':
                LATBbits.LATB11 = 1;
           break;
            
            case 'e':
            case 'E':
                LATBbits.LATB12 = 1;
            break;

            case 'f':
            case 'F':
                LATBbits.LATB13 = 1;
            break;
            
            case 'g':
            case 'G':
                LATBbits.LATB14 = 1;
            break;

        }
    }

    return 0;
}
