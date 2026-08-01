//=============================================================================
// STTIP002.PRW
// Cadastro de Pets com mBrowse (versão profissional)
// Jornada DEV START - Módulo 8 - Exercício 5
//=============================================================================
// Descrição:
//   Rotina de cadastro (CRUD) para a tabela ZA1 (Pets) utilizando mBrowse.
//   Esta é a versão profissional do STTIP001 - oferece mais controle e
//   recursos avançados como legendas coloridas, filtros dinâmicos e
//   personalização completa da interface.
//
// Diferenças entre STTIP001 (AxCadastro) e STTIP002 (mBrowse):
//   - mBrowse: mais código, mais controle, legendas, filtros avançados
//   - AxCadastro: menos código, automático, limitado
//
// Uso:
//   - Compilar com F9
//   - Executar via SmartClient: Miscelânea > Execução > Programa > STTIP002
//
// Tabela:
//   ZA1 - Pets do Cliente (mesma do STTIP001)
//=============================================================================

#include "protheus.ch"

//=============================================================================
// USER FUNCTION STTIP002
// Função principal - Cadastro de Pets com mBrowse
//=============================================================================
USER FUNCTION STTIP002()
    
    LOCAL cFiltro := ""  // Filtro inicial (vazio = mostra todos)
    
    // Título da janela do cadastro
    PRIVATE cCadastro := "Cadastro de Pets (mBrowse)"
    
    // Array de botões/opções do menu (aRotina)
    // Cada linha: {"Texto do botão", "Função a chamar", Reservado, Tipo}
    // Tipos: 1=Pesquisar, 2=Visualizar, 3=Incluir, 4=Alterar, 5=Excluir, 6=Customizado
    PRIVATE aRotina := {}
    
    // Monta o array aRotina com as opções padrão
    aAdd(aRotina, {"Pesquisar",  "AxPesqui",  0, 1})  // Tipo 1 = Pesquisa
    aAdd(aRotina, {"Visualizar", "AxVisual",  0, 2})  // Tipo 2 = Visualização
    aAdd(aRotina, {"Incluir",    "AxInclui",  0, 3})  // Tipo 3 = Inclusão
    aAdd(aRotina, {"Alterar",    "AxAltera",  0, 4})  // Tipo 4 = Alteração
    aAdd(aRotina, {"Excluir",    "AxDeleta",  0, 5})  // Tipo 5 = Exclusão
    
    // Seleciona a tabela ZA1
    dbSelectArea("ZA1")
    
    // Define o índice de ordenação (1 = ZA1_FILIAL + ZA1_COD)
    dbSetOrder(1)
    
    // Posiciona no primeiro registro da filial atual
    dbSeek(xFilial("ZA1"))
    
    // Abre o browse com mBrowse
    // Parâmetros principais:
    //   nLin1, nCol1, nLin2, nCol2 - Posição na tela (1,1,22,75 = padrão)
    //   cAlias - Tabela ("ZA1")
    //   aFixe - Colunas fixas (NIL = nenhuma)
    //   cCpo - Campos do browse (vazio = todos do SX3)
    //   ... (vários parâmetros opcionais)
    //   aColors - Legendas coloridas (NIL neste exercício, será no Ex.6)
    //   ... (mais parâmetros)
    //   cFiltro - Expressão de filtro
    mBrowse(1, 1, 22, 75, "ZA1", , , , , , , , , , , .F., , , cFiltro)

RETURN NIL
