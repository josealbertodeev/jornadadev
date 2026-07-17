FUNCTION Main()
    LOCAL cNota1, cNota2, cNota3, cNota4
    LOCAL nNota1, nNota2, nNota3, nNota4
    LOCAL nMedia

    ACCEPT "Digite a nota do 1 bimestre: " TO cNota1
    ACCEPT "Digite a nota do 2 bimestre: " TO cNota2
    ACCEPT "Digite a nota do 3 bimestre: " TO cNota3
    ACCEPT "Digite a nota do 4 bimestre: " TO cNota4

    nNota1 := Val(cNota1)
    nNota2 := Val(cNota2)
    nNota3 := Val(cNota3)
    nNota4 := Val(cNota4)

    nMedia := (nNota1 * 1 + nNota2 * 2 + nNota3 * 3 + nNota4 * 4) / (1 + 2 + 3 + 4)

    QOut("Media ponderada: " + AllTrim(Str(nMedia, 10, 2)))
RETURN NIL
