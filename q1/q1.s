# struct structure
# val integer (4 bytes)
# padding (4 bytes)
# left pointer (8 bytes)
# right pointer (8 bytes)
# total 24 bytes

.text
.globl make_node
.globl insert
.globl get
.globl getAtMost

make_node:
addi sp, sp, -16
sd ra, 0(sp)
sd s0, 8(sp)

mv s0, a0

li a0, 24
call malloc
sw s0, 0(a0) # set val to arg
sd zero, 8(a0) # set left to NULL
sd zero, 16(a0) # set right to NULL

ld s0, 8(sp)
ld ra, 0(sp)
addi sp, sp, 16
ret

insert:
addi sp, sp, -16
sd ra, 0(sp)
sd s0, 8(sp)

mv s0, a0 #root
beq s0, zero, root_null
jal zero, continue

root_null:
mv a0, a1
call make_node
mv s0, a0
jal zero, insert_end

continue:
lw t0, 0(a0)
blt a1, t0, lesser

greater_equal:
ld a0, 16(s0)
beq zero, a0, create_new_gr
call insert
jal zero, end_gr
create_new_gr:
mv a0, a1
call make_node
sd a0, 16(s0)
end_gr:
jal zero, insert_end

lesser:
ld a0, 8(s0)
beq zero, a0, create_new_le
call insert
jal zero, end_le
create_new_le:
mv a0, a1
call make_node
sd a0, 8(s0)
end_le:

insert_end:
mv a0, s0
ld s0, 8(sp)
ld ra, 0(sp)
addi sp, sp, 16
ret

get:
addi sp, sp, -16
sd ra, 0(sp)

beq a0, zero, get_end #if NULL

lw t0, 0(a0)
beq a1, t0, get_equal
blt a1, t0, get_lesser

get_greater:
ld a0, 16(a0)
call get
jal zero, get_end

get_lesser:
ld a0, 8(a0)
call get
jal zero, get_end

get_equal:
#do nothing, a0 already has required node

get_end:
ld ra, 0(sp)
addi sp, sp, 16
ret

getAtMost:
addi sp, sp, -16
sd ra, 0(sp)

li t0, -1 #ans

loop:
beq a1, zero, loop_end #NULL

lw t1, 0(a1)
beq t1, a0, gam_equal
blt t1, a0, gam_less

gam_great:
#node val greater than val, go left
ld a1, 8(a1)
jal zero, loop

gam_less:
#node val is less than val, go to right
mv t0, t1
ld a1, 16(a1)
jal zero, loop

gam_equal:
mv t0, a0 #if equal, val is answer
jal zero, loop_end

loop_end:
mv a0, t0
ld ra, 0(sp)
addi sp, sp, 16
ret
