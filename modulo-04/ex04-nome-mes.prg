FUNCTION Main()
    LOCAL nNumeroDoMes
    LOCAL aMesesDoAno := { "Janeiro", "Fevereiro", "Marco", "Abril", ;
                        "Maio", "Junho", "Julho", "Agosto", ;
                        "Setembro", "Outubro", "Novembro", "Dezembro" }

    INPUT "Digite o n£mero do mˆs (1 a 12): " TO nNumeroDoMes

    IF nNumeroDoMes >= 1 .AND. nNumeroDoMes <= 12
        Qout("O mˆs correspondente ‚: " + aMesesDoAno[nNumeroDoMes])
    ELSE
        Qout("Mˆs inv lido")
    ENDIF
RETURN NIL 
