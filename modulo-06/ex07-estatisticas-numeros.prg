FUNCTION Main()
    LOCAL aNumeros := {}
    LOCAL nSoma := 0
    LOCAL nNum
    LOCAL i

    FOR i := 1 TO 10
        ACCEPT "Digite o " + Str(i, 2) + "o numero: " TO nNum
        IF Val(nNum) == 0
            Qout("Valor invalido, digite um numero valido.")
            i -= 1
            LOOP
        ENDIF
        AAdd(aNumeros, Val(nNum))
    NEXT
    PularLinha()
    ASort(aNumeros)
    Qout("Numeros em ordem crescente:")

    FOR i := 1 TO Len(aNumeros)
        Qout(AllTrim(Str(aNumeros[i], 5)))
    NEXT
    PularLinha()

    FOR i := 1 TO Len(aNumeros)
        nSoma += aNumeros[i]
    NEXT

    Qout("*RESULTADO*")
    Qout("Soma: " + Alltrim(Str(nSoma)))
    Qout("Media: " + Alltrim(Str(nSoma / Len(aNumeros))))
    Qout("Maior: " + Str(aNumeros[Len(aNumeros)]))
    Qout("Menor: " + Str(aNumeros[1]))
RETURN NIL

FUNCTION PularLinha()
    Qout()
RETURN NIL