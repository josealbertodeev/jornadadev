# Exercício 4 — Menu no SIGACOM (Bônus)

## 📋 Objetivo

Configurar o **menu do módulo SIGACOM** (Compras) para incluir acesso às rotinas de CRM:
- ✅ **Cadastro de Contatos** (STTIP003)
- ✅ **Interações - Listagem Geral** (STTIP004B)

---

## 🎯 O que será feito

### 1️⃣ Criar STTIP004B.PRW
Versão **sem filtro** da STTIP004 para listar TODAS as interações.

### 2️⃣ Configurar Menu do SIGACOM
Adicionar opções no menu: `Cadastros > Contatos` e `Cadastros > Interações`.

---

## 📦 PARTE 1: Criar STTIP004B.PRW

### ✅ Arquivo Criado: [STTIP004B.PRW](ex-04/STTIP004B.PRW)

#### Diferenças entre STTIP004 e STTIP004B:

| Característica | STTIP004 | STTIP004B |
|----------------|----------|-----------|
| **Filtro** | ✅ Filtrado por contato | ❌ SEM FILTRO (todas) |
| **Parâmetros** | cCodContato, cNomeContato | Nenhum |
| **Chamada** | Botão "Interações" do STTIP003 | Menu SIGACOM |
| **Título** | "Interações - Contato: XXX" | "Interações - Listagem Geral" |
| **Inclusão** | U_STTIP004INC (contato fixo) | AxInclui (contato livre) |
| **Botão Extra** | - | "Contato" (visualiza SZ1) |

---

#### 📌 Código STTIP004B:

```advpl
USER FUNCTION STTIP004B()
    LOCAL aArea := GetArea()
    
    PRIVATE aRotina := {}
    
    aRotina := {
        {"Pesquisar",  "AxPesqui",  0, 1},
        {"Visualizar", "AxVisual",  0, 2},
        {"Incluir",    "AxInclui",  0, 3},
        {"Alterar",    "AxAltera",  0, 4},
        {"Excluir",    "AxDeleta",  0, 5},
        {"Contato",    "U_STTIP004BCONT", 0, 6}
    }
    
    dbSelectArea("SZ2")
    dbSetOrder(1)
    
    // SEM FILTRO - mostra todas as interações!
    mBrowse(1, 1, 22, 75, "SZ2", , , , , , , "Interações - Listagem Geral")
    
    RestArea(aArea)
RETURN
```

**Diferença Principal:** Não tem `SET FILTER TO`, então mostra TUDO!

---

#### 🔍 Botão "Contato" - U_STTIP004BCONT():

```advpl
USER FUNCTION STTIP004BCONT()
    LOCAL cCodigo := SZ2->Z2_CONTAT
    
    // Posiciona no contato da interação selecionada
    dbSelectArea("SZ1")
    dbSetOrder(1)
    
    IF dbSeek(xFilial("SZ1") + cCodigo)
        // Visualiza o contato
        AxVisual("SZ1", SZ1->(Recno()), 2)
    ELSE
        MsgAlert("Contato não encontrado: " + cCodigo, "Erro")
    ENDIF
RETURN
```

**Funcionalidade:** No browse de interações, selecionar uma interação e clicar "Contato" abre a visualização do contato relacionado!

---

## ⚙️ PARTE 2: Configurar Menu do SIGACOM

### Acessar o Configurador de Menus

```
Menu: Ambiente > Cadastros > Configurador > Menu do Sistema
ou
SIGACFG > Menu do Sistema
```

---

### 📂 Estrutura do Menu

#### 1️⃣ Selecionar Módulo: **SIGACOM** (Compras)

```
Módulo: 02 - SIGACOM (Compras)
```

---

#### 2️⃣ Localizar ou Criar o Menu "Cadastros"

Se já existir o menu **"Cadastros"**, expandir.  
Se não existir, criar:

| Propriedade | Valor |
|-------------|-------|
| **Título** | Cadastros |
| **Tipo** | 1 - Submenu |

---

#### 3️⃣ Adicionar Opção: "Contatos"

Dentro de **Cadastros**, adicionar nova opção:

| Propriedade | Valor |
|-------------|-------|
| **Título** | Contatos |
| **Função** | U_STTIP003 |
| **Tipo** | 3 - User Function |
| **Módulo** | 02 - SIGACOM |
| **Status** | Ativo |
| **Nível de Acesso** | (conforme política da empresa) |

---

#### 4️⃣ Adicionar Opção: "Interações"

Dentro de **Cadastros**, adicionar nova opção:

| Propriedade | Valor |
|-------------|-------|
| **Título** | Interações |
| **Função** | U_STTIP004B |
| **Tipo** | 3 - User Function |
| **Módulo** | 02 - SIGACOM |
| **Status** | Ativo |
| **Nível de Acesso** | (conforme política da empresa) |

---

### 📊 Estrutura Final do Menu:

