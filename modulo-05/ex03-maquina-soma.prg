FUNCTION Main()
    LOCAL nValor
    LOCAL nTotal := 0
    LOCAL nQtd := 0

    Qout("Informe valores inteiros. Digite 0 para parar.")

    INPUT "Valor: " TO nValor
    WHILE nValor != 0
        nTotal += nValor
        nQtd++
        INPUT "Valor: " TO nValor
    ENDDO

    Qout("Soma total: " + NTOC(nTotal))
    Qout("Quantidade de valores somados: " + NTOC(nQtd))
RETURN NIL