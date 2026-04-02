.data

fname: .string "input.txt"
mode: .string "r"
yes: .string "Yes\n"
no: .string "No\n"

.text
.globl main

main:
addi sp, sp, -16
sd ra, 0(sp)
la a0, fname
la a1, mode
call fopen
mv t0, a0 #file pointer
li a0, 0
call malloc
mv t1, a0 #string pointer
mv t2, zero #length
loop:
mv a0, t0
call fgetc
blt a0, zero, end
mv t3, a0 #cur char
mv a0, t1
addi a1, t2, 1
call realloc
mv t1, a0
add t1, t1, t2
sb t3, 0(t1)
sub t1, t1, t2
addi t2, t2, 1
jal zero, loop
end:
addi t2, t2, -1 #decr length by 1 to account for \n while reading file

#palindrome checking
li t4, 1 #t4 stores ans
mv t6, t2 #t6 stores right pointer
addi t6, t6, -1
li t5, 0 #t5 stores left pointer
loop2:
add t1, t1, t5
lb t2, 0(t1) #t2 stores char at left pointer
sub t1, t1, t5
add t1, t1, t6
lb t3, 0(t1) #t3 stores char at right pointer
sub t1, t1, t6
bne t2, t3, notpal
addi t5, t5, 1
addi t6, t6, -1
bge t5, t6, end2 #if left pointer >= right pointer, then done
beq zero, zero, loop2
notpal:
li t4, 0
end2:
beq t4, zero, nopa
la a0, yes
call printf
jal zero, fin
nopa:
la a0, no
call printf
fin:
mv a0, t0
call fclose
ld ra, 0(sp)
addi sp, sp, 16
ret
