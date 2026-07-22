FUNCTION FatorialN(nN)
    LOCAL nResultado := 1
    LOCAL nI

    FOR nI := 2 TO nN
        nResultado := nResultado * nI
    NEXT
RETURN nResultado

FUNCTION EhPrimo(nN)
    LOCAL nI

    IF nN < 2
        RETURN .F.
    ENDIF

    FOR nI := 2 TO nN - 1
        IF nN % nI == 0
            RETURN .F.
        ENDIF
    NEXT
RETURN .T.

FUNCTION MMC(nA, nB)
    LOCAL nMaior

    nMaior := IIF(nA > nB, nA, nB)

    DO WHILE .T.
        IF nMaior % nA == 0 .AND. nMaior % nB == 0
            RETURN nMaior
        ENDIF
        nMaior++
    ENDDO
RETURN nMaior

FUNCTION MDC(nA, nB)
    LOCAL nResto

    DO WHILE nB != 0
        nResto := nA % nB
        nA := nB
        nB := nResto
    ENDDO
RETURN nA
