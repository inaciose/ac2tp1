#include <detpic32.h>

#define KFMS 20000
#define MILIS 10

void send2displays(unsigned char);
void delay(unsigned int ms);

int main(void) {

    // configure display segment ports for output RB8-RB14
    TRISB = TRISB & 0x80FF;

    // configure display digit select ports for output RD5-RD6
    TRISD = TRISD & 0xFF9F;

    while(1) {
        send2displays(0x15);
        delay(MILIS);
    }

    return 0;
}


void send2displays(unsigned char value) {
    // array com os segmentos a enviar para cada digito de 0 a F.
    static const char d7scode[] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x07F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71 };

    // activa o digito mais signitivo no display e desactiva o menos significativo
    LATD = (LATD & 0xFF9F) | 0x0040;

    // get segments status from array using index
    //digit = d7scode[value >> 4];       
    // send to 7 segment display
    LATB = (LATB & 0x80FF) | (d7scode[value >> 4] << 8);

    //delay(MILIS);

    // troca o digito activado e o desactivado 
    LATD = LATD ^ 0x0060;

    // get segments status from array using index
    //digit = d7scode[value & 0x0F];       
    // send to 7 segment display
    LATB = (LATB & 0x80FF) | (d7scode[value & 0x0F] << 8);
}

void delay(unsigned int ms) {
    resetCoreTimer();
    while(readCoreTimer() < ms * KFMS);
}