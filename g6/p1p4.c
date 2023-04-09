#include <detpic32.h>

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

    AD1CON2bits.SMPI = 4-1;     // Interrupt is generated after N samples
    AD1CHSbits.CH0SA = 4;       // indica qual o canal a ser usado como entrada no ADC
                                // deve ser o mesmo usado no TRIS
    AD1CON1bits.ON = 1;         // Enable A/D converter (tem de ser o ultimo comando da sequência)

    //unsigned int bufferVal;     // store adc convertion buffer reading
    int i;

    while(1) {

        AD1CON1bits.ASAM = 1;               // Start conversion
        while(IFS1bits.AD1IF == 0);         // Wait while conversion not done
        // ler N posiçoes do buffer
        int *p = (int *)(&ADC1BUF0);        // aponta o ponteiro p par o endereço da primeira entrada do buffer
        for (i=0; i<4; i++) {
            printInt(*p, 10 | 4 << 16);
            putChar(' ');
            p+=4;
        }
        putChar('\n');
        
        IFS1bits.AD1IF = 0;                 // Reset AD1IF
    }

    return 0;
}
