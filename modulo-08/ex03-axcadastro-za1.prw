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


//=============================================================================
// OBSERVAÇÕES IMPORTANTES
//=============================================================================
//
// 1. O AxCadastro cria automaticamente:
//    - Browse com listagem dos pets
//    - Botões: Pesquisar, Visualizar, Incluir, Alterar, Excluir
//    - Formulário de inclusão/alteração com todos os campos do SX3
//    - Validações configuradas no dicionário (SX3)
//
// 2. Campo Virtual ZA1_NOMCLI:
//    - Aparece no formulário mas NÃO é gravado
//    - É calculado automaticamente pela relação no SX3:
//      POSICIONE("SA1",1,xFilial("SA1")+M->ZA1_CLIENT+M->ZA1_LOJA,"A1_NOME")
//    - Mostra o nome do cliente (dono) assim que ZA1_CLIENT e ZA1_LOJA 
//      são preenchidos
//
// 3. Validações:
//    - Se configurou ExistCpo no X3_VALID de ZA1_CLIENT, o sistema valida
//      automaticamente se o cliente existe na SA1
//    - Se configurou ExistChav no X3_VALID de ZA1_COD, o sistema impede
//      códigos duplicados
//
// 4. Para incluir no menu do Protheus:
//    - Abrir Configurador > Menu do Sistema
//    - Selecionar o módulo (ex: SIGACOM)
//    - Incluir item: Texto = "Pets", Função = STTIP001
//
// 5. Próximos passos (exercícios seguintes):
//    - Ex. 4: Adicionar validação com ExistCpo
//    - Ex. 5: Refazer com mBrowse (mais profissional)
//    - Ex. 6: Adicionar legendas coloridas
//    - Ex. 7: Configurar gatilho do CEP
//
//=============================================================================
