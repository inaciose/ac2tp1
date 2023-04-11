#include <detpic32.h>

#define KMS 20000
#define TMS 200
#define NREADS 2

void delay(unsigned int ms);
void send2display( unsigned char value, int more);

int main(void) {
    //
    // configure ADC
    //

    // use RB4

    TRISBbits.TRISB4 = 1;       // configura RB4 como input
    AD1PCFGbits.PCFG4 = 0;       // configura RB4 como input analógico

    AD1CON1bits.SSRC = 7;       // Conversion trigger selection bits: in this
                                // mode an internal counter ends sampling and
                                // starts conversion
    AD1CON1bits.CLRASAM = 1;    // Stop conversions when the 1st A/D converter
                                // interrupt is generated. At the same time,
                                // hardware clears the ASAM bit
    AD1CON3bits.SAMC = 16;      // Sample time is 16 TAD (TAD = 100 ns)

    AD1CON2bits.SMPI = NREADS-1;     // Interrupt is generated after N samples
    AD1CHSbits.CH0SA = 4;       // indica qual o canal a ser usado como entrada no ADC
                                // deve ser o mesmo usado no TRIS
    AD1CON1bits.ON = 1;         // Enable A/D converter (tem de ser o ultimo comando da sequência)

    // clear interruput
    IFS1bits.AD1IF = 0;

    // config RB14 - RB8 to output
    TRISB = TRISB & 0x80FF;

    // config RD6 & RD5 to output
    TRISD = TRISD & 0xFF9F;

    // config RE1 to output
    TRISEbits.TRISE1 = 0;

    // init RE1 = 0
    LATEbits.LATE1 = 0;

    int i;
    int sum;
    int average;

    while(1) {
        // request conversion
        AD1CON1bits.ASAM = 1;
        while(IFS1bits.AD1IF == 0);
        
        // read the ADC1BUF0 - 1
        sum = 0;
        int *p = (int *) &ADC1BUF0;
        for( i = 0; i < NREADS; i++) {
            sum += *p;
            p += 4;
        }
        
        // display on PC
        average = sum / NREADS;
        printInt(average, 16 | 3 << 16);
        putChar('\n');

        send2display(average * 9 / 1023, 0);

        LATEbits.LATE1 = !LATEbits.LATE1;

        IFS1bits.AD1IF = 0;
        delay(TMS);

    }

}

void send2display( unsigned char value, int more) {
    static const char symbols[] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x07F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71 };
    static char digit;

    if(more) {
        LATD = (LATD & 0xFF9F) | 0x0040;
        digit = value >> 4;
    } else {
        LATD = (LATD & 0xFF9F) | 0x0020;
        digit = value & 0x0F;
    }

    digit = symbols[(char)digit];
    LATB = (LATB & 0x80FF) | (digit << 8);
}

void delay(unsigned int ms) {
    resetCoreTimer();
    while(readCoreTimer() < ms * KMS);
}
