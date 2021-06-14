/*
 * password.c
 *
 *  Created on: 11 июн. 2021 г.
 *      Author: Y.Virsky
 */

#include <inttypes.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <util/delay.h>

#include "keyboard.h"
#include "password.h"



uint8_t accessPassword[2] = { 1, 2 }; 	// Пароль доступа по умолчанию


int8_t
password_verification( uint8_t * password_user)
{
	int8_t  success = 0;


	if( (password_user[0] == accessPassword[0]) &&
	    (password_user[1] == accessPassword[1]) )
	{
		PORTC = 0b00000100;
		success = 1;
	}

	for( int8_t i = 0; i < PASSWORD_MAX_SIZE; i++ )
	{
		password_user [i] = 0;
	}

	return success;

}
