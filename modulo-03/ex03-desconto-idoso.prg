#define PERC_DESCONTO_IDOSO 0.125
#define IDADE_IDOSO 60

FUNCTION Main()
    LOCAL cNome, cDataNasc, cPreco
    LOCAL dNasc
    LOCAL nPreco, nIdade, nDesconto, nTotal

    SET DATE FORMAT TO "DD/MM/YYYY"

    ACCEPT "Digite o nome do cliente: " TO cNome
    ACCEPT "Digite a data de nascimento (DD/MM/AAAA): " TO cDataNasc
    ACCEPT "Digite o preco do produto: " TO cPreco

    dNasc  := CTOD(cDataNasc)
    nPreco := Val(cPreco)
    nIdade := Int((Date() - dNasc) / 365)

    IF nIdade > IDADE_IDOSO
        nDesconto := nPreco * PERC_DESCONTO_IDOSO
    ELSE
        nDesconto := 0
    ENDIF

    nTotal := nPreco - nDesconto

    QOut("===== Resumo da Compra =====")
    QOut("Cliente  : " + cNome)
    QOut("Idade    : " + AllTrim(Str(nIdade)) + " anos")
    QOut("Preco    : R$ " + AllTrim(Str(nPreco, 10, 2)) + " Reais")
    QOut("Desconto : R$ " + AllTrim(Str(nDesconto, 10, 2)) + " Reais")
    QOut("Total    : R$ " + AllTrim(Str(nTotal, 10, 2)) + " Reais")
RETURN NIL
