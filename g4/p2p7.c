#include <detpic32.h>

char d7scode[] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x07F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71 };

int main(void) {
    // 7S-S: configure TRISB 8-14 for output | dipswitch: configure TRISB 0-3 for input
    TRISB = TRISB & 0x80FF | 0x000F;

    // 7S-D: configure TRISD 5-5 for output
    TRISD = TRISD & 0x0FF9F;

    // digit: disable less / enable more (output value)
    LATD = (LATD & 0xFF9F) | 0x0040;

    // dipswitch: configure TRISB 0-3 for input (done above)
    // TRISB = TRISB | 0x000F 

    unsigned int read;
    char digit;

    while(1) {
        // read value to displa
        read = PORTB & 0x000F;
        
        // get segments status from array using index
        digit = d7scode[read];       
        // send to 7 segment display
        LATB = (LATB & 0x80FF) | (digit << 8);
    }

    return 0;
}