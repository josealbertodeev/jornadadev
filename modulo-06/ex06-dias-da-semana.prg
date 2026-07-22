FUNCTION Main()
    LOCAL aDias := {"Domingo", "Segunda", "Terca", "Quarta", "Quinta", "Sexta", "Sabado"}
    LOCAL nDia

    ACCEPT "Digite um numero de 1 a 7: " TO nDia
    nDia := Val(nDia)

    IF nDia < 1 .OR. nDia > 7
        Qout("Numero fora do intervalo de 1 a 7.")
    ELSE
        Qout("Dia: " + aDias[nDia])
    ENDIF
RETURN NIL
