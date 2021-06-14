#define F_CPU 16000000L
#define __AVR_ATmega16__

#include <inttypes.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <util/delay.h>

#include <drivers/keyboard.h>
#include <drivers/password.h>
#include <drivers/timer.h>


#define 			KEYBOARD_INIT                   DDRB
#define 			KEYBOARD                    	PORTB

#define 			PASSWORD_MAX_SIZE				20

#define TIM1_OCR_TICK_PER_SECOND     ( 15625 )				 // 1,0s for presc 1024

uint8_t tempPassword_new[PASSWORD_MAX_SIZE];

//static  uint8_t timer;


void init_port ( void );

typedef enum {
	Stage_Init,
	Input_Acquired,
	Password_Valid,
	timeout,
	Working
} states_t;


static states_t state = Stage_Init;
static uint16_t  time_curr = 0;
static uint16_t  past_time = 0;

static volatile	uint16_t	time_diff;


int main( void )
{

	init_port();
	tim1_init();

	for( int8_t i = 0; i < PASSWORD_MAX_SIZE; i++ )
	{
		tempPassword_new [i] = 0;
	}

	sei();


	while (1)
	{
		time_curr = timer_time_get();

		switch ( state )
		{
			case Stage_Init:
				for( int8_t i = 0; i < PASSWORD_MAX_SIZE; i++ )
				{
					tempPassword_new [i] = 0;
				}
				PORTD = 0b00000001;
				state = Input_Acquired;
			break;

			case Input_Acquired:
				PORTD = 0b00000010;
				if( keyboard_input_get(tempPassword_new) )
				{
					state = Password_Valid;
					past_time = time_curr;
				}
			break;

			case Password_Valid:
				if( password_verification(tempPassword_new) )
				{
					PORTD = 0b00000100;
					state = timeout;
				}

			break;

			case timeout:

				time_diff =  time_curr - past_time;
				if( time_diff >= 2000 )
				{
					past_time = time_curr;

					state = Working;
				}

			break;


			case Working:
				PORTD = 0b00001000;
			break;


		}


	}

	return 0;
}


void
init_port ( void )
{
	KEYBOARD_INIT |= (1 << PB3) | (1 << PB2) | (1 << PB1) | (1 << PB0); // Порт вывода
	KEYBOARD_INIT &= ~(1 << PB7) | (1 << PB6) | (1 << PB5) | (1 << PB4); // Порт ввода
	KEYBOARD = 0xF0; // Устанавливаем лог. 1 в порт ввода
	DDRC = 0xFF; // Выход на индикатор
	PORTC = 0x00;

	DDRD = 0xFF;
	PORTD = 0x00;
}
