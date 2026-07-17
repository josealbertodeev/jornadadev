FUNCTION Main()
        LOCAL cMaior, cMenor
        LOCAL nMaior, nMenor

        ACCEPT "Digite o primeiro valor: " TO cMaior
        ACCEPT "Digite o segundo valor: " TO cMenor

        nMaior := VAL(cMaior)
        nMenor := VAL(cMenor)

        IF nMaior > nMenor
            Qout("Maior valor digitado ‚: " + STR(nMaior))
        ELSEIF nMaior < nMenor
            Qout("Menor valor digitado ‚: " + STR(nMenor))
        ELSE
            Qout("Os dois valores sÆo iguais.")
        ENDIF
RETURN NIL