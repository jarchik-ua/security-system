/*
 * timer.c
 *
 *  Created on: 14 θών. 2021 γ.
 *      Author: Y.Virsky
 */

#define F_CPU 16000000L
#define __AVR_ATmega16__

#include <inttypes.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <util/delay.h>

#include "timer.h"


#define TIM1_OCR_TICK_PER_SECOND      ( 16 ) // 1,0s for presc 1024


static uint16_t  timer_counter = 0;


uint16_t
timer_time_get( void )
{
	return timer_counter;
}

ISR (TIMER1_COMPA_vect)
{
   timer_counter ++;
}


void
tim1_init( void )
{
	//
	// Ftim = Fcpu / 1024
	// CTC mode
	//

	TCCR1B = ( 1<<WGM12 );

	OCR1AH = TIM1_OCR_TICK_PER_SECOND >> 8;
	OCR1AL = TIM1_OCR_TICK_PER_SECOND & 0xff;


	TCCR1B |= ( 1<<CS12 ) | ( 0<<CS11 ) | ( 1<<CS10 );
	TIMSK |= ( 1<<OCIE1A );
}

