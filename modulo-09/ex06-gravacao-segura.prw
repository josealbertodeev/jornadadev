/*/
===========================================================================
EX06-GRAVACAO-SEGURA.PRW - Gravação à Prova de Falhas
===========================================================================
Descrição: Implementação robusta de gravação de dados com tratamento
           completo de erros usando transações e BEGIN SEQUENCE

Funcionalidades:
   - Validação prévia dos dados
   - Gravação dentro de transação (BeginTran/CommitTran/RollBackTran)
   - Tratamento de erros com BEGIN SEQUENCE / RECOVER
   - Log automático de erros
   - Mensagens amigáveis ao usuário
   - Garantia de integridade (tudo ou nada)

Autor: Jornada DEV START - Módulo 9 - Exercício 6
===========================================================================
/*/

#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


//===========================================================================
// Função: STTIP003SALVAR
// Descrição: Grava registro de contato (SZ1) com tratamento robusto de erros
// Parâmetros: Nenhum (usa variáveis M->)
// Retorno: .T. se gravou com sucesso, .F. se houve erro
//===========================================================================
USER FUNCTION STTIP003SALVAR()
    LOCAL lRet := .F.
    LOCAL aArea := GetArea()
    LOCAL aAreaSZ1 := SZ1->(GetArea())
    
    //-----------------------------------------------------------------------
    // ETAPA 1: VALIDAÇÃO PRÉVIA
    //-----------------------------------------------------------------------
    // Valida os dados ANTES de tentar gravar
    // Se algo estiver errado, nem inicia a transação
    //-----------------------------------------------------------------------
    
    BEGIN SEQUENCE
        
        // Validação 1: Código do contato
        IF Empty(M->Z1_CODIGO)
            BREAK ErrorNew("O código do contato é obrigatório!")
        ENDIF
        
        // Validação 2: Nome do contato
        IF Empty(M->Z1_NOME)
            BREAK ErrorNew("O nome do contato é obrigatório!")
        ENDIF
        
        // Validação 3: Email (se preenchido, deve ser válido)
        IF !Empty(M->Z1_EMAIL) .AND. !U_VALEMAIL(M->Z1_EMAIL)
            BREAK ErrorNew("Email inválido!")
        ENDIF
        
        // Validação 4: Data de cadastro
        IF Empty(M->Z1_DTCAD)
            BREAK ErrorNew("A data de cadastro é obrigatória!")
        ENDIF
        
        //-------------------------------------------------------------------
        // ETAPA 2: GRAVAÇÃO COM TRANSAÇÃO
        //-------------------------------------------------------------------
        // BeginTran() = Inicia transação
        // Se der erro, RollBackTran() desfaz TUDO
        // Se der certo, CommitTran() confirma TUDO
        //-------------------------------------------------------------------
        
        BeginTran()  // INICIA TRANSAÇÃO
        
        BEGIN SEQUENCE
            
            // Tenta bloquear o registro para gravação
            dbSelectArea("SZ1")
            dbSetOrder(1) // Z1_FILIAL + Z1_CODIGO
            
            IF INCLUI
                // Inclusão: adiciona novo registro
                RecLock("SZ1", .T.)  // .T. = novo registro
            ELSE
                // Alteração: bloqueia registro existente
                IF !dbSeek(xFilial("SZ1") + M->Z1_CODIGO)
                    BREAK ErrorNew("Registro não encontrado para alteração!")
                ENDIF
                
                RecLock("SZ1", .F.)  // .F. = altera existente
            ENDIF
            
            // Grava os campos
            SZ1->Z1_FILIAL  := xFilial("SZ1")
            SZ1->Z1_CODIGO  := M->Z1_CODIGO
            SZ1->Z1_NOME    := M->Z1_NOME
            SZ1->Z1_EMAIL   := M->Z1_EMAIL
            SZ1->Z1_TELEFON := M->Z1_TELEFON
            SZ1->Z1_EMPRESA := M->Z1_EMPRESA
            SZ1->Z1_CARGO   := M->Z1_CARGO
            SZ1->Z1_DTCAD   := M->Z1_DTCAD
            
            // Confirma numeração sequencial (se usou GetSXENum)
            IF INCLUI
                ConfirmSX8()
            ENDIF
            
            // Desbloqueia o registro
            MsUnLock()
            
            // Se chegou aqui, deu tudo certo!
            CommitTran()  // CONFIRMA TRANSAÇÃO
            
            lRet := .T.
            
            MsgInfo("Contato gravado com sucesso!", "Sucesso")
            
        RECOVER WITH oErro
            //---------------------------------------------------------------
            // ERRO NA GRAVAÇÃO!
            //---------------------------------------------------------------
            // Desfaz TUDO que foi feito dentro da transação
            //---------------------------------------------------------------
            
            RollBackTran()  // DESFAZ TRANSAÇÃO
            
            // Rollback da numeração sequencial
            IF INCLUI
                RollBackSX8()
            ENDIF
            
            // Mensagem amigável ao usuário
            MsgAlert(;
                "Não foi possível gravar o contato." + CRLF + ;
                "Por favor, verifique os dados e tente novamente.",;
                "Erro na Gravação";
            )
            
            // Grava log técnico do erro
            U_GRAVARLOG("STTIP003SALVAR", oErro)
            
            lRet := .F.
            
        END SEQUENCE
        
    RECOVER WITH oErro
        //-------------------------------------------------------------------
        // ERRO NA VALIDAÇÃO!
        //-------------------------------------------------------------------
        // Erro antes de iniciar a transação (validação prévia)
        //-------------------------------------------------------------------
        
        // Mensagem específica da validação
        MsgAlert(oErro:Description, "Validação de Dados")
        
        // Grava log
        U_GRAVARLOG("STTIP003SALVAR - Validação", oErro)
        
        lRet := .F.
        
    END SEQUENCE
    
    RestArea(aAreaSZ1)
    RestArea(aArea)
    
