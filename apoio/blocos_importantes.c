//
// core timer
//

#define KFMS 20000

void delay(unsigned int ms) {
    resetCoreTimer();
    while(readCoreTimer() < ms * KFMS)
}

//
// seven segments display
//

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


//
// ADC
//


// ADC polling
        AD1CON1bits.ASAM = 1;               // Start conversion
        while(IFS1bits.AD1IF == 0);         // wait conversion
        bufferVal = ADC1BUF0;               // read one ADC buffer position (SMPI + 1)
        IFS1bits.AD1IF = 0;                 // Reset AD1IF

// ADC print multiple buffer positions

        int *p = (int *)(&ADC1BUF0);        // aponta o ponteiro p par o endereço da primeira entrada do buffer
        for (i=0; i<4; i++) {
            printInt(*p, 10 | 4 << 16);     // imprime em decimal com 4 digitos
            putChar(' ');
            p+=4;
        }

// ADC average with NREADS samples expressed in voltage

        AD1CON1bits.ASAM = 1;               // Start conversion
        while(IFS1bits.AD1IF == 0);         // Wait while conversion not done
        // ler N posiçoes do buffer
        int *p = (int *)(&ADC1BUF0);        // aponta o ponteiro p par o endereço da primeira entrada do buffer
        for (i=0; i<NREADS; i++) {
            readings[i] = *p;               // lê e guarda a leitura no buffer para a posição de memória adequada
            p+=4;                           // incrementa o pointer 16 bytes
        }

        // sum the readings
        readingsSum = 0;
        for (i=0; i<NREADS; i++) {
            readingsSum += readings[i];
        }

        // calculate average
        // readings average minimising truncature errors (33 is the voltage * 10)
        readingsAverage = ((readingsSum / NREADS) * 33 + 511) / 1023;

        // print the readings average
        printInt(readingsAverage, 10 | 2 << 16);
