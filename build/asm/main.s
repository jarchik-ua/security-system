   1               		.file	"main.c"
   2               	__SP_H__ = 0x3e
   3               	__SP_L__ = 0x3d
   4               	__SREG__ = 0x3f
   5               	__tmp_reg__ = 0
   6               	__zero_reg__ = 1
   7               		.text
   8               	.Ltext0:
   9               		.cfi_sections	.debug_frame
  10               		.section	.text.init_port,"ax",@progbits
  11               	.global	init_port
  13               	init_port:
  14               	.LFB7:
  15               		.file 1 "main.c"
   1:main.c        **** #define F_CPU 16000000L
   2:main.c        **** #define __AVR_ATmega16__
   3:main.c        **** 
   4:main.c        **** #include <inttypes.h>
   5:main.c        **** #include <avr/io.h>
   6:main.c        **** #include <avr/interrupt.h>
   7:main.c        **** #include <avr/sleep.h>
   8:main.c        **** #include <util/delay.h>
   9:main.c        **** 
  10:main.c        **** #include <drivers/keyboard.h>
  11:main.c        **** #include <drivers/password.h>
  12:main.c        **** #include <drivers/timer.h>
  13:main.c        **** 
  14:main.c        **** 
  15:main.c        **** #define 			KEYBOARD_INIT                   DDRB
  16:main.c        **** #define 			KEYBOARD                    	PORTB
  17:main.c        **** 
  18:main.c        **** #define 			PASSWORD_MAX_SIZE				20
  19:main.c        **** 
  20:main.c        **** #define TIM1_OCR_TICK_PER_SECOND     ( 15625 )				 // 1,0s for presc 1024
  21:main.c        **** 
  22:main.c        **** uint8_t tempPassword_new[PASSWORD_MAX_SIZE];
  23:main.c        **** 
  24:main.c        **** //static  uint8_t timer;
  25:main.c        **** 
  26:main.c        **** 
  27:main.c        **** void init_port ( void );
  28:main.c        **** 
  29:main.c        **** typedef enum {
  30:main.c        **** 	Stage_Init,
  31:main.c        **** 	Input_Acquired,
  32:main.c        **** 	Password_Valid,
  33:main.c        **** 	timeout,
  34:main.c        **** 	Working
  35:main.c        **** } states_t;
  36:main.c        **** 
  37:main.c        **** 
  38:main.c        **** static states_t state = Stage_Init;
  39:main.c        **** static uint16_t  time_curr = 0;
  40:main.c        **** static uint16_t  past_time = 0;
  41:main.c        **** 
  42:main.c        **** static volatile	uint16_t	time_diff;
  43:main.c        **** 
  44:main.c        **** 
  45:main.c        **** int main( void )
  46:main.c        **** {
  47:main.c        **** 
  48:main.c        **** 	init_port();
  49:main.c        **** 	tim1_init();
  50:main.c        **** 
  51:main.c        **** 	for( int8_t i = 0; i < PASSWORD_MAX_SIZE; i++ )
  52:main.c        **** 	{
  53:main.c        **** 		tempPassword_new [i] = 0;
  54:main.c        **** 	}
  55:main.c        **** 
  56:main.c        **** 	sei();
  57:main.c        **** 
  58:main.c        **** 
  59:main.c        **** 	while (1)
  60:main.c        **** 	{
  61:main.c        **** 		time_curr = timer_time_get();
  62:main.c        **** 
  63:main.c        **** 		switch ( state )
  64:main.c        **** 		{
  65:main.c        **** 			case Stage_Init:
  66:main.c        **** 				for( int8_t i = 0; i < PASSWORD_MAX_SIZE; i++ )
  67:main.c        **** 				{
  68:main.c        **** 					tempPassword_new [i] = 0;
  69:main.c        **** 				}
  70:main.c        **** 				PORTD = 0b00000001;
  71:main.c        **** 				state = Input_Acquired;
  72:main.c        **** 			break;
  73:main.c        **** 
  74:main.c        **** 			case Input_Acquired:
  75:main.c        **** 				PORTD = 0b00000010;
  76:main.c        **** 				if( keyboard_input_get(tempPassword_new) )
  77:main.c        **** 				{
  78:main.c        **** 					state = Password_Valid;
  79:main.c        **** 					past_time = time_curr;
  80:main.c        **** 				}
  81:main.c        **** 			break;
  82:main.c        **** 
  83:main.c        **** 			case Password_Valid:
  84:main.c        **** 				if( password_verification(tempPassword_new) )
  85:main.c        **** 				{
  86:main.c        **** 					PORTD = 0b00000100;
  87:main.c        **** 					state = timeout;
  88:main.c        **** 				}
  89:main.c        **** 
  90:main.c        **** 			break;
  91:main.c        **** 
  92:main.c        **** 			case timeout:
  93:main.c        **** 
  94:main.c        **** 				time_diff =  time_curr - past_time;
  95:main.c        **** 				if( time_diff >= 2000 )
  96:main.c        **** 				{
  97:main.c        **** 					past_time = time_curr;
  98:main.c        **** 
  99:main.c        **** 					state = Working;
 100:main.c        **** 				}
 101:main.c        **** 
 102:main.c        **** 			break;
 103:main.c        **** 
 104:main.c        **** 
 105:main.c        **** 			case Working:
 106:main.c        **** 				PORTD = 0b00001000;
 107:main.c        **** 			break;
 108:main.c        **** 
 109:main.c        **** 
 110:main.c        **** 		}
 111:main.c        **** 
 112:main.c        **** 
 113:main.c        **** 	}
 114:main.c        **** 
 115:main.c        **** 	return 0;
 116:main.c        **** }
 117:main.c        **** 
 118:main.c        **** 
 119:main.c        **** void
 120:main.c        **** init_port ( void )
 121:main.c        **** {
  16               		.loc 1 121 1 view -0
  17               		.cfi_startproc
  18               	/* prologue: function */
  19               	/* frame size = 0 */
  20               	/* stack size = 0 */
  21               	.L__stack_usage = 0
 122:main.c        **** 	KEYBOARD_INIT |= (1 << PB3) | (1 << PB2) | (1 << PB1) | (1 << PB0); // Порт вывода
  22               		.loc 1 122 2 view .LVU1
  23               		.loc 1 122 16 is_stmt 0 view .LVU2
  24 0000 87B3      		in r24,0x17
  25 0002 8F60      		ori r24,lo8(15)
  26 0004 87BB      		out 0x17,r24
 123:main.c        **** 	KEYBOARD_INIT &= ~(1 << PB7) | (1 << PB6) | (1 << PB5) | (1 << PB4); // Порт ввода
  27               		.loc 1 123 2 is_stmt 1 view .LVU3
  28               		.loc 1 123 16 is_stmt 0 view .LVU4
  29 0006 BF98      		cbi 0x17,7
 124:main.c        **** 	KEYBOARD = 0xF0; // Устанавливаем лог. 1 в порт ввода
  30               		.loc 1 124 2 is_stmt 1 view .LVU5
  31               		.loc 1 124 11 is_stmt 0 view .LVU6
  32 0008 80EF      		ldi r24,lo8(-16)
  33 000a 88BB      		out 0x18,r24
 125:main.c        **** 	DDRC = 0xFF; // Выход на индикатор
  34               		.loc 1 125 2 is_stmt 1 view .LVU7
  35               		.loc 1 125 7 is_stmt 0 view .LVU8
  36 000c 8FEF      		ldi r24,lo8(-1)
  37 000e 84BB      		out 0x14,r24
 126:main.c        **** 	PORTC = 0x00;
  38               		.loc 1 126 2 is_stmt 1 view .LVU9
  39               		.loc 1 126 8 is_stmt 0 view .LVU10
  40 0010 15BA      		out 0x15,__zero_reg__
 127:main.c        **** 
 128:main.c        **** 	DDRD = 0xFF;
  41               		.loc 1 128 2 is_stmt 1 view .LVU11
  42               		.loc 1 128 7 is_stmt 0 view .LVU12
  43 0012 81BB      		out 0x11,r24
 129:main.c        **** 	PORTD = 0x00;
  44               		.loc 1 129 2 is_stmt 1 view .LVU13
  45               		.loc 1 129 8 is_stmt 0 view .LVU14
  46 0014 12BA      		out 0x12,__zero_reg__
  47               	/* epilogue start */
 130:main.c        **** }
  48               		.loc 1 130 1 view .LVU15
  49 0016 0895      		ret
  50               		.cfi_endproc
  51               	.LFE7:
  53               		.section	.text.startup.main,"ax",@progbits
  54               	.global	main
  56               	main:
  57               	.LFB6:
  46:main.c        **** 
  58               		.loc 1 46 1 is_stmt 1 view -0
  59               		.cfi_startproc
  60               	/* prologue: function */
  61               	/* frame size = 0 */
  62               	/* stack size = 0 */
  63               	.L__stack_usage = 0
  48:main.c        **** 	tim1_init();
  64               		.loc 1 48 2 view .LVU17
  65 0000 0E94 0000 		call init_port
  66               	.LVL0:
  49:main.c        **** 
  67               		.loc 1 49 2 view .LVU18
  68 0004 0E94 0000 		call tim1_init
  69               	.LVL1:
  51:main.c        **** 	{
  70               		.loc 1 51 2 view .LVU19
  71               	.LBB2:
  51:main.c        **** 	{
  72               		.loc 1 51 7 view .LVU20
  51:main.c        **** 	{
  73               		.loc 1 51 7 is_stmt 0 view .LVU21
  74               	.LBE2:
  49:main.c        **** 
  75               		.loc 1 49 2 view .LVU22
  76 0008 E0E0      		ldi r30,lo8(tempPassword_new)
  77 000a F0E0      		ldi r31,hi8(tempPassword_new)
  78               	.LVL2:
  79               	.L3:
  80               	.LBB3:
  53:main.c        **** 	}
  81               		.loc 1 53 3 is_stmt 1 discriminator 3 view .LVU23
  53:main.c        **** 	}
  82               		.loc 1 53 24 is_stmt 0 discriminator 3 view .LVU24
  83 000c 1192      		st Z+,__zero_reg__
  84               	.LVL3:
  51:main.c        **** 	{
  85               		.loc 1 51 2 discriminator 3 view .LVU25
  86 000e 40E0      		ldi r20,hi8(tempPassword_new+20)
  87 0010 E030      		cpi r30,lo8(tempPassword_new+20)
  88 0012 F407      		cpc r31,r20
  89 0014 01F4      		brne .L3
  90               	.LBE3:
  56:main.c        **** 
  91               		.loc 1 56 2 is_stmt 1 view .LVU26
  92               	/* #APP */
  93               	 ;  56 "main.c" 1
  94 0016 7894      		sei
  95               	 ;  0 "" 2
  99:main.c        **** 				}
  96               		.loc 1 99 12 is_stmt 0 view .LVU27
  97               	/* #NOAPP */
  98 0018 C4E0      		ldi r28,lo8(4)
 106:main.c        **** 			break;
  99               		.loc 1 106 11 view .LVU28
 100 001a 08E0      		ldi r16,lo8(8)
  70:main.c        **** 				state = Input_Acquired;
 101               		.loc 1 70 11 view .LVU29
 102 001c D1E0      		ldi r29,lo8(1)
  75:main.c        **** 				if( keyboard_input_get(tempPassword_new) )
 103               		.loc 1 75 11 view .LVU30
 104 001e 12E0      		ldi r17,lo8(2)
  87:main.c        **** 				}
 105               		.loc 1 87 12 view .LVU31
 106 0020 83E0      		ldi r24,lo8(3)
 107 0022 F82E      		mov r15,r24
 108               	.LVL4:
 109               	.L21:
  59:main.c        **** 	{
 110               		.loc 1 59 2 is_stmt 1 view .LVU32
  61:main.c        **** 
 111               		.loc 1 61 3 view .LVU33
  61:main.c        **** 
 112               		.loc 1 61 15 is_stmt 0 view .LVU34
 113 0024 0E94 0000 		call timer_time_get
 114               	.LVL5:
 115 0028 9C01      		movw r18,r24
  61:main.c        **** 
 116               		.loc 1 61 13 view .LVU35
 117 002a 9093 0000 		sts time_curr+1,r25
 118 002e 8093 0000 		sts time_curr,r24
  63:main.c        **** 		{
 119               		.loc 1 63 3 is_stmt 1 view .LVU36
 120 0032 9091 0000 		lds r25,state
 121 0036 9230      		cpi r25,lo8(2)
 122 0038 01F0      		breq .L5
 123 003a 00F4      		brsh .L6
 124 003c 9923      		tst r25
 125 003e 01F0      		breq .L14
 126 0040 9130      		cpi r25,lo8(1)
 127 0042 01F4      		brne .L21
  75:main.c        **** 				if( keyboard_input_get(tempPassword_new) )
 128               		.loc 1 75 5 view .LVU37
  75:main.c        **** 				if( keyboard_input_get(tempPassword_new) )
 129               		.loc 1 75 11 is_stmt 0 view .LVU38
 130 0044 12BB      		out 0x12,r17
  76:main.c        **** 				{
 131               		.loc 1 76 5 is_stmt 1 view .LVU39
  76:main.c        **** 				{
 132               		.loc 1 76 9 is_stmt 0 view .LVU40
 133 0046 80E0      		ldi r24,lo8(tempPassword_new)
 134 0048 90E0      		ldi r25,hi8(tempPassword_new)
 135 004a 0E94 0000 		call keyboard_input_get
 136               	.LVL6:
  76:main.c        **** 				{
 137               		.loc 1 76 7 view .LVU41
 138 004e 8823      		tst r24
 139 0050 01F0      		breq .L21
  78:main.c        **** 					past_time = time_curr;
 140               		.loc 1 78 6 is_stmt 1 view .LVU42
  78:main.c        **** 					past_time = time_curr;
 141               		.loc 1 78 12 is_stmt 0 view .LVU43
 142 0052 1093 0000 		sts state,r17
  79:main.c        **** 				}
 143               		.loc 1 79 6 is_stmt 1 view .LVU44
  79:main.c        **** 				}
 144               		.loc 1 79 16 is_stmt 0 view .LVU45
 145 0056 8091 0000 		lds r24,time_curr
 146 005a 9091 0000 		lds r25,time_curr+1
 147 005e 9093 0000 		sts past_time+1,r25
 148 0062 8093 0000 		sts past_time,r24
 149 0066 00C0      		rjmp .L21
 150               	.L6:
  63:main.c        **** 		{
 151               		.loc 1 63 3 view .LVU46
 152 0068 9330      		cpi r25,lo8(3)
 153 006a 01F0      		breq .L10
 154 006c 9430      		cpi r25,lo8(4)
 155 006e 01F4      		brne .L21
 106:main.c        **** 			break;
 156               		.loc 1 106 5 is_stmt 1 view .LVU47
 106:main.c        **** 			break;
 157               		.loc 1 106 11 is_stmt 0 view .LVU48
 158 0070 02BB      		out 0x12,r16
 107:main.c        **** 
 159               		.loc 1 107 4 is_stmt 1 view .LVU49
 160 0072 00C0      		rjmp .L21
 161               	.L14:
  63:main.c        **** 		{
 162               		.loc 1 63 3 is_stmt 0 view .LVU50
 163 0074 E0E0      		ldi r30,lo8(tempPassword_new)
 164 0076 F0E0      		ldi r31,hi8(tempPassword_new)
 165               	.L7:
 166               	.LVL7:
 167               	.LBB4:
  68:main.c        **** 				}
 168               		.loc 1 68 6 is_stmt 1 discriminator 3 view .LVU51
  68:main.c        **** 				}
 169               		.loc 1 68 27 is_stmt 0 discriminator 3 view .LVU52
 170 0078 1192      		st Z+,__zero_reg__
 171               	.LVL8:
  66:main.c        **** 				{
 172               		.loc 1 66 5 discriminator 3 view .LVU53
 173 007a 50E0      		ldi r21,hi8(tempPassword_new+20)
 174 007c E030      		cpi r30,lo8(tempPassword_new+20)
 175 007e F507      		cpc r31,r21
 176 0080 01F4      		brne .L7
 177               	.LBE4:
  70:main.c        **** 				state = Input_Acquired;
 178               		.loc 1 70 5 is_stmt 1 view .LVU54
  70:main.c        **** 				state = Input_Acquired;
 179               		.loc 1 70 11 is_stmt 0 view .LVU55
 180 0082 D2BB      		out 0x12,r29
  71:main.c        **** 			break;
 181               		.loc 1 71 5 is_stmt 1 view .LVU56
  71:main.c        **** 			break;
 182               		.loc 1 71 11 is_stmt 0 view .LVU57
 183 0084 D093 0000 		sts state,r29
  72:main.c        **** 
 184               		.loc 1 72 4 is_stmt 1 view .LVU58
 185 0088 00C0      		rjmp .L21
 186               	.LVL9:
 187               	.L5:
  84:main.c        **** 				{
 188               		.loc 1 84 5 view .LVU59
  84:main.c        **** 				{
 189               		.loc 1 84 9 is_stmt 0 view .LVU60
 190 008a 80E0      		ldi r24,lo8(tempPassword_new)
 191 008c 90E0      		ldi r25,hi8(tempPassword_new)
 192 008e 0E94 0000 		call password_verification
 193               	.LVL10:
  84:main.c        **** 				{
 194               		.loc 1 84 7 view .LVU61
 195 0092 8823      		tst r24
 196 0094 01F0      		breq .L21
  86:main.c        **** 					state = timeout;
 197               		.loc 1 86 6 is_stmt 1 view .LVU62
  86:main.c        **** 					state = timeout;
 198               		.loc 1 86 12 is_stmt 0 view .LVU63
 199 0096 C2BB      		out 0x12,r28
  87:main.c        **** 				}
 200               		.loc 1 87 6 is_stmt 1 view .LVU64
  87:main.c        **** 				}
 201               		.loc 1 87 12 is_stmt 0 view .LVU65
 202 0098 F092 0000 		sts state,r15
 203 009c 00C0      		rjmp .L21
 204               	.L10:
  94:main.c        **** 				if( time_diff >= 2000 )
 205               		.loc 1 94 5 is_stmt 1 view .LVU66
  94:main.c        **** 				if( time_diff >= 2000 )
 206               		.loc 1 94 28 is_stmt 0 view .LVU67
 207 009e 8091 0000 		lds r24,past_time
 208 00a2 9091 0000 		lds r25,past_time+1
 209 00a6 A901      		movw r20,r18
 210 00a8 481B      		sub r20,r24
 211 00aa 590B      		sbc r21,r25
  94:main.c        **** 				if( time_diff >= 2000 )
 212               		.loc 1 94 15 view .LVU68
 213 00ac 5093 0000 		sts time_diff+1,r21
 214 00b0 4093 0000 		sts time_diff,r20
  95:main.c        **** 				{
 215               		.loc 1 95 5 is_stmt 1 view .LVU69
  95:main.c        **** 				{
 216               		.loc 1 95 19 is_stmt 0 view .LVU70
 217 00b4 8091 0000 		lds r24,time_diff
 218 00b8 9091 0000 		lds r25,time_diff+1
  95:main.c        **** 				{
 219               		.loc 1 95 7 view .LVU71
 220 00bc 803D      		cpi r24,-48
 221 00be 9740      		sbci r25,7
 222 00c0 00F4      		brsh .+2
 223 00c2 00C0      		rjmp .L21
  97:main.c        **** 
 224               		.loc 1 97 6 is_stmt 1 view .LVU72
  97:main.c        **** 
 225               		.loc 1 97 16 is_stmt 0 view .LVU73
 226 00c4 3093 0000 		sts past_time+1,r19
 227 00c8 2093 0000 		sts past_time,r18
  99:main.c        **** 				}
 228               		.loc 1 99 6 is_stmt 1 view .LVU74
  99:main.c        **** 				}
 229               		.loc 1 99 12 is_stmt 0 view .LVU75
 230 00cc C093 0000 		sts state,r28
 231 00d0 00C0      		rjmp .L21
 232               		.cfi_endproc
 233               	.LFE6:
 235               		.section	.bss.time_diff,"aw",@nobits
 238               	time_diff:
 239 0000 0000      		.zero	2
 240               		.section	.bss.past_time,"aw",@nobits
 243               	past_time:
 244 0000 0000      		.zero	2
 245               		.section	.bss.time_curr,"aw",@nobits
 248               	time_curr:
 249 0000 0000      		.zero	2
 250               		.section	.bss.state,"aw",@nobits
 253               	state:
 254 0000 00        		.zero	1
 255               		.comm	tempPassword_new,20,1
 256               		.text
 257               	.Letext0:
 258               		.file 2 "c:\\bin\\avr-gcc-8.3.0-x64-mingw\\lib\\gcc\\avr\\8.3.0\\include\\stdint-gcc.h"
 259               		.file 3 "./drivers/timer.h"
 260               		.file 4 "./drivers/keyboard.h"
 261               		.file 5 "./drivers/password.h"
DEFINED SYMBOLS
                            *ABS*:0000000000000000 main.c
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccNWhVJQ.s:2      *ABS*:000000000000003e __SP_H__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccNWhVJQ.s:3      *ABS*:000000000000003d __SP_L__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccNWhVJQ.s:4      *ABS*:000000000000003f __SREG__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccNWhVJQ.s:5      *ABS*:0000000000000000 __tmp_reg__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccNWhVJQ.s:6      *ABS*:0000000000000001 __zero_reg__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccNWhVJQ.s:13     .text.init_port:0000000000000000 init_port
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccNWhVJQ.s:56     .text.startup.main:0000000000000000 main
                            *COM*:0000000000000014 tempPassword_new
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccNWhVJQ.s:248    .bss.time_curr:0000000000000000 time_curr
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccNWhVJQ.s:253    .bss.state:0000000000000000 state
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccNWhVJQ.s:243    .bss.past_time:0000000000000000 past_time
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccNWhVJQ.s:238    .bss.time_diff:0000000000000000 time_diff

UNDEFINED SYMBOLS
tim1_init
timer_time_get
keyboard_input_get
password_verification
__do_clear_bss
