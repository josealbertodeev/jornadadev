/*/
===========================================================================
EX07-DESAFIO-INTEGRIDADE-EXECUTOR.PRW - Desafio Opcional
===========================================================================
Descrição: Implementação de duas funcionalidades avançadas:
           7a - Validação de integridade referencial (impede exclusão)
           7b - Executor seguro genérico (tratamento de erros reutilizável)

Funcionalidades:
   7a) U_VALEXCSZ1() - Impede excluir Contato com Interações
   7b) U_EXECUTARSEGURO() - Executa bloco de código com proteção

Autor: Jornada DEV START - Módulo 9 - Exercício 7
===========================================================================
/*/

#INCLUDE "PROTHEUS.CH"


//===========================================================================
// PARTE 7a: INTEGRIDADE REFERENCIAL
//===========================================================================


//===========================================================================
// Função: VALEXCSZ1
// Descrição: Valida se Contato (SZ1) pode ser excluído
//            IMPEDE exclusão se tiver Interações (SZ2) vinculadas
//
// Uso: Configurar no X3_VALID do campo Z1_CODIGO ou no X3_WHEN = .F.
//      OU usar no aRotina antes de AxDeleta
//
// Retorno: .T. se pode excluir, .F. se não pode
//===========================================================================
USER FUNCTION VALEXCSZ1()
    LOCAL lPodeExcluir := .T.
    LOCAL aArea := GetArea()
    LOCAL aAreaSZ2 := SZ2->(GetArea())
    LOCAL cCodigo := ""
    LOCAL nQtdInteracoes := 0

    // Pega o código do contato
    IF Type("SZ1->Z1_CODIGO") != "U"
        cCodigo := SZ1->Z1_CODIGO
    ELSEIF Type("M->Z1_CODIGO") != "U"
        cCodigo := M->Z1_CODIGO
    ELSE
        // Não conseguiu identificar o código
        lPodeExcluir := .F.
        MsgAlert("Não foi possível identificar o código do contato!", "Erro de Validação")
        RestArea(aAreaSZ2)
        RestArea(aArea)
        RETURN lPodeExcluir
    ENDIF

    // Verifica se existem interações vinculadas
    dbSelectArea("SZ2")
    dbSetOrder(1) // Z2_FILIAL + Z2_CONTAT + Z2_SEQUEN

    IF dbSeek(xFilial("SZ2") + cCodigo)
        // Conta quantas interações existem
        WHILE !EOF() .AND. SZ2->Z2_FILIAL == xFilial("SZ2") .AND. ;
                SZ2->Z2_CONTAT == cCodigo

            nQtdInteracoes++
            dbSkip()
        ENDDO

        // Se encontrou interações, NÃO pode excluir
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


//===========================================================================
// Função: VALEXCSZ1V2 (Versão Simplificada)
// Descrição: Versão mais enxuta usando apenas ExistCpo
// Retorno: .T. se pode excluir, .F. se não pode
//===========================================================================
USER FUNCTION VALEXCSZ1V2()
    LOCAL lPodeExcluir := .T.
    LOCAL cCodigo := SZ1->Z1_CODIGO

    // Verifica se existe alguma interação com este contato
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


//===========================================================================
// Função: STTIP003DEL (Exclusão com Validação)
// Descrição: Substitui AxDeleta com validação prévia de integridade
// Uso: Colocar no aRotina no lugar de AxDeleta
//===========================================================================
USER FUNCTION STTIP003DEL()
    LOCAL nOpcao := 0

    // Valida ANTES de chamar a exclusão padrão
    IF !U_VALEXCSZ1()
        // Validação falhou - não pode excluir
        RETURN NIL
    ENDIF

    // Se passou na validação, pode excluir
    nOpcao := AxDeleta("SZ1", SZ1->(Recno()), 5)

RETURN nOpcao


//===========================================================================
// PARTE 7b: EXECUTOR SEGURO GENÉRICO
//===========================================================================


