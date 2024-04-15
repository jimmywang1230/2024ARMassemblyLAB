AREA GCD, CODE, READONLY ; name this block of code
    ENTRY ; mark first instruction
start
    LDR R1, =n1    ; Load the first number into R1 (18)
    LDR R1, [R1]
    LDR R2, =n2    ; Load the second number into R2 (48)
    LDR R2, [R2]

gcd_loop
    CMP R1, R2     ; Compare the two numbers
    BEQ done       ; If they are equal, the GCD is either R1 or R2
    BGT reduce_r1  ; If R1 > R2, reduce R1 by R2
    SUB R2, R2, R1 ; If R2 >= R1, subtract R1 from R2
    B gcd_loop

reduce_r1
    SUB R1, R1, R2 ; Subtract R2 from R1
    B gcd_loop

done
    MOV R0, R1     ; Move final GCD into R0
    B stop         ; Terminate

stop
    B stop          ; Infinite loop to stop the program

    AREA data, DATA, READONLY
n1 dcd 18
n2 dcd 48
    END ; Mark end of file