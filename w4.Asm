; Template for console application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

         .CONST
MsgExit  DB    0AH,0DH,"Press Enter to Exit",0AH,0DH,0
strenter DB    "Enter your line: ",0
strorg DB    0AH,0DH,"Origin line: ",0
strout DB    0AH,0DH,"Result line: ",0

         .DATA
source DB 43 DUP(?)
result DB 40 DUP(?)

         .DATA?
inbuf    DB    100 DUP (?)

         .CODE
Start:
         XOR    EAX,EAX
         Invoke StdOut,ADDR strenter
         Invoke StdIn, ADDR source,LengthOf source
         Invoke StripLF,ADDR source
         mov source[39],' '
         lea ESI,source
         lea EDI,result
         mov ECX,40d
         rep movsb
         Invoke StdOut,ADDR strorg
         Invoke StdOut,ADDR result
         cld
         lea EDI,source-8
         mov EBX,1
         cyclesort1:
            cmp EBX,4
            jg continue
            mov ECX,4
            cyclesort2:
                push EDI
                lea EDI,[EDI+ECX*8]
                lea ESI,[EDI+8]
                push ECX
                push EDI
                push ESI
                mov ECX,7
                repe cmpsb
                pop ESI
                pop EDI
                jg nextstep
                push EDI
                mov ESI,EDI
                lea EDI,source+40d
                mov ECX,8
                rep movsb
                pop EDI
                push EDI
                lea ESI,[EDI+8]
                mov ECX,8
                rep movsb
                mov ECX,8
                lea ESI,source+40d
                rep movsb
                pop EDI
               nextstep:
                
                pop ECX
                pop EDI
            loop cyclesort2
            inc EBX
         jmp cyclesort1
continue:
         lea ESI,source
         lea EDI,result
         mov ECX,40d
         rep movsb
         Invoke StdOut,ADDR strout
         Invoke StdOut,ADDR result
                  
         XOR    EAX,EAX
         Invoke StdOut,ADDR MsgExit
         Invoke StdIn,ADDR inbuf,LengthOf inbuf    
  
         Invoke ExitProcess,0
         End    Start 
