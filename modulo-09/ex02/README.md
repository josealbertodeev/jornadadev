# Exercício 2 — Biblioteca e Rotinas (Bônus)

## 📋 Objetivo

Criar e compilar os **três fontes principais** do projeto de CRM/Gestão de Contatos:
1. **STTIPLIB.PRW** - Biblioteca com funções auxiliares
2. **STTIP003.PRW** - CRUD de Contatos (SZ1) com mBrowse e legendas
3. **STTIP004.PRW** - CRUD de Interações (SZ2) filtrado por contato

---

## 📦 Arquivos Criados

### ✅ [STTIPLIB.PRW](ex-02/STTIPLIB.PRW) - Biblioteca de Funções

Biblioteca centralizada com funções auxiliares para manipulação de dados.

#### Funções Públicas:

| Função | Descrição | Parâmetros | Retorno |
|--------|-----------|------------|---------|
| **U_NomeCliente()** | Busca nome do contato | cCodigo | Nome ou "NÃO ENCONTRADO" |
| **U_ProxCodigoSZ1()** | Gera próximo código SZ1 | - | Código sequencial (6 chars) |
| **U_ProxSequenSZ2()** | Gera próxima sequência SZ2 | cContato | Sequência (3 chars) |
| **U_DescTipoInteracao()** | Descrição do tipo | cTipo | Descrição da SX5 |
| **U_SZ1STATUS()** | Status do contato (Virtual) | - | "Quente"/"Ativo"/"Frio"/etc |
| **U_SZ1ULTINT()** | Última interação (Virtual) | - | Data ou CTOD("//") |
| **U_VALEMAIL()** | Valida formato de email | cEmail | .T. ou .F. |
| **U_PROXSEQ()** | Atalho para ProxSequenSZ2 | - | Sequência (p/ SX3) |

---

#### 🎯 Função: U_NomeCliente(cCodigo)

```advpl
// Busca o nome do contato pelo código
cNome := U_NomeCliente("000001")
// Retorna: "JOSÉ ALBERTO DA SILVA"
```

**Uso:** Exibir nome em relatórios, mensagens, etc.

---

#### 🎯 Função: U_ProxCodigoSZ1()

```advpl
// Gera próximo código automático para SZ1
cNovoCodigo := U_ProxCodigoSZ1()
// Retorna: "000001", "000002", etc
```

**Uso:** Inicializador do campo Z1_CODIGO no SX3

---

#### 🎯 Função: U_ProxSequenSZ2(cContato)

```advpl
// Gera próxima sequência para interações do contato
cSeq := U_ProxSequenSZ2("000001")
// Retorna: "001", "002", "003", etc
```

**Lógica:**
- Busca maior sequência existente para o contato
- Incrementa + 1
- Formata com 3 dígitos (StrZero)

**Uso:** Inicializador do campo Z2_SEQUEN no SX3

---

#### 🎯 Função: U_DescTipoInteracao(cTipo)

```advpl
// Busca descrição na tabela SX5 - código Z2
cDesc := U_DescTipoInteracao("E")
// Retorna: "Email"

cDesc := U_DescTipoInteracao("L")
// Retorna: "Ligação"
```

**Tipos válidos (SX5 - Z2):**
- **E** = Email
- **L** = Ligação
- **R** = Reunião
- **V** = Visita
- **W** = WhatsApp

**Uso:** Campo virtual Z2_TIPODES no SX3

---

#### 🎯 Função: U_SZ1STATUS() - Campo Virtual

```advpl
// Calcula status baseado na última interação
cStatus := U_SZ1STATUS()
```

**Regras de Classificação:**

| Condição | Status | Cor (Legenda) |
|----------|--------|---------------|
| Nunca teve interação | "Sem Interação" | 🔵 Azul |
| Última interação ≤ 7 dias | "Quente" | 🟢 Verde |
| Última interação 8-30 dias | "Ativo" | 🟡 Amarelo |
| Última interação 31-90 dias | "Frio" | 🟠 Laranja |
| Última interação > 90 dias | "Inativo" | 🔴 Vermelho |

**Uso:** Campo virtual Z1_STATUS no SX3

---

#### 🎯 Função: U_SZ1ULTINT() - Campo Virtual

```advpl
// Retorna data da última interação do contato
dUltima := U_SZ1ULTINT()
// Retorna: 01/08/2026 ou CTOD("//") se sem interação
```

**Lógica:**
- Percorre todas as interações (SZ2) do contato
- Retorna a data mais recente (Z2_DATA)

**Uso:** Campo virtual Z1_ULTINT no SX3

---

