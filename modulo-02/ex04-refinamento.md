## Nível 1 — Visão geral

```
Início
    Registrar itens da compra
    Calcular subtotal
    Aplicar desconto (se tiver cartão fidelidade)
    Mostrar total a pagar
Fim
```

---

## Nível 2 — Detalhamento

```
Registrar itens da compra:
    Subtotal ← 0
    Repita
        Leia NomeProduto
        Leia PrecoProduto
        Subtotal ← Subtotal + PrecoProduto
    Até que não haja mais itens

Calcular subtotal:
    (acumulado durante o registro de cada item)

Aplicar desconto:
    Leia PossuiCartaoFidelidade
    Se PossuiCartaoFidelidade = "Sim"
        Desconto ← Subtotal * 0.05
    Senão
        Desconto ← 0
    Total ← Subtotal - Desconto

Mostrar total a pagar:
    Escreva "Subtotal: R$ ", Subtotal
    Escreva "Desconto: R$ ", Desconto
    Escreva "Total a pagar: R$ ", Total
```

---