# Exercício 1 — AxCadastro × mBrowse

## a. Quando você usaria AxCadastro e quando usaria mBrowse? Dê um exemplo de cada.

### AxCadastro
Eu usaria **AxCadastro** quando preciso criar um cadastro simples rapidamente, como um protótipo ou uma tabela que não exige muita customização visual ou regras complexas. É o jeito mais rápido de ter um CRUD funcionando.

**Exemplo:** Um cadastro básico de categorias de produtos (ZA0 - Categorias) onde só preciso incluir, alterar, excluir e visualizar registros simples, sem necessidade de legendas coloridas ou filtros avançados.

### mBrowse
Eu usaria **mBrowse** em rotinas de produção onde preciso de mais controle sobre a interface e funcionalidades avançadas, como legendas coloridas para destacar status, filtros dinâmicos personalizados, ou colunas customizadas.

**Exemplo:** Um cadastro de pedidos de venda onde preciso que as linhas apareçam com cores diferentes dependendo do status (verde = aprovado, amarelo = pendente, vermelho = cancelado), além de filtros para mostrar só pedidos do mês ou de um cliente específico.

---

## b. Cite três coisas que o mBrowse faz e o AxCadastro não faz.

1. **Legendas coloridas (aColors):** O mBrowse permite pintar as linhas do browse com cores diferentes baseadas em regras de negócio, facilitando a identificação visual de registros importantes ou com status específicos.

2. **Filtros dinâmicos avançados:** O mBrowse oferece controle completo sobre filtros, permitindo criar filtros pré-definidos por código (cFiltro) e habilitar/desabilitar o menu de filtro para o usuário (lNoMnuFilter).

3. **Colunas personalizadas:** O mBrowse permite definir exatamente quais colunas aparecem no browse e em que ordem, através do array aColunas, oferecendo controle total sobre a apresentação dos dados.

---

## c. Na configuração de legendas (aColors), por que a regra ".T." deve ficar por último?

A regra **".T."** (que significa sempre verdadeiro) deve ficar por último porque as regras do aColors são **avaliadas de cima para baixo**, e o Protheus aplica a cor da **primeira regra que for verdadeira**.

Se colocarmos ".T." no início, ela sempre será verdadeira para todos os registros, e as outras regras nunca serão avaliadas. Por isso, ".T." funciona como a **cor padrão** para todos os registros que não se enquadram em nenhuma das regras específicas anteriores.

**Exemplo:**
```advpl
aColors := {
    {"ZA1->ZA1_DTNASC < dDataBase - 30", "BR_RED"},    // Vermelho: pets antigos
    {"ZA1->ZA1_DTNASC == dDataBase", "BR_YELLOW"},     // Amarelo: aniversário hoje
    {".T.", "BR_GREEN"}                                 // Verde: padrão (todos os demais)
}
```

---

## d. Qual a diferença entre um campo Virtual (X3_RELACAO) e um gatilho (SX7) para preencher o nome do cliente?

### Campo Virtual (X3_RELACAO)
- **Não é gravado no banco de dados** - o valor é calculado apenas na exibição
- É recalculado toda vez que o formulário é aberto ou atualizado
- O contexto é **Virtual** no SX3
- **Uso:** Quando não preciso persistir o dado, apenas exibi-lo

**Exemplo no ZA1_NOMCLI:**
```
X3_CONTEXT = "Virtual"
X3_RELACAO = POSICIONE("SA1",1,xFilial("SA1")+M->ZA1_CLIENT+M->ZA1_LOJA,"A1_NOME")
```

### Gatilho (SX7)
- **Grava o valor no banco de dados** - preenche um campo Real no momento da digitação
- É executado quando o usuário sai do campo que dispara o gatilho
- O valor fica persistido e não muda automaticamente se o cliente for alterado depois
- **Uso:** Quando preciso guardar o valor no momento do cadastro

**Exemplo ZA1_CLIENT → ZA1_NOMCLI:**
```
Campo: ZA1_CLIENT
Contra-domínio: ZA1_NOMCLI
Regra: POSICIONE("SA1",1,xFilial("SA1")+M->ZA1_CLIENT+M->ZA1_LOJA,"A1_NOME")
```

