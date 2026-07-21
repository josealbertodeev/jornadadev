REQUEST HB_LANG_PT

FUNCTION Main()
    LOCAL cNome := "Jos‚ Alberto"
    LOCAL cCidade := "SÆo Paulo"
    LOCAL cFrase := "Pronto para aprender ADVPL!"

    hb_cdpSelect( "PT850" )
    hb_langSelect( "PT" )

    QOut("Nome: " + cNome)
    QOut("Cidade: " + cCidade)
    QOut("Frase: " + cFrase)
RETURN NIL