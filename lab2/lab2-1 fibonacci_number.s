AREA Fibon, CODE, READONLY ; name this block of code
    ENTRY ; mark first instruction
start
    LDR R1, =n1      ; Load first Fibonacci number (a1 = 1)
    LDR R1, [R1]
    LDR R2, =n2      ; Load second Fibonacci number (a2 = 1)
    LDR R2, [R2]
    LDR R3, =num     ; Load the number of Fibonacci numbers to calculate
    LDR R3, [R3]
    LDR R4, =Sequence; Base address of MATRIXA array where results will be stored

    STR R1, [R4], #4 ; Store first Fibonacci number
    SUBS R3, R3, #1  ; Decrement count
    STR R2, [R4], #4 ; Store second Fibonacci number
    SUBS R3, R3, #1  ; Decrement count

fib_loop
    ADD R0, R1, R2   ; Calculate next Fibonacci number (an = an-1 + an-2)
    STR R0, [R4], #4 ; Store the result in MATRIXA
    MOV R1, R2       ; Move an-1 to an-2
    MOV R2, R0       ; New an-1
    SUBS R3, R3, #1  ; Decrement the loop counter
    BNE fib_loop     ; If count not zero, continue loop

stop
    B stop           ; Infinite loop to stop the program

    AREA data, DATA, READONLY
n1 dcd 1
n2 dcd 1
num dcd 10 ;Number of items
Sequence dcd 0,0,0,0,0,0,0,0,0,0 ; Storage for the Fibonacci sequence
    END ; Mark end of file