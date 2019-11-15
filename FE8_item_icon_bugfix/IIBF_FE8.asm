.thumb
.org 0x00000000
	
	IIBF_FIX_ST:
	ldr		r0, ICON_FLAG_TARG
	add		r4, #0x1				
	ldr		r5, ICON_LIST_TARG		 
	mov		r3, #0x0				

	CHECK_LOOP:
	ldrb	r2, [r5, r3]			
	cmp		r2, r4					@ r4 is the value we check for
	beq		SUCCESS					@ 
	add		r3, #0x1				@ increment here
	cmp		r2, #0x0				@ 00 is terminator
	bne		CHECK_LOOP				@ 
FAILURE:
	mov		r3, #0x0				
	b		END
SUCCESS:
	add		r3, #0x1				
END:
	sub		r4, #0x1				
	lsl		r1, r4, #0x2			
	add		r5, r1, r0				
	strb	r3, [r5, #0x1]	
	ldrb	r0,[r5,#0x01]
	cmp		r0,#0x00
	beq		ALT_END
	ldr		r0, IIBF_RET			
	bx		r0
ALT_END:
	ldr		r0, IIBF_ALT_RET
	bx		r0

	
	.align	2


ICON_LIST_TARG:
	.long	0x02026E10
ICON_FLAG_TARG:
	.long 	0x02026A90
IIBF_RET:
	.long	0x08003660+1
IIBF_ALT_RET:
	.long	0x08003670+1
.align 4

@.org 0x003656
@
@	ldr		r0, Free_Space	@ edit to where you are inserting the routine
@	bx		r0
@
@Free_Space:
	
	
	