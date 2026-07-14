REQUEST HB_LANG_PT

FUNCTION Main()
    LOCAL nNome := "Jos‚ Alberto"
    LOCAL nCidade := "SÆo Paulo"
    LOCAL nFrase := "Pronto para aprender ADVPL!"

    hb_cdpSelect( "PT850" )
    hb_langSelect( "PT" )

    QOut("Nome: " + nNome)
    QOut("Cidade: " + nCidade)
    QOut("Frase: " + nFrase)
RETURN NIL