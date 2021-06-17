   1               		.file	"keyboard.c"
   2               	__SP_H__ = 0x3e
   3               	__SP_L__ = 0x3d
   4               	__SREG__ = 0x3f
   5               	__tmp_reg__ = 0
   6               	__zero_reg__ = 1
   7               		.text
   8               	.Ltext0:
   9               		.cfi_sections	.debug_frame
  10               		.section	.text.scan_key,"ax",@progbits
  11               	.global	scan_key
  13               	scan_key:
  14               	.LFB6:
  15               		.file 1 "drivers/keyboard.c"
   1:drivers/keyboard.c **** /*
   2:drivers/keyboard.c ****  * keyboard.c
   3:drivers/keyboard.c ****  *
   4:drivers/keyboard.c ****  *  Created on: 11 июн. 2021 г.
   5:drivers/keyboard.c ****  *      Author: Y.Virsky
   6:drivers/keyboard.c ****  */
   7:drivers/keyboard.c **** 
   8:drivers/keyboard.c **** 
   9:drivers/keyboard.c **** #include <inttypes.h>
  10:drivers/keyboard.c **** #include <avr/io.h>
  11:drivers/keyboard.c **** #include <avr/interrupt.h>
  12:drivers/keyboard.c **** #include <avr/sleep.h>
  13:drivers/keyboard.c **** #include <util/delay.h>
  14:drivers/keyboard.c **** 
  15:drivers/keyboard.c **** #include "keyboard.h"
  16:drivers/keyboard.c **** 
  17:drivers/keyboard.c **** #define 			KEYBOARD_INIT                   DDRB
  18:drivers/keyboard.c **** #define 			KEYBOARD                    	PORTB
  19:drivers/keyboard.c **** 
  20:drivers/keyboard.c **** #define 			PASSWORD_MAX_SIZE				20
  21:drivers/keyboard.c **** 
  22:drivers/keyboard.c **** 
  23:drivers/keyboard.c **** uint8_t tempPassword[PASSWORD_MAX_SIZE]; 					// Массив для временного хранения введённого пароля
  24:drivers/keyboard.c **** 
  25:drivers/keyboard.c **** int passwordIndex = 0;     // Индекс цифры пароля, с которой мы в данный момент работаем
  26:drivers/keyboard.c **** //static uint8_t input_available;
  27:drivers/keyboard.c **** 
  28:drivers/keyboard.c **** const unsigned char key_tab[4] = {0b11111110,
  29:drivers/keyboard.c **** 					     0b11111101,
  30:drivers/keyboard.c **** 					     0b11111011,
  31:drivers/keyboard.c **** 					     0b11110111};
  32:drivers/keyboard.c **** 
  33:drivers/keyboard.c **** 
  34:drivers/keyboard.c **** static volatile uint16_t			last_key_pressed;
  35:drivers/keyboard.c **** 
  36:drivers/keyboard.c **** 
  37:drivers/keyboard.c **** 
  38:drivers/keyboard.c **** unsigned char
  39:drivers/keyboard.c **** scan_key( void )
  40:drivers/keyboard.c **** {
  16               		.loc 1 40 1 view -0
  17               		.cfi_startproc
  18               	/* prologue: function */
  19               	/* frame size = 0 */
  20               	/* stack size = 0 */
  21               	.L__stack_usage = 0
  41:drivers/keyboard.c **** 	char		ret_key = 0;
  22               		.loc 1 41 2 view .LVU1
  23               	.LVL0:
  42:drivers/keyboard.c **** 	uint8_t		pin_value;
  24               		.loc 1 42 2 view .LVU2
  43:drivers/keyboard.c **** 	unsigned char key_value = 0;
  25               		.loc 1 43 2 view .LVU3
  44:drivers/keyboard.c **** 	static char	prev_key_val = 0;
  26               		.loc 1 44 2 view .LVU4
  45:drivers/keyboard.c **** 
  46:drivers/keyboard.c **** 	for( int8_t line = 0; line < 4; line++ )
  27               		.loc 1 46 2 view .LVU5
  28               	.LBB31:
  29               		.loc 1 46 7 view .LVU6
  30               		.loc 1 46 7 is_stmt 0 view .LVU7
  31 0000 E0E0      		ldi r30,lo8(key_tab)
  32 0002 F0E0      		ldi r31,hi8(key_tab)
  33               	.LBE31:
  40:drivers/keyboard.c **** 	char		ret_key = 0;
  34               		.loc 1 40 1 view .LVU8
  35 0004 30E0      		ldi r19,0
  36 0006 20E0      		ldi r18,0
  37               	.LBB40:
  38               	.LBB32:
  39               	.LBB33:
  40               	.LBB34:
  41               	.LBB35:
  42               		.file 2 "c:\\bin\\avr-gcc-8.3.0-x64-mingw\\avr\\include\\util\\delay_basic.h"
   1:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** /* Copyright (c) 2002, Marek Michalkiewicz
   2:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****    Copyright (c) 2007 Joerg Wunsch
   3:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****    All rights reserved.
   4:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** 
   5:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****    Redistribution and use in source and binary forms, with or without
   6:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****    modification, are permitted provided that the following conditions are met:
   7:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** 
   8:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****    * Redistributions of source code must retain the above copyright
   9:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****      notice, this list of conditions and the following disclaimer.
  10:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** 
  11:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****    * Redistributions in binary form must reproduce the above copyright
  12:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****      notice, this list of conditions and the following disclaimer in
  13:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****      the documentation and/or other materials provided with the
  14:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****      distribution.
  15:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** 
  16:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****    * Neither the name of the copyright holders nor the names of
  17:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****      contributors may be used to endorse or promote products derived
  18:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****      from this software without specific prior written permission.
  19:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** 
  20:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  21:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  22:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  23:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****   ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
  24:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  25:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  26:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  27:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  28:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  29:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  30:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****   POSSIBILITY OF SUCH DAMAGE. */
  31:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** 
  32:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** /* $Id: delay_basic.h 2453 2014-10-19 08:18:11Z saaadhu $ */
  33:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** 
  34:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** #ifndef _UTIL_DELAY_BASIC_H_
  35:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** #define _UTIL_DELAY_BASIC_H_ 1
  36:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** 
  37:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** #include <inttypes.h>
  38:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** 
  39:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** #if !defined(__DOXYGEN__)
  40:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** static __inline__ void _delay_loop_1(uint8_t __count) __attribute__((__always_inline__));
  41:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** static __inline__ void _delay_loop_2(uint16_t __count) __attribute__((__always_inline__));
  42:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** #endif
  43:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** 
  44:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** /** \file */
  45:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** /** \defgroup util_delay_basic <util/delay_basic.h>: Basic busy-wait delay loops
  46:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****     \code
  47:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****     #include <util/delay_basic.h>
  48:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****     \endcode
  49:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** 
  50:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****     The functions in this header file implement simple delay loops
  51:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****     that perform a busy-waiting.  They are typically used to
  52:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****     facilitate short delays in the program execution.  They are
  53:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****     implemented as count-down loops with a well-known CPU cycle
  54:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****     count per loop iteration.  As such, no other processing can
  55:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****     occur simultaneously.  It should be kept in mind that the
  56:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****     functions described here do not disable interrupts.
  57:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** 
  58:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****     In general, for long delays, the use of hardware timers is
  59:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****     much preferrable, as they free the CPU, and allow for
  60:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****     concurrent processing of other events while the timer is
  61:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****     running.  However, in particular for very short delays, the
  62:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****     overhead of setting up a hardware timer is too much compared
  63:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****     to the overall delay time.
  64:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** 
  65:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****     Two inline functions are provided for the actual delay algorithms.
  66:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** 
  67:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** */
  68:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** 
  69:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** /** \ingroup util_delay_basic
  70:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** 
  71:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****     Delay loop using an 8-bit counter \c __count, so up to 256
  72:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****     iterations are possible.  (The value 256 would have to be passed
  73:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****     as 0.)  The loop executes three CPU cycles per iteration, not
  74:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****     including the overhead the compiler needs to setup the counter
  75:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****     register.
  76:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** 
  77:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****     Thus, at a CPU speed of 1 MHz, delays of up to 768 microseconds
  78:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h ****     can be achieved.
  79:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** */
  80:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** void
  81:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** _delay_loop_1(uint8_t __count)
  82:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** {
  83:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** 	__asm__ volatile (
  43               		.loc 2 83 2 view .LVU9
  44 0008 93E0      		ldi r25,lo8(3)
  45               	.LVL1:
  46               	.L7:
  47               		.loc 2 83 2 view .LVU10
  48               	.LBE35:
  49               	.LBE34:
  50               	.LBE33:
  51               	.LBE32:
  47:drivers/keyboard.c **** 	{
  48:drivers/keyboard.c **** 		KEYBOARD = key_tab[line]; // выводим лог. 0 в порт вывода
  52               		.loc 1 48 3 is_stmt 1 view .LVU11
  53               		.loc 1 48 21 is_stmt 0 view .LVU12
  54 000a 8191      		ld r24,Z+
  55               		.loc 1 48 12 view .LVU13
  56 000c 88BB      		out 0x18,r24
  49:drivers/keyboard.c **** 		_delay_us(10);
  57               		.loc 1 49 3 is_stmt 1 view .LVU14
  58               	.LVL2:
  59               	.LBB39:
  60               	.LBI32:
  61               		.file 3 "c:\\bin\\avr-gcc-8.3.0-x64-mingw\\avr\\include\\util\\delay.h"
   1:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** /* Copyright (c) 2002, Marek Michalkiewicz
   2:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    Copyright (c) 2004,2005,2007 Joerg Wunsch
   3:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    Copyright (c) 2007  Florin-Viorel Petrov
   4:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    All rights reserved.
   5:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
   6:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    Redistribution and use in source and binary forms, with or without
   7:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    modification, are permitted provided that the following conditions are met:
   8:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
   9:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    * Redistributions of source code must retain the above copyright
  10:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****      notice, this list of conditions and the following disclaimer.
  11:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
  12:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    * Redistributions in binary form must reproduce the above copyright
  13:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****      notice, this list of conditions and the following disclaimer in
  14:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****      the documentation and/or other materials provided with the
  15:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****      distribution.
  16:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
  17:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    * Neither the name of the copyright holders nor the names of
  18:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****      contributors may be used to endorse or promote products derived
  19:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****      from this software without specific prior written permission.
  20:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
  21:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  22:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  23:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  24:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****   ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
  25:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  26:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  27:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  28:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  29:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  30:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  31:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****   POSSIBILITY OF SUCH DAMAGE. */
  32:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
  33:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** /* $Id: delay.h.in 2506 2016-02-08 10:05:45Z joerg_wunsch $ */
  34:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
  35:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** #ifndef _UTIL_DELAY_H_
  36:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** #define _UTIL_DELAY_H_ 1
  37:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
  38:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** #ifndef __DOXYGEN__
  39:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** #  ifndef __HAS_DELAY_CYCLES
  40:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** #    define __HAS_DELAY_CYCLES 1
  41:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** #  endif
  42:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** #endif  /* __DOXYGEN__ */
  43:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
  44:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** #include <inttypes.h>
  45:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** #include <util/delay_basic.h>
  46:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** #include <math.h>
  47:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
  48:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** /** \file */
  49:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** /** \defgroup util_delay <util/delay.h>: Convenience functions for busy-wait delay loops
  50:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     \code
  51:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     #define F_CPU 1000000UL  // 1 MHz
  52:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     //#define F_CPU 14.7456E6
  53:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     #include <util/delay.h>
  54:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     \endcode
  55:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
  56:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     \note As an alternative method, it is possible to pass the
  57:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     F_CPU macro down to the compiler from the Makefile.
  58:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     Obviously, in that case, no \c \#define statement should be
  59:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     used.
  60:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
  61:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     The functions in this header file are wrappers around the basic
  62:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     busy-wait functions from <util/delay_basic.h>.  They are meant as
  63:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     convenience functions where actual time values can be specified
  64:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     rather than a number of cycles to wait for.  The idea behind is
  65:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     that compile-time constant expressions will be eliminated by
  66:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     compiler optimization so floating-point expressions can be used
  67:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     to calculate the number of delay cycles needed based on the CPU
  68:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     frequency passed by the macro F_CPU.
  69:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
  70:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     \note In order for these functions to work as intended, compiler
  71:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     optimizations <em>must</em> be enabled, and the delay time
  72:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     <em>must</em> be an expression that is a known constant at
  73:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     compile-time.  If these requirements are not met, the resulting
  74:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     delay will be much longer (and basically unpredictable), and
  75:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     applications that otherwise do not use floating-point calculations
  76:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     will experience severe code bloat by the floating-point library
  77:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     routines linked into the application.
  78:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
  79:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     The functions available allow the specification of microsecond, and
  80:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     millisecond delays directly, using the application-supplied macro
  81:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     F_CPU as the CPU clock frequency (in Hertz).
  82:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
  83:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** */
  84:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
  85:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** #if !defined(__DOXYGEN__)
  86:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** static __inline__ void _delay_us(double __us) __attribute__((__always_inline__));
  87:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** static __inline__ void _delay_ms(double __ms) __attribute__((__always_inline__));
  88:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** #endif
  89:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
  90:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** #ifndef F_CPU
  91:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** /* prevent compiler error by supplying a default */
  92:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** # warning "F_CPU not defined for <util/delay.h>"
  93:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** /** \ingroup util_delay
  94:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     \def F_CPU
  95:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     \brief CPU frequency in Hz
  96:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
  97:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     The macro F_CPU specifies the CPU frequency to be considered by
  98:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     the delay macros.  This macro is normally supplied by the
  99:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     environment (e.g. from within a project header, or the project's
 100:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     Makefile).  The value 1 MHz here is only provided as a "vanilla"
 101:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     fallback if no such user-provided definition could be found.
 102:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 103:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     In terms of the delay functions, the CPU frequency can be given as
 104:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     a floating-point constant (e.g. 3.6864E6 for 3.6864 MHz).
 105:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     However, the macros in <util/setbaud.h> require it to be an
 106:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****     integer value.
 107:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****  */
 108:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** # define F_CPU 1000000UL
 109:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** #endif
 110:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 111:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** #ifndef __OPTIMIZE__
 112:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** # warning "Compiler optimizations disabled; functions from <util/delay.h> won't work as designed"
 113:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** #endif
 114:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 115:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** #if __HAS_DELAY_CYCLES && defined(__OPTIMIZE__) && \
 116:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****   !defined(__DELAY_BACKWARD_COMPATIBLE__) &&	   \
 117:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****   __STDC_HOSTED__
 118:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** #  include <math.h>
 119:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** #endif
 120:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 121:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** /**
 122:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    \ingroup util_delay
 123:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 124:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    Perform a delay of \c __ms milliseconds, using _delay_loop_2().
 125:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 126:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    The macro F_CPU is supposed to be defined to a
 127:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    constant defining the CPU clock frequency (in Hertz).
 128:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 129:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    The maximal possible delay is 262.14 ms / F_CPU in MHz.
 130:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 131:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    When the user request delay which exceed the maximum possible one,
 132:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    _delay_ms() provides a decreased resolution functionality. In this
 133:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    mode _delay_ms() will work with a resolution of 1/10 ms, providing
 134:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    delays up to 6.5535 seconds (independent from CPU frequency).  The
 135:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    user will not be informed about decreased resolution.
 136:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 137:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    If the avr-gcc toolchain has __builtin_avr_delay_cycles()
 138:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    support, maximal possible delay is 4294967.295 ms/ F_CPU in MHz. For
 139:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    values greater than the maximal possible delay, overflows results in
 140:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    no delay i.e., 0ms.
 141:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 142:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    Conversion of \c __ms into clock cycles may not always result in
 143:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    integer.  By default, the clock cycles rounded up to next
 144:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    integer. This ensures that the user gets at least \c __ms
 145:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    microseconds of delay.
 146:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 147:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    Alternatively, by defining the macro \c __DELAY_ROUND_DOWN__, or
 148:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    \c __DELAY_ROUND_CLOSEST__, before including this header file, the
 149:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    algorithm can be made to round down, or round to closest integer,
 150:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    respectively.
 151:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 152:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    \note
 153:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 154:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    The implementation of _delay_ms() based on
 155:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    __builtin_avr_delay_cycles() is not backward compatible with older
 156:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    implementations.  In order to get functionality backward compatible
 157:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    with previous versions, the macro \c "__DELAY_BACKWARD_COMPATIBLE__"
 158:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    must be defined before including this header file. Also, the
 159:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    backward compatible algorithm will be chosen if the code is
 160:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    compiled in a <em>freestanding environment</em> (GCC option
 161:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    \c -ffreestanding), as the math functions required for rounding are
 162:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    not available to the compiler then.
 163:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 164:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****  */
 165:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** void
 166:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** _delay_ms(double __ms)
 167:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** {
 168:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	double __tmp ;
 169:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** #if __HAS_DELAY_CYCLES && defined(__OPTIMIZE__) && \
 170:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****   !defined(__DELAY_BACKWARD_COMPATIBLE__) &&	   \
 171:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****   __STDC_HOSTED__
 172:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	uint32_t __ticks_dc;
 173:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	extern void __builtin_avr_delay_cycles(unsigned long);
 174:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	__tmp = ((F_CPU) / 1e3) * __ms;
 175:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 176:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	#if defined(__DELAY_ROUND_DOWN__)
 177:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 		__ticks_dc = (uint32_t)fabs(__tmp);
 178:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 179:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	#elif defined(__DELAY_ROUND_CLOSEST__)
 180:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 		__ticks_dc = (uint32_t)(fabs(__tmp)+0.5);
 181:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 182:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	#else
 183:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 		//round up by default
 184:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 		__ticks_dc = (uint32_t)(ceil(fabs(__tmp)));
 185:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	#endif
 186:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 187:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	__builtin_avr_delay_cycles(__ticks_dc);
 188:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 189:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** #else
 190:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	uint16_t __ticks;
 191:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	__tmp = ((F_CPU) / 4e3) * __ms;
 192:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	if (__tmp < 1.0)
 193:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 		__ticks = 1;
 194:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	else if (__tmp > 65535)
 195:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	{
 196:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 		//	__ticks = requested delay in 1/10 ms
 197:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 		__ticks = (uint16_t) (__ms * 10.0);
 198:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 		while(__ticks)
 199:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 		{
 200:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 			// wait 1/10 ms
 201:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 			_delay_loop_2(((F_CPU) / 4e3) / 10);
 202:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 			__ticks --;
 203:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 		}
 204:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 		return;
 205:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	}
 206:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	else
 207:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 		__ticks = (uint16_t)__tmp;
 208:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	_delay_loop_2(__ticks);
 209:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** #endif
 210:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** }
 211:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 212:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** /**
 213:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    \ingroup util_delay
 214:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 215:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    Perform a delay of \c __us microseconds, using _delay_loop_1().
 216:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 217:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    The macro F_CPU is supposed to be defined to a
 218:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    constant defining the CPU clock frequency (in Hertz).
 219:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 220:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    The maximal possible delay is 768 us / F_CPU in MHz.
 221:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 222:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    If the user requests a delay greater than the maximal possible one,
 223:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    _delay_us() will automatically call _delay_ms() instead.  The user
 224:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    will not be informed about this case.
 225:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 226:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    If the avr-gcc toolchain has __builtin_avr_delay_cycles()
 227:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    support, maximal possible delay is 4294967.295 us/ F_CPU in MHz. For
 228:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    values greater than the maximal possible delay, overflow results in
 229:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    no delay i.e., 0us.
 230:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 231:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    Conversion of \c __us into clock cycles may not always result in
 232:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    integer.  By default, the clock cycles rounded up to next
 233:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    integer. This ensures that the user gets at least \c __us
 234:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    microseconds of delay.
 235:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 236:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    Alternatively, by defining the macro \c __DELAY_ROUND_DOWN__, or
 237:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    \c __DELAY_ROUND_CLOSEST__, before including this header file, the
 238:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    algorithm can be made to round down, or round to closest integer,
 239:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    respectively.
 240:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 241:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    \note
 242:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 243:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    The implementation of _delay_ms() based on
 244:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    __builtin_avr_delay_cycles() is not backward compatible with older
 245:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    implementations.  In order to get functionality backward compatible
 246:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    with previous versions, the macro \c __DELAY_BACKWARD_COMPATIBLE__
 247:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    must be defined before including this header file. Also, the
 248:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    backward compatible algorithm will be chosen if the code is
 249:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    compiled in a <em>freestanding environment</em> (GCC option
 250:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    \c -ffreestanding), as the math functions required for rounding are
 251:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****    not available to the compiler then.
 252:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 253:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****  */
 254:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** void
 255:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** _delay_us(double __us)
  62               		.loc 3 255 1 view .LVU15
  63               	.LBB38:
 256:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** {
 257:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	double __tmp ;
  64               		.loc 3 257 2 view .LVU16
 258:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** #if __HAS_DELAY_CYCLES && defined(__OPTIMIZE__) && \
 259:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****   !defined(__DELAY_BACKWARD_COMPATIBLE__) &&	   \
 260:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h ****   __STDC_HOSTED__
 261:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	uint32_t __ticks_dc;
 262:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	extern void __builtin_avr_delay_cycles(unsigned long);
 263:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	__tmp = ((F_CPU) / 1e6) * __us;
 264:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 265:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	#if defined(__DELAY_ROUND_DOWN__)
 266:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 		__ticks_dc = (uint32_t)fabs(__tmp);
 267:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 268:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	#elif defined(__DELAY_ROUND_CLOSEST__)
 269:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 		__ticks_dc = (uint32_t)(fabs(__tmp)+0.5);
 270:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 271:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	#else
 272:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 		//round up by default
 273:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 		__ticks_dc = (uint32_t)(ceil(fabs(__tmp)));
 274:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	#endif
 275:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 276:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	__builtin_avr_delay_cycles(__ticks_dc);
 277:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 
 278:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** #else
 279:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	uint8_t __ticks;
  65               		.loc 3 279 2 view .LVU17
 280:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	double __tmp2 ;
  66               		.loc 3 280 2 view .LVU18
 281:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	__tmp = ((F_CPU) / 3e6) * __us;
  67               		.loc 3 281 2 view .LVU19
 282:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	__tmp2 = ((F_CPU) / 4e6) * __us;
  68               		.loc 3 282 2 view .LVU20
 283:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	if (__tmp < 1.0)
  69               		.loc 3 283 2 view .LVU21
 284:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 		__ticks = 1;
 285:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	else if (__tmp2 > 65535)
  70               		.loc 3 285 7 view .LVU22
 286:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	{
 287:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 		_delay_ms(__us / 1000.0);
 288:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	}
 289:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	else if (__tmp > 255)
  71               		.loc 3 289 7 view .LVU23
 290:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	{
 291:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 		uint16_t __ticks=(uint16_t)__tmp2;
 292:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 		_delay_loop_2(__ticks);
 293:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 		return;
 294:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	}
 295:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	else
 296:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 		__ticks = (uint8_t)__tmp;
  72               		.loc 3 296 3 view .LVU24
 297:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay.h **** 	_delay_loop_1(__ticks);
  73               		.loc 3 297 2 view .LVU25
  74               	.LBB37:
  75               	.LBI34:
  81:c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h **** {
  76               		.loc 2 81 1 view .LVU26
  77               	.LBB36:
  78               		.loc 2 83 2 view .LVU27
  79 000e 892F      		mov r24,r25
  80               	/* #APP */
  81               	 ;  83 "c:\bin\avr-gcc-8.3.0-x64-mingw\avr\include\util\delay_basic.h" 1
  82 0010 8A95      		1: dec r24
  83 0012 01F4      		brne 1b
  84               	 ;  0 "" 2
  85               	.LVL3:
  86               		.loc 2 83 2 is_stmt 0 view .LVU28
  87               	/* #NOAPP */
  88               	.LBE36:
  89               	.LBE37:
  90               	.LBE38:
  91               	.LBE39:
  50:drivers/keyboard.c **** 
  51:drivers/keyboard.c **** 		pin_value = PINB & 0xF0;
  92               		.loc 1 51 3 is_stmt 1 view .LVU29
  93               		.loc 1 51 20 is_stmt 0 view .LVU30
  94 0014 86B3      		in r24,0x16
  95               		.loc 1 51 13 view .LVU31
  96 0016 807F      		andi r24,lo8(-16)
  97               	.LVL4:
  52:drivers/keyboard.c **** 
  53:drivers/keyboard.c **** 		switch( pin_value )
  98               		.loc 1 53 3 is_stmt 1 view .LVU32
  99 0018 803D      		cpi r24,lo8(-48)
 100 001a 01F0      		breq .L2
 101 001c 803E      		cpi r24,lo8(-32)
 102 001e 01F0      		breq .L3
 103 0020 2F5F      		subi r18,-1
 104 0022 3F4F      		sbci r19,-1
 105 0024 803B      		cpi r24,lo8(-80)
 106 0026 01F4      		brne .L14
  54:drivers/keyboard.c **** 		{
  55:drivers/keyboard.c **** 			case 0b11100000:			// PB4
  56:drivers/keyboard.c **** 				key_value = 1 + line * 3;
  57:drivers/keyboard.c **** 			break;
  58:drivers/keyboard.c **** 
  59:drivers/keyboard.c **** 			case 0b11010000:			// PB5
  60:drivers/keyboard.c **** 				key_value = 2 + line * 3;
  61:drivers/keyboard.c **** 			break;
  62:drivers/keyboard.c **** 
  63:drivers/keyboard.c **** 			case 0b10110000:			// PB6
  64:drivers/keyboard.c **** 				key_value = 3 + line * 3;
 107               		.loc 1 64 5 view .LVU33
 108               		.loc 1 64 15 is_stmt 0 view .LVU34
 109 0028 822F      		mov r24,r18
 110               	.LVL5:
 111               		.loc 1 64 15 view .LVU35
 112 002a 880F      		lsl r24
 113 002c 820F      		add r24,r18
 114               	.LVL6:
  65:drivers/keyboard.c **** 			break;
 115               		.loc 1 65 4 is_stmt 1 view .LVU36
 116 002e 00C0      		rjmp .L6
 117               	.LVL7:
 118               	.L3:
  56:drivers/keyboard.c **** 			break;
 119               		.loc 1 56 5 view .LVU37
  56:drivers/keyboard.c **** 			break;
 120               		.loc 1 56 26 is_stmt 0 view .LVU38
 121 0030 822F      		mov r24,r18
 122               	.LVL8:
  56:drivers/keyboard.c **** 			break;
 123               		.loc 1 56 26 view .LVU39
 124 0032 880F      		lsl r24
 125 0034 820F      		add r24,r18
  56:drivers/keyboard.c **** 			break;
 126               		.loc 1 56 15 view .LVU40
 127 0036 8F5F      		subi r24,lo8(-(1))
 128               	.LVL9:
  57:drivers/keyboard.c **** 
 129               		.loc 1 57 4 is_stmt 1 view .LVU41
 130               	.L6:
  57:drivers/keyboard.c **** 
 131               		.loc 1 57 4 is_stmt 0 view .LVU42
 132               	.LBE40:
  66:drivers/keyboard.c **** 
  67:drivers/keyboard.c **** 			default:
  68:drivers/keyboard.c **** 				break;
  69:drivers/keyboard.c **** 		}
  70:drivers/keyboard.c **** 
  71:drivers/keyboard.c **** 		if( key_value != 0 )
  72:drivers/keyboard.c **** 		{
  73:drivers/keyboard.c **** 			break;
  74:drivers/keyboard.c **** 		}
  75:drivers/keyboard.c ****    }
  76:drivers/keyboard.c **** 
  77:drivers/keyboard.c **** 	if( prev_key_val != key_value )
 133               		.loc 1 77 2 is_stmt 1 view .LVU43
 134               		.loc 1 77 4 is_stmt 0 view .LVU44
 135 0038 9091 0000 		lds r25,prev_key_val.1178
 136 003c 9817      		cp r25,r24
 137 003e 01F0      		breq .L9
  78:drivers/keyboard.c **** 	{
  79:drivers/keyboard.c **** 		ret_key = key_value;
 138               		.loc 1 79 3 is_stmt 1 view .LVU45
 139               	.LVL10:
  80:drivers/keyboard.c **** 		prev_key_val = key_value;
 140               		.loc 1 80 3 view .LVU46
 141               		.loc 1 80 16 is_stmt 0 view .LVU47
 142 0040 8093 0000 		sts prev_key_val.1178,r24
  81:drivers/keyboard.c **** 	}
  82:drivers/keyboard.c **** 
  83:drivers/keyboard.c **** 	if( ret_key )
 143               		.loc 1 83 2 is_stmt 1 view .LVU48
 144               		.loc 1 83 4 is_stmt 0 view .LVU49
 145 0044 8823      		tst r24
 146 0046 01F0      		breq .L1
  84:drivers/keyboard.c **** 	{
  85:drivers/keyboard.c **** 		last_key_pressed = ret_key;
 147               		.loc 1 85 3 is_stmt 1 view .LVU50
 148               		.loc 1 85 20 is_stmt 0 view .LVU51
 149 0048 282F      		mov r18,r24
 150 004a 30E0      		ldi r19,0
 151 004c 3093 0000 		sts last_key_pressed+1,r19
 152 0050 2093 0000 		sts last_key_pressed,r18
 153 0054 0895      		ret
 154               	.LVL11:
 155               	.L2:
 156               	.LBB41:
  60:drivers/keyboard.c **** 			break;
 157               		.loc 1 60 5 is_stmt 1 view .LVU52
  60:drivers/keyboard.c **** 			break;
 158               		.loc 1 60 26 is_stmt 0 view .LVU53
 159 0056 822F      		mov r24,r18
 160               	.LVL12:
  60:drivers/keyboard.c **** 			break;
 161               		.loc 1 60 26 view .LVU54
 162 0058 880F      		lsl r24
 163 005a 820F      		add r24,r18
  60:drivers/keyboard.c **** 			break;
 164               		.loc 1 60 15 view .LVU55
 165 005c 8E5F      		subi r24,lo8(-(2))
 166               	.LVL13:
  61:drivers/keyboard.c **** 
 167               		.loc 1 61 4 is_stmt 1 view .LVU56
 168 005e 00C0      		rjmp .L6
 169               	.LVL14:
 170               	.L14:
  71:drivers/keyboard.c **** 		{
 171               		.loc 1 71 3 discriminator 2 view .LVU57
  46:drivers/keyboard.c **** 	{
 172               		.loc 1 46 2 is_stmt 0 discriminator 2 view .LVU58
 173 0060 2430      		cpi r18,4
 174 0062 3105      		cpc r19,__zero_reg__
 175 0064 01F4      		brne .L7
 176 0066 80E0      		ldi r24,0
 177               	.LVL15:
  46:drivers/keyboard.c **** 	{
 178               		.loc 1 46 2 discriminator 2 view .LVU59
 179 0068 00C0      		rjmp .L6
 180               	.LVL16:
 181               	.L9:
  46:drivers/keyboard.c **** 	{
 182               		.loc 1 46 2 discriminator 2 view .LVU60
 183               	.LBE41:
  41:drivers/keyboard.c **** 	uint8_t		pin_value;
 184               		.loc 1 41 8 view .LVU61
 185 006a 80E0      		ldi r24,0
 186               	.LVL17:
  86:drivers/keyboard.c **** 	}
  87:drivers/keyboard.c **** 
  88:drivers/keyboard.c **** 	return ret_key;
 187               		.loc 1 88 2 is_stmt 1 view .LVU62
 188               	.L1:
 189               	/* epilogue start */
  89:drivers/keyboard.c **** }
 190               		.loc 1 89 1 is_stmt 0 view .LVU63
 191 006c 0895      		ret
 192               		.cfi_endproc
 193               	.LFE6:
 195               		.section	.text.keyboard_input_get,"ax",@progbits
 196               	.global	keyboard_input_get
 198               	keyboard_input_get:
 199               	.LVL18:
 200               	.LFB7:
  90:drivers/keyboard.c **** 
  91:drivers/keyboard.c **** 
  92:drivers/keyboard.c **** /** keboard input */
  93:drivers/keyboard.c **** int8_t
  94:drivers/keyboard.c **** keyboard_input_get ( uint8_t * tempPassword )
  95:drivers/keyboard.c **** {
 201               		.loc 1 95 1 is_stmt 1 view -0
 202               		.cfi_startproc
 203               		.loc 1 95 1 is_stmt 0 view .LVU65
 204 0000 CF93      		push r28
 205               	.LCFI0:
 206               		.cfi_def_cfa_offset 3
 207               		.cfi_offset 28, -2
 208 0002 DF93      		push r29
 209               	.LCFI1:
 210               		.cfi_def_cfa_offset 4
 211               		.cfi_offset 29, -3
 212               	/* prologue: function */
 213               	/* frame size = 0 */
 214               	/* stack size = 2 */
 215               	.L__stack_usage = 2
 216 0004 EC01      		movw r28,r24
  96:drivers/keyboard.c **** 	uint16_t key = scan_key ();
 217               		.loc 1 96 2 is_stmt 1 view .LVU66
 218               		.loc 1 96 17 is_stmt 0 view .LVU67
 219 0006 0E94 0000 		call scan_key
 220               	.LVL19:
 221               		.loc 1 96 11 view .LVU68
 222 000a 282F      		mov r18,r24
 223 000c 30E0      		ldi r19,0
 224               	.LVL20:
  97:drivers/keyboard.c **** 
  98:drivers/keyboard.c **** 	if( key == 10 )                        //   *
 225               		.loc 1 98 2 is_stmt 1 view .LVU69
 226               		.loc 1 98 4 is_stmt 0 view .LVU70
 227 000e 2A30      		cpi r18,10
 228 0010 3105      		cpc r19,__zero_reg__
 229 0012 01F4      		brne .L16
 230 0014 CE01      		movw r24,r28
 231 0016 4496      		adiw r24,20
 232               	.LVL21:
 233               	.L17:
 234               	.LBB42:
  99:drivers/keyboard.c **** 	{
 100:drivers/keyboard.c **** //		input_available = 0;
 101:drivers/keyboard.c **** 		// clean password
 102:drivers/keyboard.c **** 
 103:drivers/keyboard.c **** 		for( uint8_t i = 0; i < PASSWORD_MAX_SIZE; i++ )
 104:drivers/keyboard.c **** 		{
 105:drivers/keyboard.c **** 			tempPassword [i] = 0;
 235               		.loc 1 105 4 is_stmt 1 discriminator 3 view .LVU71
 236               		.loc 1 105 21 is_stmt 0 discriminator 3 view .LVU72
 237 0018 1992      		st Y+,__zero_reg__
 238               	.LVL22:
 103:drivers/keyboard.c **** 		{
 239               		.loc 1 103 3 discriminator 3 view .LVU73
 240 001a C817      		cp r28,r24
 241 001c D907      		cpc r29,r25
 242 001e 01F4      		brne .L17
 243               	.LBE42:
 106:drivers/keyboard.c **** 		}
 107:drivers/keyboard.c **** 		passwordIndex = 0;
 244               		.loc 1 107 3 is_stmt 1 view .LVU74
 245               		.loc 1 107 17 is_stmt 0 view .LVU75
 246 0020 1092 0000 		sts passwordIndex+1,__zero_reg__
 247 0024 1092 0000 		sts passwordIndex,__zero_reg__
 108:drivers/keyboard.c **** 
 109:drivers/keyboard.c **** 		PORTC = 0b00001000;
 248               		.loc 1 109 3 is_stmt 1 view .LVU76
 249               		.loc 1 109 9 is_stmt 0 view .LVU77
 250 0028 88E0      		ldi r24,lo8(8)
 251               	.LVL23:
 252               		.loc 1 109 9 view .LVU78
 253 002a 85BB      		out 0x15,r24
 254               	.LVL24:
 255               	.L26:
 110:drivers/keyboard.c **** 	}
 111:drivers/keyboard.c **** 	else if( key == 12 )                  //   #
 112:drivers/keyboard.c **** 	{
 113:drivers/keyboard.c **** //		input_available = 1;
 114:drivers/keyboard.c **** 		passwordIndex = 0;
 115:drivers/keyboard.c **** 		PORTC = 0;
 116:drivers/keyboard.c **** 		return 1;
 117:drivers/keyboard.c **** 	}
 118:drivers/keyboard.c **** 	else
 119:drivers/keyboard.c **** 	if( key != 0 )
 120:drivers/keyboard.c **** 	{
 121:drivers/keyboard.c **** 		if( key == 1 )
 122:drivers/keyboard.c **** 		{
 123:drivers/keyboard.c **** 			PORTC = 0b00000001;
 124:drivers/keyboard.c **** 		}
 125:drivers/keyboard.c **** 
 126:drivers/keyboard.c **** 		if( key == 2 )
 127:drivers/keyboard.c **** 		{
 128:drivers/keyboard.c **** 			PORTC = 0b00000010;
 129:drivers/keyboard.c **** 		}
 130:drivers/keyboard.c **** 
 131:drivers/keyboard.c **** 		if( passwordIndex < PASSWORD_MAX_SIZE )
 132:drivers/keyboard.c **** 		{
 133:drivers/keyboard.c **** 			tempPassword[passwordIndex] = key; // Заносим очередной символ во временный массив
 134:drivers/keyboard.c **** 			passwordIndex++;
 135:drivers/keyboard.c **** 		}
 136:drivers/keyboard.c **** 	}
 137:drivers/keyboard.c **** 	else
 138:drivers/keyboard.c **** 	{
 139:drivers/keyboard.c **** 		/*** no buttons pressed (idle state) */
 140:drivers/keyboard.c **** 	}
 141:drivers/keyboard.c **** 
 142:drivers/keyboard.c **** 
 143:drivers/keyboard.c **** 	return 0;
 256               		.loc 1 143 9 view .LVU79
 257 002c 80E0      		ldi r24,0
 258 002e 00C0      		rjmp .L15
 259               	.LVL25:
 260               	.L16:
 111:drivers/keyboard.c **** 	{
 261               		.loc 1 111 7 is_stmt 1 view .LVU80
 111:drivers/keyboard.c **** 	{
 262               		.loc 1 111 9 is_stmt 0 view .LVU81
 263 0030 2C30      		cpi r18,12
 264 0032 3105      		cpc r19,__zero_reg__
 265 0034 01F4      		brne .L19
 114:drivers/keyboard.c **** 		PORTC = 0;
 266               		.loc 1 114 3 is_stmt 1 view .LVU82
 114:drivers/keyboard.c **** 		PORTC = 0;
 267               		.loc 1 114 17 is_stmt 0 view .LVU83
 268 0036 1092 0000 		sts passwordIndex+1,__zero_reg__
 269 003a 1092 0000 		sts passwordIndex,__zero_reg__
 115:drivers/keyboard.c **** 		return 1;
 270               		.loc 1 115 3 is_stmt 1 view .LVU84
 115:drivers/keyboard.c **** 		return 1;
 271               		.loc 1 115 9 is_stmt 0 view .LVU85
 272 003e 15BA      		out 0x15,__zero_reg__
 116:drivers/keyboard.c **** 	}
 273               		.loc 1 116 3 is_stmt 1 view .LVU86
 116:drivers/keyboard.c **** 	}
 274               		.loc 1 116 10 is_stmt 0 view .LVU87
 275 0040 81E0      		ldi r24,lo8(1)
 276               	.LVL26:
 277               	.L15:
 278               	/* epilogue start */
 144:drivers/keyboard.c **** }
 279               		.loc 1 144 1 view .LVU88
 280 0042 DF91      		pop r29
 281 0044 CF91      		pop r28
 282 0046 0895      		ret
 283               	.LVL27:
 284               	.L19:
 119:drivers/keyboard.c **** 	{
 285               		.loc 1 119 2 is_stmt 1 view .LVU89
 119:drivers/keyboard.c **** 	{
 286               		.loc 1 119 4 is_stmt 0 view .LVU90
 287 0048 2115      		cp r18,__zero_reg__
 288 004a 3105      		cpc r19,__zero_reg__
 289 004c 01F0      		breq .L26
 121:drivers/keyboard.c **** 		{
 290               		.loc 1 121 3 is_stmt 1 view .LVU91
 123:drivers/keyboard.c **** 		}
 291               		.loc 1 123 10 is_stmt 0 view .LVU92
 292 004e 91E0      		ldi r25,lo8(1)
 121:drivers/keyboard.c **** 		{
 293               		.loc 1 121 5 view .LVU93
 294 0050 2130      		cpi r18,1
 295 0052 3105      		cpc r19,__zero_reg__
 296 0054 01F0      		breq .L25
 126:drivers/keyboard.c **** 		{
 297               		.loc 1 126 3 is_stmt 1 view .LVU94
 126:drivers/keyboard.c **** 		{
 298               		.loc 1 126 5 is_stmt 0 view .LVU95
 299 0056 2230      		cpi r18,2
 300 0058 3105      		cpc r19,__zero_reg__
 301 005a 01F4      		brne .L22
 128:drivers/keyboard.c **** 		}
 302               		.loc 1 128 4 is_stmt 1 view .LVU96
 128:drivers/keyboard.c **** 		}
 303               		.loc 1 128 10 is_stmt 0 view .LVU97
 304 005c 92E0      		ldi r25,lo8(2)
 305               	.L25:
 306 005e 95BB      		out 0x15,r25
 307               	.L22:
 131:drivers/keyboard.c **** 		{
 308               		.loc 1 131 3 is_stmt 1 view .LVU98
 131:drivers/keyboard.c **** 		{
 309               		.loc 1 131 21 is_stmt 0 view .LVU99
 310 0060 E091 0000 		lds r30,passwordIndex
 311 0064 F091 0000 		lds r31,passwordIndex+1
 131:drivers/keyboard.c **** 		{
 312               		.loc 1 131 5 view .LVU100
 313 0068 E431      		cpi r30,20
 314 006a F105      		cpc r31,__zero_reg__
 315 006c 04F4      		brge .L26
 133:drivers/keyboard.c **** 			passwordIndex++;
 316               		.loc 1 133 4 is_stmt 1 view .LVU101
 133:drivers/keyboard.c **** 			passwordIndex++;
 317               		.loc 1 133 32 is_stmt 0 view .LVU102
 318 006e EC0F      		add r30,r28
 319 0070 FD1F      		adc r31,r29
 320 0072 8083      		st Z,r24
 134:drivers/keyboard.c **** 		}
 321               		.loc 1 134 4 is_stmt 1 view .LVU103
 134:drivers/keyboard.c **** 		}
 322               		.loc 1 134 17 is_stmt 0 view .LVU104
 323 0074 8091 0000 		lds r24,passwordIndex
 324 0078 9091 0000 		lds r25,passwordIndex+1
 325 007c 0196      		adiw r24,1
 326 007e 9093 0000 		sts passwordIndex+1,r25
 327 0082 8093 0000 		sts passwordIndex,r24
 328 0086 00C0      		rjmp .L26
 329               		.cfi_endproc
 330               	.LFE7:
 332               		.section	.bss.prev_key_val.1178,"aw",@nobits
 335               	prev_key_val.1178:
 336 0000 00        		.zero	1
 337               		.section	.bss.last_key_pressed,"aw",@nobits
 340               	last_key_pressed:
 341 0000 0000      		.zero	2
 342               	.global	key_tab
 343               		.section	.rodata.key_tab,"a"
 346               	key_tab:
 347 0000 FE        		.byte	-2
 348 0001 FD        		.byte	-3
 349 0002 FB        		.byte	-5
 350 0003 F7        		.byte	-9
 351               	.global	passwordIndex
 352               		.section	.bss.passwordIndex,"aw",@nobits
 355               	passwordIndex:
 356 0000 0000      		.zero	2
 357               		.comm	tempPassword,20,1
 358               		.text
 359               	.Letext0:
 360               		.file 4 "c:\\bin\\avr-gcc-8.3.0-x64-mingw\\lib\\gcc\\avr\\8.3.0\\include\\stdint-gcc.h"
DEFINED SYMBOLS
                            *ABS*:0000000000000000 keyboard.c
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccyxiVuz.s:2      *ABS*:000000000000003e __SP_H__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccyxiVuz.s:3      *ABS*:000000000000003d __SP_L__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccyxiVuz.s:4      *ABS*:000000000000003f __SREG__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccyxiVuz.s:5      *ABS*:0000000000000000 __tmp_reg__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccyxiVuz.s:6      *ABS*:0000000000000001 __zero_reg__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccyxiVuz.s:13     .text.scan_key:0000000000000000 scan_key
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccyxiVuz.s:346    .rodata.key_tab:0000000000000000 key_tab
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccyxiVuz.s:335    .bss.prev_key_val.1178:0000000000000000 prev_key_val.1178
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccyxiVuz.s:340    .bss.last_key_pressed:0000000000000000 last_key_pressed
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccyxiVuz.s:198    .text.keyboard_input_get:0000000000000000 keyboard_input_get
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccyxiVuz.s:355    .bss.passwordIndex:0000000000000000 passwordIndex
                            *COM*:0000000000000014 tempPassword

UNDEFINED SYMBOLS
__do_copy_data
__do_clear_bss
