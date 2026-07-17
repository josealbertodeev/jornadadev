FUNCTION Main()

    LOCAL cNomeFuncionario := "Rodolfo Silva"
    LOCAL nSalarioBruto    := 4500
    LOCAL lAtivo           := .T.
    LOCAL dDataAdmissao
    LOCAL cCodDepartamento := "TI-01"

    SET DATE FORMAT TO "DD/MM/YYYY"

    dDataAdmissao := CTOD("15/04/2021")

    QOut(cNomeFuncionario)
    QOut("R$ " +AllTrim(Str(nSalarioBruto, 10, 2)) + " reais")
    QOut(lAtivo)
    QOut(dDataAdmissao)
    QOut(cCodDepartamento)
RETURN NIL

