#define VALOR_ATE_25       180
#define VALOR_26_A_40      260
#define VALOR_41_A_60      380
#define VALOR_ACIMA_60     520
#define VALOR_DEPENDENTE   90

FUNCTION Main()
    LOCAL nIdade, nDependentes, nValorPlano, nValorTotal

    INPUT "Digite a idade: " TO nIdade
    INPUT "Digite o n£mero de dependentes: " TO nDependentes

    IF nIdade <= 25
        nValorPlano := VALOR_ATE_25
    ELSEIF nIdade >= 26 .AND. nIdade <= 40
        nValorPlano := VALOR_26_A_40
    ELSEIF nIdade >= 41 .AND. nIdade <= 60
        nValorPlano := VALOR_41_A_60
    ELSE
        nValorPlano := VALOR_ACIMA_60
    ENDIF

    nValorTotal := nValorPlano + (nDependentes * VALOR_DEPENDENTE)

    QOut("===== Plano de Sa£de =====")
    QOut("Idade         : " + AllTrim(Str(nIdade)) + " anos")
    QOut("Dependentes   : " + AllTrim(Str(nDependentes)))
    QOut("Valor base    : R$ " + AllTrim(Str(nValorPlano, 10, 2)))
    QOut("Valor total   : R$ " + AllTrim(Str(nValorTotal, 10, 2)))
RETURN NIL
