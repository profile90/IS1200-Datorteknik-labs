/* mipslabwork.c

   This file written 2015 by F Lundevall
   Updated 2017-04-21 by F Lundevall

   This file should be changed by YOU! So you must
   add comment(s) here with your name(s) and date(s):

   This file modified 2017-04-31 by Ture Teknolog 

   For copyright and licensing, see file COPYING */

#include <stdint.h>   /* Declarations of uint_32 and the like */
#include <pic32mx.h>  /* Declarations of system-specific addresses etc */
#include "mipslab.h"  /* Declatations for these labs */
#define true 1
#define false 0
int mytime = 0x5957;

char textstring[] = "text, more text, and even more text!";
int tickcounter = 0;
int timeout = 0;
/* Interrupt Service Routine */

void user_isr( void )
{
  return;
}

/* Lab-specific initialization goes here */
void labinit( void )
{
  /* LEDS START */
  TRISE &= 0xff00;
  /* LEDS END */  

  /* LEDS START */
  TRISD &= 0xffe0; // bits 11 - 5 are set into inputs
  
  
  T2CON = 0x70;
  #define TMR2PERIOD ((80000000 / 256) / 10)
  #if TMR2PERIOD > 0xffff
  #error "Timer period is too big."
  #endif

  PR2 = TMR2PERIOD;
  TMR2 = 0;
  T2CONSET = 0x8000;
}

void timerTest() {
  if(IFS(0) & 0x100) {
    IFS(0) = 0;
    timeout++;
  } 
}

/* This function is called repetitively from the main program */
void labwork( void )
{
  /* LEDS START */
  volatile int* porte = (volatile int*) 0xbf886110;
  *porte = tickcounter;
  /* LEDS END */
  timerTest();
  if(timeout >= 10){
      timeout = 0;
      time2string( textstring, mytime );
      display_string( 3, textstring );
      display_update();
      tick( &mytime );
      display_image(96, icon);
  }

  switch(getbtns()) {
    case 0x1:
      mytime =  ((mytime & 0xff0f) | (getsw() << 4));
      break;
    case 0x2:
      mytime =  ((mytime & 0xf0ff) | (getsw() << 8));
      break;
    case 0x4:
      mytime =  ((mytime & 0x0fff) | (getsw() << 12));
      break;
    case 0x3:
      mytime =  ((mytime & 0xf00f) | (getsw() << 4) | (getsw() << 8));
      break;
    case 0x5:
      mytime =  ((mytime & 0x0f0f) | (getsw() << 12) | (getsw() << 4));
      break;
    case 0x6:
      mytime =  ((mytime & 0x00ff) | (getsw() << 12) | (getsw() << 8));
      break;
    case 0x7:
      mytime =  ((mytime & 0x000f) | (getsw() << 12) | (getsw() << 8) | (getsw() << 4));
      break;
  }
}
