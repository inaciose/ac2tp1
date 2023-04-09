#include <detpic32.h>

#define NREADS 4

// CORE TIMER (delay)
#define KFMS 20000
#define MILISD 10  // freq for display
#define MILISDF 10 // factor * (freq * 2) = 200

void delay(unsigned int);
unsigned char toBCD (unsigned char);
void send2display(unsigned char);


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

    // store adc convertion buffer reading
    // index for readings
    int i;
    // sum of readings
    unsigned int readingsSum;
    unsigned int readingsAverage = 0;

    //
    // configure 7 segments display
    //

    // configure segments ports for output (RB8-RB14) reset bits to 0 
    TRISB = TRISB & 0x80FF;

    // configure display digit control (RD5-RD6) reset bits to 0 
    TRISD = TRISD & 0xFF9F;

    // counter for adc sample freq
    int ii = 0;

    while(1) {

        i = 0;
        do {
            send2display(toBCD(readingsAverage));
            delay(MILISD);
        } while(++i < 2);

        ii++;
        if(ii == MILISDF) {
            ii = 0;

            AD1CON1bits.ASAM = 1;               // Start conversion
            while(IFS1bits.AD1IF == 0);         // Wait while conversion not done
            
            // ler N posiçoes do buffer e somandoas
            readingsSum = 0;
            int *p = (int *)(&ADC1BUF0);        // aponta o ponteiro p par o endereço da primeira entrada do buffer
            for (i=0; i<NREADS; i++) {
                readingsSum += *p;               // lê e guarda a leitura no buffer para a posição de memória adequada
                p+=4;                           // incrementa o pointer 16 bytes
            }

            // readings average minimising truncature errors (33 is the voltage * 10)
            readingsAverage = ((readingsSum / NREADS) * 33 + 511) / 1023;
            
            // Reset AD1IF
            IFS1bits.AD1IF = 0;                 
        }
    }

    return 0;
}

unsigned char toBCD (unsigned char value) {
    //     MSB               +  LSB
    return ((value/10) << 4) + (value % 10);

}

void send2display(unsigned char value) {
    char symbols[] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x07F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71 };
    static int msd = 1;

    static unsigned char digit;

    if(msd) {
        // isolate high digit
        digit = value >> 4;
        // set high digit on, low digit off
        LATD = (LATD & 0xFF9F) | 0x0040;

    } else {
        // isolate low digit
        digit = value & 0x0F;
        // set high digit off, low digit on
        LATD = (LATD & 0xFF9F) | 0x0020;
    }
    
    // select segments for digit
    digit = symbols[digit];
    // send segments
    LATB = (LATB & 0x80FF) | (digit << 8);

    // switch digit flag
    msd = !msd;
}

void delay(unsigned int ms) {
    resetCoreTimer();
    while(readCoreTimer() < ms * KFMS);
}
