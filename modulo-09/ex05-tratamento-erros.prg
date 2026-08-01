/*/
===========================================================================
EX05-TRATAMENTO-ERROS.PRG - Primeiro Contato com Erros (Harbour Puro)
===========================================================================
Descriá∆o: Demonstraá∆o do mecanismo de tratamento de erros em Harbour
           usando BEGIN SEQUENCE / RECOVER WITH

Objetivo: Entender como capturar e tratar erros sem travar o programa

Conceitos:
   - BEGIN SEQUENCE ... END SEQUENCE
   - RECOVER WITH oErro
   - BREAK (foráa erro)
   - oErro:Description (mensagem do erro)
   - Continuar executando ap¢s erro

Autor: Jornada DEV START - M¢dulo 9 - Exerc°cio 5
===========================================================================
/*/


//===========================================================================
// EXEMPLO 1: Divis∆o por Zero (Erro Provocado)
//===========================================================================
FUNCTION Main()
    LOCAL nA := 10
    LOCAL nB := 0
    LOCAL nRes := 0
    
    QOut("")
    QOut("=" + Replicate("=", 70))
    QOut("EXEMPLO 1: Divis∆o por Zero")
    QOut("=" + Replicate("=", 70))
    
    // Tenta dividir por zero
    BEGIN SEQUENCE
        QOut("Tentando dividir " + Str(nA) + " por " + Str(nB) + "...")
        
        nRes := nA / nB  // ERRO! Divis∆o por zero
        
        QOut("Resultado: " + Str(nRes))  // Esta linha N«O ser† executada
        
    RECOVER WITH oErro
        // Captura o erro e exibe mensagem
        QOut("")
        QOut(">>> ERRO CAPTURADO! <<<")
        QOut(">>> Descriá∆o: " + oErro:Description)
        QOut(">>> Operaá∆o: " + oErro:Operation)
        QOut("")
        
    END SEQUENCE
    
    QOut("O programa continua de pÇ!")
    QOut("")
    
    // Chama outros exemplos
    Exemplo2_ArrayInvalido()
    Exemplo3_BreakManual()
    Exemplo4_TratamentoAninhado()
    Exemplo5_ComProtheus()
    
RETURN NIL


//===========================================================================
// EXEMPLO 2: Acesso a ÷ndice Inv†lido de Array
//===========================================================================
FUNCTION Exemplo2_ArrayInvalido()
    LOCAL aLista := {"A", "B", "C"}
    LOCAL cItem := ""
    
    QOut("=" + Replicate("=", 70))
    QOut("EXEMPLO 2: Acesso a ÷ndice Inv†lido de Array")
    QOut("=" + Replicate("=", 70))
    
    BEGIN SEQUENCE
        QOut("Array tem " + Str(Len(aLista)) + " elementos: A, B, C")
        QOut("Tentando acessar posiá∆o 10...")
        
        cItem := aLista[10]  // ERRO! ÷ndice fora do limite
        
        QOut("Item: " + cItem)  // N«O ser† executado
        
    RECOVER WITH oErro
        QOut("")
        QOut(">>> ERRO CAPTURADO! <<<")
        QOut(">>> Descriá∆o: " + oErro:Description)
        QOut(">>> N∆o existe posiá∆o 10 no array!")
        QOut("")
        
    END SEQUENCE
    
    QOut("Programa continua normalmente.")
    QOut("")
    
RETURN NIL


