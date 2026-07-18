FUNCTION Main()
    LOCAL cNome
    LOCAL cDisc
    LOCAL nNota1
    LOCAL nNota2
    LOCAL nMedia

    cNome := Space(0)
    WHILE Len(Trim(cNome)) == 0
        ACCEPT "Nome: " TO cNome
        IF Len(Trim(cNome)) == 0
            Qout("Nome nao pode ser vazio. Tente novamente.")
        ENDIF
    ENDDO

    cDisc := Space(0)
    WHILE !(Len(cDisc) == 3 .AND. cDisc == Upper(cDisc))
        ACCEPT "Disciplina (3 letras maiusculas, ex.: MAT): " TO cDisc
        IF !(Len(cDisc) == 3 .AND. cDisc == Upper(cDisc))
            Qout("Disciplina invalida. Informe exatamente 3 letras maiusculas.")
        ENDIF
    ENDDO

    nNota1 := -1
    WHILE nNota1 < 0 .OR. nNota1 > 10
        INPUT "Nota 1 (0 a 10): " TO nNota1
        IF nNota1 < 0 .OR. nNota1 > 10
            Qout("Nota invalida. Informe um valor entre 0 e 10.")
        ENDIF
    ENDDO

    nNota2 := -1
    WHILE nNota2 < 0 .OR. nNota2 > 10
        INPUT "Nota 2 (0 a 10): " TO nNota2
        IF nNota2 < 0 .OR. nNota2 > 10
            Qout("Nota invalida. Informe um valor entre 0 e 10.")
        ENDIF
    ENDDO

    nMedia := (nNota1 + nNota2) / 2

    Qout("")
    Qout("Nome: " + Trim(cNome))
    Qout("Disciplina: " + cDisc)
    Qout("Nota 1: " + NTOC(nNota1))
    Qout("Nota 2: " + NTOC(nNota2))
    Qout("Media: " + NTOC(nMedia))
RETURN NIL