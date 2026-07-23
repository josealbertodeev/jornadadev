FUNCTION MostrarMenu()
    LOCAL cOpcao

    MostrarMenuEstoque()
    
    ACCEPT "Escolha uma opcao: " TO cOpcao
RETURN Val(cOpcao)

FUNCTION MostrarMenuEstoque()
    Qout()
    Qout("=== CONTROLE DE ESTOQUE ===")
    Qout("1 - Cadastrar produto")
    Qout("2 - Listar produtos")
    Qout("3 - Entrada de estoque")
    Qout("4 - Saida de estoque")
    Qout("5 - Buscar produto por codigo")
    Qout("6 - Relatorio de estoque")
    Qout("0 - Sair")
RETURN NIL

FUNCTION CadastrarProduto(aProdutos)
    LOCAL cCodigo
    LOCAL cNome
    LOCAL cQuantidade
    LOCAL cPreco

    ACCEPT "Codigo do produto: " TO cCodigo

    IF BuscarProduto(aProdutos, cCodigo) > 0
        Qout("Ja existe um produto com esse codigo.")
        RETURN NIL
    ENDIF

    ACCEPT "Nome do produto: " TO cNome
    ACCEPT "Quantidade inicial: " TO cQuantidade
    ACCEPT "Preco unitario: " TO cPreco

    IF Val(cQuantidade) < 0 .OR. Val(cPreco) < 0
        Qout("Quantidade e preco devem ser valores positivos.")
        RETURN NIL
    ENDIF

    AAdd(aProdutos, {cCodigo, cNome, Val(cQuantidade), Val(cPreco)})
    Qout("Produto cadastrado com sucesso.")
RETURN NIL

FUNCTION ListarProdutos(aProdutos)
    LOCAL i

    IF Len(aProdutos) == 0
        Qout("Nenhum produto cadastrado.")
        RETURN NIL
    ENDIF

    Qout()
    Qout("*PRODUTOS CADASTRADOS*")
    FOR i := 1 TO Len(aProdutos)
        Qout(aProdutos[i][1] + " - " + aProdutos[i][2] + " - Qtd: " + ;
            AllTrim(Str(aProdutos[i][3], 10, 0)) + " - R$ " + ;
            AllTrim(Str(aProdutos[i][4], 10, 2)))
    NEXT
RETURN NIL

FUNCTION EntradaEstoque(aProdutos)
    LOCAL cCodigo
    LOCAL cQuantidade
    LOCAL nPos

    ACCEPT "Codigo do produto: " TO cCodigo
    nPos := BuscarProduto(aProdutos, cCodigo)

    IF nPos == 0
        Qout("Produto nao encontrado.")
        RETURN NIL
    ENDIF

    ACCEPT "Quantidade a adicionar: " TO cQuantidade

    IF Val(cQuantidade) <= 0
        Qout("A quantidade deve ser maior que zero.")
        RETURN NIL
    ENDIF

    aProdutos[nPos][3] += Val(cQuantidade)
    Qout("Entrada registrada com sucesso.")
RETURN NIL

FUNCTION SaidaEstoque(aProdutos)
    LOCAL cCodigo
    LOCAL cQuantidade
    LOCAL nPos

    ACCEPT "Codigo do produto: " TO cCodigo
    nPos := BuscarProduto(aProdutos, cCodigo)

    IF nPos == 0
        Qout("Produto nao encontrado.")
        RETURN NIL
    ENDIF

    ACCEPT "Quantidade a retirar: " TO cQuantidade

    IF Val(cQuantidade) <= 0
        Qout("A quantidade deve ser maior que zero.")
        RETURN NIL
    ENDIF

    IF Val(cQuantidade) > aProdutos[nPos][3]
        Qout("Estoque insuficiente. Quantidade disponivel: " + AllTrim(Str(aProdutos[nPos][3], 10, 0)))
        RETURN NIL
    ENDIF

    aProdutos[nPos][3] -= Val(cQuantidade)
    Qout("Saida registrada com sucesso.")
RETURN NIL

FUNCTION BuscarProduto(aProdutos, cCodigo)
    LOCAL i

    FOR i := 1 TO Len(aProdutos)
        IF aProdutos[i][1] == cCodigo
            RETURN i
        ENDIF
    NEXT
RETURN 0

FUNCTION RelatorioEstoque(aProdutos)
    LOCAL i
    LOCAL nValorProduto
    LOCAL nValorTotal := 0

    IF Len(aProdutos) == 0
        Qout("Nenhum produto cadastrado.")
        RETURN NIL
    ENDIF

    Qout()
    Qout("*RELATORIO DE ESTOQUE*")
    FOR i := 1 TO Len(aProdutos)
        nValorProduto := aProdutos[i][3] * aProdutos[i][4]
        nValorTotal += nValorProduto
        Qout(aProdutos[i][2] + " - R$ " + AllTrim(Str(nValorProduto, 10, 2)))
    NEXT

    Qout()
    Qout("Valor total em estoque: R$ " + AllTrim(Str(nValorTotal, 10, 2)))
RETURN NIL
