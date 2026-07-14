REQUEST HB_LANG_PT

FUNCTION Main()
    LOCAL cNome := "Jos‚ Alberto"
    LOCAL cCidade := "SÆo Paulo"
    LOCAL cCurso := "Harbour/ADVPL"
    LOCAL cIgual := "==========================="
    LOCAL cData := DToC(Date())
    LOCAL cHora := Time() 

    hb_cdpSelect( "PT850" )
    hb_langSelect( "PT" )

    QOut(cIgual)
    QOut("  FICHA DE APRESENTACAO")
    QOut(cIgual)
    QOut("Nome    : " + cNome)
    QOut("Cidade  : " + cCidade)
    QOut("Curso   : " + cCurso)
    QOut("Data    : " + cData)
    QOut("Hora    : " + cHora)
    QOut(cIgual)
RETURN NIL    
