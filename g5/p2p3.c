
#include <detpic32.h>

#define KFMS 20000
#define MILIS7S 10
#define MILISCD 25
#define MILISCU 10

unsigned char toBcd(unsigned char value);
void send2display(unsigned char value);
void delay(unsigned int);

int main(void) {
    // D7S-S: configure RB8-RB14 for output
    TRISB = TRISB & 0x80FF;

    // D7S-D: configure RD5 & RD6 for output
    TRISD = TRISD & 0xFF9F;

    // configure leds RE0-RE7
    TRISE = TRISE & 0xFF00;

    // reset leds
    LATE = (LATE & 0xFF00);

    // configure dipswitch 1 (RB0) for input
    TRISBbits.TRISB0 = 1;


    // declare variables
    int counter = 0;
    int i;
    int ii = 0;

    int up = 1;

    while(1) {
        i = 0;

        up = PORTBbits.RB0;

        do{
            send2display(toBcd((unsigned char)counter));
            delay(MILIS7S);
        } while(++i < 2);
        LATE = (LATE & 0xFF00) | (toBcd((unsigned char)counter));
        ii++;

        if(up) {
            if(ii == MILISCU) {
                ii = 0;
                counter++;
                if(counter == 60) counter = 0; 
            }
        } else {
            if(ii == MILISCD) {
                ii = 0;
                counter--;
                if(counter == -1) counter = 59;
            }

        }

    }

    return 0;

}


unsigned char toBcd(unsigned char value) {
    return ((value / 10) << 4) + (value % 10);
}

void send2display(unsigned char value) {
    // array com os segmentos a enviar para cada digito de 0 a F.
    static const char d7scode[] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x07F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71 };
    static char displayFlag = 1;

    if(displayFlag) {
        // select display digit
        LATD = (LATD & 0xFF9F) | 0x0040;
        // set digit segments
        LATB = (LATB & 0x80FF) | (d7scode[value >> 4] << 8);
    } else {
        // select display digit
        //LATD = (LATD & 0xFF9F) | 0x0040;
        LATD = LATD ^ 0x0060;
        // set digit segments
        LATB = (LATB & 0x80FF) | (d7scode[value & 0x0F] << 8);
    }

    displayFlag = !displayFlag;
}

void delay(unsigned int ms) {
    resetCoreTimer();
    while(readCoreTimer() < ms * KFMS);
}
