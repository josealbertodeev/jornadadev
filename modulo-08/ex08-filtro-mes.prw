//=============================================================================
// STTIP004.PRW
// CRUD de Pets com mBrowse + Legendas + Filtro do Mês + Botão Customizado
// Jornada DEV START - Módulo 8 - Exercício 8 (Opcional/Bônus)
//=============================================================================
// Descrição:
//   Evolução do STTIP003 adicionando:
//   - Filtro para mostrar apenas pets cadastrados no mês/ano atual
//   - Botão customizado para ativar/desativar o filtro
//
// O que mudou em relação ao STTIP003:
//   1. Variável STATIC para controlar se filtro está ativo
//   2. Função U_STTIP004FLT() para alternar filtro
//   3. Botão "Filtro Mês" no aRotina (tipo 6)
//   4. cFiltro dinâmico que muda conforme botão
//
// Como usar:
//   - Executar U_STTIP004 no SmartClient
//   - Browse mostra todos os pets (filtro desativado por padrão)
//   - Clicar no botão "Filtro Mês" para mostrar só pets do mês atual
//   - Clicar novamente para desativar o filtro
//=============================================================================

#include "protheus.ch"
#include "colors.ch"

//=============================================================================
// Variável STATIC - mantém valor entre chamadas
//=============================================================================
STATIC lFiltroAtivo := .F.  // Controla se filtro do mês está ativo


//=============================================================================
// USER FUNCTION STTIP004
// Cadastro de Pets com mBrowse + Legendas + Filtro do Mês
//=============================================================================
USER FUNCTION STTIP004()

    LOCAL aArea := GetArea()
    LOCAL cFiltro := ""

    // Array de botões (menu) - mesma estrutura do STTIP003 + botão Filtro
    PRIVATE aRotina := {}

    aAdd(aRotina, {"Pesquisar",  "AxPesqui",   0, 1})  // 1=Pesquisar
    aAdd(aRotina, {"Visualizar", "AxVisual",   0, 2})  // 2=Visualizar
    aAdd(aRotina, {"Incluir",    "AxInclui",   0, 3})  // 3=Incluir
    aAdd(aRotina, {"Alterar",    "AxAltera",   0, 4})  // 4=Alterar
    aAdd(aRotina, {"Excluir",    "AxDeleta",   0, 5})  // 5=Excluir
    aAdd(aRotina, {"Legenda",    "U_STTIP004LEG", 0, 6})  // 6=Outros (Legenda)
    aAdd(aRotina, {"Filtro Mês", "U_STTIP004FLT", 0, 6})  // 6=Outros (Filtro)

    // Posiciona na tabela ZA1
    dbSelectArea("ZA1")
    dbSetOrder(1)  // ZA1_FILIAL + ZA1_COD
    dbGoTop()

    //=========================================================================
    // Filtro inicial: desativado (mostra todos)
    //=========================================================================
    lFiltroAtivo := .F.
    cFiltro := ""

    //=========================================================================
    // Chama mBrowse com legendas coloridas e filtro
    //=========================================================================
    mBrowse(;
        1,                      ;  // Linha inicial (top)
        1,                      ;  // Coluna inicial (left)
        22,                     ;  // Linha final (bottom)
        75,                     ;  // Coluna final (right)
        "ZA1",                  ;  // Alias da tabela
        ,                       ;  // Campos a mostrar (vazio = todos)
        ,                       ;  // Campo para top (vazio = primeiro registro)
        ,                       ;  // Registro inicial (vazio = primeiro)
        ,                       ;  // Expressão de filtro
        ,                       ;  // Expressão de pesquisa
        ;                       ;  // Cores das linhas (array) - usaremos AddLegend
        "Cadastro de Pets",     ;  // Título da janela
        cFiltro,                ;  // Filtro inicial (vazio = todos)
        ,                       ;  // Alias para consulta padrão
        ,                       ;  // Apresenta deletados?
        ,                       ;  // Função executada ao mudar registro
        ,                       ;  // Colunas
        ,                       ;  // Função para duplo clique
        ,                       ;  // Apresenta menu?
        ,                       ;  // Filtro permanente
        .F.                     ;  // Apresenta coluna de legenda?
        )

    RestArea(aArea)

RETURN NIL


//=============================================================================
// USER FUNCTION STTIP004LEG
// Exibe a janela de legenda das cores
//=============================================================================
USER FUNCTION STTIP004LEG()

    LOCAL aLegenda := {}

    aAdd(aLegenda, {"BR_VERMELHO", "Pet com mais de 30 dias de vida"})
    aAdd(aLegenda, {"BR_AMARELO",  "Pet nascido hoje"})
    aAdd(aLegenda, {"BR_VERDE",    "Pet com até 30 dias de vida"})

    BrwLegenda("Legenda de Pets", "Status", aLegenda)

RETURN NIL


//=============================================================================
// USER FUNCTION STTIP004FLT
// Alterna o filtro do mês (ativa/desativa)
//=============================================================================
USER FUNCTION STTIP004FLT()

    LOCAL cMesAno := ""
    LOCAL cMensagem := ""

    // Inverte o estado do filtro
    lFiltroAtivo := !lFiltroAtivo

    IF lFiltroAtivo
        //=====================================================================
        // ATIVAR FILTRO: Mostrar apenas pets do mês/ano atual
        //=====================================================================

        // Monta string com mês/ano atual (ex: "202608" para agosto/2026)
        cMesAno := SubStr(DTOS(dDataBase), 1, 6)  // YYYYMM

        // Aplica filtro na tabela
        dbSelectArea("ZA1")
        Set Filter To SubStr(DTOS(ZA1->ZA1_DTNASC), 1, 6) == cMesAno
        dbGoTop()

        cMensagem := "Filtro ATIVADO!" + CRLF + CRLF
        cMensagem += "Mostrando apenas pets nascidos em:" + CRLF
        cMensagem += MesExtenso(Month(dDataBase)) + "/" + AllTrim(Str(Year(dDataBase)))
        cMensagem += CRLF + CRLF
        cMensagem += "Clique novamente para desativar o filtro."

        MsgInfo(cMensagem, "Filtro do Mês - ATIVO")

    ELSE
        //=====================================================================
        // DESATIVAR FILTRO: Mostrar todos os pets
        //=====================================================================

        // Remove filtro da tabela
        dbSelectArea("ZA1")
        Set Filter To
        dbGoTop()

        cMensagem := "Filtro DESATIVADO!" + CRLF + CRLF
        cMensagem += "Mostrando todos os pets cadastrados."
        cMensagem += CRLF + CRLF
        cMensagem += "Clique novamente para ativar o filtro."

        MsgInfo(cMensagem, "Filtro do Mês - INATIVO")

    ENDIF

RETURN NIL


//=============================================================================
// Função para definir as legendas (cores das linhas)
// Esta função é chamada automaticamente pelo mBrowse para cada registro
//=============================================================================
STATIC FUNCTION MenuDef()
    // Esta função não é usada aqui porque usamos PRIVATE aRotina
    // Mas alguns desenvolvedores preferem usar MenuDef() ao invés de aRotina
RETURN aRotina