//===========================================================================
// Função: EXECUTARSEGURO
// Descrição: Executa bloco de código com tratamento automático de erros
//
// Parâmetros:
//   bBloco    - Bloco de código a executar {|| MeuCodigo() }
//   cMsgErro  - Mensagem amigável ao usuário se der erro (opcional)
//   lGravaLog - Se .T., grava log de erro (padrão: .T.)
//   lMostraMsgErro - Se .T., exibe MsgAlert ao usuário (padrão: .T.)
//
// Retorno: .T. se executou com sucesso, .F. se houve erro
//
// Exemplos:
//   U_EXECUTARSEGURO({|| AbrirArquivo("dados.dbf")}, "Falha ao abrir dados")
//   U_EXECUTARSEGURO({|| ProcessarPedido()}, "Erro ao processar pedido")
//===========================================================================
USER FUNCTION EXECUTARSEGURO(bBloco, cMsgErro, lGravaLog, lMostraMsgErro)
    LOCAL lSucesso := .F.
    LOCAL xRetorno := NIL

    // Parâmetros padrão
    DEFAULT cMsgErro := "Ocorreu um erro durante a execução da operação."
    DEFAULT lGravaLog := .T.
    DEFAULT lMostraMsgErro := .T.

    // Valida parâmetros
    IF bBloco == NIL .OR. ValType(bBloco) != "B"
        MsgAlert("Parâmetro inválido! Esperado um bloco de código.", "Erro")
        RETURN .F.
    ENDIF

    // Executa o bloco com proteção
    BEGIN SEQUENCE

        // Executa o bloco de código
        xRetorno := Eval(bBloco)

        // Se chegou aqui, executou com sucesso
        lSucesso := .T.

        RECOVER WITH oErro

        // Erro capturado!
        lSucesso := .F.

        // Exibe mensagem amigável ao usuário
        IF lMostraMsgErro
            MsgAlert(;
                cMsgErro + CRLF + CRLF + ;
                "Detalhes técnicos:" + CRLF + ;
                oErro:Description,;
                "?? Erro na Operação";
                )
        ENDIF

        // Grava log técnico
        IF lGravaLog
            U_GRAVARLOG("EXECUTARSEGURO - " + cMsgErro, oErro)
        ENDIF

    END SEQUENCE

RETURN lSucesso


//===========================================================================
// Função: EXECUTARSEGURORET (Com Retorno)
// Descrição: Similar ao EXECUTARSEGURO, mas retorna o valor do bloco
//
// Parâmetros:
//   bBloco       - Bloco de código a executar
//   xValorPadrao - Valor a retornar em caso de erro
//   cMsgErro     - Mensagem de erro (opcional)
//
// Retorno: Resultado do bloco ou xValorPadrao se erro
//
// Exemplos:
//   nSaldo := U_EXECUTARSEGURORET({|| CalculaSaldo()}, 0, "Erro ao calcular saldo")
//   cNome  := U_EXECUTARSEGURORET({|| BuscaNome()}, "DESCONHECIDO", "Erro ao buscar nome")
//===========================================================================
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


//===========================================================================
// EXEMPLOS DE USO
//===========================================================================


//===========================================================================
// Função: TESTE_INTEGRIDADE
// Descrição: Testa a validação de integridade referencial
//===========================================================================
USER FUNCTION STTIP007A()
    LOCAL cCodigo := ""

    // Solicita código do contato
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

    // Posiciona no contato
    dbSelectArea("SZ1")
    dbSetOrder(1)

    IF !dbSeek(xFilial("SZ1") + cCodigo)
        MsgAlert("Contato não encontrado: " + cCodigo, "Aviso")
        RETURN
    ENDIF

    // Testa a validação
    IF U_VALEXCSZ1()
        MsgInfo(;
            "? VALIDAÇÃO PASSOU!" + CRLF + CRLF + ;
            "O contato PODE ser excluído." + CRLF + ;
            "(Não há interações vinculadas)",;
            "Resultado";
            )
    ELSE
        // A própria função já exibiu a mensagem de erro
        // Aqui só confirmamos
        MsgInfo("? A validação IMPEDIU a exclusão!", "Resultado")
    ENDIF

RETURN


