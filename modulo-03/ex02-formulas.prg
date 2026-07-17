#define PI 3.14159

FUNCTION Main()
    LOCAL cRaio, cCatetoA, cCatetoB, cPeso, cAltura
    LOCAL nRaio, nCatetoA, nCatetoB, nPeso, nAltura
    LOCAL nAreaCirculo, nHipotenusa, nImc

    ACCEPT "Digite o raio do circulo: " TO cRaio
    ACCEPT "Digite o cateto A do triangulo: " TO cCatetoA
    ACCEPT "Digite o cateto B do triangulo: " TO cCatetoB
    ACCEPT "Digite o peso (kg): " TO cPeso
    ACCEPT "Digite a altura (m): " TO cAltura

    nRaio    := Val(cRaio)
    nCatetoA := Val(cCatetoA)
    nCatetoB := Val(cCatetoB)
    nPeso    := Val(cPeso)
    nAltura  := Val(cAltura)

    nAreaCirculo := PI * (nRaio ^ 2)
    nHipotenusa  := Sqrt((nCatetoA ^ 2) + (nCatetoB ^ 2))
    nImc         := nPeso / (nAltura ^ 2)

    QOut("Area do circulo : " + AllTrim(Str(nAreaCirculo, 10, 2)))
    QOut("Hipotenusa      : " + AllTrim(Str(nHipotenusa, 10, 2)))
    QOut("IMC             : " + AllTrim(Str(nImc, 10, 2)))
RETURN NIL

