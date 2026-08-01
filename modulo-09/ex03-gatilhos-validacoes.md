# Exercício 3 — Gatilhos, Campos Virtuais e Validações Cruzadas (Bônus)

## 📋 Objetivo

Deixar o sistema **"esperto"** com funcionalidades automáticas:
- ✅ **Campos virtuais** que buscam dados relacionados
- ✅ **Gatilhos automáticos** que preenchem campos sozinhos
- ✅ **Validações cruzadas** que garantem integridade referencial

---

## 🎯 O que será configurado

### 1️⃣ Campos Virtuais na SZ2
- `Z2_CODIGO` - Código do contato (cópia do Z2_CONTAT para exibição)
- `Z2_ASSUNT` - Assunto da interação (já existe como Real, mas pode ser Virtual para busca)

### 2️⃣ Gatilhos Automáticos (SX7)
- `Z2_DATA` → `dDataBase` (fase 1)
- `Z2_HORA` → `IF(INCLUI, Time(), SZ2->Z2_HORA)` (fase 3)
- `Z2_USUAR` → `cNomUsr` (fase 1)

### 3️⃣ Validação Cruzada
- `Z2_CONTAT` → `ExistCpo("SZ1", ...)` no X3_VALID

---

## 📝 PARTE 1: Campos Virtuais na SZ2

### Acessar o Configurador
```
Menu: Configurador > Dicionário de Dados > Campos (SX3)
Tabela: SZ2
```

---

### ✅ Campo Virtual: Z2_NOMCONT (Nome do Contato)

Vamos criar um campo **NOVO** para exibir o nome do contato no browse de interações.

| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_NOMCONT |
| **Tipo** | Caractere |
| **Tamanho** | 50 |
| **Decimal** | 0 |
| **Título** | Nome Contato |
| **Descrição** | Nome do Contato |
| **Contexto** | **Virtual** |
| **Inicializador (X3_RELACAO)** | `POSICIONE("SZ1",1,xFilial("SZ1")+SZ2->Z2_CONTAT,"Z1_NOME")` |
| **Uso** | Usado |
| **Browse** | Sim |
| **Visual** | V |
| **Ordem** | (depois de Z2_CONTAT) |

#### 📌 Explicação do POSICIONE:

```advpl
POSICIONE(
    "SZ1",                              // Tabela a ser consultada
    1,                                   // Índice (Ordem 1 = Z1_FILIAL+Z1_CODIGO)
    xFilial("SZ1") + SZ2->Z2_CONTAT,    // Chave de busca
    "Z1_NOME"                            // Campo a retornar
)
```

**O que faz:**
- Busca na tabela SZ1 (Contatos)
- Usando o índice 1 (Z1_FILIAL + Z1_CODIGO)
- Com a chave: filial atual + código do contato da interação
- Retorna o campo Z1_NOME (nome do contato)

---

### ✅ Campo Virtual: Z2_EMAILCONT (Email do Contato)

Outro exemplo de campo virtual útil.

| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_EMAILCONT |
| **Tipo** | Caractere |
| **Tamanho** | 100 |
| **Decimal** | 0 |
| **Título** | Email Contato |
| **Descrição** | Email do Contato |
| **Contexto** | **Virtual** |
| **Inicializador (X3_RELACAO)** | `POSICIONE("SZ1",1,xFilial("SZ1")+SZ2->Z2_CONTAT,"Z1_EMAIL")` |
| **Uso** | Usado |
| **Browse** | Não |
| **Visual** | V |

---

## ⚡ PARTE 2: Gatilhos Automáticos (SX7)

### Acessar o Configurador
```
Menu: Configurador > Dicionário de Dados > Gatilhos (SX7)
```

---

### 🎯 Conceito de Gatilhos

**Gatilho (Trigger)** é uma regra que dispara automaticamente quando um campo é preenchido.

**Fases de Execução:**
- **Fase 1**: Executa IMEDIATAMENTE após digitar (sai do campo)
- **Fase 2**: Executa após validação (X3_VALID passou)
- **Fase 3**: Executa durante confirmação (antes de gravar)
- **Fase 4**: Executa após confirmação (depois de gravar)

---

### ✅ Gatilho 1: Z2_DATA → dDataBase (Fase 1)

**Objetivo:** Preencher data atual automaticamente ao incluir interação.

#### Configuração no SX7:

