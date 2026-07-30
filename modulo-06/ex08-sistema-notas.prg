FUNCTION Main()
    LOCAL aAlunos := {}
    LOCAL nQtd
    LOCAL cNome
    LOCAL cNota
    LOCAL nMedia
    LOCAL i, j
    LOCAL aAluno
    LOCAL nAprovados := 0
    LOCAL nReprovados := 0

    ACCEPT "Quantos alunos serao cadastrados? " TO nQtd

    FOR i := 1 TO Val(nQtd)
        aAluno := {}

        ACCEPT "Nome do aluno " + AllTrim(Str(i)) + ": " TO cNome
        DO WHILE !NomeValido(cNome)
            ACCEPT "Nome invalido, digite apenas letras: " TO cNome
        ENDDO
        AAdd(aAluno, cNome)

        FOR j := 1 TO 4
            ACCEPT "  Nota " + AllTrim(Str(j)) + ": " TO cNota
            DO WHILE !NotaValida(cNota)
                ACCEPT "  Nota invalida, digite apenas numeros: " TO cNota
            ENDDO
            AAdd(aAluno, Val(cNota))
        NEXT

        AAdd(aAlunos, aAluno)
    NEXT

    FOR i := 1 TO Len(aAlunos)
        nMedia := (aAlunos[i][2] + aAlunos[i][3] + aAlunos[i][4] + aAlunos[i][5]) / 4
        IF nMedia >= 7
            nAprovados++
        ELSE
            nReprovados++
        ENDIF
    NEXT

    IF nAprovados > 0
        Qout()
        Qout("*APROVADOS*")
        FOR i := 1 TO Len(aAlunos)
            nMedia := (aAlunos[i][2] + aAlunos[i][3] + aAlunos[i][4] + aAlunos[i][5]) / 4
            IF nMedia >= 7
                Qout(aAlunos[i][1] + " - Media: " + AllTrim(Str(nMedia, 10, 2)))
            ENDIF
        NEXT
    ENDIF

    IF nReprovados > 0
        Qout()
        Qout("*REPROVADOS*")
        FOR i := 1 TO Len(aAlunos)
            nMedia := (aAlunos[i][2] + aAlunos[i][3] + aAlunos[i][4] + aAlunos[i][5]) / 4
            IF nMedia < 7
                Qout(aAlunos[i][1] + " - Media: " + AllTrim(Str(nMedia, 10, 2)))
            ENDIF
        NEXT
    ENDIF
RETURN NIL

FUNCTION NomeValido(cTexto)
    LOCAL i

    IF Empty(cTexto)
        RETURN .F.
    ENDIF

    FOR i := 1 TO Len(cTexto)
        IF !(IsAlpha(SubStr(cTexto, i, 1)) .OR. SubStr(cTexto, i, 1) == " ")
            RETURN .F.
        ENDIF
    NEXT
RETURN .T.

FUNCTION NotaValida(cTexto)
    LOCAL i

    IF Empty(cTexto)
        RETURN .F.
    ENDIF

    FOR i := 1 TO Len(cTexto)
        IF !(IsDigit(SubStr(cTexto, i, 1)) .OR. SubStr(cTexto, i, 1) == ".")
            RETURN .F.
        ENDIF
    NEXT
RETURN .T.
