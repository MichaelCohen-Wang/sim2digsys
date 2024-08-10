# Operands to multiply
.data
in: .word 0x22D2

.text
main:   # Load data from memory
        la      t0, in      # Load address of 'in' into t0
        lw      t0, 0(t0)   # Load word from memory address in t0
        
        # Initialize outputs
        addi    a0, x0, 0   # Initialize output to 0


        # Initialize loop counter
        li      t2, 4       # Loop counter set to 4 for 4 iterations

loop:   # Check if loop counter is 0
        beq     t2, x0, finish


        # Shift left to get next outputs
        slli    a0,a0,1

        # Mask the rightmost letter to isolate it
        andi    t1, t0, 0xF

        # Separate signals from letter

        andi    t3, t1, 1 # is_car
        srli    t1, t1, 1
        andi    t4, t1, 1 # is_person
        srli    t1, t1, 1
        andi    t5, t1, 1 # t_flicker
        srli    t1, t1, 1
        andi    t6, t1, 1 # t_done

###############
# ADD YOUR CODE HERE - operations on isolated singals to calculate t_start
# You can use the signals in registers t3,t4,t5,t6
# Have the output in each iteration in the register a0, the lower bit will be isolated and pushed left

# Use the code below to calculate arithmetic:
# or <Output>, <Input>, <Input>
# and <Output>, <Input>, <Input>
# not <Output>, <Input>
	not t3, t3
    not t5, t5
    and a1, t5, t3
    and a1, a1, t4
# END OF YOUR CODE
###############

	#Isolate lower bit 
	andi a1, a1, 1 
        #Add to final output register
        add    a0, a0, a1
        # Decrement loop counter
        addi    t2, t2, -1

        # Shift right to get the next letter into the rightmost position
        srai    t0, t0, 4

        j       loop

finish: addi    a1, a0, 0 # Exit code
        addi    a0, x0, 1
        ecall   # print integer ecall
        addi    a0,x0, 10
        ecall   # terminate call