FUNCTION Main()
    LOCAL aCarrinho := {}
    LOCAL cNome
    LOCAL cPreco
    LOCAL cContinuar
    LOCAL nTotal := 0
    LOCAL i

    DO WHILE .T.
        ACCEPT "Nome do produto: " TO cNome
        ACCEPT "Preco do produto: " TO cPreco

        AAdd(aCarrinho, {cNome, Val(cPreco)})

        ACCEPT "Deseja adicionar outro item? (S/N) " TO cContinuar
        IF Upper(cContinuar) != "S"
            EXIT
        ENDIF
    ENDDO

    Qout()
    Qout("*ITENS DO CARRINHO*")
    FOR i := 1 TO Len(aCarrinho)
        Qout(aCarrinho[i][1] + " - R$ " + AllTrim(Str(aCarrinho[i][2], 10, 2)))
        nTotal += aCarrinho[i][2]
    NEXT

    Qout()
    Qout("Total: R$ " + AllTrim(Str(nTotal, 10, 2)))
RETURN NIL