//===========================================================================
// Função: TESTE_EXECUTOR
// Descrição: Testa o executor seguro genérico
//===========================================================================
USER FUNCTION STTIP007B()
    LOCAL nOpcao := 0
    LOCAL lResultado := .F.

    // Menu de testes
    nOpcao := Aviso(;
        "Teste do Executor Seguro",;
        "Escolha o tipo de operação para testar:",;
        {"Sucesso", "Divisão por Zero", "Array Inválido", "Arquivo Inexistente", "Cancelar"},;
        3;
        )

    DO CASE
        CASE nOpcao == 1
            // Teste 1: Operação com SUCESSO
            MsgInfo("Executando operação que vai ter SUCESSO...", "Teste 1")

            lResultado := U_EXECUTARSEGURO(;
                {|| MsgInfo("Operação executada com sucesso!", "Dentro do Bloco")},;
                "Erro inesperado";
                )

            MsgInfo("Resultado: " + IIF(lResultado, "SUCESSO ?", "ERRO ?"), "Teste 1")

        CASE nOpcao == 2
            // Teste 2: Divisão por ZERO (erro)
            MsgInfo("Executando operação que vai FALHAR (divisão por zero)...", "Teste 2")

            lResultado := U_EXECUTARSEGURO(;
                {|| TesteDivisaoPorZero()},;
                "Falha ao executar cálculo matemático";
                )

            MsgInfo("Resultado: " + IIF(lResultado, "SUCESSO ?", "ERRO ?"), "Teste 2")

        CASE nOpcao == 3
            // Teste 3: Array inválido
            MsgInfo("Executando operação que vai FALHAR (array)...", "Teste 3")

            lResultado := U_EXECUTARSEGURO(;
                {|| TesteArrayInvalido()},;
                "Falha ao acessar lista de dados";
                )

            MsgInfo("Resultado: " + IIF(lResultado, "SUCESSO ?", "ERRO ?"), "Teste 3")

        CASE nOpcao == 4
            // Teste 4: Arquivo inexistente
            MsgInfo("Executando operação que vai FALHAR (arquivo)...", "Teste 4")

            lResultado := U_EXECUTARSEGURO(;
                {|| TesteArquivoInexistente()},;
                "Falha ao abrir arquivo de dados";
                )

            MsgInfo("Resultado: " + IIF(lResultado, "SUCESSO ?", "ERRO ?"), "Teste 4")

    ENDCASE

RETURN


//===========================================================================
// Funções auxiliares para testes
//===========================================================================

STATIC FUNCTION TesteDivisaoPorZero()
    LOCAL nResultado := 0

    nResultado := 100 / 0  // ERRO!

RETURN nResultado

STATIC FUNCTION TesteArrayInvalido()
    LOCAL aLista := {1, 2, 3}
    LOCAL xItem := NIL

    xItem := aLista[999]  // ERRO!

RETURN xItem

STATIC FUNCTION TesteArquivoInexistente()
    LOCAL nHandle := 0

    nHandle := FOpen("C:\arquivo_que_nao_existe.txt")

    IF nHandle == -1
        BREAK ErrorNew("Arquivo não encontrado!")
    ENDIF

RETURN nHandle


//===========================================================================
// Função: EXEMPLO_USO_REAL
// Descrição: Exemplos práticos de uso do EXECUTARSEGURO em cenários reais
//===========================================================================
USER FUNCTION STTIP007EX()
    LOCAL nSaldo := 0
    LOCAL cNome := ""
    LOCAL lGravou := .F.

    MsgInfo("Demonstração de usos práticos do EXECUTARSEGURO", "Exemplos")

    // Exemplo 1: Cálculo com valor padrão se erro
    nSaldo := U_EXECUTARSEGURORET(;
        {|| CalculaSaldoCliente("000001")},;
        0,;  // Valor padrão se erro
        "Erro ao calcular saldo do cliente";
        )

    MsgInfo("Saldo calculado: R$ " + Transform(nSaldo, "@E 999,999.99"), "Exemplo 1")


    // Exemplo 2: Busca de dados com valor padrão
    cNome := U_EXECUTARSEGURORET(;
        {|| POSICIONE("SA1", 1, xFilial("SA1") + "000001", "A1_NOME")},;
        "CLIENTE NÃO ENCONTRADO",;
        "Erro ao buscar nome do cliente";
        )

    MsgInfo("Nome encontrado: " + cNome, "Exemplo 2")


    // Exemplo 3: Gravação protegida
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


//===========================================================================
// Funções auxiliares para exemplos
//===========================================================================

STATIC FUNCTION CalculaSaldoCliente(cCliente)
    LOCAL nSaldo := 0

    // Simula cálculo que pode dar erro
    nSaldo := Val(cCliente) * 100

RETURN nSaldo

STATIC FUNCTION GravaRegistroProtegido()
    // Simula gravação
    ConOut("Gravando registro protegido...")
RETURN .T.


//===========================================================================
// MENU PRINCIPAL DE TESTES
//===========================================================================
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


//===========================================================================
// FIM DE EX07-DESAFIO-INTEGRIDADE-EXECUTOR.PRW
//===========================================================================
