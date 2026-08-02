#INCLUDE "PROTHEUS.CH"

USER FUNCTION VALEXCSZ1()
    LOCAL lPodeExcluir := .T.
    LOCAL aArea := GetArea()
    LOCAL aAreaSZ2 := SZ2->(GetArea())
    LOCAL cCodigo := ""
    LOCAL nQtdInteracoes := 0

    IF Type("SZ1->Z1_CODIGO") != "U"
        cCodigo := SZ1->Z1_CODIGO
    ELSEIF Type("M->Z1_CODIGO") != "U"
        cCodigo := M->Z1_CODIGO
    ELSE
        lPodeExcluir := .F.
        MsgAlert("Não foi possível identificar o código do contato!", "Erro de Validação")
        RestArea(aAreaSZ2)
        RestArea(aArea)
        RETURN lPodeExcluir
    ENDIF

    dbSelectArea("SZ2")
    dbSetOrder(1)

    IF dbSeek(xFilial("SZ2") + cCodigo)
        WHILE !EOF() .AND. SZ2->Z2_FILIAL == xFilial("SZ2") .AND. ;
                SZ2->Z2_CONTAT == cCodigo

            nQtdInteracoes++
            dbSkip()
        ENDDO

        IF nQtdInteracoes > 0
            lPodeExcluir := .F.

            MsgAlert(;
                "Não é possível excluir este contato!" + CRLF + CRLF + ;
                "Código: " + AllTrim(cCodigo) + CRLF + ;
                "Motivo: Existem " + AllTrim(Str(nQtdInteracoes)) + " interação(ões) vinculada(s)." + CRLF + CRLF + ;
                "Para excluir o contato, primeiro exclua todas as interações.",;
                "?? Integridade Referencial";
                )
        ENDIF
    ENDIF

    RestArea(aAreaSZ2)
    RestArea(aArea)

RETURN lPodeExcluir


USER FUNCTION VALEXCSZ1V2()
    LOCAL lPodeExcluir := .T.
    LOCAL cCodigo := SZ1->Z1_CODIGO

    IF ExistCpo("SZ2", xFilial("SZ2") + cCodigo, 1)
        lPodeExcluir := .F.

        MsgAlert(;
            "Não é possível excluir este contato!" + CRLF + CRLF + ;
            "Existem interações vinculadas a ele." + CRLF + CRLF + ;
            "Exclua primeiro todas as interações.",;
            "?? Integridade Referencial";
            )
    ENDIF

RETURN lPodeExcluir


USER FUNCTION STTIP003DEL()
    LOCAL nOpcao := 0

    IF !U_VALEXCSZ1()
        RETURN NIL
    ENDIF

    nOpcao := AxDeleta("SZ1", SZ1->(Recno()), 5)

RETURN nOpcao


USER FUNCTION EXECUTARSEGURO(bBloco, cMsgErro, lGravaLog, lMostraMsgErro)
    LOCAL lSucesso := .F.
    LOCAL xRetorno := NIL

    DEFAULT cMsgErro := "Ocorreu um erro durante a execução da operação."
    DEFAULT lGravaLog := .T.
    DEFAULT lMostraMsgErro := .T.

    IF bBloco == NIL .OR. ValType(bBloco) != "B"
        MsgAlert("Parâmetro inválido! Esperado um bloco de código.", "Erro")
        RETURN .F.
    ENDIF

    BEGIN SEQUENCE

        xRetorno := Eval(bBloco)

        lSucesso := .T.

        RECOVER WITH oErro

        lSucesso := .F.

        IF lMostraMsgErro
            MsgAlert(;
                cMsgErro + CRLF + CRLF + ;
                "Detalhes técnicos:" + CRLF + ;
                oErro:Description,;
                "?? Erro na Operação";
                )
        ENDIF

        IF lGravaLog
            U_GRAVARLOG("EXECUTARSEGURO - " + cMsgErro, oErro)
        ENDIF

    END SEQUENCE

RETURN lSucesso

USER FUNCTION EXECUTARSEGURORET(bBloco, xValorPadrao, cMsgErro)
    LOCAL xRetorno := xValorPadrao

    DEFAULT cMsgErro := "Erro na execução"

    BEGIN SEQUENCE

        xRetorno := Eval(bBloco)

        RECOVER WITH oErro

        MsgAlert(cMsgErro + CRLF + CRLF + oErro:Description, "Erro")
        U_GRAVARLOG("EXECUTARSEGURORET - " + cMsgErro, oErro)

        xRetorno := xValorPadrao

    END SEQUENCE

RETURN xRetorno


USER FUNCTION STTIP007A()
    LOCAL cCodigo := ""

    cCodigo := Space(6)

    IF !ParamBox(;
            {;
            {1, "Código do Contato", cCodigo, "", "", "SZ1", "", 60, .T.};
            },;
            "Testar Validação de Integridade",;
            @cCodigo;
            )
        RETURN
    ENDIF

    cCodigo := AllTrim(cCodigo)

    dbSelectArea("SZ1")
    dbSetOrder(1)

    IF !dbSeek(xFilial("SZ1") + cCodigo)
        MsgAlert("Contato não encontrado: " + cCodigo, "Aviso")
        RETURN
    ENDIF

    IF U_VALEXCSZ1()
        MsgInfo(;
            "? VALIDAÇÃO PASSOU!" + CRLF + CRLF + ;
            "O contato PODE ser excluído." + CRLF + ;
            "(Não há interações vinculadas)",;
            "Resultado";
            )
    ELSE
        MsgInfo("? A validação IMPEDIU a exclusão!", "Resultado")
    ENDIF