RETURN lRet


//===========================================================================
// Função: STTIP004SALVAR
// Descrição: Grava registro de interação (SZ2) com tratamento de erros
// Parâmetros: Nenhum (usa variáveis M->)
// Retorno: .T. se gravou com sucesso, .F. se houve erro
//===========================================================================
USER FUNCTION STTIP004SALVAR()
    LOCAL lRet := .F.
    LOCAL aArea := GetArea()
    LOCAL aAreaSZ2 := SZ2->(GetArea())
    
    //-----------------------------------------------------------------------
    // VALIDAÇÃO PRÉVIA
    //-----------------------------------------------------------------------
    
    BEGIN SEQUENCE
        
        // Validação 1: Código do contato
        IF Empty(M->Z2_CONTAT)
            BREAK ErrorNew("O código do contato é obrigatório!")
        ENDIF
        
        // Validação 2: Contato deve existir
        IF !ExistCpo("SZ1", xFilial("SZ1") + M->Z2_CONTAT, 1)
            BREAK ErrorNew("Contato não encontrado: " + M->Z2_CONTAT)
        ENDIF
        
        // Validação 3: Sequência
        IF Empty(M->Z2_SEQUEN)
            BREAK ErrorNew("A sequência é obrigatória!")
        ENDIF
        
        // Validação 4: Data
        IF Empty(M->Z2_DATA)
            BREAK ErrorNew("A data da interação é obrigatória!")
        ENDIF
        
        // Validação 5: Data não pode ser futura
        IF M->Z2_DATA > Date()
            BREAK ErrorNew("A data da interação não pode ser futura!")
        ENDIF
        
        // Validação 6: Tipo
        IF Empty(M->Z2_TIPO)
            BREAK ErrorNew("O tipo de interação é obrigatório!")
        ENDIF
        
        // Validação 7: Tipo deve ser válido (E, L, R, V, W)
        IF !(M->Z2_TIPO $ "E|L|R|V|W")
            BREAK ErrorNew("Tipo de interação inválido! Use: E, L, R, V ou W")
        ENDIF
        
        // Validação 8: Assunto
        IF Empty(M->Z2_ASSUNTO)
            BREAK ErrorNew("O assunto da interação é obrigatório!")
        ENDIF
        
        //-------------------------------------------------------------------
        // GRAVAÇÃO COM TRANSAÇÃO
        //-------------------------------------------------------------------
        
        BeginTran()
        
        BEGIN SEQUENCE
            
            dbSelectArea("SZ2")
            dbSetOrder(1) // Z2_FILIAL + Z2_CONTAT + Z2_SEQUEN
            
            IF INCLUI
                RecLock("SZ2", .T.)
            ELSE
                IF !dbSeek(xFilial("SZ2") + M->Z2_CONTAT + M->Z2_SEQUEN)
                    BREAK ErrorNew("Registro não encontrado para alteração!")
                ENDIF
                
                RecLock("SZ2", .F.)
            ENDIF
            
            // Grava os campos
            SZ2->Z2_FILIAL  := xFilial("SZ2")
            SZ2->Z2_CONTAT  := M->Z2_CONTAT
            SZ2->Z2_SEQUEN  := M->Z2_SEQUEN
            SZ2->Z2_DATA    := M->Z2_DATA
            SZ2->Z2_HORA    := M->Z2_HORA
            SZ2->Z2_TIPO    := M->Z2_TIPO
            SZ2->Z2_ASSUNTO := M->Z2_ASSUNTO
            SZ2->Z2_DESCRIC := M->Z2_DESCRIC
            SZ2->Z2_USUARIO := M->Z2_USUARIO
            
            MsUnLock()
            
            CommitTran()
            
            lRet := .T.
            
            MsgInfo("Interação gravada com sucesso!", "Sucesso")
            
        RECOVER WITH oErro
            
            RollBackTran()
            
            MsgAlert(;
                "Não foi possível gravar a interação." + CRLF + ;
                "Por favor, verifique os dados e tente novamente.",;
                "Erro na Gravação";
            )
            
            U_GRAVARLOG("STTIP004SALVAR", oErro)
            
            lRet := .F.
            
        END SEQUENCE
        
    RECOVER WITH oErro
        
        MsgAlert(oErro:Description, "Validação de Dados")
        
        U_GRAVARLOG("STTIP004SALVAR - Validação", oErro)
        
        lRet := .F.
        
    END SEQUENCE
    
    RestArea(aAreaSZ2)
    RestArea(aArea)
    
