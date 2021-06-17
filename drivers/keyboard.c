/*
 * keyboard.c
 *
 *  Created on: 11 ���. 2021 �.
 *      Author: Y.Virsky
 */


#include <inttypes.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <util/delay.h>

#include "keyboard.h"

#define 			KEYBOARD_INIT                   DDRB
#define 			KEYBOARD                    	PORTB

#define 			PASSWORD_MAX_SIZE				20


uint8_t tempPassword[PASSWORD_MAX_SIZE]; 					// ������ ��� ���������� �������� ��������� ������

int passwordIndex = 0;     // ������ ����� ������, � ������� �� � ������ ������ ��������
//static uint8_t input_available;

const unsigned char key_tab[4] = {0b11111110,
					     0b11111101,
					     0b11111011,
					     0b11110111};


static volatile uint16_t			last_key_pressed;



unsigned char
scan_key( void )
{
	char		ret_key = 0;
	uint8_t		pin_value;
	unsigned char key_value = 0;
	static char	prev_key_val = 0;

	for( int8_t line = 0; line < 4; line++ )
	{
		KEYBOARD = key_tab[line]; // ������� ���. 0 � ���� ������
		_delay_us(10);

		pin_value = PINB & 0xF0;

		switch( pin_value )
		{
			case 0b11100000:			// PB4
				key_value = 1 + line * 3;
			break;

			case 0b11010000:			// PB5
				key_value = 2 + line * 3;
			break;

			case 0b10110000:			// PB6
				key_value = 3 + line * 3;
			break;

			default:
				break;
		}

		if( key_value != 0 )
		{
			break;
		}
   }

	if( prev_key_val != key_value )
	{
		ret_key = key_value;
		prev_key_val = key_value;
	}

	if( ret_key )
	{
		last_key_pressed = ret_key;
	}

	return ret_key;
}


/** keboard input */
int8_t
keyboard_input_get ( uint8_t * tempPassword )
{
	uint16_t key = scan_key ();

	if( key == 10 )                        //   *
	{
//		input_available = 0;
		// clean password

		for( uint8_t i = 0; i < PASSWORD_MAX_SIZE; i++ )
		{
			tempPassword [i] = 0;
		}
		passwordIndex = 0;

		PORTC = 0b00001000;
	}
	else if( key == 12 )                  //   #
	{
//		input_available = 1;
		passwordIndex = 0;
		PORTC = 0;
		return 1;
	}
	else
	if( key != 0 )
	{
		if( key == 1 )
		{
			PORTC = 0b00000001;
		}

		if( key == 2 )
		{
			PORTC = 0b00000010;
		}

		if( passwordIndex < PASSWORD_MAX_SIZE )
		{
			tempPassword[passwordIndex] = key; // ������� ��������� ������ �� ��������� ������
			passwordIndex++;
		}
	}
	else
	{
		/*** no buttons pressed (idle state) */
	}


	return 0;
}
