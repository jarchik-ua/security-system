   1               		.file	"main.c"
   2               	__SP_H__ = 0x3e
   3               	__SP_L__ = 0x3d
   4               	__SREG__ = 0x3f
   5               	__tmp_reg__ = 0
   6               	__zero_reg__ = 1
   7               		.text
   8               	.Ltext0:
   9               		.cfi_sections	.debug_frame
  10               		.section	.text.password_check,"ax",@progbits
  11               	.global	password_check
  13               	password_check:
  14               	.LFB6:
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
  20:main.c        **** static  uint8_t time_curr;
  21:main.c        **** 
  22:main.c        **** 
  23:main.c        **** 
  24:main.c        **** /***
  25:main.c        ****  *  Password sequence
  26:main.c        ****  */
  27:main.c        **** typedef enum {
  28:main.c        **** 	Pass_Arr_Init,
  29:main.c        **** 	Pass_Enter,
  30:main.c        **** 	Pass_Validate,
  31:main.c        **** } pass_state_t;
  32:main.c        **** 
  33:main.c        **** static pass_state_t state_password = Pass_Arr_Init;
  34:main.c        **** /*-----------------------------------------------------------------*/
  35:main.c        **** 
  36:main.c        **** 
  37:main.c        **** /***
  38:main.c        ****  *  Disarmed sequence
  39:main.c        ****  */
  40:main.c        **** typedef enum {
  41:main.c        **** 	Disarmed_Sequence_Init,			// turn off every led
  42:main.c        **** 	Disarmed_Password_Check,
  43:main.c        **** 	Disarmed_Timeout_Until_Enable,
  44:main.c        **** 	Disarmed_Timeout_Until_Disable,
  45:main.c        **** } disarmed_t;
  46:main.c        **** 
  47:main.c        **** static volatile disarmed_t	disarmed_state = Disarmed_Sequence_Init;
  48:main.c        **** /*-----------------------------------------------------------------*/
  49:main.c        **** 
  50:main.c        **** enum {
  51:main.c        **** 	Password_Check_In_Process,
  52:main.c        **** 	Password_Correct,
  53:main.c        **** 	Password_Incorrect,
  54:main.c        **** };
  55:main.c        **** 
  56:main.c        **** enum {
  57:main.c        **** 	Idle,
  58:main.c        **** 	Alarm_Request,
  59:main.c        **** 	Disarm_Request,
  60:main.c        **** };
  61:main.c        **** 
  62:main.c        **** /*-----------------------------------------------------------------*/
  63:main.c        **** 
  64:main.c        **** 
  65:main.c        **** typedef enum {
  66:main.c        **** 	Disarmed,
  67:main.c        **** 	Armed,
  68:main.c        **** 	Alarm
  69:main.c        **** } states_work;
  70:main.c        **** 
  71:main.c        **** static volatile states_work 	stage = Disarmed;
  72:main.c        **** static volatile states_work		stage_prev = Disarmed;
  73:main.c        **** 
  74:main.c        **** 
  75:main.c        **** int8_t
  76:main.c        **** password_check( void )
  77:main.c        **** {
  16               		.loc 1 77 1 view -0
  17               		.cfi_startproc
  18               	/* prologue: function */
  19               	/* frame size = 0 */
  20               	/* stack size = 0 */
  21               	.L__stack_usage = 0
  78:main.c        **** 	int8_t		ret = Password_Check_In_Process;
  22               		.loc 1 78 2 view .LVU1
  23               	.LVL0:
  79:main.c        **** 	static uint8_t tempPassword_new[PASSWORD_MAX_SIZE];
  24               		.loc 1 79 2 view .LVU2
  80:main.c        **** 
  81:main.c        **** 
  82:main.c        **** 	switch ( state_password )
  25               		.loc 1 82 2 view .LVU3
  26 0000 8091 0000 		lds r24,state_password
  27 0004 8130      		cpi r24,lo8(1)
  28 0006 01F0      		breq .L2
  29 0008 8823      		tst r24
  30 000a 01F0      		breq .L3
  31 000c 8230      		cpi r24,lo8(2)
  32 000e 01F0      		breq .L4
  33               	.L13:
  83:main.c        **** 	{
  84:main.c        **** 	case Pass_Arr_Init:
  85:main.c        **** 		for( int8_t i = 0; i < PASSWORD_MAX_SIZE; i++ )
  86:main.c        **** 		{
  87:main.c        **** 			tempPassword_new [i] = 0;
  88:main.c        **** 		}
  89:main.c        **** 
  90:main.c        **** 		state_password = Pass_Enter;
  91:main.c        **** 		break;
  34               		.loc 1 91 3 view .LVU4
  78:main.c        **** 	static uint8_t tempPassword_new[PASSWORD_MAX_SIZE];
  35               		.loc 1 78 10 is_stmt 0 view .LVU5
  36 0010 80E0      		ldi r24,0
  37               		.loc 1 91 3 view .LVU6
  38 0012 0895      		ret
  39               	.L3:
  40 0014 E0E0      		ldi r30,lo8(tempPassword_new.1207)
  41 0016 F0E0      		ldi r31,hi8(tempPassword_new.1207)
  42               	.L6:
  43               	.LVL1:
  44               	.LBB7:
  87:main.c        **** 		}
  45               		.loc 1 87 4 is_stmt 1 discriminator 3 view .LVU7
  87:main.c        **** 		}
  46               		.loc 1 87 25 is_stmt 0 discriminator 3 view .LVU8
  47 0018 1192      		st Z+,__zero_reg__
  48               	.LVL2:
  85:main.c        **** 		{
  49               		.loc 1 85 3 discriminator 3 view .LVU9
  50 001a 80E0      		ldi r24,hi8(tempPassword_new.1207+20)
  51 001c E030      		cpi r30,lo8(tempPassword_new.1207+20)
  52 001e F807      		cpc r31,r24
  53 0020 01F4      		brne .L6
  54               	.LBE7:
  90:main.c        **** 		break;
  55               		.loc 1 90 3 is_stmt 1 view .LVU10
  90:main.c        **** 		break;
  56               		.loc 1 90 18 is_stmt 0 view .LVU11
  57 0022 81E0      		ldi r24,lo8(1)
  58               	.LVL3:
  59               	.L14:
  90:main.c        **** 		break;
  60               		.loc 1 90 18 view .LVU12
  61 0024 8093 0000 		sts state_password,r24
  62 0028 00C0      		rjmp .L13
  63               	.L2:
  64               	.LBB8:
  65               	.LBI8:
  76:main.c        **** {
  66               		.loc 1 76 1 is_stmt 1 view .LVU13
  67               	.LBB9:
  92:main.c        **** 
  93:main.c        **** 	case Pass_Enter:
  94:main.c        **** 		if( keyboard_input_get(tempPassword_new) )
  68               		.loc 1 94 3 view .LVU14
  69               		.loc 1 94 7 is_stmt 0 view .LVU15
  70 002a 80E0      		ldi r24,lo8(tempPassword_new.1207)
  71 002c 90E0      		ldi r25,hi8(tempPassword_new.1207)
  72 002e 0E94 0000 		call keyboard_input_get
  73               	.LVL4:
  74               		.loc 1 94 5 view .LVU16
  75 0032 8823      		tst r24
  76 0034 01F0      		breq .L1
  95:main.c        **** 		{
  96:main.c        **** 			state_password = Pass_Validate;
  77               		.loc 1 96 4 is_stmt 1 view .LVU17
  78               		.loc 1 96 19 is_stmt 0 view .LVU18
  79 0036 82E0      		ldi r24,lo8(2)
  80 0038 00C0      		rjmp .L14
  81               	.L4:
  82               	.LBE9:
  83               	.LBE8:
  97:main.c        **** 		}
  98:main.c        **** 		break;
  99:main.c        **** 
 100:main.c        **** 	case Pass_Validate:
 101:main.c        **** 		if( password_verification(tempPassword_new) )
  84               		.loc 1 101 3 is_stmt 1 view .LVU19
  85               		.loc 1 101 7 is_stmt 0 view .LVU20
  86 003a 80E0      		ldi r24,lo8(tempPassword_new.1207)
  87 003c 90E0      		ldi r25,hi8(tempPassword_new.1207)
  88 003e 0E94 0000 		call password_verification
  89               	.LVL5:
  90               		.loc 1 101 5 view .LVU21
  91 0042 8111      		cpse r24,__zero_reg__
  92 0044 00C0      		rjmp .L8
 102:main.c        **** 		{
 103:main.c        **** 			ret = Password_Correct;
 104:main.c        **** 		}
 105:main.c        **** 		else
 106:main.c        **** 		{
 107:main.c        **** 			ret = Password_Incorrect;
  93               		.loc 1 107 8 view .LVU22
  94 0046 82E0      		ldi r24,lo8(2)
  95               	.L7:
  96               	.LVL6:
 108:main.c        **** 		}
 109:main.c        **** 
 110:main.c        **** 		state_password = Pass_Arr_Init;
  97               		.loc 1 110 3 is_stmt 1 view .LVU23
  98               		.loc 1 110 18 is_stmt 0 view .LVU24
  99 0048 1092 0000 		sts state_password,__zero_reg__
 111:main.c        **** 		break;
 100               		.loc 1 111 3 is_stmt 1 view .LVU25
 112:main.c        **** 	}
 113:main.c        **** 
 114:main.c        **** 	return ret;
 101               		.loc 1 114 2 view .LVU26
 102               	.LVL7:
 103               	.L1:
 104               	/* epilogue start */
 115:main.c        **** }
 105               		.loc 1 115 1 is_stmt 0 view .LVU27
 106 004c 0895      		ret
 107               	.LVL8:
 108               	.L8:
 103:main.c        **** 		}
 109               		.loc 1 103 8 view .LVU28
 110 004e 81E0      		ldi r24,lo8(1)
 111 0050 00C0      		rjmp .L7
 112               		.cfi_endproc
 113               	.LFE6:
 115               		.section	.text.disarmed_state_handle,"ax",@progbits
 116               	.global	disarmed_state_handle
 118               	disarmed_state_handle:
 119               	.LFB7:
 116:main.c        **** 
 117:main.c        **** 
 118:main.c        **** 
 119:main.c        **** int8_t
 120:main.c        **** disarmed_state_handle( void )
 121:main.c        **** {
 120               		.loc 1 121 1 is_stmt 1 view -0
 121               		.cfi_startproc
 122 0000 CF93      		push r28
 123               	.LCFI0:
 124               		.cfi_def_cfa_offset 3
 125               		.cfi_offset 28, -2
 126 0002 DF93      		push r29
 127               	.LCFI1:
 128               		.cfi_def_cfa_offset 4
 129               		.cfi_offset 29, -3
 130               	/* prologue: function */
 131               	/* frame size = 0 */
 132               	/* stack size = 2 */
 133               	.L__stack_usage = 2
 122:main.c        **** 	uint16_t	time_curr = timer_time_get();
 134               		.loc 1 122 2 view .LVU30
 135               		.loc 1 122 23 is_stmt 0 view .LVU31
 136 0004 0E94 0000 		call timer_time_get
 137               	.LVL9:
 138 0008 EC01      		movw r28,r24
 139               	.LVL10:
 123:main.c        **** 	static uint16_t	timeout;
 140               		.loc 1 123 2 is_stmt 1 view .LVU32
 124:main.c        **** 
 125:main.c        **** 	int8_t		pass_state = Password_Check_In_Process;
 141               		.loc 1 125 2 view .LVU33
 126:main.c        **** 	int8_t		ret = 0;
 142               		.loc 1 126 2 view .LVU34
 127:main.c        **** 
 128:main.c        **** 	switch ( disarmed_state )
 143               		.loc 1 128 2 view .LVU35
 144 000a 8091 0000 		lds r24,disarmed_state
 145               	.LVL11:
 146               		.loc 1 128 2 is_stmt 0 view .LVU36
 147 000e 8130      		cpi r24,lo8(1)
 148 0010 01F0      		breq .L16
 149 0012 8823      		tst r24
 150 0014 01F0      		breq .L17
 151 0016 8230      		cpi r24,lo8(2)
 152 0018 01F0      		breq .L18
 153 001a 8330      		cpi r24,lo8(3)
 154 001c 01F0      		breq .L19
 155               	.LVL12:
 156               	.L24:
 126:main.c        **** 	int8_t		ret = 0;
 157               		.loc 1 126 10 view .LVU37
 158 001e 80E0      		ldi r24,0
 129:main.c        **** 	{
 130:main.c        **** 	case Disarmed_Sequence_Init:
 131:main.c        **** 		PORTD &= ~( (1 << 3) | (1 << 2) | (1 << 1) | (1 << 0) );
 132:main.c        **** 		disarmed_state = Disarmed_Password_Check;
 133:main.c        **** 		break;
 134:main.c        **** 
 135:main.c        **** 	case Disarmed_Password_Check:
 136:main.c        **** 		pass_state = password_check();
 137:main.c        **** 
 138:main.c        **** 		if( pass_state != Password_Check_In_Process )
 139:main.c        **** 		{
 140:main.c        **** 			timeout = time_curr;
 141:main.c        **** 
 142:main.c        **** 			if( pass_state == Password_Correct )
 143:main.c        **** 			{
 144:main.c        **** 				disarmed_state = Disarmed_Timeout_Until_Enable;
 145:main.c        **** 			}
 146:main.c        **** 			else
 147:main.c        **** 			if( pass_state == Password_Incorrect )
 148:main.c        **** 			{
 149:main.c        **** 				disarmed_state = Disarmed_Timeout_Until_Disable;
 150:main.c        **** 			}
 151:main.c        **** 			else
 152:main.c        **** 			{
 153:main.c        **** 				/*    */
 154:main.c        **** 			}
 155:main.c        **** 		}
 156:main.c        **** 		break;
 157:main.c        **** 
 158:main.c        **** 	case Disarmed_Timeout_Until_Enable:
 159:main.c        **** 		if( time_curr - timeout >= 2000 )
 160:main.c        **** 		{
 161:main.c        **** 			timeout = time_curr;
 162:main.c        **** 
 163:main.c        **** 			disarmed_state = Disarmed_Sequence_Init;
 164:main.c        **** 			ret = 1;
 165:main.c        **** 		}
 166:main.c        **** 		break;
 167:main.c        **** 
 168:main.c        **** 	case Disarmed_Timeout_Until_Disable:
 169:main.c        **** 		PORTD |= (1 << 2);
 170:main.c        **** 		if( time_curr - timeout >= 2000 )
 171:main.c        **** 		{
 172:main.c        **** 			timeout = time_curr;
 173:main.c        **** 			disarmed_state = Disarmed_Sequence_Init;
 174:main.c        **** 		}
 175:main.c        **** 		break;
 176:main.c        **** 	}
 177:main.c        **** 
 178:main.c        **** 	return ret;
 159               		.loc 1 178 2 is_stmt 1 view .LVU38
 160               		.loc 1 178 9 is_stmt 0 view .LVU39
 161 0020 00C0      		rjmp .L15
 162               	.LVL13:
 163               	.L17:
 131:main.c        **** 		disarmed_state = Disarmed_Password_Check;
 164               		.loc 1 131 3 is_stmt 1 view .LVU40
 131:main.c        **** 		disarmed_state = Disarmed_Password_Check;
 165               		.loc 1 131 9 is_stmt 0 view .LVU41
 166 0022 82B3      		in r24,0x12
 167 0024 807F      		andi r24,lo8(-16)
 168 0026 82BB      		out 0x12,r24
 132:main.c        **** 		break;
 169               		.loc 1 132 3 is_stmt 1 view .LVU42
 132:main.c        **** 		break;
 170               		.loc 1 132 18 is_stmt 0 view .LVU43
 171 0028 81E0      		ldi r24,lo8(1)
 172               	.LVL14:
 173               	.L25:
 149:main.c        **** 			}
 174               		.loc 1 149 20 view .LVU44
 175 002a 8093 0000 		sts disarmed_state,r24
 176 002e 00C0      		rjmp .L24
 177               	.LVL15:
 178               	.L16:
 136:main.c        **** 
 179               		.loc 1 136 3 is_stmt 1 view .LVU45
 136:main.c        **** 
 180               		.loc 1 136 16 is_stmt 0 view .LVU46
 181 0030 0E94 0000 		call password_check
 182               	.LVL16:
 138:main.c        **** 		{
 183               		.loc 1 138 3 is_stmt 1 view .LVU47
 138:main.c        **** 		{
 184               		.loc 1 138 5 is_stmt 0 view .LVU48
 185 0034 8823      		tst r24
 186 0036 01F0      		breq .L24
 140:main.c        **** 
 187               		.loc 1 140 4 is_stmt 1 view .LVU49
 140:main.c        **** 
 188               		.loc 1 140 12 is_stmt 0 view .LVU50
 189 0038 D093 0000 		sts timeout.1220+1,r29
 190 003c C093 0000 		sts timeout.1220,r28
 142:main.c        **** 			{
 191               		.loc 1 142 4 is_stmt 1 view .LVU51
 142:main.c        **** 			{
 192               		.loc 1 142 6 is_stmt 0 view .LVU52
 193 0040 8130      		cpi r24,lo8(1)
 194 0042 01F4      		brne .L22
 144:main.c        **** 			}
 195               		.loc 1 144 5 is_stmt 1 view .LVU53
 144:main.c        **** 			}
 196               		.loc 1 144 20 is_stmt 0 view .LVU54
 197 0044 82E0      		ldi r24,lo8(2)
 198               	.LVL17:
 144:main.c        **** 			}
 199               		.loc 1 144 20 view .LVU55
 200 0046 00C0      		rjmp .L25
 201               	.LVL18:
 202               	.L22:
 147:main.c        **** 			{
 203               		.loc 1 147 4 is_stmt 1 view .LVU56
 147:main.c        **** 			{
 204               		.loc 1 147 6 is_stmt 0 view .LVU57
 205 0048 8230      		cpi r24,lo8(2)
 206 004a 01F4      		brne .L24
 149:main.c        **** 			}
 207               		.loc 1 149 5 is_stmt 1 view .LVU58
 149:main.c        **** 			}
 208               		.loc 1 149 20 is_stmt 0 view .LVU59
 209 004c 83E0      		ldi r24,lo8(3)
 210               	.LVL19:
 149:main.c        **** 			}
 211               		.loc 1 149 20 view .LVU60
 212 004e 00C0      		rjmp .L25
 213               	.LVL20:
 214               	.L18:
 159:main.c        **** 		{
 215               		.loc 1 159 3 is_stmt 1 view .LVU61
 159:main.c        **** 		{
 216               		.loc 1 159 17 is_stmt 0 view .LVU62
 217 0050 8091 0000 		lds r24,timeout.1220
 218 0054 9091 0000 		lds r25,timeout.1220+1
 219 0058 9E01      		movw r18,r28
 220 005a 281B      		sub r18,r24
 221 005c 390B      		sbc r19,r25
 222 005e C901      		movw r24,r18
 159:main.c        **** 		{
 223               		.loc 1 159 5 view .LVU63
 224 0060 803D      		cpi r24,-48
 225 0062 9740      		sbci r25,7
 226 0064 00F0      		brlo .L24
 161:main.c        **** 
 227               		.loc 1 161 4 is_stmt 1 view .LVU64
 161:main.c        **** 
 228               		.loc 1 161 12 is_stmt 0 view .LVU65
 229 0066 D093 0000 		sts timeout.1220+1,r29
 230 006a C093 0000 		sts timeout.1220,r28
 163:main.c        **** 			ret = 1;
 231               		.loc 1 163 4 is_stmt 1 view .LVU66
 163:main.c        **** 			ret = 1;
 232               		.loc 1 163 19 is_stmt 0 view .LVU67
 233 006e 1092 0000 		sts disarmed_state,__zero_reg__
 164:main.c        **** 		}
 234               		.loc 1 164 4 is_stmt 1 view .LVU68
 235               	.LVL21:
 164:main.c        **** 		}
 236               		.loc 1 164 8 is_stmt 0 view .LVU69
 237 0072 81E0      		ldi r24,lo8(1)
 238               	.LVL22:
 239               	.L15:
 240               	/* epilogue start */
 179:main.c        **** }
 241               		.loc 1 179 1 view .LVU70
 242 0074 DF91      		pop r29
 243 0076 CF91      		pop r28
 244               	.LVL23:
 245               		.loc 1 179 1 view .LVU71
 246 0078 0895      		ret
 247               	.LVL24:
 248               	.L19:
 169:main.c        **** 		if( time_curr - timeout >= 2000 )
 249               		.loc 1 169 3 is_stmt 1 view .LVU72
 169:main.c        **** 		if( time_curr - timeout >= 2000 )
 250               		.loc 1 169 9 is_stmt 0 view .LVU73
 251 007a 929A      		sbi 0x12,2
 170:main.c        **** 		{
 252               		.loc 1 170 3 is_stmt 1 view .LVU74
 170:main.c        **** 		{
 253               		.loc 1 170 17 is_stmt 0 view .LVU75
 254 007c 8091 0000 		lds r24,timeout.1220
 255 0080 9091 0000 		lds r25,timeout.1220+1
 256 0084 9E01      		movw r18,r28
 257 0086 281B      		sub r18,r24
 258 0088 390B      		sbc r19,r25
 259 008a C901      		movw r24,r18
 170:main.c        **** 		{
 260               		.loc 1 170 5 view .LVU76
 261 008c 803D      		cpi r24,-48
 262 008e 9740      		sbci r25,7
 263 0090 00F0      		brlo .L24
 172:main.c        **** 			disarmed_state = Disarmed_Sequence_Init;
 264               		.loc 1 172 4 is_stmt 1 view .LVU77
 172:main.c        **** 			disarmed_state = Disarmed_Sequence_Init;
 265               		.loc 1 172 12 is_stmt 0 view .LVU78
 266 0092 D093 0000 		sts timeout.1220+1,r29
 267 0096 C093 0000 		sts timeout.1220,r28
 173:main.c        **** 		}
 268               		.loc 1 173 4 is_stmt 1 view .LVU79
 173:main.c        **** 		}
 269               		.loc 1 173 19 is_stmt 0 view .LVU80
 270 009a 1092 0000 		sts disarmed_state,__zero_reg__
 271 009e 00C0      		rjmp .L24
 272               		.cfi_endproc
 273               	.LFE7:
 275               		.section	.text.alarm_system_proc,"ax",@progbits
 276               	.global	alarm_system_proc
 278               	alarm_system_proc:
 279               	.LFB8:
 180:main.c        **** 
 181:main.c        **** 
 182:main.c        **** void
 183:main.c        **** alarm_system_proc( void )
 184:main.c        **** {
 280               		.loc 1 184 1 is_stmt 1 view -0
 281               		.cfi_startproc
 282               	/* prologue: function */
 283               	/* frame size = 0 */
 284               	/* stack size = 0 */
 285               	.L__stack_usage = 0
 185:main.c        **** 	int8_t		pass_state = Password_Check_In_Process;
 286               		.loc 1 185 2 view .LVU82
 287               	.LVL25:
 186:main.c        **** 	uint8_t		motion_sens_alarm = 0;		// 1 alarm
 288               		.loc 1 186 2 view .LVU83
 187:main.c        **** 	uint8_t		gerkon_alarm = 0;			// 1 alarm
 289               		.loc 1 187 2 view .LVU84
 188:main.c        **** 
 189:main.c        **** 
 190:main.c        **** 	time_curr = timer_time_get();
 290               		.loc 1 190 2 view .LVU85
 291               		.loc 1 190 14 is_stmt 0 view .LVU86
 292 0000 0E94 0000 		call timer_time_get
 293               	.LVL26:
 191:main.c        **** 
 192:main.c        **** 	switch( stage )
 294               		.loc 1 192 2 is_stmt 1 view .LVU87
 295 0004 8091 0000 		lds r24,stage
 296 0008 8130      		cpi r24,lo8(1)
 297 000a 01F0      		breq .L27
 298 000c 8823      		tst r24
 299 000e 01F0      		breq .L28
 300 0010 8230      		cpi r24,lo8(2)
 301 0012 01F0      		breq .L29
 302               	.LVL27:
 303               	.L30:
 193:main.c        **** 	{
 194:main.c        **** 	case Disarmed:
 195:main.c        **** 		if( disarmed_state_handle() == 1 )
 196:main.c        **** 		{
 197:main.c        **** 			stage = Armed;
 198:main.c        **** 		}
 199:main.c        **** 		break;
 200:main.c        **** 
 201:main.c        **** 	case Armed:
 202:main.c        **** 		PORTD |= (1 << 3) ;
 203:main.c        **** 		pass_state = password_check();
 204:main.c        **** 		motion_sens_alarm = !(PINA & (1 << 1)) ? 1 : 0;
 205:main.c        **** 		gerkon_alarm = (PINA & (1 << 3)) ? 1 : 0;
 206:main.c        **** 
 207:main.c        **** 		/** Check sensor */
 208:main.c        **** 		if( motion_sens_alarm == 1 || \
 209:main.c        **** 		    gerkon_alarm == 1	   || \
 210:main.c        **** 			pass_state == Password_Incorrect )
 211:main.c        **** 		{
 212:main.c        **** 			stage = Alarm;
 213:main.c        **** 		}
 214:main.c        **** 		else
 215:main.c        **** 		if( pass_state == Password_Correct )
 216:main.c        **** 		{
 217:main.c        **** 			stage = Disarmed;
 218:main.c        **** 		}
 219:main.c        **** 		break;
 220:main.c        **** 
 221:main.c        **** 	case Alarm:
 222:main.c        **** 		PORTD |= (1 << 1) | (1 << 0) ;
 223:main.c        **** 
 224:main.c        **** 		pass_state = password_check();
 225:main.c        **** 
 226:main.c        **** 		if( pass_state == Password_Correct )
 227:main.c        **** 		{
 228:main.c        **** 			stage = Disarmed;
 229:main.c        **** 		}
 230:main.c        **** 		break;
 231:main.c        **** 	}
 232:main.c        **** 
 233:main.c        **** 	if( stage_prev != stage )
 304               		.loc 1 233 2 view .LVU88
 305               		.loc 1 233 17 is_stmt 0 view .LVU89
 306 0014 9091 0000 		lds r25,stage_prev
 307 0018 8091 0000 		lds r24,stage
 308               		.loc 1 233 4 view .LVU90
 309 001c 9817      		cp r25,r24
 310 001e 01F0      		breq .L26
 234:main.c        **** 	{
 235:main.c        **** 		stage_prev = stage;
 311               		.loc 1 235 3 is_stmt 1 view .LVU91
 312               		.loc 1 235 14 is_stmt 0 view .LVU92
 313 0020 8091 0000 		lds r24,stage
 314 0024 8093 0000 		sts stage_prev,r24
 236:main.c        **** 		state_password = Pass_Arr_Init;
 315               		.loc 1 236 3 is_stmt 1 view .LVU93
 316               		.loc 1 236 18 is_stmt 0 view .LVU94
 317 0028 1092 0000 		sts state_password,__zero_reg__
 318               	.L26:
 319               	/* epilogue start */
 237:main.c        **** 	}
 238:main.c        **** }
 320               		.loc 1 238 1 view .LVU95
 321 002c 0895      		ret
 322               	.LVL28:
 323               	.L28:
 195:main.c        **** 		{
 324               		.loc 1 195 3 is_stmt 1 view .LVU96
 195:main.c        **** 		{
 325               		.loc 1 195 7 is_stmt 0 view .LVU97
 326 002e 0E94 0000 		call disarmed_state_handle
 327               	.LVL29:
 195:main.c        **** 		{
 328               		.loc 1 195 5 view .LVU98
 329 0032 8130      		cpi r24,lo8(1)
 330 0034 01F4      		brne .L30
 331               	.LVL30:
 332               	.L39:
 212:main.c        **** 		}
 333               		.loc 1 212 10 view .LVU99
 334 0036 8093 0000 		sts stage,r24
 335 003a 00C0      		rjmp .L30
 336               	.LVL31:
 337               	.L27:
 202:main.c        **** 		pass_state = password_check();
 338               		.loc 1 202 3 is_stmt 1 view .LVU100
 202:main.c        **** 		pass_state = password_check();
 339               		.loc 1 202 9 is_stmt 0 view .LVU101
 340 003c 939A      		sbi 0x12,3
 203:main.c        **** 		motion_sens_alarm = !(PINA & (1 << 1)) ? 1 : 0;
 341               		.loc 1 203 3 is_stmt 1 view .LVU102
 203:main.c        **** 		motion_sens_alarm = !(PINA & (1 << 1)) ? 1 : 0;
 342               		.loc 1 203 16 is_stmt 0 view .LVU103
 343 003e 0E94 0000 		call password_check
 344               	.LVL32:
 204:main.c        **** 		gerkon_alarm = (PINA & (1 << 3)) ? 1 : 0;
 345               		.loc 1 204 3 is_stmt 1 view .LVU104
 204:main.c        **** 		gerkon_alarm = (PINA & (1 << 3)) ? 1 : 0;
 346               		.loc 1 204 25 is_stmt 0 view .LVU105
 347 0042 29B3      		in r18,0x19
 348               	.LVL33:
 205:main.c        **** 
 349               		.loc 1 205 3 is_stmt 1 view .LVU106
 205:main.c        **** 
 350               		.loc 1 205 19 is_stmt 0 view .LVU107
 351 0044 99B3      		in r25,0x19
 352               	.LVL34:
 208:main.c        **** 		    gerkon_alarm == 1	   || \
 353               		.loc 1 208 3 is_stmt 1 view .LVU108
 208:main.c        **** 		    gerkon_alarm == 1	   || \
 354               		.loc 1 208 5 is_stmt 0 view .LVU109
 355 0046 21FF      		sbrs r18,1
 356 0048 00C0      		rjmp .L32
 208:main.c        **** 		    gerkon_alarm == 1	   || \
 357               		.loc 1 208 30 discriminator 1 view .LVU110
 358 004a 93FD      		sbrc r25,3
 359 004c 00C0      		rjmp .L32
 209:main.c        **** 			pass_state == Password_Incorrect )
 360               		.loc 1 209 28 view .LVU111
 361 004e 8230      		cpi r24,lo8(2)
 362 0050 01F4      		brne .L42
 363               	.L32:
 212:main.c        **** 		}
 364               		.loc 1 212 4 is_stmt 1 view .LVU112
 212:main.c        **** 		}
 365               		.loc 1 212 10 is_stmt 0 view .LVU113
 366 0052 82E0      		ldi r24,lo8(2)
 367               	.LVL35:
 212:main.c        **** 		}
 368               		.loc 1 212 10 view .LVU114
 369 0054 00C0      		rjmp .L39
 370               	.LVL36:
 371               	.L29:
 222:main.c        **** 
 372               		.loc 1 222 3 is_stmt 1 view .LVU115
 222:main.c        **** 
 373               		.loc 1 222 9 is_stmt 0 view .LVU116
 374 0056 82B3      		in r24,0x12
 375 0058 8360      		ori r24,lo8(3)
 376 005a 82BB      		out 0x12,r24
 224:main.c        **** 
 377               		.loc 1 224 3 is_stmt 1 view .LVU117
 224:main.c        **** 
 378               		.loc 1 224 16 is_stmt 0 view .LVU118
 379 005c 0E94 0000 		call password_check
 380               	.LVL37:
 381               	.L42:
 226:main.c        **** 		{
 382               		.loc 1 226 3 is_stmt 1 view .LVU119
 226:main.c        **** 		{
 383               		.loc 1 226 5 is_stmt 0 view .LVU120
 384 0060 8130      		cpi r24,lo8(1)
 385 0062 01F4      		brne .L30
 228:main.c        **** 		}
 386               		.loc 1 228 4 is_stmt 1 view .LVU121
 228:main.c        **** 		}
 387               		.loc 1 228 10 is_stmt 0 view .LVU122
 388 0064 1092 0000 		sts stage,__zero_reg__
 389 0068 00C0      		rjmp .L30
 390               		.cfi_endproc
 391               	.LFE8:
 393               		.section	.text.init_port,"ax",@progbits
 394               	.global	init_port
 396               	init_port:
 397               	.LFB9:
 239:main.c        **** 
 240:main.c        **** 
 241:main.c        **** void
 242:main.c        **** init_port ( void )
 243:main.c        **** {
 398               		.loc 1 243 1 is_stmt 1 view -0
 399               		.cfi_startproc
 400               	/* prologue: function */
 401               	/* frame size = 0 */
 402               	/* stack size = 0 */
 403               	.L__stack_usage = 0
 244:main.c        **** 	KEYBOARD_INIT |= (1 << PB3) | (1 << PB2) | (1 << PB1) | (1 << PB0); // Порт вывода
 404               		.loc 1 244 2 view .LVU124
 405               		.loc 1 244 16 is_stmt 0 view .LVU125
 406 0000 87B3      		in r24,0x17
 407 0002 8F60      		ori r24,lo8(15)
 408 0004 87BB      		out 0x17,r24
 245:main.c        **** 	KEYBOARD_INIT &= ~(1 << PB7) | (1 << PB6) | (1 << PB5) | (1 << PB4); // Порт ввода
 409               		.loc 1 245 2 is_stmt 1 view .LVU126
 410               		.loc 1 245 16 is_stmt 0 view .LVU127
 411 0006 BF98      		cbi 0x17,7
 246:main.c        **** 	KEYBOARD = 0xF0; // Устанавливаем лог. 1 в порт ввода
 412               		.loc 1 246 2 is_stmt 1 view .LVU128
 413               		.loc 1 246 11 is_stmt 0 view .LVU129
 414 0008 80EF      		ldi r24,lo8(-16)
 415 000a 88BB      		out 0x18,r24
 247:main.c        **** 	DDRC = 0xFF; // Выход на индикатор
 416               		.loc 1 247 2 is_stmt 1 view .LVU130
 417               		.loc 1 247 7 is_stmt 0 view .LVU131
 418 000c 8FEF      		ldi r24,lo8(-1)
 419 000e 84BB      		out 0x14,r24
 248:main.c        **** 	PORTC = 0x00;
 420               		.loc 1 248 2 is_stmt 1 view .LVU132
 421               		.loc 1 248 8 is_stmt 0 view .LVU133
 422 0010 15BA      		out 0x15,__zero_reg__
 249:main.c        **** 
 250:main.c        **** 	DDRD = 0xFF;
 423               		.loc 1 250 2 is_stmt 1 view .LVU134
 424               		.loc 1 250 7 is_stmt 0 view .LVU135
 425 0012 81BB      		out 0x11,r24
 251:main.c        **** 	PORTD = 0x00;
 426               		.loc 1 251 2 is_stmt 1 view .LVU136
 427               		.loc 1 251 8 is_stmt 0 view .LVU137
 428 0014 12BA      		out 0x12,__zero_reg__
 252:main.c        **** 
 253:main.c        **** 	DDRA = 0x00;
 429               		.loc 1 253 2 is_stmt 1 view .LVU138
 430               		.loc 1 253 7 is_stmt 0 view .LVU139
 431 0016 1ABA      		out 0x1a,__zero_reg__
 254:main.c        **** 	PORTA |= (1 << 3) | (1 << 1);
 432               		.loc 1 254 2 is_stmt 1 view .LVU140
 433               		.loc 1 254 8 is_stmt 0 view .LVU141
 434 0018 8BB3      		in r24,0x1b
 435 001a 8A60      		ori r24,lo8(10)
 436 001c 8BBB      		out 0x1b,r24
 437               	/* epilogue start */
 255:main.c        **** }
 438               		.loc 1 255 1 view .LVU142
 439 001e 0895      		ret
 440               		.cfi_endproc
 441               	.LFE9:
 443               		.section	.text.startup.main,"ax",@progbits
 444               	.global	main
 446               	main:
 447               	.LFB10:
 256:main.c        **** 
 257:main.c        **** 
 258:main.c        **** int main( void )
 259:main.c        **** {
 448               		.loc 1 259 1 is_stmt 1 view -0
 449               		.cfi_startproc
 450               	/* prologue: function */
 451               	/* frame size = 0 */
 452               	/* stack size = 0 */
 453               	.L__stack_usage = 0
 260:main.c        **** 	sei();
 454               		.loc 1 260 2 view .LVU144
 455               	/* #APP */
 456               	 ;  260 "main.c" 1
 457 0000 7894      		sei
 458               	 ;  0 "" 2
 261:main.c        **** 
 262:main.c        **** 	init_port();
 459               		.loc 1 262 2 view .LVU145
 460               	/* #NOAPP */
 461 0002 0E94 0000 		call init_port
 462               	.LVL38:
 263:main.c        **** 	tim1_init();
 463               		.loc 1 263 2 view .LVU146
 464 0006 0E94 0000 		call tim1_init
 465               	.LVL39:
 466               	.L45:
 264:main.c        **** 
 265:main.c        **** 	while (1)
 467               		.loc 1 265 2 discriminator 1 view .LVU147
 266:main.c        **** 	{
 267:main.c        **** 		alarm_system_proc();
 468               		.loc 1 267 3 discriminator 1 view .LVU148
 469 000a 0E94 0000 		call alarm_system_proc
 470               	.LVL40:
 471 000e 00C0      		rjmp .L45
 472               		.cfi_endproc
 473               	.LFE10:
 475               		.section	.bss.timeout.1220,"aw",@nobits
 478               	timeout.1220:
 479 0000 0000      		.zero	2
 480               		.section	.bss.tempPassword_new.1207,"aw",@nobits
 483               	tempPassword_new.1207:
 484 0000 0000 0000 		.zero	20
 484      0000 0000 
 484      0000 0000 
 484      0000 0000 
 484      0000 0000 
 485               		.section	.bss.stage_prev,"aw",@nobits
 488               	stage_prev:
 489 0000 00        		.zero	1
 490               		.section	.bss.stage,"aw",@nobits
 493               	stage:
 494 0000 00        		.zero	1
 495               		.section	.bss.disarmed_state,"aw",@nobits
 498               	disarmed_state:
 499 0000 00        		.zero	1
 500               		.section	.bss.state_password,"aw",@nobits
 503               	state_password:
 504 0000 00        		.zero	1
 505               		.text
 506               	.Letext0:
 507               		.file 2 "c:\\bin\\avr-gcc-8.3.0-x64-mingw\\lib\\gcc\\avr\\8.3.0\\include\\stdint-gcc.h"
 508               		.file 3 "./drivers/timer.h"
 509               		.file 4 "./drivers/keyboard.h"
 510               		.file 5 "./drivers/password.h"
DEFINED SYMBOLS
                            *ABS*:0000000000000000 main.c
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccy3XsZ4.s:2      *ABS*:000000000000003e __SP_H__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccy3XsZ4.s:3      *ABS*:000000000000003d __SP_L__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccy3XsZ4.s:4      *ABS*:000000000000003f __SREG__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccy3XsZ4.s:5      *ABS*:0000000000000000 __tmp_reg__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccy3XsZ4.s:6      *ABS*:0000000000000001 __zero_reg__
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccy3XsZ4.s:13     .text.password_check:0000000000000000 password_check
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccy3XsZ4.s:503    .bss.state_password:0000000000000000 state_password
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccy3XsZ4.s:483    .bss.tempPassword_new.1207:0000000000000000 tempPassword_new.1207
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccy3XsZ4.s:118    .text.disarmed_state_handle:0000000000000000 disarmed_state_handle
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccy3XsZ4.s:498    .bss.disarmed_state:0000000000000000 disarmed_state
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccy3XsZ4.s:478    .bss.timeout.1220:0000000000000000 timeout.1220
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccy3XsZ4.s:278    .text.alarm_system_proc:0000000000000000 alarm_system_proc
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccy3XsZ4.s:493    .bss.stage:0000000000000000 stage
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccy3XsZ4.s:488    .bss.stage_prev:0000000000000000 stage_prev
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccy3XsZ4.s:396    .text.init_port:0000000000000000 init_port
C:\Users\YB38D~1.VIR\AppData\Local\Temp\ccy3XsZ4.s:446    .text.startup.main:0000000000000000 main

UNDEFINED SYMBOLS
keyboard_input_get
password_verification
timer_time_get
tim1_init
__do_clear_bss
