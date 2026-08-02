# TCC — Controle de Não Conformidades de Fornecedores (ISO 9001)

**Curso:** TOTVS Paulista — Jornada DEV START (Harbour/AdvPL — Do Zero ao Protheus)

**Aluno:** José Alberto  — [josealbertodeev](https://github.com/josealbertodeev)
**Entrega individual.**

## 1. Descrição do sistema

A Indústria XYZ precisa monitorar as não conformidades na entrada de materiais dos
seus fornecedores para se manter em conformidade com o processo de certificação
ISO 9001. O sistema, desenvolvido em AdvPL sobre o Protheus, registra:

- Os **certificados de qualidade dos fornecedores**, com uma tolerância percentual
  de não conformidade aceitável (tabela `ZZ1`);
- As **ocorrências de não conformidade** em cada entrega de material, vinculadas ao
  certificado do fornecedor (tabela `ZZ2`).

As rotinas foram pensadas para o módulo de Compras (SIGACOM), vinculando-se às
tabelas padrão `SA2` (Fornecedores) e `SB1` (Produtos).

## 2. Como este TCC foi entregue

Durante o desenvolvimento, o ambiente Protheus local apresentou instabilidade
recorrente na gravação do dicionário de dados (o Configurador restaurava um
snapshot antigo do SIX/SX2/SX3 mesmo após confirmar e salvar as tabelas ZZ1 e ZZ2
corretamente, fazendo-as desaparecer). Para não comprometer o prazo, segui o
caminho alternativo previsto no próprio enunciado do TCC:

> *"Sem o ambiente Protheus? Você entrega mesmo assim: o dicionário como
> CSV/tabela no README e os fontes .PRW escritos e comentados."*

Por isso, esta entrega está toda em **texto** (CSV + `.PRW`), sem `.dbf` nem
prints de tela — o que, segundo a própria rubrica de avaliação, garante nota
cheia nos itens de código.

## 3. Estrutura de arquivos

```
TCC/
├── Dados-e-Dicionario/
│   ├── SX2_Tabelas.csv     ← cabeçalho das tabelas ZZ1 e ZZ2
│   ├── SX3_Campos.csv      ← campos, tipos, tamanhos e validações
│   ├── SIX_Indices.csv     ← índices das duas tabelas
│   ├── SX7_Gatilhos.csv    ← gatilhos automáticos
│   ├── SIGACOM_Menu.csv    ← estrutura de menu no módulo de Compras
│   └── SXB_Consultas.csv   ← consultas padrão (ZZ1, SA2, SB1)
├── STTZZ1.PRW              ← rotina de manutenção da ZZ1
├── STTZZ2.PRW              ← rotina de manutenção da ZZ2 (+ versão filtrada)
├── STTZZLIB.PRW            ← biblioteca de funções comuns
├── README.md                ← este arquivo
└── AUTOAVALIACAO.md
```

## 4. Tabelas

### ZZ1 — Controle de Fornecimento

10 campos, 3 índices. Acesso compartilhado. Estrutura completa em
`Dados-e-Dicionario/SX2_Tabelas.csv`, `SX3_Campos.csv` e `SIX_Indices.csv`.

Resumo dos campos principais:

| Campo | Tipo | Descrição |
|---|---|---|
| ZZ1_CODIGO | C(6) | Código do controle (chave, junto com a filial) |
| ZZ1_FORNEC / ZZ1_LOJAFO | C(6)/C(2) | Fornecedor (chave composta com a SA2) |
| ZZ1_NOMEFO | C(40), **virtual** | Nome do fornecedor (via gatilho, `POSICIONE` na SA2) |
| ZZ1_CERTIF | C(256) | Dados do certificado |
| ZZ1_VALCER | D | Validade do certificado |
| ZZ1_TOLERA | N(5,2) | Tolerância percentual de não conformidade (0 a 100) |
| ZZ1_TOTOK / ZZ1_TOTNOK | N(12,2) | Totais de itens conformes / não conformes |

**Validações** (campo a campo, no SX3 — coluna `Valid` do CSV):
- `ZZ1_FORNEC` precisa existir na SA2 (`ExistCpo`)
- `ZZ1_VALCER` não pode ser anterior à data atual
- `ZZ1_TOLERA` precisa estar entre 0 e 100

### ZZ2 — Ocorrências do Fornecedor

13 campos, 3 índices. Acesso compartilhado. Vinculada à ZZ1 pelo campo
`ZZ2_CONFOR` (código do controle).

| Campo | Tipo | Descrição |
|---|---|---|
| ZZ2_CONFOR | C(6) | Controle da ZZ1 vinculado |
| ZZ2_FORNEC / ZZ2_LOJAFO / ZZ2_NOMEFO | — | Preenchidos automaticamente via gatilho, a partir da ZZ1 |
| ZZ2_DATA / ZZ2_HORA | D / C(5) | Preenchidos automaticamente na inclusão (data/hora atual) |
| ZZ2_CODPRO | C(15) | Produto da ocorrência (SB1) |
| ZZ2_QTDOK / ZZ2_QTDNOK | N(12) | Quantidades conforme/não conforme |
| ZZ2_VLRUNI | N(12,2) | Valor unitário |
| ZZ2_TOTOK / ZZ2_TOTNOK | N(12,2), **virtuais** | Valor total conforme/não conforme (qtd × valor unitário) |

**Validações:**
- `ZZ2_CONFOR` precisa existir na ZZ1
- `ZZ2_CODPRO` precisa existir na SB1
- `ZZ2_DATA` não pode ser uma data futura

## 5. Gatilhos (SX7)

Detalhados em `Dados-e-Dicionario/SX7_Gatilhos.csv`. Resumo:

1. `ZZ1_FORNEC` → preenche `ZZ1_NOMEFO` (nome via SA2)
2-4. `ZZ2_CONFOR` → preenche `ZZ2_FORNEC`, `ZZ2_LOJAFO` e `ZZ2_NOMEFO` (dados
     puxados da ZZ1 e da SA2)
5. `ZZ2_DATA` → preenche a data atual na inclusão
6. `ZZ2_HORA` → preenche a hora atual na inclusão

## 6. Rotinas

### STTZZ1.PRW — `USER FUNCTION STTZZ1()`

Manutenção da ZZ1 usando `AxCadastro`, que já entrega Pesquisar, Incluir,
Alterar, Excluir e Visualizar. Toda a chamada está protegida por um bloco
`BEGIN SEQUENCE / RECOVER`: qualquer erro inesperado durante a operação exibe
uma mensagem amigável ao usuário e grava um log técnico via
`U_GravarLogTCC` (STTZZLIB.PRW), em vez de estourar um erro cru do Protheus.

### STTZZ2.PRW — `USER FUNCTION STTZZ2()` e `STTZZ2FLT(cCodigoZZ1)`

Mesmo padrão da STTZZ1 (AxCadastro + BEGIN SEQUENCE). A `STTZZ2FLT` é uma
versão que filtra a ZZ2 por um código de controle da ZZ1 específico — já
deixa a base pronta para, numa próxima iteração, ser chamada por um botão
"Ocorrências" dentro da STTZZ1.

### STTZZLIB.PRW — biblioteca de funções comuns

| Função | O que faz |
|---|---|
| `NomeFornecedor(cFornec, cLoja)` | Busca o nome do fornecedor na SA2 |
| `NomeProduto(cCodPro)` | Busca a descrição do produto na SB1 |
| `PercNaoConforme(nOk, nNok)` | Calcula o % de não conformidade |
| `CertificadoVencendo(dValCer)` | Retorna `.T.` se o certificado vence em até 30 dias |
| `GravarLogTCC(cFuncao, oErro)` | Log técnico de erro, usado nos blocos `RECOVER` |

## 7. Consultas padrão (SXB)

Definidas em `Dados-e-Dicionario/SXB_Consultas.csv`:

| Código | Descrição | Campos exibidos |
|---|---|---|
| ZZ1 | Controle de Fornecimento | Código, Nome do Fornecedor, Validade do Certificado |
| SA2 | Fornecedores | Código, Loja, Nome |
| SB1 | Produtos | Código, Descrição, Unidade de Medida |

## 8. Menu (SIGACOM)

Estrutura definida em `Dados-e-Dicionario/SIGACOM_Menu.csv`:

```
Cadastros
 └── Controle ISO 9001
     ├── Controle de Fornecimento (ZZ1) → USER FUNCTION STTZZ1
     └── Ocorrências de Fornecedores (ZZ2) → USER FUNCTION STTZZ2
```

## 9. Como instalar (quando o ambiente estiver disponível)

1. Importar a estrutura das tabelas `ZZ1` e `ZZ2` no Configurador
   (Base de Dados → Dicionário → Base de Dados → Incluir), usando os campos e
   índices descritos em `SX2_Tabelas.csv`, `SX3_Campos.csv` e `SIX_Indices.csv`.
2. Cadastrar os 6 gatilhos listados em `SX7_Gatilhos.csv`
   (Base de Dados → Dicionário → Gatilhos).
3. Compilar `STTZZLIB.PRW`, `STTZZ1.PRW` e `STTZZ2.PRW` no ambiente (a ordem
   importa: `STTZZLIB.PRW` primeiro, porque as outras duas dependem da função
   `U_GravarLogTCC`).
4. Acessar via `STTZZ1` (Controle de Fornecimento) e `STTZZ2` (Ocorrências do
   Fornecedor).

> ⚠️ Durante o desenvolvimento, reiniciar o AppServer depois de alterar o
> dicionário se mostrou necessário para que os gatilhos reconhecessem os
> campos novos — vale testar isso se surgir o erro "NOMECPO" ao cadastrar
> gatilhos logo após criar uma tabela.

## 10. O que ainda não foi implementado

Para deixar claro o que é núcleo mínimo (entregue) e o que é diferencial
(parcialmente entregue):

- ✅ Dicionário completo (ZZ1 + ZZ2), rotinas de manutenção, validações,
  gatilhos, tratamento de erros, biblioteca de funções.
- ⬜ Legenda colorida por mBrowse (comparação de % não conforme vs.
  `ZZ1_TOLERA`) — as rotinas atuais usam `AxCadastro`, mais simples.
- ⬜ Integridade referencial na exclusão (impedir apagar uma ZZ1 com ZZ2
  vinculada).
- ⬜ Classe ADVPL (POO).
