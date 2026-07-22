FUNCTION Main()
    LOCAL cHora
    LOCAL nAtualizacao

    Qout("=== RELOGIO DIGITAL ===")

    FOR nAtualizacao := 1 TO 5
        cHora := ObterHora()
        cHora := FormatarHora(cHora)
        ExibirHora(cHora)
        hb_idleSleep(30)
    NEXT
RETURN NIL

FUNCTION ObterHora()
RETURN Time()

FUNCTION FormatarHora(cHora)
RETURN cHora

FUNCTION ExibirHora(cHora)
    Qout("Hora atual: " + cHora)
RETURN NIL 
