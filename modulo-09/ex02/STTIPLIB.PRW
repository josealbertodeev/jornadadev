/*/
===========================================================================
STTIPLIB.PRW - Biblioteca de Funções para Sistema de Contatos/CRM
===========================================================================
Descrição: Funções auxiliares para manipulação de dados de Contatos (SZ1)
           e Interações (SZ2)

Funções Públicas:
   U_NomeCliente(cCodigo)       - Retorna nome do contato pelo código
   U_ProxCodigoSZ1()            - Gera próximo código sequencial para SZ1
   U_ProxSequenSZ2(cContato)    - Gera próxima sequência para SZ2
   U_DescTipoInteracao(cTipo)   - Retorna descrição do tipo de interação
   U_SZ1STATUS()                - Retorna status do contato (Virtual)
   U_SZ1ULTINT()                - Retorna data da última interação (Virtual)
   U_VALEMAIL(cEmail)           - Valida formato de email
   U_PROXSEQ()                  - Atalho para ProxSequenSZ2 (compatibilidade SX3)
===========================================================================
/*/

//===========================================================================
// Função: NomeCliente
// Descrição: Retorna o nome do contato pelo código
// Parâmetros: cCodigo - Código do contato (SZ1)
// Retorno: cNome - Nome do contato ou "NÃO ENCONTRADO"
//===========================================================================
USER FUNCTION NomeCliente(cCodigo)
    LOCAL cNome := ""
    LOCAL aArea := GetArea()
    LOCAL aAreaSZ1 := SZ1->(GetArea())

    DEFAULT cCodigo := ""

    IF Empty(cCodigo)
        cNome := ""
    ELSE
        dbSelectArea("SZ1")
        dbSetOrder(1) // Z1_FILIAL + Z1_CODIGO

        IF dbSeek(xFilial("SZ1") + cCodigo)
            cNome := AllTrim(SZ1->Z1_NOME)
        ELSE
            cNome := "NÃO ENCONTRADO"
        ENDIF
    ENDIF

    RestArea(aAreaSZ1)
    RestArea(aArea)
RETURN cNome


//===========================================================================
// Função: ProxCodigoSZ1
// Descrição: Gera o próximo código sequencial para a tabela SZ1
// Parâmetros: Nenhum
// Retorno: cProxCod - Próximo código disponível (6 caracteres)
//===========================================================================
USER FUNCTION ProxCodigoSZ1()
    LOCAL cProxCod := ""
    LOCAL aArea := GetArea()
    LOCAL aAreaSZ1 := SZ1->(GetArea())

    // Método 1: Usando GetSXENum (recomendado pela TOTVS)
    cProxCod := GetSXENum("SZ1", "Z1_CODIGO")

    // Confirma a numeração
    ConfirmSX8()

    RestArea(aAreaSZ1)
    RestArea(aArea)
RETURN cProxCod


//===========================================================================
// Função: ProxSequenSZ2
// Descrição: Gera a próxima sequência para interações de um contato
// Parâmetros: cContato - Código do contato (opcional, pega de M->Z2_CONTAT)
// Retorno: cSequencia - Próxima sequência (3 caracteres numéricos)
//===========================================================================
USER FUNCTION ProxSequenSZ2(cContato)
    LOCAL cSequencia := "001"
    LOCAL aArea := GetArea()
    LOCAL aAreaSZ2 := SZ2->(GetArea())
    LOCAL nUltimaSeq := 0

    // Se não passou parâmetro, tenta pegar da memória
    DEFAULT cContato := IIF(Type("M->Z2_CONTAT") != "U", M->Z2_CONTAT, "")

    IF Empty(cContato)
        cSequencia := "001"
    ELSE
        dbSelectArea("SZ2")
        dbSetOrder(1) // Z2_FILIAL + Z2_CONTAT + Z2_SEQUEN

        // Posiciona no primeiro registro do contato
        IF dbSeek(xFilial("SZ2") + cContato)
            // Percorre todos os registros do contato
            WHILE !EOF() .AND. SZ2->Z2_FILIAL == xFilial("SZ2") .AND. ;
                    SZ2->Z2_CONTAT == cContato

                nUltimaSeq := Max(nUltimaSeq, Val(SZ2->Z2_SEQUEN))
                dbSkip()
            ENDDO
        ENDIF

        // Incrementa a última sequência encontrada
        nUltimaSeq++
        cSequencia := StrZero(nUltimaSeq, 3)
    ENDIF

    RestArea(aAreaSZ2)
    RestArea(aArea)
RETURN cSequencia


