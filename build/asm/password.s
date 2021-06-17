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
  27:drivers/password.c **** 	if (password_user[2] == 0)
  27               		.loc 1 27 2 view .LVU3
  28               		.loc 1 27 5 is_stmt 0 view .LVU4
  29 0002 8281      		ldd r24,Z+2
  30               	.LVL2:
  31               		.loc 1 27 5 view .LVU5
  32 0004 8111      		cpse r24,__zero_reg__
  33 0006 00C0      		rjmp .L5
  28:drivers/password.c **** 	{
  29:drivers/password.c **** 		if( (password_user[0] == accessPassword[0]) &&
  34               		.loc 1 29 3 is_stmt 1 view .LVU6
  35               		.loc 1 29 5 is_stmt 0 view .LVU7
  36 0008 9081      		ld r25,Z
  37 000a 8091 0000 		lds r24,accessPassword
  38 000e 9813      		cpse r25,r24
  39 0010 00C0      		rjmp .L5
  40               		.loc 1 29 47 discriminator 1 view .LVU8
  41 0012 9181      		ldd r25,Z+1
  42 0014 8091 0000 		lds r24,accessPassword+1
  43 0018 9813      		cpse r25,r24
  44 001a 00C0      		rjmp .L5
  30:drivers/password.c **** 			(password_user[1] == accessPassword[1]) )
  31:drivers/password.c **** 		{
  32:drivers/password.c **** 			PORTC = 0b00000100;
  45               		.loc 1 32 4 is_stmt 1 view .LVU9
  46               		.loc 1 32 10 is_stmt 0 view .LVU10
  47 001c 84E0      		ldi r24,lo8(4)
  48 001e 85BB      		out 0x15,r24
  33:drivers/password.c **** 			success = 1;
  49               		.loc 1 33 4 is_stmt 1 view .LVU11
  50               	.LVL3:
  51               		.loc 1 33 12 is_stmt 0 view .LVU12
  52 0020 81E0      		ldi r24,lo8(1)
  53 0022 0895      		ret
  54               	.LVL4:
  55               	.L5:
  25:drivers/password.c **** 
  56               		.loc 1 25 10 view .LVU13
  57 0024 80E0      		ldi r24,0
  34:drivers/password.c **** 		}
  35:drivers/password.c **** 	}
  36:drivers/password.c **** 
  37:drivers/password.c **** 	return success;
  58               		.loc 1 37 2 is_stmt 1 view .LVU14
  59               	/* epilogue start */
  38:drivers/password.c **** }
  60               		.loc 1 38 1 is_stmt 0 view .LVU15
  61 0026 0895      		ret
  62               		.cfi_endproc
  63               	.LFE6:
  65               	.global	accessPassword
  66               		.section	.data.accessPassword,"aw"
  69               	accessPassword:
  70 0000 01        		.byte	1
  71 0001 02        		.byte	2
  72               		.text
  73               	.Letext0:
  74               		.file 2 "c:\\bin\\avr-gcc-8.3.0-x64-mingw\\lib\\gcc\\avr\\8.3.0\\include\\stdint-gcc.h"
DEFINED SYMBOLS
                            *ABS*:0000000000000000 password.c
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccepzDGK.s:2      *ABS*:000000000000003e __SP_H__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccepzDGK.s:3      *ABS*:000000000000003d __SP_L__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccepzDGK.s:4      *ABS*:000000000000003f __SREG__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccepzDGK.s:5      *ABS*:0000000000000000 __tmp_reg__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccepzDGK.s:6      *ABS*:0000000000000001 __zero_reg__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccepzDGK.s:13     .text.password_verification:0000000000000000 password_verification
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccepzDGK.s:69     .data.accessPassword:0000000000000000 accessPassword

UNDEFINED SYMBOLS
__do_copy_data
