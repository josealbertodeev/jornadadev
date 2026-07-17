FUNCTION Main()
    LOCAL cCompleta := "Harbour"
    LOCAL cParcial  := "Harb"

    // '=' compara so os caracteres da string mais curta (comparacao parcial no harbour ele considera os primeiros 4 caracteres da string e ignora o resto)
    IF cCompleta = cParcial
        QOut("cCompleta =  cParcial  -> .T.")
    ELSE
        QOut("cCompleta =  cParcial  -> .F.")
    ENDIF

    // '==' exige que as duas strings sejam identicas em conteudo e tamanho
    IF cCompleta == cParcial
        QOut("cCompleta == cParcial -> .T.")
    ELSE
        QOut("cCompleta == cParcial -> .F.")
    ENDIF
RETURN NIL
