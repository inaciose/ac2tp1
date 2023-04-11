#include <detpic32.h>

#define KMS 20000

void delay (unsigned int ms);

int main(void) {

    // config RE7-RE2 to output
    TRISE = TRISE & 0xFF03;

    // config RB2 & RB0 to input
    TRISB = TRISB | 0x0005;

    int portval;
    int ms = 95;

    unsigned char cnt = 0x0030; // 48
    
    unsigned char tmp; 

    while(1) {

        LATE = (LATE & 0xFF00) | (cnt << 2);

        portval = PORTBbits.RB0 + PORTBbits.RB2;

        switch (portval) {
            case 0:
                ms = 286;
                break;
            case 2:
                ms = 95;
                break;
        }

        delay(ms);

        tmp = (cnt & 0x01) << 6;
        cnt = cnt | tmp;

        cnt = (cnt >> 1); // & 0x3F;
    }

    return 0;
}


void delay(unsigned int ms) {
    resetCoreTimer();
    while(readCoreTimer() < ms * KMS);
}

