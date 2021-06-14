   1               		.file	"password.c"
   2               	__SP_H__ = 0x3e
   3               	__SP_L__ = 0x3d
   4               	__SREG__ = 0x3f
   5               	__tmp_reg__ = 0
   6               	__zero_reg__ = 1
   7               		.text
   8               	.Ltext0:
   9               		.cfi_sections	.debug_frame
  10               		.section	.text.password_verification,"ax",@progbits
  11               	.global	password_verification
  13               	password_verification:
  14               	.LVL0:
  15               	.LFB6:
  16               		.file 1 "drivers/password.c"
   1:drivers/password.c **** /*
   2:drivers/password.c ****  * password.c
   3:drivers/password.c ****  *
   4:drivers/password.c ****  *  Created on: 11 июн. 2021 г.
   5:drivers/password.c ****  *      Author: Y.Virsky
   6:drivers/password.c ****  */
   7:drivers/password.c **** 
   8:drivers/password.c **** #include <inttypes.h>
   9:drivers/password.c **** #include <avr/io.h>
  10:drivers/password.c **** #include <avr/interrupt.h>
  11:drivers/password.c **** #include <avr/sleep.h>
  12:drivers/password.c **** #include <util/delay.h>
  13:drivers/password.c **** 
  14:drivers/password.c **** #include "keyboard.h"
  15:drivers/password.c **** #include "password.h"
  16:drivers/password.c **** 
  17:drivers/password.c **** 
  18:drivers/password.c **** 
  19:drivers/password.c **** uint8_t accessPassword[2] = { 1, 2 }; 	// Пароль доступа по умолчанию
  20:drivers/password.c **** 
  21:drivers/password.c **** 
  22:drivers/password.c **** int8_t
  23:drivers/password.c **** password_verification( uint8_t * password_user)
  24:drivers/password.c **** {
  17               		.loc 1 24 1 view -0
  18               		.cfi_startproc
  19               	/* prologue: function */
  20               	/* frame size = 0 */
  21               	/* stack size = 0 */
  22               	.L__stack_usage = 0
  23               		.loc 1 24 1 is_stmt 0 view .LVU1
  24 0000 FC01      		movw r30,r24
  25:drivers/password.c **** 	int8_t  success = 0;
  25               		.loc 1 25 2 is_stmt 1 view .LVU2
  26               	.LVL1:
  26:drivers/password.c **** 
  27:drivers/password.c **** 
  28:drivers/password.c **** 	if( (password_user[0] == accessPassword[0]) &&
  27               		.loc 1 28 2 view .LVU3
  28               		.loc 1 28 4 is_stmt 0 view .LVU4
  29 0002 9081      		ld r25,Z
  30 0004 8091 0000 		lds r24,accessPassword
  31               	.LVL2:
  32               		.loc 1 28 4 view .LVU5
  33 0008 9813      		cpse r25,r24
  34 000a 00C0      		rjmp .L5
  35               		.loc 1 28 46 discriminator 1 view .LVU6
  36 000c 9181      		ldd r25,Z+1
  37 000e 8091 0000 		lds r24,accessPassword+1
  38 0012 9813      		cpse r25,r24
  39 0014 00C0      		rjmp .L5
  29:drivers/password.c **** 	    (password_user[1] == accessPassword[1]) )
  30:drivers/password.c **** 	{
  31:drivers/password.c **** 		PORTC = 0b00000100;
  40               		.loc 1 31 3 is_stmt 1 view .LVU7
  41               		.loc 1 31 9 is_stmt 0 view .LVU8
  42 0016 84E0      		ldi r24,lo8(4)
  43 0018 85BB      		out 0x15,r24
  32:drivers/password.c **** 		success = 1;
  44               		.loc 1 32 3 is_stmt 1 view .LVU9
  45               	.LVL3:
  46               		.loc 1 32 11 is_stmt 0 view .LVU10
  47 001a 81E0      		ldi r24,lo8(1)
  48               	.LVL4:
  49               	.L2:
  33:drivers/password.c **** 	}
  34:drivers/password.c **** 
  35:drivers/password.c **** 	for( int8_t i = 0; i < PASSWORD_MAX_SIZE; i++ )
  50               		.loc 1 35 2 is_stmt 1 view .LVU11
  51               	.LBB2:
  52               		.loc 1 35 7 view .LVU12
  53               		.loc 1 35 7 is_stmt 0 view .LVU13
  54 001c 9F01      		movw r18,r30
  55 001e 2C5E      		subi r18,-20
  56 0020 3F4F      		sbci r19,-1
  57               	.LVL5:
  58               	.L3:
  36:drivers/password.c **** 	{
  37:drivers/password.c **** 		password_user [i] = 0;
  59               		.loc 1 37 3 is_stmt 1 discriminator 3 view .LVU14
  60               		.loc 1 37 21 is_stmt 0 discriminator 3 view .LVU15
  61 0022 1192      		st Z+,__zero_reg__
  62               	.LVL6:
  35:drivers/password.c **** 	{
  63               		.loc 1 35 2 discriminator 3 view .LVU16
  64 0024 E217      		cp r30,r18
  65 0026 F307      		cpc r31,r19
  66 0028 01F4      		brne .L3
  67               	/* epilogue start */
  68               	.LBE2:
  38:drivers/password.c **** 	}
  39:drivers/password.c **** 
  40:drivers/password.c **** 	return success;
  41:drivers/password.c **** 
  42:drivers/password.c **** }
  69               		.loc 1 42 1 view .LVU17
  70 002a 0895      		ret
  71               	.LVL7:
  72               	.L5:
  25:drivers/password.c **** 
  73               		.loc 1 25 10 view .LVU18
  74 002c 80E0      		ldi r24,0
  75 002e 00C0      		rjmp .L2
  76               		.cfi_endproc
  77               	.LFE6:
  79               	.global	accessPassword
  80               		.section	.data.accessPassword,"aw"
  83               	accessPassword:
  84 0000 01        		.byte	1
  85 0001 02        		.byte	2
  86               		.text
  87               	.Letext0:
  88               		.file 2 "c:\\bin\\avr-gcc-8.3.0-x64-mingw\\lib\\gcc\\avr\\8.3.0\\include\\stdint-gcc.h"
DEFINED SYMBOLS
                            *ABS*:0000000000000000 password.c
C:\Users\YB38D~1.VIR\AppData\Local\Temp\cczjidnu.s:2      *ABS*:000000000000003e __SP_H__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\cczjidnu.s:3      *ABS*:000000000000003d __SP_L__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\cczjidnu.s:4      *ABS*:000000000000003f __SREG__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\cczjidnu.s:5      *ABS*:0000000000000000 __tmp_reg__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\cczjidnu.s:6      *ABS*:0000000000000001 __zero_reg__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\cczjidnu.s:13     .text.password_verification:0000000000000000 password_verification
C:\Users\YB38D~1.VIR\AppData\Local\Temp\cczjidnu.s:83     .data.accessPassword:0000000000000000 accessPassword

UNDEFINED SYMBOLS
__do_copy_data
