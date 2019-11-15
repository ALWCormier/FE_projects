.thumb
.org 0x16aec
	ldr		r1, CALL_ROUTINE
	bx		r1
	
	.align
CALL_ROUTINE:
	.long 0x8b2a770+1

.org 0xb2a770

STAR_ST:
	push	{r0-r6}
	@ldr 	r5, =0x203A4EC	@ store attacker data
	mov		r1, #0xFF		
	and		r1,r0
	mov		r0,r1
	lsl 	r1,r0,#0x3
	add 	r1,r1,r0
	lsl 	r1,r1,#0x2
	ldr 	r0, =0x8809B10
	add 	r0,r0,r1
	ldrb 	r1,[r0,#0x07]
	cmp		r1,#0x09
	beq		ITEM_DECREMENT
	mov		r4, #0x0		@ init loop
	mov		r6, #0x0		@ 'False' value
	b		label1			@ largely imitating the Iron Rune check routine here.
	
ITEM_LOOP:
	add		r4, #0x1		@ this is skipped over on the first loop
	
label1:
	cmp		r4, #0x4		@ there are 0x5 slots in inventory
	bgt		CHECK_STARSPHERE 
	@ldr		r2, =0x03004e50	@active character data
	@ldr		r2,[r2]
	lsl		r1, r4, #0x1	@r4 contains the cycle
	add		r1, #0x1E		@index of items in character data
	add		r1,r5,r1		
	ldrh	r0, [r1]		@ loads item
	cmp		r0, #0x0		@ if there is no Xth item, branch to routine end
	beq		CHECK_STARSPHERE
	bl		GET_ATTRIBUTE	@ Loads weapon ability word into r0
	mov		r1, #0x02
	lsl		r1, #0x08
	and		r1, r0			@ isolates "weapon ability 2" bit 1
	cmp		r1, #0x00		@ is "starsphere" bit set to on?
	beq		ITEM_LOOP		@ if not, keep looking
	
TRUE:
	mov		r6, #0x1		@ "True" value

CHECK_STARSPHERE:
	cmp		r6, #0x00
	beq		DECREMENT

STAR_END:
	pop		{r0-r6}
	mov		r2,r0
	ldr 	r1, =0x802B818+1
	bx		r1
	
	
GET_ATTRIBUTE:
	ldr		r1, =0x0801756C+1	@ Routine 
	bx		r1

DECREMENT:
	pop  	{r0-r6}
	mov		r2,r0
	mov 	r1, #0xFF
	and		r1,r2
	lsl		r0,r1,#0x03
	add		r0,r0,r1
	lsl		r0,r0,#0x02
	ldr 	r1, =0x8809b10
	add		r0,r0,r1
	ldr 	r0,[r0,#0x08]
	mov		r1,#0x08
	and		r0,r1
	cmp		r0,#0x00
	bne 	branch1
	ldr 	r0, =0xFFFFFF00
	add		r2,r2,r0
	cmp		r2,#0xFF
	ble 	Weapon_Broke

branch1:
	lsl		r0,r2,#0x10
	lsr		r0,r0,#0x10
	b 		NORMAL_END

Weapon_Broke:
	mov		r0,#0x00

NORMAL_END:
	ldr 	r1, =0x802B818+1
	bx		r1

ITEM_DECREMENT:
	pop  	{r0-r6}
	mov		r2,r0
	mov 	r1, #0xFF
	and		r1,r2
	lsl		r0,r1,#0x03
	add		r0,r0,r1
	lsl		r0,r0,#0x02
	ldr 	r1, =0x8809b10
	add		r0,r0,r1
	ldr 	r0,[r0,#0x08]
	mov		r1,#0x08
	and		r0,r1
	cmp		r0,#0x00
	bne 	branch2
	ldr 	r0, =0xFFFFFF00
	add		r2,r2,r0
	cmp		r2,#0xFF
	ble 	ITEM_BROKE
	
branch2:
	lsl		r0,r2,#0x10
	lsr		r0,r0,#0x10
	b 		ITEM_END
	
ITEM_BROKE:
	mov		r0,#0x00
	
ITEM_END:
	ldr		r1,=0x802cca0+1
	bx		r1
	