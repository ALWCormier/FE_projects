.thumb
.org 0x00000000

DC_EFFECT_START:
push {r4-r7, r14}
ldr r1, CharDataPointer
ldr r4, [r1]        @r4 = char data in ram
mov r7, r5
mov r5, #0x0        @loop counter

CheckItem:
ldrb r0, [r4, #0x1e]@ItemID of 1st item
mov r6, r0          @save the ItemID
ldr r3, Get_ItemData
bl GOTO_R3
mov r2, r0
ldrb r0, [r2, #0x7] @7th byte is weapon type
cmp r0, #0x7
ble CheckUses
cmp r0, #0xB
beq CheckUses

ContinueLoop:
add r4, #0x2        @check next item
add r5, #0x1        @increment loop
cmp r5, #0x5        @is it the last item?
bge End
b CheckItem

CheckUses:
mov r0, r6
ldr r3, Get_ItemData
bl GOTO_R3
mov r2, r0
ldrb r0, [r2, #0x8]
mov r1, #0x8
and r0, r1
cmp r0, #0x8        @check if indestructible
beq ContinueLoop
ldrb r0, [r2, #0x14] @max durability
ldrb r3, [r4,#0x1f] @current durability
cmp r0, r3
ble ContinueLoop
asr r2,r0,#0x2
add r3,r2,r3
asr r2,r0,#0x3
add r3,r2,r3
cmp r0, r3
ble MaxUses
strb r3, [r4,#0x1f]
b DecrementUse

MaxUses:
strb r0, [r4,#0x1f]
b DecrementUse

DecrementUse:
@at this point: r6 = ItemID of repaired wep
@Get Inventory Slot into r1,
@and chardata into r0,
@then call $18994 to decrement and refresh.

ldr r1, ItemPos     @load up inventory slot of crystals
ldrb r1, [r1]
ldr r0, CharDataPointer
ldr r0, [r0]
ldr r3, DecrementRoutine
bl GOTO_R3

PlaySound:
mov r0, #0xAC      @sound ID (weapon get!)
ldr r3, SoundRoutine    @play sound routine
bl GOTO_R3

DrawBox:
ldr r0, Text_ID       @or whatever text ID
ldr r3, UncompressText
bl GOTO_R3

mov r0, r6          @move Item ID back to r0
ldr r3, GetIcon
bl GOTO_R3
mov r1, r0          @r1 = icon ID

mov r0, r7 			@ r0 = struct
ldr r2, Text
ldr r3, DrawFunction
bl GOTO_R3

End:
pop {r4-r7}
pop {r1}

GOTO_R1:
bx r1

GOTO_R3:
bx r3

.align
CharDataPointer:     @contains a pointer to the currently selected unit's data in ram
.long 0x03004690

ItemPos: @Inventory position of last selected item.
.long 0x203A86E

DecrementRoutine:
.long 0x0801842C+1

DrawFunction:
.long 0x0801F100+1

UncompressText:
.long 0x08012C60+1

Text:
.long 0x0202a5b4

GetIcon:
.long 0x08017400+1

Get_ItemData:
.long 0x080174AC+1

Check_Durability:
.long 0x08016174+1

SoundRoutine:
.long 0x080BE594+1

Text_ID:
.long 0x00000F17