//===========================================================================
// EXEMPLO 3: BREAK Manual (Foráar Erro)
//===========================================================================
FUNCTION Exemplo3_BreakManual()
    LOCAL nIdade := -5
    
    QOut("=" + Replicate("=", 70))
    QOut("EXEMPLO 3: BREAK Manual (Validaá∆o Customizada)")
    QOut("=" + Replicate("=", 70))
    
    BEGIN SEQUENCE
        QOut("Validando idade: " + Str(nIdade))
        
        // Validaá∆o customizada
        IF nIdade < 0
            // Foráa um erro com mensagem customizada
            BREAK ErrorNew("Idade n∆o pode ser negativa!")
        ENDIF
        
        QOut("Idade v†lida: " + Str(nIdade))
        
    RECOVER WITH oErro
        QOut("")
        QOut(">>> VALIDAÄ«O FALHOU! <<<")
        QOut(">>> " + oErro:Description)
        QOut("")
        
    END SEQUENCE
    
    QOut("Programa continua executando.")
    QOut("")
    
RETURN NIL


//===========================================================================
// EXEMPLO 4: Tratamento Aninhado (Sequàncias Dentro de Sequàncias)
//===========================================================================
FUNCTION Exemplo4_TratamentoAninhado()
    LOCAL nValor := 0
    
    QOut("=" + Replicate("=", 70))
    QOut("EXEMPLO 4: Tratamento Aninhado")
    QOut("=" + Replicate("=", 70))
    
    BEGIN SEQUENCE
        QOut("Bloco externo - in°cio")
        
        BEGIN SEQUENCE
            QOut("  Bloco interno - tentando dividir por zero")
            nValor := 100 / 0  // Erro aqui
            
        RECOVER WITH oErro
            QOut("  >>> ERRO NO BLOCO INTERNO <<<")
            QOut("  >>> " + oErro:Description)
            
            // Pode relanáar o erro para o bloco externo
            // BREAK oErro
        END SEQUENCE
        
        QOut("Bloco externo - fim")
        
    RECOVER WITH oErro
        QOut(">>> ERRO NO BLOCO EXTERNO <<<")
        QOut(">>> " + oErro:Description)
        
    END SEQUENCE
    
    QOut("Programa continua.")
    QOut("")
    
RETURN NIL


//===========================================================================
// EXEMPLO 5: Padr∆o para Uso no Protheus (TRY/CATCH Style)
//===========================================================================
FUNCTION Exemplo5_ComProtheus()
    LOCAL nResult := 0
    LOCAL lSucesso := .F.
    
    QOut("=" + Replicate("=", 70))
    QOut("EXEMPLO 5: Padr∆o Protheus (Estilo TRY/CATCH)")
    QOut("=" + Replicate("=", 70))
    
    // TRY
    BEGIN SEQUENCE
        QOut("Executando operaá∆o cr°tica...")
        
        // Simula operaá∆o que pode falhar
        nResult := OperacaoCritica()
        
        QOut("Operaá∆o bem-sucedida! Resultado: " + Str(nResult))
        lSucesso := .T.
        
        // CATCH
    RECOVER WITH oErro
        QOut("")
        QOut(">>> FALHA NA OPERAÄ«O <<<")
        QOut(">>> Erro: " + oErro:Description)
        QOut(">>> Aplicando plano B...")
        QOut("")
        
        // Plano B: valor padr∆o
        nResult := 0
        lSucesso := .F.
        
    END SEQUENCE
    
    // FINALLY (sempre executa)
    QOut("Status final: " + IIF(lSucesso, "SUCESSO", "FALHA"))
    QOut("Resultado final: " + Str(nResult))
    QOut("")
    
RETURN NIL


//===========================================================================
// Funá∆o auxiliar que pode lanáar erro
//===========================================================================
FUNCTION OperacaoCritica()
    LOCAL nRandom := Seconds() % 2  // 0 ou 1
    
    IF nRandom == 0
        // 50% de chance de erro
        BREAK ErrorNew("Falha simulada na operaá∆o cr°tica!")
    ENDIF
    
RETURN 42


//===========================================================================
// HELPER: Cria objeto de erro customizado
//===========================================================================
FUNCTION ErrorNew(cMessage)
    LOCAL oError := ErrorNew()
    
    oError:Description := cMessage
    oError:Operation   := ProcName(1)
    oError:SubSystem   := "CUSTOM"
    
RETURN oError


