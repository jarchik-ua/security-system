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

static  uint8_t time_curr;



/***
 *  Password sequence
 */
typedef enum {
	Pass_Arr_Init,
	Pass_Enter,
	Pass_Validate,
} pass_state_t;

static pass_state_t state_password = Pass_Arr_Init;
/*-----------------------------------------------------------------*/


/***
 *  Disarmed sequence
 */
typedef enum {
	Disarmed_Sequence_Init,			// turn off every led
	Disarmed_Password_Check,
	Disarmed_Timeout_Until_Enable,
	Disarmed_Timeout_Until_Disable,
} disarmed_t;

static volatile disarmed_t	disarmed_state = Disarmed_Sequence_Init;
/*-----------------------------------------------------------------*/

enum {
	Password_Check_In_Process,
	Password_Correct,
	Password_Incorrect,
};

enum {
	Idle,
	Alarm_Request,
	Disarm_Request,
};

/*-----------------------------------------------------------------*/


typedef enum {
	Disarmed,
	Armed,
	Alarm
} states_work;

static volatile states_work 	stage = Disarmed;
static volatile states_work		stage_prev = Disarmed;


int8_t
password_check( void )
{
	int8_t		ret = Password_Check_In_Process;
	static uint8_t tempPassword_new[PASSWORD_MAX_SIZE];


	switch ( state_password )
	{
	case Pass_Arr_Init:
		for( int8_t i = 0; i < PASSWORD_MAX_SIZE; i++ )
		{
			tempPassword_new [i] = 0;
		}

		state_password = Pass_Enter;
		break;

	case Pass_Enter:
		if( keyboard_input_get(tempPassword_new) )
		{
			state_password = Pass_Validate;
		}
		break;

	case Pass_Validate:
		if( password_verification(tempPassword_new) )
		{
			ret = Password_Correct;
		}
		else
		{
			ret = Password_Incorrect;
		}

		state_password = Pass_Arr_Init;
		break;
	}

	return ret;
}



int8_t
disarmed_state_handle( void )
{
	uint16_t	time_curr = timer_time_get();
	static uint16_t	timeout;

	int8_t		pass_state = Password_Check_In_Process;
	int8_t		ret = 0;

	switch ( disarmed_state )
	{
	case Disarmed_Sequence_Init:
		PORTD &= ~( (1 << 3) | (1 << 2) | (1 << 1) | (1 << 0) );
		disarmed_state = Disarmed_Password_Check;
		break;

	case Disarmed_Password_Check:
		pass_state = password_check();

		if( pass_state != Password_Check_In_Process )
		{
			timeout = time_curr;

			if( pass_state == Password_Correct )
			{
				disarmed_state = Disarmed_Timeout_Until_Enable;
			}
			else
			if( pass_state == Password_Incorrect )
			{
				disarmed_state = Disarmed_Timeout_Until_Disable;
			}
			else
			{
				/*    */
			}
		}
		break;

	case Disarmed_Timeout_Until_Enable:
		if( time_curr - timeout >= 2000 )
		{
			timeout = time_curr;

			disarmed_state = Disarmed_Sequence_Init;
			ret = 1;
		}
		break;

	case Disarmed_Timeout_Until_Disable:
		PORTD |= (1 << 2);
		if( time_curr - timeout >= 2000 )
		{
			timeout = time_curr;
			disarmed_state = Disarmed_Sequence_Init;
		}
		break;
	}

	return ret;
}


void
alarm_system_proc( void )
{
	int8_t		pass_state = Password_Check_In_Process;
	uint8_t		motion_sens_alarm = 0;		// 1 alarm
	uint8_t		gerkon_alarm = 0;			// 1 alarm


	time_curr = timer_time_get();

	switch( stage )
	{
	case Disarmed:
		if( disarmed_state_handle() == 1 )
		{
			stage = Armed;
		}
		break;

	case Armed:
		PORTD |= (1 << 3) ;
		pass_state = password_check();
		motion_sens_alarm = !(PINA & (1 << 1)) ? 1 : 0;
		gerkon_alarm = (PINA & (1 << 3)) ? 1 : 0;

		/** Check sensor */
		if( motion_sens_alarm == 1 || \
		    gerkon_alarm == 1	   || \
			pass_state == Password_Incorrect )
		{
			stage = Alarm;
		}
		else
		if( pass_state == Password_Correct )
		{
			stage = Disarmed;
		}
		break;

	case Alarm:
		PORTD |= (1 << 1) | (1 << 0) ;

		pass_state = password_check();

		if( pass_state == Password_Correct )
		{
			stage = Disarmed;
		}
		break;
	}

	if( stage_prev != stage )
	{
		stage_prev = stage;
		state_password = Pass_Arr_Init;
	}
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

	DDRA = 0x00;
	PORTA |= (1 << 3) | (1 << 1);
}


int main( void )
{
	sei();

	init_port();
	tim1_init();

	while (1)
	{
		alarm_system_proc();
	}

	return 0;
}



