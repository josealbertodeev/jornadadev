//=============================================================================
// STTIP003.PRW
// Cadastro de Pets com mBrowse e Legendas Coloridas
// Jornada DEV START - Módulo 8 - Exercício 6
//=============================================================================
// Descrição:
//   Rotina de cadastro (CRUD) para a tabela ZA1 (Pets) utilizando mBrowse
//   com LEGENDAS COLORIDAS para identificar visualmente o status dos pets.

// Legendas:
//   ?? VERMELHO - Pets com nascimento há mais de 10 anos (idosos)
//   ?? AMARELO  - Pets cadastrados hoje
//   ?? VERDE    - Os demais pets (padrão)

// Tabela:
//   ZA1 - Pets do Cliente
//=============================================================================

#include "protheus.ch"

//=============================================================================
// USER FUNCTION STTIP003
// Função principal - Cadastro de Pets com Legendas Coloridas
//=============================================================================
USER FUNCTION STTIP003()

    LOCAL cFiltro := ""     // Filtro inicial (vazio = mostra todos)
    LOCAL aColors := {}     // Array de legendas coloridas

    // Título da janela do cadastro
    PRIVATE cCadastro := "Cadastro de Pets - Com Legendas"

    // Array de botões/opções do menu (aRotina)
    PRIVATE aRotina := {}

    // Monta o array aRotina com as opções padrão
    aAdd(aRotina, {"Pesquisar",  "AxPesqui",  0, 1})  // Pesquisa
    aAdd(aRotina, {"Visualizar", "AxVisual",  0, 2})  // Visualização
    aAdd(aRotina, {"Incluir",    "AxInclui",  0, 3})  // Inclusão
    aAdd(aRotina, {"Alterar",    "AxAltera",  0, 4})  // Alteração
    aAdd(aRotina, {"Excluir",    "AxDeleta",  0, 5})  // Exclusão
    aAdd(aRotina, {"Legenda",    "U_STTIP003LEG", 0, 6})  // Mostra legenda

    //=========================================================================
    // CONFIGURAÇÃO DAS LEGENDAS COLORIDAS (aColors)
    //=========================================================================
    // Cada linha: {"Condição", "Cor"}
    //
    // IMPORTANTE: As regras são avaliadas DE CIMA PARA BAIXO!
    // A primeira regra verdadeira define a cor da linha.
    // Por isso ".T." (sempre verdadeiro) fica POR ÚLTIMO como cor padrão.
    //
    // Cores disponíveis:
    //   BR_RED     = Vermelho
    //   BR_YELLOW  = Amarelo
    //   BR_GREEN   = Verde
    //   BR_BLUE    = Azul
    //   BR_ORANGE  = Laranja
    //   BR_PINK    = Rosa
    //   BR_BROWN   = Marrom
    //   BR_BLACK   = Preto
    //   BR_WHITE   = Branco
    //=========================================================================

    aColors := {}

    // ?? VERMELHO: Pets com nascimento há mais de 10 anos (3650 dias)
    // ou adaptando: há mais de 30 dias para facilitar o teste
    aAdd(aColors, {"ZA1->ZA1_DTNASC < dDataBase - 30", "BR_RED"})

    // ?? AMARELO: Pets cadastrados hoje (data de nascimento = hoje)
    aAdd(aColors, {"ZA1->ZA1_DTNASC == dDataBase", "BR_YELLOW"})

    // ?? VERDE: Todos os demais (regra padrão - sempre por último!)
    aAdd(aColors, {".T.", "BR_GREEN"})

    //=========================================================================
    // ABRE O BROWSE COM AS LEGENDAS
    //=========================================================================

    // Seleciona a tabela ZA1
    dbSelectArea("ZA1")

    // Define o índice de ordenação (1 = ZA1_FILIAL + ZA1_COD)
    dbSetOrder(1)

    // Posiciona no primeiro registro da filial atual
    dbSeek(xFilial("ZA1"))

    // Abre o browse com mBrowse e as legendas coloridas
    // O parâmetro aColors (11º parâmetro) define as cores das linhas
    mBrowse(1, 1, 22, 75, "ZA1", , , , , , aColors, , , , , .F., , , cFiltro)

RETURN NIL


//=============================================================================
// USER FUNCTION STTIP003LEG
// Exibe a tela de legenda (o que significa cada cor)
//=============================================================================
USER FUNCTION STTIP003LEG()

    LOCAL aLegenda := {}

    // Monta o array com as legendas
    // Cada linha: {"Cor", "Descrição"}
    aAdd(aLegenda, {"BR_RED",    "Pets com mais de 30 dias de nascimento (idosos)"})
    aAdd(aLegenda, {"BR_YELLOW", "Pets com data de nascimento hoje"})
    aAdd(aLegenda, {"BR_GREEN",  "Pets normais (padrão)"})

    // Exibe a tela de legenda
    BrwLegenda(cCadastro, "Legenda", aLegenda)

RETURN NIL


//=============================================================================
// EXEMPLOS DE OUTRAS REGRAS DE LEGENDAS
//=============================================================================
/*
// ?? VERMELHO: Pets com mais de 10 anos (real)
aAdd(aColors, {"ZA1->ZA1_DTNASC < dDataBase - 3650", "BR_RED"})

// ?? AMARELO: Pets cadastrados no mês atual
aAdd(aColors, {"Month(ZA1->ZA1_DTNASC) == Month(dDataBase) .AND. Year(ZA1->ZA1_DTNASC) == Year(dDataBase)", "BR_YELLOW"})

// ?? AZUL: Pets de raça específica (ex: "Labrador")
aAdd(aColors, {"AllTrim(ZA1->ZA1_RACA) == 'Labrador'", "BR_BLUE"})

// ?? LARANJA: Pets sem observações
aAdd(aColors, {"Empty(ZA1->ZA1_OBS)", "BR_ORANGE"})

// ?? VERDE: Todos os demais (sempre por último!)
aAdd(aColors, {".T.", "BR_GREEN"})
*/


