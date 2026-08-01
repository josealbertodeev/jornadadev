/*/
===========================================================================
STTIP003.PRW - Cadastro de Contatos (SZ1) com mBrowse e Legendas
===========================================================================
Descrição: Rotina principal de cadastro de contatos usando mBrowse
           profissional com legendas coloridas e botão para interações

Funcionalidades:
   - Cadastro completo de contatos (CRUD)
   - Legendas coloridas por status do contato
   - Botão "Interações" para visualizar/gerenciar interações

Legendas:
   ?? Azul     - Sem Interação (nunca teve contato)
   ?? Verde    - Quente (última interação <= 7 dias)
   ?? Amarelo  - Ativo (última interação 8-30 dias)
   ?? Laranja  - Frio (última interação 31-90 dias)
   ?? Vermelho - Inativo (última interação > 90 dias)
===========================================================================
/*/

#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"

//===========================================================================
// Função Principal: STTIP003
// Descrição: Abre o browse de contatos com legendas e opções de CRUD
//===========================================================================
USER FUNCTION STTIP003()
    LOCAL aArea := GetArea()
    LOCAL aColors := {}
    LOCAL cFiltro := ""

    PRIVATE aRotina := {}

    // Define os botões do menu (aRotina)
    aRotina := {;
        {"Pesquisar",  "AxPesqui",        0, 1},;
        {"Visualizar", "AxVisual",        0, 2},;
        {"Incluir",    "AxInclui",        0, 3},;
        {"Alterar",    "AxAltera",        0, 4},;
        {"Excluir",    "AxDeleta",        0, 5},;
        {"Interações", "U_STTIP003INT",   0, 6},;
        {"Legenda",    "U_STTIP003LEG",   0, 7};
        }

    // Define as cores das legendas
    // Ordem IMPORTANTÍSSIMA: condição .T. deve ser a ÚLTIMA!
    aColors := {;
        {"U_SZ1STATUS() == 'Inativo'",       "BR_VERMELHO"},;
        {"U_SZ1STATUS() == 'Frio'",          "BR_LARANJA"},;
        {"U_SZ1STATUS() == 'Ativo'",         "BR_AMARELO"},;
        {"U_SZ1STATUS() == 'Quente'",        "BR_VERDE"},;
        {"U_SZ1STATUS() == 'Sem Interação'", "BR_AZUL"},;
        {".T.",                              "BR_BRANCO"};
        }

    // Seleciona a tabela
    dbSelectArea("SZ1")
    dbSetOrder(1) // Z1_FILIAL + Z1_CODIGO

    // Abre o Browse
    mBrowse(1, 1, 22, 75, "SZ1", , , , , , aColors, , , , , , , , cFiltro)

    RestArea(aArea)
RETURN


//===========================================================================
// Função: STTIP003LEG
// Descrição: Exibe a janela de legendas do browse
//===========================================================================
USER FUNCTION STTIP003LEG()
    LOCAL aLegenda := {}

    aLegenda := {;
        {"BR_AZUL",     "Sem Interação - Nunca teve contato"},;
        {"BR_VERDE",    "Quente - Última interação <= 7 dias"},;
        {"BR_AMARELO",  "Ativo - Última interação 8-30 dias"},;
        {"BR_LARANJA",  "Frio - Última interação 31-90 dias"},;
        {"BR_VERMELHO", "Inativo - Última interação > 90 dias"};
        }

    BrwLegenda("Status dos Contatos", "Legenda", aLegenda)
RETURN


//===========================================================================
// Função: STTIP003INT
// Descrição: Abre o browse de interações do contato selecionado
//===========================================================================
USER FUNCTION STTIP003INT()
    LOCAL cCodigo := SZ1->Z1_CODIGO
    LOCAL cNome := AllTrim(SZ1->Z1_NOME)

    IF Empty(cCodigo)
        MsgAlert("Nenhum contato selecionado!", "Atenção")
        RETURN
    ENDIF

    // Chama a rotina de interações passando o código do contato
    U_STTIP004(cCodigo, cNome)
RETURN


//===========================================================================
// FIM DE STTIP003.PRW
//===========================================================================
