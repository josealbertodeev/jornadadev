
FUNCTION Main()
    LOCAL aNumeros := {5, 3, 8, 1, 9, 2, 7, 4, 6, 0}
    LOCAL i
    
    Qout("Antes:")
    FOR i := 1 TO Len(aNumeros)
        Qout(AllTrim(Str(aNumeros[i], 5)))
        hb_idleSleep(0.1)
    NEXT

    BubbleSort(aNumeros)

    Qout()
    Qout("Depois:")
    FOR i := 1 TO Len(aNumeros)
        Qout(AllTrim(Str(aNumeros[i], 5)))
        hb_idleSleep(0.1)
    NEXT
RETURN NIL

FUNCTION BubbleSort(aVetor)
    LOCAL i
    LOCAL j
    LOCAL nTemp

    FOR i := 1 TO Len(aVetor) - 1
        FOR j := 1 TO Len(aVetor) - i
            IF aVetor[j] > aVetor[j + 1]
                nTemp := aVetor[j]
                aVetor[j] := aVetor[j + 1]
                aVetor[j + 1] := nTemp
            ENDIF
        NEXT
    NEXT
RETURN aVetor