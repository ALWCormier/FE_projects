.thumb
.org 0x00000000

DC_USABILITY_START:
push {r4-r5}
ldr r1, CharDataPointer
ldr r4, [r1]        @r4 = char data in ram
mov r5, #0x0        @loop counter

CheckItem:
ldrb r0, [r4, #0x1e]@ItemID of 1st item
ldr r3, Get_ItemData
bl GOTO_R3
mov r2, r0
ldrb r0, [r2, #0x7] @7th byte is weapon type
cmp r0, #0x7
ble CheckUses
cmp r0, #0xB
beq CheckUses

ContinueLoop:
mov r0, #0x0
add r4, #0x2        @check next item
add r5, #0x1        @increment loop
cmp r5, #0x5        @is it the last item?
bge End
b CheckItem

CheckUses:
ldrb r0, [r2, #0x8]
mov r1, #0x8
and r0, r1
cmp r0, #0x8        @check if indestructible
beq ContinueLoop
ldrb r0, [r2, #0x14]@max durability
ldrb r3, [r4,#0x1f] @current durability
cmp r0, r3
ble ContinueLoop
mov r0, #0x1

End:
pop {r4-r5}
ldr r1, ReturnValue

GOTO_R1:
bx r1

GOTO_R3:
bx r3

.align
CharDataPointer:     @contains a pointer to the currently selected unit's data in ram
.long 0x03004690

Get_ItemData:
.long 0x080174AC+1

ReturnValue:
.long 0x08026f46+1