| Propriedade | Valor |
|-------------|-------|
| **Campo Origem (X7_CAMPO)** | Z2_DATA |
| **Sequência (X7_SEQUENC)** | 001 |
| **Campo Destino (X7_CDOMIN)** | Z2_DATA |
| **Tipo (X7_TIPO)** | Campo |
| **Regra (X7_REGRA)** | `dDataBase` |
| **Posiciona (X7_SEEK)** | N |
| **Alias (X7_ALIAS)** | - |
| **Ordem (X7_ORDEM)** | - |
| **Chave (X7_CHAVE)** | - |
| **Condição (X7_CONDIC)** | `INCLUI` |
| **Propri (X7_PROPRI)** | U |
| **Fase (X7_FASE)** | **1** |

#### 📌 Explicação:

```advpl
// Campo Origem: Z2_DATA
// Campo Destino: Z2_DATA (autopreenche ele mesmo)
// Regra: dDataBase (data atual do sistema)
// Condição: INCLUI (só executa na inclusão, não na alteração)
// Fase: 1 (imediatamente ao entrar no campo)
```

**Resultado:** Ao incluir uma interação, o campo Z2_DATA já aparece preenchido com a data atual.

---

### ✅ Gatilho 2: Z2_HORA → Time() (Fase 3)

**Objetivo:** Preencher hora atual automaticamente, mas permitir alteração.

#### Configuração no SX7:

| Propriedade | Valor |
|-------------|-------|
| **Campo Origem (X7_CAMPO)** | Z2_HORA |
| **Sequência (X7_SEQUENC)** | 001 |
| **Campo Destino (X7_CDOMIN)** | Z2_HORA |
| **Tipo (X7_TIPO)** | Campo |
| **Regra (X7_REGRA)** | `IIF(INCLUI, Time(), SZ2->Z2_HORA)` |
| **Posiciona (X7_SEEK)** | N |
| **Alias (X7_ALIAS)** | - |
| **Ordem (X7_ORDEM)** | - |
| **Chave (X7_CHAVE)** | - |
| **Condição (X7_CONDIC)** | - |
| **Propri (X7_PROPRI)** | U |
| **Fase (X7_FASE)** | **3** |

#### 📌 Explicação:

```advpl
// Regra: IIF(INCLUI, Time(), SZ2->Z2_HORA)
//   Se INCLUINDO: retorna Time() (hora atual)
//   Se ALTERANDO: retorna SZ2->Z2_HORA (hora original, não altera)

// Fase: 3 (durante confirmação)
//   Permite que usuário altere a hora antes de salvar
```

**Resultado:** 
- Na **inclusão**: hora atual é preenchida, mas usuário pode alterar
- Na **alteração**: mantém a hora original

---

### ✅ Gatilho 3: Z2_USUARIO → RetCodUsr() + cNomUsr (Fase 1)

**Objetivo:** Preencher código e nome do usuário automaticamente.

#### Primeiro, garantir que o campo Z2_USUARIO existe:

| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_USUARIO |
| **Tipo** | Caractere |
| **Tamanho** | 15 |
| **Contexto** | Real |
| **Inicializador** | `RetCodUsr()` |

#### Configuração do Gatilho no SX7:

| Propriedade | Valor |
|-------------|-------|
| **Campo Origem (X7_CAMPO)** | Z2_USUARIO |
| **Sequência (X7_SEQUENC)** | 001 |
| **Campo Destino (X7_CDOMIN)** | Z2_USUARIO |
| **Tipo (X7_TIPO)** | Campo |
| **Regra (X7_REGRA)** | `RetCodUsr()` |
| **Posiciona (X7_SEEK)** | N |
| **Condição (X7_CONDIC)** | `INCLUI` |
| **Propri (X7_PROPRI)** | U |
| **Fase (X7_FASE)** | **1** |

---

### ✅ Gatilho 4 (Opcional): Z2_USUARIO → Z2_NOMUSR (Nome do Usuário)

Criar campo virtual para exibir o **nome** do usuário.

#### Criar campo Z2_NOMUSR no SX3:

| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_NOMUSR |
| **Tipo** | Caractere |
| **Tamanho** | 40 |
| **Contexto** | **Virtual** |
| **Inicializador** | `UsrRetName(SZ2->Z2_USUARIO)` |
| **Título** | Nome Usuário |
| **Browse** | Sim |

#### Configuração do Gatilho no SX7:

