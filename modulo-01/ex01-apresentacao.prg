FUNCTION Main()
    LOCAL cNome:= "Jos‚ Alberto"
    LOCAL cCidade:= "SÆo Paulo"
    LOCAL cCurso:= "Harbour/ADVPL"

    hb_cdpSelect("PT850")

    ? "==========================="
    ? "  FICHA DE APRESENTACAO"
    ? "==========================="
    ? "Nome  : " + cNome
    ? "Cidade: " + cCidade
    ? "Curso : " + cCurso
    ? "==========================="
RETURN NIL
