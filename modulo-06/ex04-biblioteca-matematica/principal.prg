SET PROCEDURE TO matematica.prg

FUNCTION Main()
    Qout("Fatorial de 5: " + AllTrim(STR(FatorialN(5), 5)))

    Qout("7 e primo? " + IIF(EhPrimo(7), "Sim", "Nao"))
    Qout("8 e primo? " + IIF(EhPrimo(8), "Sim", "Nao"))

    Qout("MMC de 4 e 6: " + AllTrim(STR(MMC(4, 6), 5)))
    Qout("MDC de 48 e 18: " + AllTrim(STR(MDC(48, 18), 5)))
RETURN NIL
