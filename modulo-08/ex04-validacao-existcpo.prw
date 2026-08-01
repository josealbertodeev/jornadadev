//=============================================================================
// VALCLI001.PRW (ou pode incluir no STTIP001.PRW)
// Validação de Cliente com ExistCpo
// Jornada DEV START - Módulo 8 - Exercício 4
//=============================================================================
// Descrição:
//   Função de validação para o campo ZA1_CLIENT que verifica se o cliente
//   (dono do pet) existe na tabela SA1 (Cadastro de Clientes).
//   Utiliza a função ExistCpo para validar a existência do registro.
//
// Configuração no Dicionário (SX3):
//   Campo: ZA1_CLIENT
//   X3_VALID = "U_VALCLI001()"
//
//   OU configurar direto no X3_VALID sem USER FUNCTION:
//   X3_VALID = "ExistCpo('SA1',xFilial('SA1')+M->ZA1_CLIENT+M->ZA1_LOJA,1)"
//
// Como funciona:
//   - Quando o usuário sai do campo ZA1_CLIENT, a validação é executada
//   - Se o cliente NÃO existe na SA1, exibe mensagem e não deixa prosseguir
//   - Se o cliente existe, permite continuar o cadastro
//=============================================================================

#include "protheus.ch"

//=============================================================================
// USER FUNCTION VALCLI001
// Valida se o cliente existe na tabela SA1
//=============================================================================
// Retorno:
//   .T. - Cliente existe, validação OK
//   .F. - Cliente não existe, bloqueia o campo
//=============================================================================
USER FUNCTION VALCLI001()
    
    LOCAL lRetorno := .T.
    
    // Verifica se o cliente existe na SA1
    // Parâmetros do ExistCpo:
    //   1. "SA1" - Alias da tabela a verificar
    //   2. xFilial("SA1")+M->ZA1_CLIENT+M->ZA1_LOJA - Chave de busca
    //   3. 1 - Número do índice a usar (índice 1 da SA1)
    //
    // M-> acessa o valor que está sendo digitado no formulário
    // (antes de gravar no banco)
    
    IF !ExistCpo("SA1", xFilial("SA1") + M->ZA1_CLIENT + M->ZA1_LOJA, 1)
        // Cliente não encontrado na SA1
        MsgAlert("Cliente não cadastrado na SA1!", "Atenção")
        lRetorno := .F.
    ENDIF
    
RETURN lRetorno
