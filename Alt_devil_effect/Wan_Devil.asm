.thumb
.org 0x00000000

Start:
push {r0-r7, r14}
mov r5, r0
mov r3, #0xFF					@arbitrary check to make routine run once
cmp r1,r3
bgt End


Is_Devil_Check:
mov r1, #0x4A
ldrb r4, [r0,r1]
mov r0,r4
ldr r3, Get_Weapon_Effect  
bl GOTO_R3
mov r1, #0x04					@need devil id
cmp r0,r1 						@check for devil ability bit
beq Damage_Dealt_Check					
b End


Damage_Dealt_Check:
ldr r0, [r5, #0x7C]				@value set to 1 if dmg has been dealt
mov r1, #0x01
cmp r0 ,r1
bne End


Weapon_Type_Check:
mov r0, r4						@check for each indiviual weapon type 
ldr r3, Get_Weapon_Type
bl GOTO_R3
mov r1, #0x01
cmp r1,r0
beq Lance_Effect
mov r1, #0x02
cmp r1, r0
beq Axe_Effect
b End


Axe_Effect:
bl Struct_Check
ldrb r1, [r0, #0x13] 		@current health
mov r2, #0x01
cmp r2, r1
beq End						@if health is 1, end
mov r2, r1
mov r3, #0x01
and r2, r3
mov r3, #0x00
cmp r2, r3
beq Even					@ if health is even, dvide health by 2. Else add one and then divide
add r1, #0x01
Even:
lsr r1, r1, #0x01
strb r1, [r0, #0x13] 		@current health
b End


Lance_Effect:
bl Struct_Check
ldrb r1, [r4, #0x13]		@check to see if enemy is dead
cmp r1, #0x00
beq End
ldrb r1, [r0, #0x12] 		@max health
mov r2, #0x01 				@if max health is one, end
cmp r1, r2
beq End
mov r2, #0x02 				@if max health is 2, reduce to one
cmp r1, r2
bne Decrease
sub r1, r1, #0x01
strb r1, [r0, #0x12]
b End

Decrease: 					
sub r1, r1, #0x02 			@otherwise reduce by 2
strb r1, [r0, #0x12]		@max health
b End

Struct_Check:
mov r0, r5
ldr r1, Defender_RAM
cmp r0, r1
beq Defender
mov r0, r7
mov r4, r6
bx lr 

Defender:
mov r0, r6
mov r4, r7
bx lr



GOTO_R3:
bx r3 

End:
pop {r0-r7}
push {r4-r7}
mov r7, r0
mov r0, #0x0B
ldsb r0, [r7, r0]
ldr r3, Return_Location
bx r3

.align 
Get_Weapon_Type: 
.long 0x08017548+1

Get_Weapon_Effect:			@routine to get weapon effect given weapon halfword in r0
.long 0x08017724+1

Return_Location:
.long 0x0802C0BC+1

Defender_RAM:
.long 0x0203A56C
