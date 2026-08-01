/*/
===========================================================================
STTIP004.PRW - Cadastro de Interações (SZ2) Filtrado por Contato
===========================================================================
Descrição: Rotina de cadastro de interações vinculadas a um contato
           específico usando mBrowse com filtro dinâmico

Funcionalidades:
   - Cadastro de interações (CRUD) filtrado por contato
   - Validação automática do código do contato
   - Inicialização automática da sequência
   - Exibição do nome do contato no título

Chamada: U_STTIP004(cCodContato, cNomeContato)

Parâmetros:
   cCodContato  - Código do contato (SZ1)
   cNomeContato - Nome do contato (opcional, para exibição)
===========================================================================
/*/

#INCLUDE "PROTHEUS.CH"

// Variáveis estáticas para manter o filtro entre chamadas
STATIC cContatoAtual := ""
STATIC cNomeContatoAtual := ""


//===========================================================================
// Função Principal: STTIP004
// Descrição: Abre o browse de interações filtrado pelo contato
// Parâmetros: cCodContato - Código do contato (obrigatório)
//             cNomeContato - Nome do contato (opcional)
//===========================================================================
USER FUNCTION STTIP004(cCodContato, cNomeContato)
    LOCAL aArea := GetArea()
    LOCAL cFiltro := ""
    LOCAL cTitulo := ""

    PRIVATE aRotina := {}

    // Parâmetros
    DEFAULT cCodContato := ""
    DEFAULT cNomeContato := ""

    // Validação
    IF Empty(cCodContato)
        MsgAlert("Código do contato não informado!", "Erro")
        RETURN
    ENDIF

    // Se não passou o nome, busca na tabela
    IF Empty(cNomeContato)
        cNomeContato := U_NomeCliente(cCodContato)
    ENDIF

    // Armazena nas variáveis estáticas
    cContatoAtual := cCodContato
    cNomeContatoAtual := cNomeContato

    // Define os botões do menu (aRotina)
    aRotina := {;
        {"Pesquisar",  "AxPesqui",  0, 1},;
        {"Visualizar", "AxVisual",  0, 2},;
        {"Incluir",    "U_STTIP004INC",  0, 3},;
        {"Alterar",    "AxAltera",  0, 4},;
        {"Excluir",    "AxDeleta",  0, 5};
        }

    // Define o filtro para o contato atual
    cFiltro := "Z2_FILIAL == '" + xFilial("SZ2") + "' .AND. "
    cFiltro += "Z2_CONTAT == '" + cContatoAtual + "'"

    // Título do browse
    cTitulo := "Interações - Contato: " + cContatoAtual + " - " + cNomeContatoAtual

    // Seleciona a tabela
    dbSelectArea("SZ2")
    dbSetOrder(1) // Z2_FILIAL + Z2_CONTAT + Z2_SEQUEN

    // Aplica o filtro
    SET FILTER TO &cFiltro

    // Posiciona no primeiro registro do contato
    dbSeek(xFilial("SZ2") + cContatoAtual)

    // Abre o Browse
    mBrowse(1, 1, 22, 75, "SZ2", , , , , , , cTitulo)

    // Remove o filtro ao sair
    SET FILTER TO

    RestArea(aArea)
RETURN


//===========================================================================
// Função: STTIP004INC
// Descrição: Inclusão de interação com código do contato pré-preenchido
//===========================================================================
USER FUNCTION STTIP004INC()
    LOCAL aArea := GetArea()
    LOCAL nOpcao := 0

    // Inclui forçando o contato atual
    // Usa AxInclui mas com inicialização controlada

    // Cria variáveis de memória com valores padrão
    PRIVATE M->Z2_FILIAL  := xFilial("SZ2")
    PRIVATE M->Z2_CONTAT  := cContatoAtual
    PRIVATE M->Z2_SEQUEN  := U_ProxSequenSZ2(cContatoAtual)
    PRIVATE M->Z2_DATA    := Date()
    PRIVATE M->Z2_HORA    := Time()
    PRIVATE M->Z2_USUARIO := RetCodUsr()

    // Chama a função padrão de inclusão
    nOpcao := AxInclui("SZ2", , 3)

    // Se confirmou a inclusão, atualiza o browse
    IF nOpcao == 1
        dbSelectArea("SZ2")
        dbSetOrder(1)
        dbSeek(xFilial("SZ2") + cContatoAtual)
    ENDIF

    RestArea(aArea)
RETURN


//===========================================================================
// Função: STTIP004VAL
// Descrição: Validação para garantir que o contato não seja alterado
//            (Usar no X3_WHEN do campo Z2_CONTAT = .F.)
//===========================================================================
USER FUNCTION STTIP004VAL()
    LOCAL lRet := .T.

    // Se estiver incluindo, força o contato atual
    IF INCLUI
        M->Z2_CONTAT := cContatoAtual
        lRet := .F. // Não permite alteração
    ELSEIF ALTERA
        // Na alteração, não permite mudar o contato
        IF M->Z2_CONTAT != SZ2->Z2_CONTAT
            MsgAlert("Não é permitido alterar o contato da interação!", "Validação")
            M->Z2_CONTAT := SZ2->Z2_CONTAT
            lRet := .F.
        ENDIF
    ENDIF
RETURN lRet


//===========================================================================
// FIM DE STTIP004.PRW
//===========================================================================