```
SIGACOM (Compras)
│
├── Atualizações
│   ├── Pedidos
│   ├── Produtos
│   └── ...
│
├── Cadastros
│   ├── Fornecedores
│   ├── Produtos
│   ├── ── ── ── ── ── ── ──
│   ├── 📞 Contatos           ← NOVO! (U_STTIP003)
│   └── 📝 Interações         ← NOVO! (U_STTIP004B)
│
├── Relatórios
│   └── ...
│
└── Miscelânea
    └── ...
```

---

## 🧪 Como Testar

### 1️⃣ Compilar o STTIP004B

No **Protheus AppServer**, compile:

```
Compilar > STTIP004B.PRW
```

---

### 2️⃣ Atualizar o Menu

Após configurar no Configurador:

```
Menu: Ambiente > Cadastros > Configurador > Atualizar Menus
ou
Fechar e abrir o SmartClient novamente
```

---

### 3️⃣ Verificar o Menu do SIGACOM

1. Abrir o **SmartClient**
2. Selecionar ambiente **SIGACOM** (Compras)
3. No menu principal, expandir **Cadastros**
4. Verificar se aparecem:
   - ✅ **Contatos**
   - ✅ **Interações**

---

### 4️⃣ Testar "Contatos" pelo Menu

```
Menu: Cadastros > Contatos
```

**Resultado:** Abre **U_STTIP003** (browse de contatos com legendas)

---

### 5️⃣ Testar "Interações" pelo Menu

```
Menu: Cadastros > Interações
```

**Resultado:** Abre **U_STTIP004B** (browse de TODAS as interações)

---

### 6️⃣ Testar Botão "Contato"

1. No browse de interações (STTIP004B)
2. Selecionar uma interação
3. Clicar no botão **"Contato"**

**Resultado:** Abre visualização do contato relacionado (SZ1)

---

### 7️⃣ Comparar STTIP004 vs STTIP004B

#### STTIP004 (Filtrado):

```
STTIP003 (Contatos)
    └─> Selecionar contato "000001 - JOSÉ ALBERTO"
        └─> Botão "Interações"
            └─> Abre STTIP004
                └─> Mostra APENAS interações do contato 000001
```

#### STTIP004B (Sem Filtro):

```
Menu > Cadastros > Interações
    └─> Abre STTIP004B
        └─> Mostra TODAS as interações de TODOS os contatos
            ├─> Interações do contato 000001
            ├─> Interações do contato 000002
            ├─> Interações do contato 000003
            └─> ...
```

---

## 📊 Fluxos de Navegação

### 🔹 Fluxo 1: Menu → Contatos → Interações do Contato

```
1. Menu > Cadastros > Contatos
   └─> Abre STTIP003

2. Selecionar contato (ex: 000001)
   └─> Botão "Interações"
       └─> Abre STTIP004 (filtrado)
           └─> Mostra apenas interações deste contato
```

---

### 🔹 Fluxo 2: Menu → Interações (Todas) → Contato da Interação

```
1. Menu > Cadastros > Interações
   └─> Abre STTIP004B (todas)

2. Browse mostra TODAS as interações
   ├─> Contato 000001 - Sequência 001
   ├─> Contato 000001 - Sequência 002
   ├─> Contato 000002 - Sequência 001
   └─> ...

3. Selecionar uma interação
   └─> Botão "Contato"
       └─> Abre visualização do contato (SZ1)
```

---

### 🔹 Fluxo 3: Incluir Interação via Menu

```
1. Menu > Cadastros > Interações
   └─> Abre STTIP004B

2. Botão "Incluir"
   └─> AxInclui (padrão)
       ├─> Z2_CONTAT: Campo LIVRE (digitar código)
       ├─> F3 disponível (consulta SZ1)
       ├─> Validação: ExistCpo (só aceita contato existente)
       ├─> Gatilhos funcionam (data/hora/usuário)
       └─> Campos virtuais funcionam (nome do contato)

3. Confirmar
   └─> Interação gravada!
```

---

## 🎯 Casos de Uso

### ✅ Quando usar STTIP003 (Contatos):

- Gerenciar cadastro de contatos
- Ver status visual dos contatos (legendas)
- Acessar interações de um contato específico

### ✅ Quando usar STTIP004 (Interações Filtradas):

- Chamado automaticamente pelo botão "Interações" do STTIP003
- Gerenciar interações de UM contato específico
- Inclusão rápida com contato pré-selecionado

### ✅ Quando usar STTIP004B (Interações Gerais):

- Listar TODAS as interações do sistema
- Pesquisar interações sem saber o contato
- Relatórios gerais de atividades
- Consultar interação específica e ver qual contato pertence

---

## 💡 Conceitos Aprendidos

### **Menu do Sistema (XNU)**

O menu do Protheus é configurado na tabela **XNU** (Menu do Sistema).

**Tipos de Item de Menu:**
- **1 - Submenu**: Agrupa outras opções
- **2 - Função Padrão**: Função do sistema (AxCadastro, etc)
- **3 - User Function**: Função customizada (U_STTIP003)
- **4 - Separador**: Linha separadora
- **5 - Grupo**: Agrupamento visual

