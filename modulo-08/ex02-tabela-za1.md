# Exercício 2 — Completando a tabela ZA1 (o pet ganha um dono)

## Objetivo
Completar a tabela ZA1 (Pets) no Configurador, adicionando os campos que amarram o pet ao seu dono (cliente da SA1), configurando o campo virtual ZA1_NOMCLI e os índices necessários.

---

## 1. Configuração da Tabela (SX2)

**Menu:** Configurador > Dicionário > Banco de Dados > Dicionário de Dados

| Campo | Valor |
|-------|-------|
| **Prefixo** | ZA1 |
| **Nome** | Pets |
| **Modo** | C (Compartilhado) |
| **Arquivo** | ZA1010 |

---

## 2. Campos da Tabela (SX3)

**Menu:** Configurador > Dicionário > Campos

### Estrutura completa dos campos:

| Campo | Descrição | Tipo | Tamanho | Dec | Contexto | Observações |
|-------|-----------|------|---------|-----|----------|-------------|
| ZA1_FILIAL | Filial | C | 2 | 0 | Real | Campo padrão de todas as tabelas |
| ZA1_COD | Código | C | 6 | 0 | Real | Código sequencial do pet |
| ZA1_CLIENT | Cliente (dono) | C | 6 | 0 | Real | Código do cliente na SA1 |
| ZA1_LOJA | Loja do cliente | C | 2 | 0 | Real | Loja do cliente na SA1 |
| ZA1_NOMCLI | Nome do cliente | C | 40 | 0 | **Virtual** | Calculado pela relação |
| ZA1_NOME | Nome do pet | C | 30 | 0 | Real | Nome do animal |
| ZA1_RACA | Raça | C | 20 | 0 | Real | Raça do pet |
| ZA1_DTNASC | Nascimento | D | 8 | 0 | Real | Data de nascimento |
| ZA1_OBS | Observação | C | 60 | 0 | Real | Observações gerais |

---

## 3. Configurações Especiais

### Campo ZA1_COD (Código sequencial)
- **Browse:** Sim (aparece na listagem)
- **X3_VALID:** ExistChav("ZA1") (garante unicidade)
- **X3_RELACAO:** GetSXENum("ZA1","ZA1_COD") (gera próximo número)

### Campo ZA1_CLIENT (Cliente - Dono do Pet)
- **Browse:** Sim
- **X3_F3:** SA1 ou SA1010 (consulta padrão de clientes)
- **X3_VALID:** ExistCpo("SA1", xFilial("SA1")+M->ZA1_CLIENT+M->ZA1_LOJA, 1)
  - Valida se o cliente existe na SA1

### Campo ZA1_LOJA (Loja do Cliente)
- **Browse:** Sim
- **Observação:** Trabalha em conjunto com ZA1_CLIENT para identificar o cliente

### Campo ZA1_NOMCLI (Nome do Cliente - VIRTUAL)
Este é o campo mais importante do exercício - ele amarra o pet ao dono!

- **X3_CONTEXT:** Virtual (não grava no banco)
- **X3_BROWSE:** Sim (aparece na listagem)
- **X3_RELACAO (Relação/Inicializador):**
```advpl
POSICIONE("SA1",1,xFilial("SA1")+M->ZA1_CLIENT+M->ZA1_LOJA,"A1_NOME")
```

**Explicação da relação:**
- `POSICIONE("SA1", 1, ...)` - Busca na tabela SA1 usando o índice 1
- `xFilial("SA1")` - Filial correta da SA1
- `M->ZA1_CLIENT + M->ZA1_LOJA` - Monta a chave de busca (código + loja)
- `"A1_NOME"` - Retorna o nome do cliente

### Campo ZA1_NOME (Nome do Pet)
- **Browse:** Sim
- **X3_OBRIGAT:** Sim (campo obrigatório)

### Campo ZA1_DTNASC (Data de Nascimento)
- **Browse:** Sim
- **Tipo:** D (Data)

---

## 4. Índices da Tabela (SIX)

**Menu:** Configurador > Dicionário > Índices

### Índice 1 - Chave Primária
- **Ordem:** 1
- **Chave:** `ZA1_FILIAL + ZA1_COD`
- **Descrição:** Código do Pet
- **Único:** Sim

### Índice 2 - Por Cliente
- **Ordem:** 2
- **Chave:** `ZA1_FILIAL + ZA1_CLIENT + ZA1_LOJA`
- **Descrição:** Cliente + Loja
- **Único:** Não

**Uso do índice 2:** Permite buscar rapidamente todos os pets de um determinado cliente.

---

## 5. Resumo das Ações no Configurador

### Passo a Passo:

1. **SX2 - Criar/Verificar a tabela:**
   - Abrir: Configurador > Dicionário > Banco de Dados
   - Incluir tabela ZA1 se não existir
   - Modo: Compartilhado (C)

2. **SX3 - Configurar todos os campos:**
   - Abrir: Configurador > Dicionário > Campos
   - Incluir cada campo da lista acima
   - **Atenção especial:**
     - ZA1_CLIENT: configurar F3 e validação
     - ZA1_NOMCLI: contexto Virtual + relação POSICIONE

3. **SIX - Criar os índices:**
   - Abrir: Configurador > Dicionário > Índices
   - Índice 1: ZA1_FILIAL + ZA1_COD
   - Índice 2: ZA1_FILIAL + ZA1_CLIENT + ZA1_LOJA

4. **Abrir tabelas:**
   - Menu: Miscelânea > Administrador > Dicionário > Abrir Tabelas
   - Selecionar ZA1 para criar fisicamente a tabela no banco

---

