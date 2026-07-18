FUNCTION Main()
    LOCAL nI

    Qout("a) N£meros de 1 a 100:")
    FOR nI := 1 TO 100
        Qout(NTOC(nI))
    NEXT

    Qout("")
    Qout("b) N£meros de -50 a 50:")
    FOR nI := -50 TO 50
        Qout(NTOC(nI))
    NEXT

    Qout("")
    Qout("c) N£meros de 80 a 5 (decrescente):")
    FOR nI := 80 TO 5 STEP -1
        Qout(NTOC(nI))
    NEXT
RETURN NIL