| Propriedade | Valor |
|-------------|-------|
| **Campo Origem (X7_CAMPO)** | Z2_USUARIO |
| **Sequência (X7_SEQUENC)** | 002 |
| **Campo Destino (X7_CDOMIN)** | Z2_NOMUSR |
| **Tipo (X7_TIPO)** | Campo |
| **Regra (X7_REGRA)** | `UsrRetName(M->Z2_USUARIO)` |
| **Condição (X7_CONDIC)** | - |
| **Propri (X7_PROPRI)** | U |
| **Fase (X7_FASE)** | **2** |

---

## ✅ PARTE 3: Validação Cruzada

### Acessar o Configurador
```
Menu: Configurador > Dicionário de Dados > Campos (SX3)
Campo: Z2_CONTAT
```

---

### 🔒 Validação do Campo Z2_CONTAT

**Objetivo:** Garantir que o código do contato informado **realmente exista** na tabela SZ1.

#### Configuração no SX3 - Campo Z2_CONTAT:

| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_CONTAT |
| **Tipo** | Caractere |
| **Tamanho** | 6 |
| **Contexto** | Real |
| **Valid (X3_VALID)** | `ExistCpo("SZ1",xFilial("SZ1")+M->Z2_CONTAT,1)` |
| **F3 (X3_F3)** | SZ1 |
| **Obrigat.** | Sim |

---

### 📌 Explicação do ExistCpo:

```advpl
ExistCpo(
    "SZ1",                           // Tabela onde buscar
    xFilial("SZ1") + M->Z2_CONTAT,  // Chave completa (filial + código)
    1                                // Índice (Ordem 1 = Z1_FILIAL+Z1_CODIGO)
)
```

**O que faz:**
- Busca na tabela **SZ1** (Contatos)
- Usando o **índice 1** (Z1_FILIAL + Z1_CODIGO)
- Com a chave: **filial atual + código digitado** (M->Z2_CONTAT)
- Retorna **.T.** se encontrou, **.F.** se não encontrou

**Resultado:**
- Se o contato **existir**: validação passa, permite continuar
- Se o contato **NÃO existir**: mostra mensagem de erro e não permite salvar

---

### 🔍 Consulta F3 para Z2_CONTAT

Para facilitar a seleção de contatos, configurar consulta padrão.

#### Criar consulta SXB - SZ1:

```
Menu: Configurador > Dicionário de Dados > Consultas Padrão (SXB)
```

| Propriedade | Valor |
|-------------|-------|
| **Consulta** | SZ1 |
| **Tipo** | 1 - Tabela |
| **Tabela** | SZ1 |
| **Retorno** | Z1_CODIGO |
| **Chave de Pesquisa** | Z1_CODIGO+Z1_NOME |
| **Campos Exibidos** | Z1_CODIGO, Z1_NOME, Z1_EMAIL, Z1_TELEFON |

**Resultado:** Ao pressionar **F3** no campo Z2_CONTAT, abre lista de contatos para seleção.

---

## 🧪 Como Testar

### 1️⃣ Atualizar Dicionário

Após fazer todas as configurações no Configurador:

```
Menu: Miscelânea > Atualizações > Processar SX
ou
Executar CFGX051 (processar dicionário)
```

---

### 2️⃣ Testar Campos Virtuais

#### Abrir STTIP004 (Interações):

```advpl
// Através do STTIP003:
U_STTIP003()
// Selecionar um contato
// Clicar em "Interações"
```

#### Verificar no Browse:

O browse de interações agora deve mostrar:
- ✅ **Z2_NOMCONT** - Nome do contato (vindo da SZ1)
- ✅ **Z2_EMAILCONT** - Email do contato (vindo da SZ1)

**Campos virtuais aparecem automaticamente, sem código ADVPL!**

---

### 3️⃣ Testar Gatilhos Automáticos

#### Incluir Nova Interação:

1. No browse de interações, clicar **"Incluir"**
2. Observar que os campos aparecem **pré-preenchidos**:

| Campo | Valor Automático | Como Aparece |
|-------|------------------|--------------|
| **Z2_DATA** | Data atual | 01/08/2026 (já preenchido) |
| **Z2_HORA** | Hora atual | 14:35 (já preenchido, mas pode alterar) |
| **Z2_USUARIO** | Código do usuário | 000001 (automaticamente) |
| **Z2_NOMUSR** | Nome do usuário | ADMINISTRADOR (virtual) |