//===========================================================================
// Função: DescTipoInteracao
// Descrição: Retorna a descrição do tipo de interação pela tabela SX5
// Parâmetros: cTipo - Código do tipo (E/L/R/V/W)
// Retorno: cDescricao - Descrição do tipo ou "Tipo Inválido"
//===========================================================================
USER FUNCTION DescTipoInteracao(cTipo)
    LOCAL cDescricao := ""

    DEFAULT cTipo := IIF(Type("M->Z2_TIPO") != "U", M->Z2_TIPO, "")

    IF Empty(cTipo)
        cDescricao := ""
    ELSE
        // Busca na tabela genérica SX5
        // Tabela Z2 = Tipos de Interação
        cDescricao := AllTrim(X5Descri("Z2", cTipo, , , GetSXEIdioma()))

        // Se não encontrou, retorna descrição padrão
        IF Empty(cDescricao)
            cDescricao := "Tipo Inválido"
        ENDIF
    ENDIF
RETURN cDescricao


//===========================================================================
// Função: SZ1STATUS (Campo Virtual)
// Descrição: Calcula o status do contato baseado na última interação
// Parâmetros: Nenhum (usa registro posicionado em SZ1)
// Retorno: cStatus - "Sem Interação", "Quente", "Ativo", "Frio" ou "Inativo"
//
// Regras:
//   - Sem Interação: Nunca teve interação
//   - Quente:  Última interação há <= 7 dias
//   - Ativo:   Última interação há 8-30 dias
//   - Frio:    Última interação há 31-90 dias
//   - Inativo: Última interação há > 90 dias
//===========================================================================
USER FUNCTION SZ1STATUS()
    LOCAL cStatus := "Sem Interação"
    LOCAL dUltimaInt := CTOD("//")
    LOCAL nDias := 0
    LOCAL aArea := GetArea()
    LOCAL aAreaSZ2 := SZ2->(GetArea())

    // Busca a última interação do contato atual
    dUltimaInt := U_SZ1ULTINT()

    IF Empty(dUltimaInt)
        cStatus := "Sem Interação"
    ELSE
        nDias := Date() - dUltimaInt

        IF nDias <= 7
            cStatus := "Quente"
        ELSEIF nDias <= 30
            cStatus := "Ativo"
        ELSEIF nDias <= 90
            cStatus := "Frio"
        ELSE
            cStatus := "Inativo"
        ENDIF
    ENDIF

    RestArea(aAreaSZ2)
    RestArea(aArea)
RETURN cStatus


//===========================================================================
// Função: SZ1ULTINT (Campo Virtual)
// Descrição: Retorna a data da última interação do contato
// Parâmetros: Nenhum (usa registro posicionado em SZ1)
// Retorno: dUltimaInt - Data da última interação ou CTOD("//")
//===========================================================================
USER FUNCTION SZ1ULTINT()
    LOCAL dUltimaInt := CTOD("//")
    LOCAL aArea := GetArea()
    LOCAL aAreaSZ2 := SZ2->(GetArea())
    LOCAL cCodContato := ""

    // Pega código do contato atual
    cCodContato := SZ1->Z1_CODIGO

    dbSelectArea("SZ2")
    dbSetOrder(1) // Z2_FILIAL + Z2_CONTAT + Z2_SEQUEN

    // Posiciona no primeiro registro do contato
    IF dbSeek(xFilial("SZ2") + cCodContato)
        // Percorre todos os registros do contato buscando a data mais recente
        WHILE !EOF() .AND. SZ2->Z2_FILIAL == xFilial("SZ2") .AND. ;
                SZ2->Z2_CONTAT == cCodContato

            IF SZ2->Z2_DATA > dUltimaInt
                dUltimaInt := SZ2->Z2_DATA
            ENDIF

            dbSkip()
        ENDDO
    ENDIF

    RestArea(aAreaSZ2)
    RestArea(aArea)
RETURN dUltimaInt


//===========================================================================
// Função: VALEMAIL
// Descrição: Valida formato de email (verificação básica)
// Parâmetros: cEmail - Email a ser validado
// Retorno: .T. se válido, .F. se inválido
//===========================================================================
USER FUNCTION VALEMAIL(cEmail)
    LOCAL lValido := .T.

    DEFAULT cEmail := ""

    cEmail := AllTrim(cEmail)

    // Se estiver vazio, considera válido (campo não obrigatório)
    IF Empty(cEmail)
        lValido := .T.
    ELSE
        // Verificações básicas:
        // 1. Deve conter @
        // 2. Deve conter . após o @
        // 3. Não pode começar ou terminar com @
        // 4. Não pode ter espaços

        IF !("@" $ cEmail)
            lValido := .F.
            MsgAlert("Email deve conter @", "Validação de Email")
        ELSEIF At("@", cEmail) == 1 .OR. At("@", cEmail) == Len(cEmail)
            lValido := .F.
            MsgAlert("Email inválido: @ na posição incorreta", "Validação de Email")
        ELSEIF !("." $ SubStr(cEmail, At("@", cEmail)))
            lValido := .F.
            MsgAlert("Email deve conter domínio (.com, .br, etc)", "Validação de Email")
        ELSEIF " " $ cEmail
            lValido := .F.
            MsgAlert("Email não pode conter espaços", "Validação de Email")
        ENDIF
    ENDIF
