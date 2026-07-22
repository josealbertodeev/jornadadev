FUNCTION Main()
    LOCAL cJogadaUsuario, cJogadaCPU, cResultado

    Qout("=== JOKENPO ===")
    ACCEPT "Escolha pedra, papel ou tesoura: " TO cJogadaUsuario
    cJogadaUsuario := Lower(cJogadaUsuario)

    IF !ValidarJogada(cJogadaUsuario)
        Qout("Jogada invalida.")
        RETURN NIL
    ENDIF

    cJogadaCPU := SortearJogadaCPU()
    Qout("CPU jogou: " + cJogadaCPU)

    cResultado := DefinirVencedor(cJogadaUsuario, cJogadaCPU)
    Qout(cResultado)
RETURN NIL

FUNCTION SortearJogadaCPU()
    LOCAL aJogadas := {"pedra", "papel", "tesoura"}
RETURN aJogadas[HB_RandomInt(1, 3)]

FUNCTION ValidarJogada(cJogada)
RETURN cJogada == "pedra" .OR. cJogada == "papel" .OR. cJogada == "tesoura"

FUNCTION DefinirVencedor(cJogada1, cJogada2)
    IF cJogada1 == cJogada2
        RETURN "Empate!"
    ENDIF

    IF (cJogada1 == "pedra" .AND. cJogada2 == "tesoura") .OR. ;
       (cJogada1 == "papel" .AND. cJogada2 == "pedra") .OR. ;
       (cJogada1 == "tesoura" .AND. cJogada2 == "papel")
        RETURN "Voce venceu!"
    ENDIF
RETURN "CPU venceu!"