3. Preencher apenas:
   - Tipo (E/L/R/V/W)
   - Assunto
   - Descrição

4. Confirmar (Ctrl+O)

**Resultado:** Interação gravada com data/hora/usuário automáticos!

---

### 4️⃣ Testar Validação Cruzada

#### Tentar Incluir com Contato Inválido:

1. Incluir nova interação
2. No campo **Z2_CONTAT**, digitar código inexistente: **"999999"**
3. Pressionar Enter

**Resultado Esperado:**
```
┌─────────────────────────────────────┐
│  ⚠️  Atenção                        │
├─────────────────────────────────────┤
│  Registro não encontrado na         │
│  tabela SZ1!                        │
│                                     │
│  Por favor, selecione um            │
│  contato válido.                    │
└─────────────────────────────────────┘
        [    OK    ]
```

**Sistema recusa** salvar a interação!

---

#### Usar F3 para Seleção:

1. Incluir nova interação
2. No campo **Z2_CONTAT**, pressionar **F3**
3. Abre lista de contatos disponíveis
4. Selecionar um contato da lista
5. Código é preenchido automaticamente

**Resultado:** Validação passa, interação é salva com sucesso!

---

## 📊 Resumo das Configurações

### ✅ Campos Virtuais Criados:

| Campo | Fórmula | Exibição |
|-------|---------|----------|
| **Z2_NOMCONT** | `POSICIONE("SZ1",1,...),"Z1_NOME")` | Nome do contato |
| **Z2_EMAILCONT** | `POSICIONE("SZ1",1,...),"Z1_EMAIL")` | Email do contato |
| **Z2_NOMUSR** | `UsrRetName(SZ2->Z2_USUARIO)` | Nome do usuário |

---

### ✅ Gatilhos Configurados:

| Campo Origem | Campo Destino | Regra | Fase | Quando |
|--------------|---------------|-------|------|--------|
| Z2_DATA | Z2_DATA | `dDataBase` | 1 | INCLUI |
| Z2_HORA | Z2_HORA | `IIF(INCLUI,Time(),SZ2->Z2_HORA)` | 3 | Sempre |
| Z2_USUARIO | Z2_USUARIO | `RetCodUsr()` | 1 | INCLUI |
| Z2_USUARIO | Z2_NOMUSR | `UsrRetName(M->Z2_USUARIO)` | 2 | Sempre |

---

### ✅ Validações Configuradas:

| Campo | Tipo | Fórmula | Efeito |
|-------|------|---------|--------|
| Z2_CONTAT | X3_VALID | `ExistCpo("SZ1",xFilial("SZ1")+M->Z2_CONTAT,1)` | Recusa código inexistente |
| Z2_CONTAT | X3_F3 | SZ1 | Consulta padrão F3 |

---

## 💡 Conceitos Aprendidos

### **Campo Virtual vs Gatilho vs Validação**

#### 🔹 **Campo Virtual (X3_RELACAO):**
- Calculado em **tempo real** (não grava no banco)
- Usado para **exibir** informações de outras tabelas
- Exemplo: Z2_NOMCONT busca nome na SZ1

#### 🔹 **Gatilho (SX7):**
- Executa **ação** quando campo é preenchido
- Pode preencher **outros campos** automaticamente
- Exemplo: Z2_DATA preenche data atual

#### 🔹 **Validação (X3_VALID):**
- **Verifica** se valor digitado é válido
- **Bloqueia** gravação se inválido
- Exemplo: Z2_CONTAT verifica se contato existe

---

### **Fases dos Gatilhos**

| Fase | Quando Executa | Uso Comum |
|------|----------------|-----------|
| **1** | Ao sair do campo (imediato) | Preenchimento automático simples |
| **2** | Após validação passar | Cálculos que dependem de campo válido |
| **3** | Na confirmação (antes de gravar) | Cálculos finais, totalizações |
| **4** | Após confirmação (depois de gravar) | Atualizações em outras tabelas |

---

### **POSICIONE vs ExistCpo**

#### 🔹 **POSICIONE:**
- **Busca e retorna** um valor de campo
- Usado em campos **virtuais**
- Exemplo: `POSICIONE("SZ1",1,xFilial("SZ1")+codigo,"Z1_NOME")`

#### 🔹 **ExistCpo:**
- **Verifica se registro existe**
- Retorna **.T.** ou **.F.**
- Usado em **validações**
- Exemplo: `ExistCpo("SZ1",xFilial("SZ1")+M->Z2_CONTAT,1)`

