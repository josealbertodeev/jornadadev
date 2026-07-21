FUNCTION Main()
    LOCAL cValor1, cValor2
    LOCAL nValor1, nValor2

    ACCEPT "Digite o primeiro valor: " TO cValor1
    ACCEPT "Digite o segundo valor: " TO cValor2

    nValor1 := VAL(cValor1)
    nValor2 := VAL(cValor2)

    IF nValor1 == nValor2
        Qout("Os dois valores sÆo iguais.")
    ELSE
        IF nValor1 > nValor2
            Qout("Maior valor: " + AllTrim(STR(nValor1)))
            Qout("Menor valor: " + AllTrim(STR(nValor2)))
        ELSE
            Qout("Maior valor: " + AllTrim(STR(nValor2)))
            Qout("Menor valor: " + AllTrim(STR(nValor1)))
        ENDIF
    ENDIF
RETURN NIL