RETURN lRet


//===========================================================================
// Função: EXEMPLO_ERRO_PROVOCADO
// Descrição: Testa o tratamento de erros provocando falhas intencionais
//===========================================================================
USER FUNCTION STTIP006TESTE()
    LOCAL nOpcao := 0
    
    // Menu de testes
    nOpcao := Aviso(;
        "Teste de Gravação Segura",;
        "Escolha o tipo de erro para provocar:",;
        {"Código Vazio", "Nome Vazio", "Email Inválido", "Data Futura", "Cancelar"},;
        3;
    )
    
    // Simula variáveis de memória
    PRIVATE INCLUI := .T.
    PRIVATE ALTERA := .F.
    
    DO CASE
        CASE nOpcao == 1
            // Teste 1: Código vazio
            M->Z1_CODIGO  := ""           // ERRO: vazio!
            M->Z1_NOME    := "TESTE"
            M->Z1_EMAIL   := "teste@email.com"
            M->Z1_TELEFON := ""
            M->Z1_EMPRESA := ""
            M->Z1_CARGO   := ""
            M->Z1_DTCAD   := Date()
            
            U_STTIP003SALVAR()
            
        CASE nOpcao == 2
            // Teste 2: Nome vazio
            M->Z1_CODIGO  := "999999"
            M->Z1_NOME    := ""           // ERRO: vazio!
            M->Z1_EMAIL   := "teste@email.com"
            M->Z1_TELEFON := ""
            M->Z1_EMPRESA := ""
            M->Z1_CARGO   := ""
            M->Z1_DTCAD   := Date()
            
            U_STTIP003SALVAR()
            
        CASE nOpcao == 3
            // Teste 3: Email inválido
            M->Z1_CODIGO  := "999999"
            M->Z1_NOME    := "TESTE"
            M->Z1_EMAIL   := "email.invalido"  // ERRO: sem @!
            M->Z1_TELEFON := ""
            M->Z1_EMPRESA := ""
            M->Z1_CARGO   := ""
            M->Z1_DTCAD   := Date()
            
            U_STTIP003SALVAR()
            
        CASE nOpcao == 4
            // Teste 4: Data futura (para SZ2)
            M->Z2_CONTAT  := "000001"
            M->Z2_SEQUEN  := "999"
            M->Z2_DATA    := Date() + 30    // ERRO: data futura!
            M->Z2_HORA    := Time()
            M->Z2_TIPO    := "L"
            M->Z2_ASSUNTO := "Teste"
            M->Z2_DESCRIC := "Teste de erro"
            M->Z2_USUARIO := RetCodUsr()
            
            U_STTIP004SALVAR()
            
    ENDCASE
    
RETURN


//===========================================================================
// FIM DE EX06-GRAVACAO-SEGURA.PRW
//===========================================================================