---

### **M-> (Memória) vs Alias-> (Tabela)**

#### 🔹 **M->** (Variável de Memória):
- Valor **sendo digitado** (antes de salvar)
- Usado em: **Gatilhos, Validações, Inicializadores**
- Exemplo: `M->Z2_CONTAT` (código que usuário digitou)

#### 🔹 **Alias->** (Registro da Tabela):
- Valor **já gravado** no banco
- Usado em: **Campos Virtuais, Consultas**
- Exemplo: `SZ2->Z2_USUARIO` (usuário que gravou)

---

## 🎯 Fluxo Completo de Inclusão

```
1. Usuário clica "Incluir" em STTIP004
   └─> Sistema inicializa campos

2. Gatilho Fase 1 dispara:
   ├─> Z2_DATA = dDataBase (01/08/2026)
   ├─> Z2_USUARIO = RetCodUsr() (000001)
   └─> Campos aparecem preenchidos

3. Usuário digita Z2_CONTAT = "000001"
   └─> Pressiona Enter

4. Validação X3_VALID executa:
   └─> ExistCpo("SZ1",...) = .T.
       └─> Contato existe! ✅

5. Campos virtuais calculam:
   ├─> Z2_NOMCONT = POSICIONE(...) = "JOSÉ ALBERTO"
   └─> Z2_EMAILCONT = POSICIONE(...) = "jose@empresa.com"

6. Gatilho Fase 2 dispara:
   └─> Z2_NOMUSR = UsrRetName(...) = "ADMINISTRADOR"

7. Usuário preenche restante:
   ├─> Z2_TIPO = "L"
   ├─> Z2_ASSUNTO = "Ligação de follow-up"
   └─> Z2_DESCRIC = "Cliente solicitou nova proposta"

8. Usuário confirma (Ctrl+O)

9. Gatilho Fase 3 dispara:
   └─> Z2_HORA = IIF(INCLUI,Time(),...) = "14:35"

10. Sistema grava registro no banco SZ2 ✅

11. Browse atualiza mostrando nova interação
    └─> Com todos os campos virtuais calculados!
```

---

## 🚀 Melhorias Opcionais

### 1️⃣ Validação de Data

Não permitir interações futuras:

```advpl
// Campo: Z2_DATA
// X3_VALID:
M->Z2_DATA <= dDataBase
```

---

### 2️⃣ Campo Virtual: Dias Desde Interação

```advpl
// Campo: Z2_DIASDEC (Virtual)
// X3_RELACAO:
Date() - SZ2->Z2_DATA
```

---

### 3️⃣ Gatilho: Atualizar Última Interação em SZ1

```advpl
// Campo Origem: Z2_DATA
// Campo Destino: Z1_ULTINT (criar campo na SZ1)
// Regra: M->Z2_DATA
// Fase: 4 (após gravar)
// Condição: .T.
```

---

## ✅ Checklist de Configuração

- [ ] **SX3 - Campos Virtuais:**
  - [ ] Z2_NOMCONT (Nome do Contato)
  - [ ] Z2_EMAILCONT (Email do Contato)
  - [ ] Z2_NOMUSR (Nome do Usuário)

- [ ] **SX7 - Gatilhos:**
  - [ ] Z2_DATA → dDataBase (Fase 1)
  - [ ] Z2_HORA → IIF(INCLUI,Time(),...) (Fase 3)
  - [ ] Z2_USUARIO → RetCodUsr() (Fase 1)
  - [ ] Z2_USUARIO → Z2_NOMUSR (Fase 2)

- [ ] **SX3 - Validações:**
  - [ ] Z2_CONTAT → ExistCpo("SZ1",...)

- [ ] **SXB - Consultas:**
  - [ ] SZ1 (Consulta padrão F3)

- [ ] **Processar Dicionário:**
  - [ ] Executar CFGX051 ou Processar SX

- [ ] **Testar:**
  - [ ] Campos virtuais aparecem
  - [ ] Data/Hora/Usuário preenchem sozinhos
  - [ ] Sistema recusa contato inexistente
  - [ ] F3 funciona no Z2_CONTAT

---

**Exercício 3 concluído!** 🎉

Dominar **gatilhos, campos virtuais e validações** é essencial para criar sistemas inteligentes e confiáveis no Protheus!
