FUNCTION Main()
    LOCAL nA := 10
    LOCAL nB := 0
    LOCAL nRes := 0

    QOut("")
    QOut("=" + Replicate("=", 70))
    QOut("EXEMPLO 1: Divisão por Zero")
    QOut("=" + Replicate("=", 70))

    BEGIN SEQUENCE
        QOut("Tentando dividir " + Str(nA) + " por " + Str(nB) + "...")

        nRes := nA / nB

        QOut("Resultado: " + Str(nRes))

    RECOVER WITH oErro
        QOut("")
        QOut(">>> ERRO CAPTURADO! <<<")
        QOut(">>> Descrição: " + oErro:Description)
        QOut(">>> Operação: " + oErro:Operation)
        QOut("")

    END SEQUENCE

    QOut("O programa continua de pé!")
    QOut("")

    Exemplo2_ArrayInvalido()
    Exemplo3_BreakManual()
    Exemplo4_TratamentoAninhado()
    Exemplo5_ComProtheus()

RETURN NIL


FUNCTION Exemplo2_ArrayInvalido()
    LOCAL aLista := {"A", "B", "C"}
    LOCAL cItem := ""

    QOut("=" + Replicate("=", 70))
    QOut("EXEMPLO 2: Acesso a Índice Inválido de Array")
    QOut("=" + Replicate("=", 70))

    BEGIN SEQUENCE
        QOut("Array tem " + Str(Len(aLista)) + " elementos: A, B, C")
        QOut("Tentando acessar posição 10...")

        cItem := aLista[10]

        QOut("Item: " + cItem)

    RECOVER WITH oErro
        QOut("")
        QOut(">>> ERRO CAPTURADO! <<<")
        QOut(">>> Descrição: " + oErro:Description)
        QOut(">>> Não existe posição 10 no array!")
        QOut("")

    END SEQUENCE

    QOut("Programa continua normalmente.")
    QOut("")

RETURN NIL


FUNCTION Exemplo3_BreakManual()
    LOCAL nIdade := -5

    QOut("=" + Replicate("=", 70))
    QOut("EXEMPLO 3: BREAK Manual (Validação Customizada)")
    QOut("=" + Replicate("=", 70))

    BEGIN SEQUENCE
        QOut("Validando idade: " + Str(nIdade))

        IF nIdade < 0
            BREAK CriarErro("Idade não pode ser negativa!")
        ENDIF

        QOut("Idade válida: " + Str(nIdade))

    RECOVER WITH oErro
        QOut("")
        QOut(">>> VALIDAÇÃO FALHOU! <<<")
        QOut(">>> " + oErro:Description)
        QOut("")

    END SEQUENCE

    QOut("Programa continua executando.")
    QOut("")

RETURN NIL


FUNCTION Exemplo4_TratamentoAninhado()
    LOCAL nValor := 0

    QOut("=" + Replicate("=", 70))
    QOut("EXEMPLO 4: Tratamento Aninhado")
    QOut("=" + Replicate("=", 70))

    BEGIN SEQUENCE
        QOut("Bloco externo - início")

        BEGIN SEQUENCE
            QOut("  Bloco interno - tentando dividir por zero")
            nValor := 100 / 0

        RECOVER WITH oErro
            QOut("  >>> ERRO NO BLOCO INTERNO <<<")
            QOut("  >>> " + oErro:Description)

        END SEQUENCE

        QOut("Bloco externo - fim")

    RECOVER WITH oErro
        QOut(">>> ERRO NO BLOCO EXTERNO <<<")
        QOut(">>> " + oErro:Description)

    END SEQUENCE

    QOut("Programa continua.")
    QOut("")

RETURN NIL


FUNCTION Exemplo5_ComProtheus()
    LOCAL nResult := 0
    LOCAL lSucesso := .F.

    QOut("=" + Replicate("=", 70))
    QOut("EXEMPLO 5: Padrão Protheus (Estilo TRY/CATCH)")
    QOut("=" + Replicate("=", 70))

    BEGIN SEQUENCE
        QOut("Executando operação crítica...")

        nResult := OperacaoCritica()

        QOut("Operação bem-sucedida! Resultado: " + Str(nResult))
        lSucesso := .T.

    RECOVER WITH oErro
        QOut("")
        QOut(">>> FALHA NA OPERAÇÃO <<<")
        QOut(">>> Erro: " + oErro:Description)
        QOut(">>> Aplicando plano B...")
        QOut("")

        nResult := 0
        lSucesso := .F.

    END SEQUENCE

    QOut("Status final: " + IIF(lSucesso, "SUCESSO", "FALHA"))
    QOut("Resultado final: " + Str(nResult))
    QOut("")

RETURN NIL

FUNCTION OperacaoCritica()
    LOCAL nRandom := Seconds() % 2

    IF nRandom == 0
        BREAK CriarErro("Falha simulada na operação crítica!")
    ENDIF

RETURN 42

FUNCTION CriarErro(cMessage)
    LOCAL oError := ErrorNew()

    oError:Description := cMessage
    oError:Operation   := ProcName(1)
    oError:SubSystem   := "CUSTOM"

RETURN oError
