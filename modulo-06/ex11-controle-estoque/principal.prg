SET PROCEDURE TO estoque_lib.prg

FUNCTION Main()
    LOCAL aProdutos := {}
    LOCAL nOpcao
    LOCAL cCodigo
    LOCAL nPos

    DO WHILE .T.
        nOpcao := MostrarMenu()

        DO CASE
        CASE nOpcao == 1
            CadastrarProduto(aProdutos)

        CASE nOpcao == 2
            ListarProdutos(aProdutos)

        CASE nOpcao == 3
            EntradaEstoque(aProdutos)

        CASE nOpcao == 4
            SaidaEstoque(aProdutos)

        CASE nOpcao == 5
            ACCEPT "Codigo do produto: " TO cCodigo
            nPos := BuscarProduto(aProdutos, cCodigo)
            IF nPos == 0
                Qout("Produto nao encontrado.")
            ELSE
                Qout("Produto encontrado na posicao: " + AllTrim(Str(nPos, 5, 0)))
            ENDIF

        CASE nOpcao == 6
            RelatorioEstoque(aProdutos)

        CASE nOpcao == 0
            EXIT

        OTHERWISE
            Qout("Opcao invalida.")
        ENDCASE
    ENDDO

    Qout("Encerrando o controle de estoque.")
RETURN NIL
