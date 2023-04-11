#include <detpic32.h>

#define FREQ0 (int)(FREQ/3)
#define FREQ1 (int)(FREQ/7)

void delay(unsigned int ticks);

int main(void) {
    // cfg RE5 - RE0 for output
    TRISE = TRISE & 0xFFC0;

    // cfg RB2 as input
    TRISB = TRISB | 0x0008;

    unsigned char cnt = 1;
    unsigned char tmp;

    while(1) {
        // show leds
        LATE = (LATE & 0xFFC0) | cnt;

        // read switch
        if(PORTBbits.RB2) {
            delay(5714285);
        } else {
            delay(13333333);
        }
        
        // rotate right 5 and isolate bit 0
        tmp = (cnt >> 5) & 0x0001;

        // rotate cnt left and mask | or recycled bit
        cnt = ((cnt << 1) & 0x003F) | tmp;

    }

    return 0;
}



void delay(unsigned int ticks) {
    resetCoreTimer();
    while(readCoreTimer() < ticks);
}
