# Exercício 2 — Pseudocódigo

## a) Área de um retângulo

Início
    Leia Base
    Leia Altura
    Area <- Base * Altura
    Escreva "A área do retângulo é: ", Area
Fim

---

## b) Verificar se um número é par ou ímpar

Início
    Leia Numero
    Se (Numero % 2 = 0)
        Escreva "O número é par"
    Senão
        Escreva "O número é ímpar"
Fim

---

## c) Encontrar o maior entre três números

Início
    Leia Numero1
    Leia Numero2
    Leia Numero3

    Se (Numero1 >= Numero2) e (Numero1 >= Numero3)
        Escreva "O maior número é: ", Numero1
    SenãoSe (Numero2 >= Numero1) e (Numero2 >= Numero3)
        Escreva "O maior número é: ", Numero2
    Senão
        Escreva "O maior número é: ", Numero3
Fim