RETURN lValido


//===========================================================================
// Função: PROXSEQ (Atalho para compatibilidade com SX3)
// Descrição: Atalho para ProxSequenSZ2 - usado no inicializador do SX3
// Parâmetros: Nenhum
// Retorno: cSequencia - Próxima sequência
//===========================================================================
USER FUNCTION PROXSEQ()
RETURN U_ProxSequenSZ2()


//===========================================================================
// Função: GRAVARLOG
// Descrição: Grava log de erros em arquivo para auditoria e debug
// Parâmetros: cFuncao - Nome da função onde ocorreu o erro
//             oErro   - Objeto de erro (ErrorBlock)
// Retorno: Nenhum
//===========================================================================
USER FUNCTION GRAVARLOG(cFuncao, oErro)
    LOCAL cArquivo := ""
    LOCAL cLinha := ""
    LOCAL nHandle := 0
    LOCAL cPath := ""

    DEFAULT cFuncao := "Função Desconhecida"

    // Define caminho do arquivo de log
    // No Protheus, usa pasta de system
    cPath := GetSrvProfString("StartPath", "")

    IF Empty(cPath)
        cPath := "\"
    ENDIF

    // Garante barra no final
    IF Right(cPath, 1) != "\"
        cPath += "\"
    ENDIF

    // Nome do arquivo: STTIP_ERRO_AAAAMMDD.LOG
    cArquivo := cPath + "STTIP_ERRO_" + DTOS(Date()) + ".LOG"

    // Formata linha do log
    cLinha := ""
    cLinha += Replicate("=", 80) + CRLF
    cLinha += "DATA/HORA: " + DTOC(Date()) + " " + Time() + CRLF
    cLinha += "FUNÇÃO: " + cFuncao + CRLF
    cLinha += "USUÁRIO: " + AllTrim(cUserName) + " (" + RetCodUsr() + ")" + CRLF
    cLinha += "ESTAÇÃO: " + AllTrim(GetComputerName()) + CRLF
    cLinha += Replicate("-", 80) + CRLF

    IF oErro != NIL
        cLinha += "DESCRIÇÃO: " + oErro:Description + CRLF

        IF !Empty(oErro:Operation)
            cLinha += "OPERAÇÃO: " + oErro:Operation + CRLF
        ENDIF

        IF !Empty(oErro:SubSystem)
            cLinha += "SUBSISTEMA: " + oErro:SubSystem + CRLF
        ENDIF

        IF oErro:GenCode != NIL
            cLinha += "CÓDIGO: " + AllTrim(Str(oErro:GenCode)) + CRLF
        ENDIF

        // Stack trace (se disponível)
        IF Type("oErro:ProcName") != "U" .AND. !Empty(oErro:ProcName)
            cLinha += "PROCEDURE: " + oErro:ProcName + CRLF
        ENDIF

        IF Type("oErro:ProcLine") != "U" .AND. oErro:ProcLine > 0
            cLinha += "LINHA: " + AllTrim(Str(oErro:ProcLine)) + CRLF
        ENDIF
    ELSE
        cLinha += "ERRO: Objeto de erro não disponível" + CRLF
    ENDIF

    cLinha += Replicate("=", 80) + CRLF + CRLF

    // Grava no arquivo (append)
    nHandle := FOpen(cArquivo, 2)  // Abre para escrita

    IF nHandle == -1
        // Arquivo não existe, cria novo
        nHandle := FCreate(cArquivo)
    ELSE
        // Arquivo existe, vai para o final
        FSeek(nHandle, 0, 2)
    ENDIF

    IF nHandle != -1
        FWrite(nHandle, cLinha)
        FClose(nHandle)
    ENDIF

    // Opcional: Também exibe no console (para debug)
    ConOut(">>> ERRO GRAVADO NO LOG: " + cArquivo)
    ConOut(cLinha)

RETURN


//===========================================================================
// FIM DA BIBLIOTECA STTIPLIB.PRW
//===========================================================================
