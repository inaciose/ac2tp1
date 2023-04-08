
/*
    contador crescente módulo 10, atualizado a uma frequência de 4Hz. 
    O resultado deverá ser observando nos 4 LED ligados aos portos RE6 a RE3.
*/

#include <detpic32.h>

#define DFMS 20000
#define MILIS 250

void delay(unsigned int ms);

int main(void) {
    // configure ports
    TRISE = TRISE & 0xFF87;
    int counter = 0;

    // loop
    while(1) {
        // read, modify, write
        // LATE = LATE & reset bit 6-3 | shift left 3 bits the counter
        LATE = (LATE & 0xFF87) | (counter << 3);
        delay(MILIS);
        counter++;
        if (counter == 10) counter = 0;
    }

    return 0;
}

void delay(unsigned int ms) {
    resetCoreTimer();
    while(readCoreTimer() < ms * DFMS);
}