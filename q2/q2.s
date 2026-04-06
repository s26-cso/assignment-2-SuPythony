.data

out1: .string "%lld "
out2: .string "\n"
test: .string "%lld\n"

.text
.globl main

get_no_at_index:
#array at a0
#index at a1
#from str at a2, 1 true, 0 false
#return no as ll at a0
addi sp, sp, -16
sd ra, 0(sp)
slli a1, a1, 3
add a0, a0, a1
ld a0, 0(a0) #cur val
beq a2, zero, get_end
call atoll
get_end:
ld ra, 0(sp)
addi sp, sp, 16
ret

main:
addi sp, sp, -80
sd ra, 0(sp)
sd s0, 8(sp)
sd s1, 16(sp)
sd s2, 24(sp)
sd s3, 32(sp)
sd s4, 40(sp)
sd s5, 48(sp)
sd s6, 56(sp)
sd s7, 64(sp)
sd s8, 72(sp)

mv s0, a0 #no of args
addi s0, s0, -1 #sub 1 to account for script name
mv s1, a1 #pointer to args
addi s1, s1, 8 #skip first arg

mv s2, s0
slli s2, s2, 3
mv a0, s2
call malloc
mv s2, a0 #stack pointer
li s3, 0 #stack size
#stack stores indexes

mv s4, s0
slli s4, s4, 3
mv a0, s4
call malloc
mv s4, a0 #ans array pointer

addi s5, s0, -1 #index

loop:
mv a0, s1
mv a1, s5
li a2, 1
call get_no_at_index
mv s6, a0

loop2:
beq s3, zero, loop2_end
addi s3, s3, -1
mv a0, s2
mv a1, s3
li a2, 0
call get_no_at_index
addi s3, s3, 1
mv s7, a0 #top val of stack (index)
mv a0, s1
mv a1, s7
li a2, 1
call get_no_at_index
mv s7, a0 #top val of stack (value)
blt s6, s7, loop2_end
addi s3, s3, -1
jal zero, loop2 
loop2_end:
#if stack empty, ans -1, otherwise top val of stack. then add cur index to stack
beq s3, zero, empty
addi s3, s3, -1
mv a0, s2
mv a1, s3
li a2, 0
call get_no_at_index
addi s3, s3, 1
mv s8, a0
jal zero, ans_found
empty:
li s8, -1
ans_found: #s8 holds ans
#putting ind on stack
slli s3, s3, 3
add s2, s2, s3
sd s5, 0(s2)
sub s2, s2, s3
srli s3, s3, 3
addi s3, s3, 1
#putting ans in array
slli s5, s5, 3
add s4, s4, s5
sd s8, 0(s4)
sub s4, s4, s5
srli s5, s5, 3

addi s5, s5, -1
bge s5, zero, loop

li s5, 0
print_loop:
beq s5, s0, end
mv a0, s4
mv a1, s5
li a2, 0
call get_no_at_index
mv a1, a0
la a0, out1
call printf
addi s5, s5, 1
jal zero, print_loop

end:
la a0, out2
call printf
mv a0, s2
call free
mv a0, s4
call free
ld s8, 72(sp)
ld s7, 64(sp)
ld s6, 56(sp)
ld s5, 48(sp)
sd s4, 40(sp)
sd s3, 32(sp)
sd s2, 24(sp)
sd s1, 16(sp)
sd s0, 8(sp)
ld ra, 0(sp)
addi sp, sp, 80
ret
