#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

USER FUNCTION STTIP003SALVAR()
    LOCAL lRet := .F.
    LOCAL aArea := GetArea()
    LOCAL aAreaSZ1 := SZ1->(GetArea())

    BEGIN SEQUENCE

        IF Empty(M->Z1_CODIGO)
            BREAK ErrorNew("O código do contato é obrigatório!")
        ENDIF

        IF Empty(M->Z1_NOME)
            BREAK ErrorNew("O nome do contato é obrigatório!")
        ENDIF

        IF !Empty(M->Z1_EMAIL) .AND. !U_VALEMAIL(M->Z1_EMAIL)
            BREAK ErrorNew("Email inválido!")
        ENDIF

        IF Empty(M->Z1_DTCAD)
            BREAK ErrorNew("A data de cadastro é obrigatória!")
        ENDIF

        BeginTran()

        BEGIN SEQUENCE

            dbSelectArea("SZ1")
            dbSetOrder(1)

            IF INCLUI
                RecLock("SZ1", .T.)
            ELSE
                IF !dbSeek(xFilial("SZ1") + M->Z1_CODIGO)
                    BREAK ErrorNew("Registro não encontrado para alteração!")
                ENDIF

                RecLock("SZ1", .F.)
            ENDIF

            SZ1->Z1_FILIAL  := xFilial("SZ1")
            SZ1->Z1_CODIGO  := M->Z1_CODIGO
            SZ1->Z1_NOME    := M->Z1_NOME
            SZ1->Z1_EMAIL   := M->Z1_EMAIL
            SZ1->Z1_TELEFON := M->Z1_TELEFON
            SZ1->Z1_EMPRESA := M->Z1_EMPRESA
            SZ1->Z1_CARGO   := M->Z1_CARGO
            SZ1->Z1_DTCAD   := M->Z1_DTCAD

            IF INCLUI
                ConfirmSX8()
            ENDIF

            MsUnLock()

            CommitTran()

            lRet := .T.

            MsgInfo("Contato gravado com sucesso!", "Sucesso")

        RECOVER WITH oErro

            RollBackTran()

            IF INCLUI
                RollBackSX8()
            ENDIF

            MsgAlert(;
                "Não foi possível gravar o contato." + CRLF + ;
                "Por favor, verifique os dados e tente novamente.",;
                "Erro na Gravação";
            )

            U_GRAVARLOG("STTIP003SALVAR", oErro)

            lRet := .F.

        END SEQUENCE

    RECOVER WITH oErro

        MsgAlert(oErro:Description, "Validação de Dados")

        U_GRAVARLOG("STTIP003SALVAR - Validação", oErro)

        lRet := .F.

    END SEQUENCE

    RestArea(aAreaSZ1)
    RestArea(aArea)

RETURN lRet


USER FUNCTION STTIP004SALVAR()
    LOCAL lRet := .F.
    LOCAL aArea := GetArea()
    LOCAL aAreaSZ2 := SZ2->(GetArea())

    BEGIN SEQUENCE

        IF Empty(M->Z2_CONTAT)
            BREAK ErrorNew("O código do contato é obrigatório!")
        ENDIF

        IF !ExistCpo("SZ1", xFilial("SZ1") + M->Z2_CONTAT, 1)
            BREAK ErrorNew("Contato não encontrado: " + M->Z2_CONTAT)
        ENDIF

        IF Empty(M->Z2_SEQUEN)
            BREAK ErrorNew("A sequência é obrigatória!")
        ENDIF

        IF Empty(M->Z2_DATA)
            BREAK ErrorNew("A data da interação é obrigatória!")
        ENDIF

        IF M->Z2_DATA > Date()
            BREAK ErrorNew("A data da interação não pode ser futura!")
        ENDIF

        IF Empty(M->Z2_TIPO)
            BREAK ErrorNew("O tipo de interação é obrigatório!")
        ENDIF

        IF !(M->Z2_TIPO $ "E|L|R|V|W")
            BREAK ErrorNew("Tipo de interação inválido! Use: E, L, R, V ou W")
        ENDIF

        IF Empty(M->Z2_ASSUNTO)
            BREAK ErrorNew("O assunto da interação é obrigatório!")
        ENDIF

        BeginTran()

        BEGIN SEQUENCE

            dbSelectArea("SZ2")
            dbSetOrder(1)

            IF INCLUI
                RecLock("SZ2", .T.)
            ELSE
                IF !dbSeek(xFilial("SZ2") + M->Z2_CONTAT + M->Z2_SEQUEN)
                    BREAK ErrorNew("Registro não encontrado para alteração!")
                ENDIF

                RecLock("SZ2", .F.)
            ENDIF

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


USER FUNCTION STTIP006TESTE()
    LOCAL nOpcao := 0

    nOpcao := Aviso(;
        "Teste de Gravação Segura",;
        "Escolha o tipo de erro para provocar:",;
        {"Código Vazio", "Nome Vazio", "Email Inválido", "Data Futura", "Cancelar"},;
        3;
    )

    PRIVATE INCLUI := .T.
    PRIVATE ALTERA := .F.

    DO CASE
        CASE nOpcao == 1
            M->Z1_CODIGO  := ""
            M->Z1_NOME    := "TESTE"
            M->Z1_EMAIL   := "teste@email.com"
            M->Z1_TELEFON := ""
            M->Z1_EMPRESA := ""
            M->Z1_CARGO   := ""
            M->Z1_DTCAD   := Date()

            U_STTIP003SALVAR()

        CASE nOpcao == 2
            M->Z1_CODIGO  := "999999"
            M->Z1_NOME    := ""
            M->Z1_EMAIL   := "teste@email.com"
            M->Z1_TELEFON := ""
            M->Z1_EMPRESA := ""
            M->Z1_CARGO   := ""
            M->Z1_DTCAD   := Date()

            U_STTIP003SALVAR()

        CASE nOpcao == 3
            M->Z1_CODIGO  := "999999"
            M->Z1_NOME    := "TESTE"
            M->Z1_EMAIL   := "email.invalido"
            M->Z1_TELEFON := ""
            M->Z1_EMPRESA := ""
            M->Z1_CARGO   := ""
            M->Z1_DTCAD   := Date()

            U_STTIP003SALVAR()

        CASE nOpcao == 4
            M->Z2_CONTAT  := "000001"
            M->Z2_SEQUEN  := "999"
            M->Z2_DATA    := Date() + 30
            M->Z2_HORA    := Time()
            M->Z2_TIPO    := "L"
            M->Z2_ASSUNTO := "Teste"
            M->Z2_DESCRIC := "Teste de erro"
            M->Z2_USUARIO := RetCodUsr()

            U_STTIP004SALVAR()

    ENDCASE

RETURN