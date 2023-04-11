#include <detpic32.h> 

#define KMS 20000
#define TF 250  // 4Hz
#define NREADS 4

void send2display(unsigned char value, int up);
void delay(unsigned int ms);

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

    // configure RB14 - RB8 for output
    TRISB = TRISB & 0x80FF;

    // configure RD6 & RD5 for output
    TRISD = TRISD & 0xFF9F;

    // configure RB3 for input
    TRISBbits.TRISB3 = 1;

    // configure RE6 & RE1 for output
    TRISE = TRISE & 0xFFBD;

    int sum;
    int i;
    int average;
    int scaled;

    // init RE6 & RE1
    LATE = (LATE & 0xFFDB) | 0x0040;

    while(1) {
        AD1CON1bits.ASAM = 1;
        while(IFS1bits.AD1IF == 0);

        sum = 0;

        int *p = (int *) (&ADC1BUF0);
        for(i = 0; i <4; i++) {
            sum+=*p;
            p+=4;
        }

        IFS1bits.AD1IF = 0;

        average = sum / 4;

        printInt(average, 2 | 12 << 16);
        
        putChar('\r');

        scaled = (average * 10 / 1023) + 4;
        
        send2display(scaled, PORTBbits.RB3);

        LATE = LATE ^ 0x0042;

        delay(TF);

    }

    return 0;
}


void send2display(unsigned char value, int more) {
    static const char symbols[] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x07F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71 };

    static char digit;

    if(!more) {
        //digit = value >> 4;
        LATD = (LATD & 0xFF9F) | 0x0040;

    } else {
        LATD = (LATD & 0xFF9F) | 0x0020;
        //digit = value & 0x0F;
    }

    digit = symbols[value];

    LATB = (LATB & 0x80FF) | (digit << 8);


}

void delay(unsigned int ms) {
    resetCoreTimer();
    while(readCoreTimer() < ms * KMS);
}
