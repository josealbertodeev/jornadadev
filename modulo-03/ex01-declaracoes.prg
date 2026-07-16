FUNCTION Main()
    LOCAL cNomeFuncionario := "Rodolfo da Silva"
    LOCAL nSalarioBruto    := 4500
    LOCAL lAtivo           := .T.
    LOCAL dDataAdmissao    := STOD("20210415")
    LOCAL cCodDepartamento := "TI-01"

    SET DATE FORMAT TO "DD/MM/YYYY"

    QOut(cNomeFuncionario)
    QOut(AllTrim(Str(nSalarioBruto, 10, 2)))
    QOut(lAtivo)
    QOut(dDataAdmissao)
    QOut(cCodDepartamento)
RETURN NIL

