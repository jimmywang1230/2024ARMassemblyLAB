AREA Data, DATA, READWRITE
n       DCD 6
ArrayA  DCD 1, 10, 13
ArrayB  DCD 2, 5, 15
ArrayC  DCD 0, 0, 0, 0, 0, 0

    AREA Array, CODE, READONLY
    ENTRY
start
    LDR R0, =ArrayA      ; Load address of ArrayA
    LDR R1, =ArrayB      ; Load address of ArrayB
    LDR R2, =ArrayC      ; Load address of ArrayC
    LDR R3, =n           ; Load the total number of elements in ArrayC
    LDR R3, [R3]
    LDR R4, =3           ; Number of elements in ArrayA and ArrayB

    ; Copy ArrayA to ArrayC
    MOV R5, R0           ; Pointer to start of ArrayA
    MOV R6, R2           ; Pointer to start of ArrayC
    MOV R7, R4           ; Counter for ArrayA elements
copyA_loop
    LDR R8, [R5], #4     ; Load from ArrayA and increment pointer
    STR R8, [R6], #4     ; Store in ArrayC and increment pointer
    SUBS R7, R7, #1      ; Decrement counter
    BNE copyA_loop       ; Continue if not finished with ArrayA

    ; Copy ArrayB to ArrayC
    MOV R5, R1           ; Pointer to start of ArrayB
    MOV R7, R4           ; Counter for ArrayB elements
copyB_loop
    LDR R8, [R5], #4     ; Load from ArrayB and increment pointer
    STR R8, [R6], #4     ; Store in ArrayC and increment pointer
    SUBS R7, R7, #1      ; Decrement counter
    BNE copyB_loop       ; Continue if not finished with ArrayB

    ; Sort ArrayC
    MOV R5, R3           ; Total elements in ArrayC
    SUB R5, R5, #1       ; Decrement for zero-based index
sort_outer_loop
    MOV R9, #0           ; Flag to check if any swap happened
    MOV R6, R2           ; Reset pointer to start of ArrayC
    MOV R7, R5           ; Reset inner loop counter
sort_inner_loop
    LDR R8, [R6]         ; Load current element
    LDR R10, [R6, #4]    ; Load next element
    CMP R10, R8          ; Compare current and next
    BGE sort_skip_swap   ; Go to next if order is correct
    STR R10, [R6]        ; Swap elements
    STR R8, [R6, #4]
    MOV R9, #1           ; Set flag to indicate swap
sort_skip_swap
    ADD R6, R6, #4       ; Increment pointer to next element
    SUBS R7, R7, #1      ; Decrement counter
    BNE sort_inner_loop  ; Continue inner loop if not done
    CMP R9, #0           ; Check if any swap happened
    BEQ sort_done        ; If no swap, array is sorted
    B sort_outer_loop    ; Repeat sorting if needed

sort_done
stop
    B stop              ; Infinite loop to stop the program

    END