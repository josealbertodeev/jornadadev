//=============================================================================
// STTIP001.PRW
// Cadastro de Pets com AxCadastro
// Jornada DEV START - Módulo 8 - Exercício 3
//=============================================================================

// Tabela:
//   ZA1 - Pets do Cliente
//     ZA1_FILIAL - Filial
//     ZA1_COD    - Código do pet
//     ZA1_CLIENT - Código do cliente (dono)
//     ZA1_LOJA   - Loja do cliente
//     ZA1_NOMCLI - Nome do cliente (Virtual - calculado)
//     ZA1_NOME   - Nome do pet
//     ZA1_RACA   - Raça do pet
//     ZA1_DTNASC - Data de nascimento
//     ZA1_OBS    - Observações
//=============================================================================

#include "protheus.ch"

//=============================================================================
// USER FUNCTION STTIP001
// Função principal - Cadastro de Pets
//=============================================================================

USER FUNCTION STTIP001()
    
    // Título que aparece na janela do cadastro
    PRIVATE cCadastro := "Cadastro de Pets"
    
    // Seleciona a tabela ZA1 (Pets)
    dbSelectArea("ZA1")
    
    // Define a ordem de navegação (índice 1 = ZA1_FILIAL + ZA1_COD)
    dbSetOrder(1)
    
    // Posiciona no primeiro registro da filial atual
    dbSeek(xFilial("ZA1"))
    
    // Abre o cadastro com AxCadastro
    // Parâmetros:
    //   "ZA1"     - Alias da tabela
    //   "Pets"    - Título da tela
    //   ""        - Campos (vazio = usa todos do SX3)
    //   "1"       - Número do índice de ordenação
    //   ""        - Busca (vazio = default)
    //   ""        - Delta (vazio = default)
    //   ""        - Delta Memo (vazio = default)
    //   .F.       - Não usar memoria
    AxCadastro("ZA1", "Pets", , "1", , , , .F.)

RETURN NIL