---

### **Módulos do Protheus**

Cada módulo tem seu código:

| Código | Módulo | Descrição |
|--------|--------|-----------|
| 02 | SIGACOM | Compras |
| 04 | SIGAEST | Estoque |
| 05 | SIGAFAT | Faturamento |
| 06 | SIGAFIN | Financeiro |
| 11 | SIGAVEI | Veículos |
| 33 | SIGACTB | Contabilidade |

**Por que adicionar no SIGACOM?**
- Gestão de contatos pode estar relacionada a fornecedores
- Módulo de exemplo para demonstração
- Pode ser adaptado para outros módulos

---

### **Browse com e sem Filtro**

#### Com Filtro (STTIP004):

```advpl
cFiltro := "Z2_CONTAT == '000001'"
SET FILTER TO &cFiltro
mBrowse(...)
```

**Vantagem:** Foco em um contexto específico  
**Desvantagem:** Não vê o todo

---

#### Sem Filtro (STTIP004B):

```advpl
// SEM SET FILTER TO
mBrowse(...)
```

**Vantagem:** Visão completa dos dados  
**Desvantagem:** Pode ter muitos registros

---

## 🔄 Comparação: STTIP004 vs STTIP004B

| Aspecto | STTIP004 | STTIP004B |
|---------|----------|-----------|
| **Filtro** | Sim (por contato) | Não (todas) |
| **Chamada** | Via botão STTIP003 | Via menu |
| **Parâmetros** | cCodContato, cNomeContato | Nenhum |
| **Inclusão** | U_STTIP004INC (fixo) | AxInclui (livre) |
| **Título** | "Interações - Contato: XXX" | "Interações - Listagem Geral" |
| **Z2_CONTAT** | Bloqueado (fixo) | Editável (F3) |
| **Botão Extra** | - | "Contato" (ver SZ1) |
| **Contexto** | Operação focada | Visão geral |

---

## ✅ Checklist de Implementação

- [ ] **Código:**
  - [ ] STTIP004B.PRW criado
  - [ ] STTIP004B.PRW compilado
  - [ ] U_STTIP004BCONT() implementada

- [ ] **Menu:**
  - [ ] Acessar SIGACFG > Menu do Sistema
  - [ ] Selecionar módulo SIGACOM
  - [ ] Criar/Localizar submenu "Cadastros"
  - [ ] Adicionar opção "Contatos" (U_STTIP003)
  - [ ] Adicionar opção "Interações" (U_STTIP004B)
  - [ ] Atualizar menus no sistema

- [ ] **Testes:**
  - [ ] Menu > Cadastros > Contatos abre STTIP003
  - [ ] Menu > Cadastros > Interações abre STTIP004B
  - [ ] STTIP004B mostra todas as interações
  - [ ] Botão "Contato" abre visualização do SZ1
  - [ ] Inclusão via STTIP004B funciona (contato livre)
  - [ ] F3 em Z2_CONTAT funciona
  - [ ] Validações e gatilhos funcionam

---

## 🎯 Resumo Visual

### Estrutura Completa do Sistema:

```
┌─────────────────────────────────────────────────────┐
│              SISTEMA DE CRM - CONTATOS              │
└─────────────────────────────────────────────────────┘

╔═══════════════════════════════════════════════════╗
║  MENU SIGACOM > Cadastros                         ║
╠═══════════════════════════════════════════════════╣
║                                                   ║
║  📞 CONTATOS (U_STTIP003)                         ║
║      ├─> Browse com legendas coloridas            ║
║      ├─> Status por última interação              ║
║      └─> Botão "Interações" → STTIP004 (filtrado) ║
║                                                   ║
║  📝 INTERAÇÕES (U_STTIP004B)                      ║
║      ├─> Browse de TODAS as interações            ║
║      ├─> Campo virtual: Nome do Contato           ║
║      └─> Botão "Contato" → Visualiza SZ1          ║
║                                                   ║
╚═══════════════════════════════════════════════════╝

┌───────────────────────────────────────────────────┐
│  BIBLIOTECA: STTIPLIB.PRW                         │
│  ├─> U_NomeCliente()                              │
│  ├─> U_ProxCodigoSZ1()                            │
│  ├─> U_ProxSequenSZ2()                            │
│  ├─> U_SZ1STATUS()                                │
│  └─> U_VALEMAIL()                                 │
└───────────────────────────────────────────────────┘

┌───────────────────────────────────────────────────┐
│  DICIONÁRIO DE DADOS (Exercício 1 e 3)            │
│  ├─> SZ1 (Contatos) - 9 campos                    │
│  ├─> SZ2 (Interações) - 10+ campos                │
│  ├─> Gatilhos (Z2_DATA, Z2_HORA, Z2_USUARIO)      │
│  ├─> Campos Virtuais (Z2_NOMCONT, Z1_STATUS)      │
│  └─> Validações (ExistCpo)                        │
└───────────────────────────────────────────────────┘
```

---