RETURN


USER FUNCTION STTIP007B()
    LOCAL nOpcao := 0
    LOCAL lResultado := .F.

    nOpcao := Aviso(;
        "Teste do Executor Seguro",;
        "Escolha o tipo de operação para testar:",;
        {"Sucesso", "Divisão por Zero", "Array Inválido", "Arquivo Inexistente", "Cancelar"},;
        3;
        )

    DO CASE
        CASE nOpcao == 1
            MsgInfo("Executando operação que vai ter SUCESSO...", "Teste 1")

            lResultado := U_EXECUTARSEGURO(;
                {|| MsgInfo("Operação executada com sucesso!", "Dentro do Bloco")},;
                "Erro inesperado";
                )

            MsgInfo("Resultado: " + IIF(lResultado, "SUCESSO ?", "ERRO ?"), "Teste 1")

        CASE nOpcao == 2
            MsgInfo("Executando operação que vai FALHAR (divisão por zero)...", "Teste 2")

            lResultado := U_EXECUTARSEGURO(;
                {|| TesteDivisaoPorZero()},;
                "Falha ao executar cálculo matemático";
                )

            MsgInfo("Resultado: " + IIF(lResultado, "SUCESSO ?", "ERRO ?"), "Teste 2")

        CASE nOpcao == 3
            MsgInfo("Executando operação que vai FALHAR (array)...", "Teste 3")

            lResultado := U_EXECUTARSEGURO(;
                {|| TesteArrayInvalido()},;
                "Falha ao acessar lista de dados";
                )

            MsgInfo("Resultado: " + IIF(lResultado, "SUCESSO ?", "ERRO ?"), "Teste 3")

        CASE nOpcao == 4
            MsgInfo("Executando operação que vai FALHAR (arquivo)...", "Teste 4")

            lResultado := U_EXECUTARSEGURO(;
                {|| TesteArquivoInexistente()},;
                "Falha ao abrir arquivo de dados";
                )

            MsgInfo("Resultado: " + IIF(lResultado, "SUCESSO ?", "ERRO ?"), "Teste 4")

    ENDCASE

RETURN


STATIC FUNCTION TesteDivisaoPorZero()
    LOCAL nResultado := 0

    nResultado := 100 / 0

RETURN nResultado

STATIC FUNCTION TesteArrayInvalido()
    LOCAL aLista := {1, 2, 3}
    LOCAL xItem := NIL

    xItem := aLista[999]

RETURN xItem

STATIC FUNCTION TesteArquivoInexistente()
    LOCAL nHandle := 0

    nHandle := FOpen("C:\arquivo_que_nao_existe.txt")

    IF nHandle == -1
        BREAK ErrorNew("Arquivo não encontrado!")
    ENDIF

RETURN nHandle


USER FUNCTION STTIP007EX()
    LOCAL nSaldo := 0
    LOCAL cNome := ""
    LOCAL lGravou := .F.

    MsgInfo("Demonstração de usos práticos do EXECUTARSEGURO", "Exemplos")

    nSaldo := U_EXECUTARSEGURORET(;
        {|| CalculaSaldoCliente("000001")},;
        0,;
        "Erro ao calcular saldo do cliente";
        )

    MsgInfo("Saldo calculado: R$ " + Transform(nSaldo, "@E 999,999.99"), "Exemplo 1")


    cNome := U_EXECUTARSEGURORET(;
        {|| POSICIONE("SA1", 1, xFilial("SA1") + "000001", "A1_NOME")},;
        "CLIENTE NÃO ENCONTRADO",;
        "Erro ao buscar nome do cliente";
        )

    MsgInfo("Nome encontrado: " + cNome, "Exemplo 2")


    lGravou := U_EXECUTARSEGURO(;
        {|| GravaRegistroProtegido()},;
        "Falha ao gravar registro no banco de dados";
        )

    IF lGravou
        MsgInfo("Registro gravado com sucesso!", "Exemplo 3")
    ELSE
        MsgInfo("Falha ao gravar (erro foi tratado)", "Exemplo 3")
    ENDIF

RETURN


STATIC FUNCTION CalculaSaldoCliente(cCliente)
    LOCAL nSaldo := 0

    nSaldo := Val(cCliente) * 100

RETURN nSaldo

STATIC FUNCTION GravaRegistroProtegido()
    ConOut("Gravando registro protegido...")
RETURN .T.


USER FUNCTION STTIP007()
    LOCAL nOpcao := 0

    nOpcao := Aviso(;
        "Exercício 7 - Testes",;
        "Escolha qual funcionalidade testar:",;
        {"7a - Integridade Referencial", "7b - Executor Seguro", "Exemplos de Uso", "Cancelar"},;
        3;
        )

    DO CASE
        CASE nOpcao == 1
            U_STTIP007A()

        CASE nOpcao == 2
            U_STTIP007B()

        CASE nOpcao == 3
            U_STTIP007EX()

    ENDCASE

RETURN