#### 🎯 Função: U_VALEMAIL(cEmail)

```advpl
// Validação básica de formato de email
lOk := U_VALEMAIL("jose@empresa.com.br")
// Retorna: .T.

lOk := U_VALEMAIL("emailinvalido")
// Retorna: .F. + MsgAlert
```

**Validações:**
- ✅ Deve conter @
- ✅ Deve conter . após o @
- ✅ @ não pode estar no início ou fim
- ✅ Não pode ter espaços

**Uso:** X3_VALID do campo Z1_EMAIL

---

### ✅ [STTIP003.PRW](ex-02/STTIP003.PRW) - CRUD de Contatos

Rotina principal de cadastro de contatos usando **mBrowse profissional**.

#### Funcionalidades:

✅ **CRUD Completo:**
- 🔍 Pesquisar (AxPesqui)
- 👁️ Visualizar (AxVisual)
- ➕ Incluir (AxInclui)
- ✏️ Alterar (AxAltera)
- ❌ Excluir (AxDeleta)

✅ **Recursos Avançados:**
- 🎨 **Legendas Coloridas** por status do contato
- 📞 **Botão "Interações"** - abre STTIP004 filtrado pelo contato
- 🏷️ **Botão "Legenda"** - exibe janela explicativa

---

#### 🎨 Legendas Coloridas

```advpl
aColors := {
    {"U_SZ1STATUS() == 'Inativo'",       "BR_VERMELHO"},
    {"U_SZ1STATUS() == 'Frio'",          "BR_LARANJA"},
    {"U_SZ1STATUS() == 'Ativo'",         "BR_AMARELO"},
    {"U_SZ1STATUS() == 'Quente'",        "BR_VERDE"},
    {"U_SZ1STATUS() == 'Sem Interação'", "BR_AZUL"},
    {".T.",                              "BR_BRANCO"}
}
```

**⚠️ ORDEM IMPORTANTÍSSIMA:**
- Condições mais específicas primeiro
- Condição `.T.` (default) **SEMPRE POR ÚLTIMO**

---

#### Estrutura do aRotina:

```advpl
aRotina := {
    {"Pesquisar",  "AxPesqui",        0, 1},  // Tipo 1 - Pesquisa
    {"Visualizar", "AxVisual",        0, 2},  // Tipo 2 - Visualização
    {"Incluir",    "AxInclui",        0, 3},  // Tipo 3 - Inclusão
    {"Alterar",    "AxAltera",        0, 4},  // Tipo 4 - Alteração
    {"Excluir",    "AxDeleta",        0, 5},  // Tipo 5 - Exclusão
    {"Interações", "U_STTIP003INT",   0, 6},  // Tipo 6 - Ação customizada
    {"Legenda",    "U_STTIP003LEG",   0, 7}   // Tipo 7 - Legenda
}
```

---

#### 📞 Função: U_STTIP003INT()

Abre o browse de interações filtrado pelo contato selecionado.

```advpl
USER FUNCTION STTIP003INT()
    LOCAL cCodigo := SZ1->Z1_CODIGO
    LOCAL cNome := AllTrim(SZ1->Z1_NOME)
    
    // Chama STTIP004 passando código e nome
    U_STTIP004(cCodigo, cNome)
RETURN
```

---

#### 🏷️ Função: U_STTIP003LEG()

Exibe janela explicativa das legendas.

```advpl
aLegenda := {
    {"BR_AZUL",     "Sem Interação - Nunca teve contato"},
    {"BR_VERDE",    "Quente - Última interação <= 7 dias"},
    {"BR_AMARELO",  "Ativo - Última interação 8-30 dias"},
    {"BR_LARANJA",  "Frio - Última interação 31-90 dias"},
    {"BR_VERMELHO", "Inativo - Última interação > 90 dias"}
}

BrwLegenda("Status dos Contatos", "Legenda", aLegenda)
```

---

### ✅ [STTIP004.PRW](ex-02/STTIP004.PRW) - CRUD de Interações

Rotina de cadastro de interações **filtrada por contato**.

#### Funcionalidades:

✅ **Filtro Dinâmico:**
- Mostra apenas interações do contato selecionado
- Usa `SET FILTER TO` para filtrar SZ2

✅ **Inicialização Automática:**
- Z2_CONTAT = código do contato (bloqueado)
- Z2_SEQUEN = próxima sequência automática
- Z2_DATA = data atual
- Z2_HORA = hora atual
- Z2_USUARIO = usuário logado

✅ **Validação:**
- Não permite alterar o código do contato após inclusão

---

#### Chamada da Função:

