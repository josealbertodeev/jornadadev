FUNCTION Main()
    LOCAL nA, nB, cOperacao, nResultado

    Qout("Calculadora com DO CASE")
    Qout("=======================")

    nA := LerNumero("Digite o primeiro numero: ")
    ACCEPT "Digite a operacao (+, -, *, /, ^, R): " TO cOperacao

    IF cOperacao != "R"
        nB := LerNumero("Digite o segundo numero: ")
    ENDIF

    nResultado := Calcular(nA, nB, cOperacao)

    MostrarResultado(nResultado)
RETURN NIL

FUNCTION LerNumero(cMensagem)
    LOCAL nValor
    INPUT cMensagem TO nValor
RETURN nValor

FUNCTION Calcular(nA, nB, cOperacao)
    LOCAL nResultado

    DO CASE
        CASE cOperacao == "+"
            nResultado := nA + nB
        CASE cOperacao == "-"
            nResultado := nA - nB
        CASE cOperacao == "*"
            nResultado := nA * nB
        CASE cOperacao == "/"
            IF nB == 0
                RETURN .F.
            ENDIF
            nResultado := nA / nB
        CASE cOperacao == "^"
            nResultado := nA ^ nB
        CASE cOperacao == "R"
            IF nA < 0
                RETURN .F.
            ENDIF
            nResultado := Sqrt(nA)
        OTHERWISE
            RETURN .F.
    ENDCASE
RETURN nResultado

PROCEDURE MostrarResultado(nResultado)
    IF ValType(nResultado) == "L"
        Qout("Erro: operacao invalida ou divisao por zero.")
    ELSE
        Qout("Resultado: " + AllTrim(STR(nResultado, 10, 2)))
    ENDIF
RETURN
