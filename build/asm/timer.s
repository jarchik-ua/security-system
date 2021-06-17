   1               		.file	"timer.c"
   2               	__SP_H__ = 0x3e
   3               	__SP_L__ = 0x3d
   4               	__SREG__ = 0x3f
   5               	__tmp_reg__ = 0
   6               	__zero_reg__ = 1
   7               		.text
   8               	.Ltext0:
   9               		.cfi_sections	.debug_frame
  10               		.section	.text.timer_time_get,"ax",@progbits
  11               	.global	timer_time_get
  13               	timer_time_get:
  14               	.LFB6:
  15               		.file 1 "drivers/timer.c"
   1:drivers/timer.c **** /*
   2:drivers/timer.c ****  * timer.c
   3:drivers/timer.c ****  *
   4:drivers/timer.c ****  *  Created on: 14 θών. 2021 γ.
   5:drivers/timer.c ****  *      Author: Y.Virsky
   6:drivers/timer.c ****  */
   7:drivers/timer.c **** 
   8:drivers/timer.c **** #define F_CPU 16000000L
   9:drivers/timer.c **** #define __AVR_ATmega16__
  10:drivers/timer.c **** 
  11:drivers/timer.c **** #include <inttypes.h>
  12:drivers/timer.c **** #include <avr/io.h>
  13:drivers/timer.c **** #include <avr/interrupt.h>
  14:drivers/timer.c **** #include <avr/sleep.h>
  15:drivers/timer.c **** #include <util/delay.h>
  16:drivers/timer.c **** 
  17:drivers/timer.c **** #include "timer.h"
  18:drivers/timer.c **** 
  19:drivers/timer.c **** 
  20:drivers/timer.c **** #define TIM1_OCR_TICK_PER_SECOND      ( 16 ) // 1,0s for presc 1024
  21:drivers/timer.c **** 
  22:drivers/timer.c **** 
  23:drivers/timer.c **** static uint16_t  timer_counter = 0;
  24:drivers/timer.c **** 
  25:drivers/timer.c **** 
  26:drivers/timer.c **** uint16_t
  27:drivers/timer.c **** timer_time_get( void )
  28:drivers/timer.c **** {
  16               		.loc 1 28 1 view -0
  17               		.cfi_startproc
  18               	/* prologue: function */
  19               	/* frame size = 0 */
  20               	/* stack size = 0 */
  21               	.L__stack_usage = 0
  29:drivers/timer.c **** 	return timer_counter;
  22               		.loc 1 29 2 view .LVU1
  30:drivers/timer.c **** }
  23               		.loc 1 30 1 is_stmt 0 view .LVU2
  24 0000 8091 0000 		lds r24,timer_counter
  25 0004 9091 0000 		lds r25,timer_counter+1
  26               	/* epilogue start */
  27 0008 0895      		ret
  28               		.cfi_endproc
  29               	.LFE6:
  31               		.section	.text.__vector_6,"ax",@progbits
  32               	.global	__vector_6
  34               	__vector_6:
  35               	.LFB7:
  31:drivers/timer.c **** 
  32:drivers/timer.c **** ISR (TIMER1_COMPA_vect)
  33:drivers/timer.c **** {
  36               		.loc 1 33 1 is_stmt 1 view -0
  37               		.cfi_startproc
  38 0000 8F93 8FB7 		__gcc_isr 1
  38      8F93 
  39 0006 9F93      		push r25
  40               	.LCFI0:
  41               		.cfi_def_cfa_offset 3
  42               		.cfi_offset 25, -2
  43               	/* prologue: Signal */
  44               	/* frame size = 0 */
  45               	/* stack size = 1...5 */
  46               	.L__stack_usage = 1 + __gcc_isr.n_pushed
  34:drivers/timer.c ****    timer_counter ++;
  47               		.loc 1 34 4 view .LVU4
  48               		.loc 1 34 18 is_stmt 0 view .LVU5
  49 0008 8091 0000 		lds r24,timer_counter
  50 000c 9091 0000 		lds r25,timer_counter+1
  51 0010 0196      		adiw r24,1
  52 0012 9093 0000 		sts timer_counter+1,r25
  53 0016 8093 0000 		sts timer_counter,r24
  54               	/* epilogue start */
  35:drivers/timer.c **** }
  55               		.loc 1 35 1 view .LVU6
  56 001a 9F91      		pop r25
  57 001c 8F91 8FBF 		__gcc_isr 2
  57      8F91 
  58 0022 1895      		reti
  59               		__gcc_isr 0,r24
  60               		.cfi_endproc
  61               	.LFE7:
  63               		.section	.text.tim1_init,"ax",@progbits
  64               	.global	tim1_init
  66               	tim1_init:
  67               	.LFB8:
  36:drivers/timer.c **** 
  37:drivers/timer.c **** 
  38:drivers/timer.c **** void
  39:drivers/timer.c **** tim1_init( void )
  40:drivers/timer.c **** {
  68               		.loc 1 40 1 is_stmt 1 view -0
  69               		.cfi_startproc
  70               	/* prologue: function */
  71               	/* frame size = 0 */
  72               	/* stack size = 0 */
  73               	.L__stack_usage = 0
  41:drivers/timer.c **** 	//
  42:drivers/timer.c **** 	// Ftim = Fcpu / 1024
  43:drivers/timer.c **** 	// CTC mode
  44:drivers/timer.c **** 	//
  45:drivers/timer.c **** 
  46:drivers/timer.c **** 	TCCR1B = ( 1<<WGM12 );
  74               		.loc 1 46 2 view .LVU8
  75               		.loc 1 46 9 is_stmt 0 view .LVU9
  76 0000 88E0      		ldi r24,lo8(8)
  77 0002 8EBD      		out 0x2e,r24
  47:drivers/timer.c **** 
  48:drivers/timer.c **** 	OCR1AH = TIM1_OCR_TICK_PER_SECOND >> 8;
  78               		.loc 1 48 2 is_stmt 1 view .LVU10
  79               		.loc 1 48 9 is_stmt 0 view .LVU11
  80 0004 1BBC      		out 0x2b,__zero_reg__
  49:drivers/timer.c **** 	OCR1AL = TIM1_OCR_TICK_PER_SECOND & 0xff;
  81               		.loc 1 49 2 is_stmt 1 view .LVU12
  82               		.loc 1 49 9 is_stmt 0 view .LVU13
  83 0006 80E1      		ldi r24,lo8(16)
  84 0008 8ABD      		out 0x2a,r24
  50:drivers/timer.c **** 
  51:drivers/timer.c **** 
  52:drivers/timer.c **** 	TCCR1B |= ( 1<<CS12 ) | ( 0<<CS11 ) | ( 1<<CS10 );
  85               		.loc 1 52 2 is_stmt 1 view .LVU14
  86               		.loc 1 52 9 is_stmt 0 view .LVU15
  87 000a 8EB5      		in r24,0x2e
  88 000c 8560      		ori r24,lo8(5)
  89 000e 8EBD      		out 0x2e,r24
  53:drivers/timer.c **** 	TIMSK |= ( 1<<OCIE1A );
  90               		.loc 1 53 2 is_stmt 1 view .LVU16
  91               		.loc 1 53 8 is_stmt 0 view .LVU17
  92 0010 89B7      		in r24,0x39
  93 0012 8061      		ori r24,lo8(16)
  94 0014 89BF      		out 0x39,r24
  95               	/* epilogue start */
  54:drivers/timer.c **** }
  96               		.loc 1 54 1 view .LVU18
  97 0016 0895      		ret
  98               		.cfi_endproc
  99               	.LFE8:
 101               		.section	.bss.timer_counter,"aw",@nobits
 104               	timer_counter:
 105 0000 0000      		.zero	2
 106               		.text
 107               	.Letext0:
 108               		.file 2 "c:\\bin\\avr-gcc-8.3.0-x64-mingw\\lib\\gcc\\avr\\8.3.0\\include\\stdint-gcc.h"
DEFINED SYMBOLS
                            *ABS*:0000000000000000 timer.c
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccGdKnbX.s:2      *ABS*:000000000000003e __SP_H__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccGdKnbX.s:3      *ABS*:000000000000003d __SP_L__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccGdKnbX.s:4      *ABS*:000000000000003f __SREG__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccGdKnbX.s:5      *ABS*:0000000000000000 __tmp_reg__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccGdKnbX.s:6      *ABS*:0000000000000001 __zero_reg__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccGdKnbX.s:13     .text.timer_time_get:0000000000000000 timer_time_get
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccGdKnbX.s:104    .bss.timer_counter:0000000000000000 timer_counter
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccGdKnbX.s:34     .text.__vector_6:0000000000000000 __vector_6
                            *ABS*:0000000000000002 __gcc_isr.n_pushed.001
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccGdKnbX.s:66     .text.tim1_init:0000000000000000 tim1_init

UNDEFINED SYMBOLS
__do_clear_bss