```advpl
U_STTIP004(cCodContato, cNomeContato)
```

**Parâmetros:**
- `cCodContato` - Código do contato (obrigatório)
- `cNomeContato` - Nome do contato (opcional, para exibição no título)

---

#### 🔒 Filtro Aplicado:

```advpl
cFiltro := "Z2_FILIAL == '" + xFilial("SZ2") + "' .AND. "
cFiltro += "Z2_CONTAT == '" + cContatoAtual + "'"

SET FILTER TO &cFiltro
```

**Resultado:** Browse mostra apenas interações do contato atual

---

#### ➕ Função: U_STTIP004INC()

Inclusão customizada que pré-preenche o código do contato.

```advpl
USER FUNCTION STTIP004INC()
    // Inicializa campos com valores padrão
    PRIVATE M->Z2_FILIAL  := xFilial("SZ2")
    PRIVATE M->Z2_CONTAT  := cContatoAtual  // Código fixo
    PRIVATE M->Z2_SEQUEN  := U_ProxSequenSZ2(cContatoAtual)
    PRIVATE M->Z2_DATA    := Date()
    PRIVATE M->Z2_HORA    := Time()
    PRIVATE M->Z2_USUARIO := RetCodUsr()
    
    // Chama inclusão padrão
    AxInclui("SZ2", , 3)
RETURN
```

---

## 🧪 Como Testar

### 1️⃣ Compilar os Fontes

No **Protheus AppServer**, compile os 3 arquivos:

```
Compilar > STTIPLIB.PRW
Compilar > STTIP003.PRW
Compilar > STTIP004.PRW
```

---

### 2️⃣ Testar STTIP003 (Contatos)

#### Abrir o Cadastro:

```
Menu > Miscelânea > Cadastros > U_STTIP003
```

ou pelo SmartClient:

```advpl
U_STTIP003()
```

#### ➕ Incluir Contatos:

**Contato 1:**
- Código: 000001 (automático)
- Nome: JOSÉ ALBERTO DA SILVA
- Email: jose@empresa.com.br
- Telefone: (11) 98765-4321
- Empresa: EMPRESA ABC LTDA
- Cargo: Gerente Comercial
- Dt. Cadastro: 01/08/2026

**Contato 2:**
- Código: 000002
- Nome: MARIA SANTOS OLIVEIRA
- Email: maria@consultoria.com
- Telefone: (21) 99876-5432
- Empresa: CONSULTORIA XYZ
- Cargo: Diretora
- Dt. Cadastro: 01/08/2026

---

#### 🎨 Verificar Legendas:

Após incluir, os contatos devem aparecer com **bolinha AZUL** (Sem Interação).

---

### 3️⃣ Testar STTIP004 (Interações)

#### Abrir Interações de um Contato:

1. No browse de contatos (STTIP003)
2. Selecionar um contato (ex: 000001 - JOSÉ ALBERTO)
3. Clicar no botão **"Interações"**

O browse de interações abre filtrado para aquele contato.

---

#### ➕ Incluir Interações:

**Interação 1:**
- Contato: 000001 (bloqueado)
- Sequência: 001 (automático)
- Data: 01/08/2026
- Hora: 14:30
- Tipo: L - Ligação
- Assunto: Primeira ligação - apresentação da empresa
- Descrição: Cliente demonstrou interesse em nossos produtos
- Usuário: (automático)

**Interação 2:**
- Contato: 000001
- Sequência: 002 (automático)
- Data: 25/07/2026 (uma semana atrás)
- Hora: 10:15
- Tipo: E - Email
- Assunto: Envio de proposta comercial
- Descrição: Enviada proposta com desconto especial

**Interação 3:**
- Contato: 000001
- Sequência: 003
- Data: 15/06/2026 (45 dias atrás)
- Hora: 16:00
- Tipo: R - Reunião
- Assunto: Reunião presencial
- Descrição: Reunião na sede do cliente

---

### 4️⃣ Testar Legendas Dinâmicas

#### Voltar para STTIP003:

Fechar o browse de interações e voltar para o cadastro de contatos.

#### 🎨 Verificar Cores:

**Contato 000001** deve aparecer:
- 🟢 **VERDE (Quente)** - se última interação foi hoje (01/08)
- 🟡 **AMARELO (Ativo)** - se última interação foi 25/07 (7 dias atrás)

**Contato 000002** deve aparecer:
- 🔵 **AZUL (Sem Interação)** - se não tem interações

---

#### 🏷️ Clicar no Botão "Legenda":

