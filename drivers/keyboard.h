/*
 * keyboard.h
 *
 *  Created on: 11 ���. 2021 �.
 *      Author: Y.Virsky
 */

#ifndef DRIVERS_KEYBOARD_H_
#define DRIVERS_KEYBOARD_H_

unsigned char scan_key( void );
int8_t keyboard_input_get (  uint8_t * tempPassword );

#endif /* DRIVERS_KEYBOARD_H_ */
