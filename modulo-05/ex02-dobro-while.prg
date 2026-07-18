FUNCTION Main()
    LOCAL nValor

    Qout("Informe valores inteiros. Digite um valor zero ou negativo para parar.")

    INPUT "Valor: " TO nValor
    WHILE nValor > 0
        Qout("Dobro: " + NTOC(nValor * 2))
        INPUT "Valor: " TO nValor
    ENDDO

    Qout("Encerrado Programa.")
RETURN NIL