Deve abrir janela explicando as cores:
- 🔵 Azul - Sem Interação
- 🟢 Verde - Quente (≤ 7 dias)
- 🟡 Amarelo - Ativo (8-30 dias)
- 🟠 Laranja - Frio (31-90 dias)
- 🔴 Vermelho - Inativo (> 90 dias)

---

### 5️⃣ Testar Atualização de Status

#### Criar interação antiga:

1. Abrir interações do Contato 000002
2. Incluir interação com data de **01/04/2026** (4 meses atrás)
3. Tipo: V - Visita

#### Verificar no browse:

Contato 000002 deve mudar de:
- 🔵 **AZUL** → 🔴 **VERMELHO (Inativo)** - última interação > 90 dias

---

### 6️⃣ Testar Validação de Email

No cadastro de contatos, tentar incluir emails inválidos:

❌ **"jose.com"** - Deve alertar: "Email deve conter @"  
❌ **"@empresa.com"** - Deve alertar: "@ na posição incorreta"  
❌ **"jose@empresa"** - Deve alertar: "Email deve conter domínio"  
❌ **"jose @empresa.com"** - Deve alertar: "Email não pode conter espaços"  
✅ **"jose@empresa.com.br"** - Aceito!

---

## 🔄 Fluxo Completo de Teste

```
1. Abrir STTIP003
   └─> Browse vazio (sem contatos)

2. Incluir 3 contatos
   └─> Todos aparecem com 🔵 AZUL (Sem Interação)

3. Selecionar Contato 1 > Botão "Interações"
   └─> Abre STTIP004 filtrado

4. Incluir interação com data de HOJE
   └─> Sequência 001 automática

5. Voltar para STTIP003
   └─> Contato 1 agora é 🟢 VERDE (Quente)

6. Selecionar Contato 2 > Botão "Interações"
   └─> Abre STTIP004 vazio (sem interações)

7. Incluir interação com data de 100 dias atrás
   └─> Sequência 001

8. Voltar para STTIP003
   └─> Contato 2 agora é 🔴 VERMELHO (Inativo)

9. Clicar botão "Legenda"
   └─> Mostra janela explicativa das cores

10. Testar alteração/exclusão
    └─> Todas as operações funcionando
```

---

## 📊 Resumo Técnico

### Arquitetura:

```
STTIPLIB.PRW (Biblioteca)
    ↓
    ├─> U_NomeCliente()       → Usada em STTIP004
    ├─> U_ProxCodigoSZ1()     → Usada no SX3 (Z1_CODIGO)
    ├─> U_ProxSequenSZ2()     → Usada no SX3 (Z2_SEQUEN)
    ├─> U_DescTipoInteracao() → Usada no SX3 (Z2_TIPODES)
    ├─> U_SZ1STATUS()         → Usada no SX3 (Z1_STATUS) + Legendas
    ├─> U_SZ1ULTINT()         → Usada no SX3 (Z1_ULTINT)
    └─> U_VALEMAIL()          → Usada no SX3 (Z1_EMAIL validação)

STTIP003.PRW (Contatos)
    ├─> mBrowse com legendas coloridas
    ├─> U_STTIP003INT() → Chama STTIP004
    └─> U_STTIP003LEG() → Exibe janela de legendas

STTIP004.PRW (Interações)
    ├─> mBrowse filtrado por contato
    ├─> U_STTIP004INC() → Inclusão com valores pré-preenchidos
    └─> SET FILTER TO → Filtra pelo contato
```

---

## 💡 Conceitos Aplicados

### ✅ **mBrowse Profissional:**
- Controle total via aRotina
- Legendas coloridas dinâmicas
- Botões customizados

### ✅ **Campos Virtuais:**
- Z1_STATUS calculado em tempo real
- Z1_ULTINT calculado em tempo real
- Não ocupam espaço no banco

### ✅ **Relacionamento 1:N:**
- 1 Contato (SZ1) → N Interações (SZ2)
- Filtro dinâmico com SET FILTER TO

### ✅ **Validações:**
- ExistCpo() - garante integridade referencial
- VALEMAIL() - valida formato de email
- Inicializadores automáticos

### ✅ **Biblioteca Centralizada:**
- Reutilização de código
- Facilita manutenção
- Funções bem documentadas

---

## 🎯 Próximos Exercícios

Após dominar este exercício:

1. **Exercício 3** - Relatórios e queries SQL
2. **Exercício 4** - GetDados (grid de interações)
3. **Exercício 5** - Tratamento de erros

---

**Exercício 2 concluído!** 🎉

Dominar mBrowse + legendas + filtros é essencial para criar CRUDs profissionais no Protheus!
