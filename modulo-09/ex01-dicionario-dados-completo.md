# Exercício 1 ? Dicionário de Dados Completo (Bônus/Autoestudo)

## Objetivo

Configurar no dicionário do Protheus as duas tabelas do projeto de **CRM/Gestão de Contatos**:
- **SZ1**: Cadastro de Contatos
- **SZ2**: Interações com Contatos (histórico de ligações, emails, reuniões, etc.)

---

## O que configurar

### 1. Tabelas no SX2 (Estrutura)
### 2. Campos no SX3 (Definição de campos)
### 3. Índices no SIX (Chaves de acesso)
### 4. Domínio no SX5 (Lista de tipos de interação)

---

## Passo 1: Configurar Tabelas no SX2

### Acessar o Configurador
```
Menu: Ambiente > Cadastros > Dicionário > Tabelas (SX2)
ou
Configurador > Dicionário de Dados > Tabelas
```

### Tabela SZ1 - Cadastro de Contatos

| Campo | Valor |
|-------|-------|
| **Tabela** | SZ1 |
| **Descrição** | Cadastro de Contatos |
| **Modo de Acesso** | **Compartilhado** |
| **Tipo** | Cliente |
| **Aplicativo** | S = Sigamat |

**Por que Compartilhado?**
- Todos os contatos ficam disponíveis para todas as filiais da empresa
- Evita duplicação de dados
- Facilita relatórios consolidados

---

### Tabela SZ2 - Interações com Contatos

| Campo | Valor |
|-------|-------|
| **Tabela** | SZ2 |
| **Descrição** | Interações com Contatos |
| **Modo de Acesso** | **Compartilhado** |
| **Tipo** | Cliente |
| **Aplicativo** | S = Sigamat |

**Relacionamento:**
- SZ2 é filho de SZ1 (1:N)
- Um contato (SZ1) pode ter várias interações (SZ2)

---

## Passo 2: Configurar Campos no SX3

### Acessar o Configurador
```
Menu: Ambiente > Cadastros > Dicionário > Campos (SX3)
ou
Configurador > Dicionário de Dados > Campos
```

---

### Campos da SZ1 (Contatos)

#### Campo: Z1_FILIAL (Filial)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z1_FILIAL |
| **Tipo** | Caractere |
| **Tamanho** | 2 |
| **Decimal** | 0 |
| **Título** | Filial |
| **Descrição** | Filial do Sistema |
| **Contexto** | **Real** |
| **Inicializador** | xFilial("SZ1") |
| **Uso** | Usado |
| **Obrigat.** | Sim |
| **Browse** | Sim |
| **Visual** | V |

---

#### Campo: Z1_CODIGO (Código do Contato)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z1_CODIGO |
| **Tipo** | Caractere |
| **Tamanho** | 6 |
| **Decimal** | 0 |
| **Título** | Código |
| **Descrição** | Código do Contato |
| **Contexto** | **Real** |
| **Inicializador** | GetSXENum("SZ1","Z1_CODIGO") |
| **Valid** | ExistChav("SZ1",M->Z1_CODIGO) |
| **Uso** | Usado |
| **Obrigat.** | Sim |
| **Browse** | Sim |
| **Visual** | V |

**GetSXENum:** Gera código sequencial automático

---

#### Campo: Z1_NOME (Nome do Contato)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z1_NOME |
| **Tipo** | Caractere |
| **Tamanho** | 50 |
| **Decimal** | 0 |
| **Título** | Nome |
| **Descrição** | Nome do Contato |
| **Contexto** | **Real** |
| **Uso** | Usado |
| **Obrigat.** | Sim |
| **Browse** | Sim |
| **Visual** | A |
| **Picture** | @! |

**@!:** Converte para maiúsculas automaticamente

---

#### Campo: Z1_EMAIL (Email)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z1_EMAIL |
| **Tipo** | Caractere |
| **Tamanho** | 100 |
| **Decimal** | 0 |
| **Título** | Email |
| **Descrição** | Email do Contato |
| **Contexto** | **Real** |
| **Valid** | U_VALEMAIL(M->Z1_EMAIL) |
| **Uso** | Usado |
| **Obrigat.** | Não |
| **Browse** | Sim |
| **Visual** | A |

**VALEMAIL:** Função customizada para validar formato de email

---

#### Campo: Z1_TELEFON (Telefone)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z1_TELEFON |
| **Tipo** | Caractere |
| **Tamanho** | 20 |
| **Decimal** | 0 |
| **Título** | Telefone |
| **Descrição** | Telefone do Contato |
| **Contexto** | **Real** |
| **Picture** | @R (99) 99999-9999 |
| **Uso** | Usado |
| **Obrigat.** | Não |
| **Browse** | Sim |
| **Visual** | A |

**@R:** Máscara de edição (formato de telefone)

---

#### Campo: Z1_EMPRESA (Empresa)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z1_EMPRESA |
| **Tipo** | Caractere |
| **Tamanho** | 100 |
| **Decimal** | 0 |
| **Título** | Empresa |
| **Descrição** | Empresa do Contato |
| **Contexto** | **Real** |
| **Uso** | Usado |
| **Obrigat.** | Não |
| **Browse** | Sim |
| **Visual** | A |

---

#### Campo: Z1_CARGO (Cargo)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z1_CARGO |
| **Tipo** | Caractere |
| **Tamanho** | 50 |
| **Decimal** | 0 |
| **Título** | Cargo |
| **Descrição** | Cargo do Contato |
| **Contexto** | **Real** |
| **Uso** | Usado |
| **Obrigat.** | Não |
| **Browse** | Sim |
| **Visual** | A |

---

#### Campo: Z1_DTCAD (Data de Cadastro)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z1_DTCAD |
| **Tipo** | Data |
| **Tamanho** | 8 |
| **Decimal** | 0 |
| **Título** | Dt. Cadastro |
| **Descrição** | Data de Cadastro |
| **Contexto** | **Real** |
| **Inicializador** | dDataBase |
| **Uso** | Usado |
| **Obrigat.** | Sim |
| **Browse** | Sim |
| **Visual** | V |

---

#### Campo: Z1_STATUS (Status) - **VIRTUAL**
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z1_STATUS |
| **Tipo** | Caractere |
| **Tamanho** | 20 |
| **Decimal** | 0 |
| **Título** | Status |
| **Descrição** | Status do Contato |
| **Contexto** | **Virtual** |
| **Inicializador** | U_SZ1STATUS() |
| **Uso** | Usado |
| **Browse** | Sim |
| **Visual** | V |

**Campo Virtual:** Calculado em tempo real, não gravado no banco

**Função U_SZ1STATUS():**
```advpl
USER FUNCTION SZ1STATUS()
    LOCAL cStatus := "Ativo"
    LOCAL nDias := 0
    LOCAL dUltimaInt := CTOD("//")
    
    // Busca data da última interação
    dbSelectArea("SZ2")
    dbSetOrder(1) // Z2_FILIAL + Z2_CONTAT
    IF dbSeek(xFilial("SZ2") + SZ1->Z1_CODIGO)
        // Percorre até achar a mais recente
        WHILE !EOF() .AND. SZ2->Z2_CONTAT == SZ1->Z1_CODIGO
            IF SZ2->Z2_DATA > dUltimaInt
                dUltimaInt := SZ2->Z2_DATA
            ENDIF
            dbSkip()
        ENDDO
    ENDIF
    
    IF Empty(dUltimaInt)
        cStatus := "Sem Interação"
    ELSE
        nDias := dDataBase - dUltimaInt
        IF nDias > 90
            cStatus := "Inativo"
        ELSEIF nDias > 30
            cStatus := "Frio"
        ELSEIF nDias <= 7
            cStatus := "Quente"
        ELSE
            cStatus := "Ativo"
        ENDIF
    ENDIF
    
RETURN cStatus
```

---

#### Campo: Z1_ULTINT (Última Interação) - **VIRTUAL**
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z1_ULTINT |
| **Tipo** | Data |
| **Tamanho** | 8 |
| **Decimal** | 0 |
| **Título** | Últ. Interação |
| **Descrição** | Data da Última Interação |
| **Contexto** | **Virtual** |
| **Inicializador** | U_SZ1ULTINT() |
| **Uso** | Usado |
| **Browse** | Sim |
| **Visual** | V |

---

### Campos da SZ2 (Interações)

#### Campo: Z2_FILIAL (Filial)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_FILIAL |
| **Tipo** | Caractere |
| **Tamanho** | 2 |
| **Decimal** | 0 |
| **Título** | Filial |
| **Descrição** | Filial do Sistema |
| **Contexto** | **Real** |
| **Inicializador** | xFilial("SZ2") |
| **Uso** | Usado |
| **Obrigat.** | Sim |
| **Browse** | Sim |
| **Visual** | V |

---

#### Campo: Z2_CONTAT (Código do Contato)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_CONTAT |
| **Tipo** | Caractere |
| **Tamanho** | 6 |
| **Decimal** | 0 |
| **Título** | Contato |
| **Descrição** | Código do Contato |
| **Contexto** | **Real** |
| **Valid** | ExistCpo("SZ1",M->Z2_CONTAT) |
| **F3** | SZ1 |
| **Uso** | Usado |
| **Obrigat.** | Sim |
| **Browse** | Sim |
| **Visual** | A |

**F3:** Consulta padrão para buscar contatos

---

#### Campo: Z2_SEQUEN (Sequência)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_SEQUEN |
| **Tipo** | Caractere |
| **Tamanho** | 3 |
| **Decimal** | 0 |
| **Título** | Sequência |
| **Descrição** | Sequência da Interação |
| **Contexto** | **Real** |
| **Inicializador** | U_PROXSEQ() |
| **Uso** | Usado |
| **Obrigat.** | Sim |
| **Browse** | Sim |
| **Visual** | V |

**U_PROXSEQ():** Calcula próximo número de sequência para o contato

---

#### Campo: Z2_DATA (Data da Interação)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_DATA |
| **Tipo** | Data |
| **Tamanho** | 8 |
| **Decimal** | 0 |
| **Título** | Data |
| **Descrição** | Data da Interação |
| **Contexto** | **Real** |
| **Inicializador** | dDataBase |
| **Uso** | Usado |
| **Obrigat.** | Sim |
| **Browse** | Sim |
| **Visual** | A |

---

#### Campo: Z2_HORA (Hora da Interação)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_HORA |
| **Tipo** | Caractere |
| **Tamanho** | 5 |
| **Decimal** | 0 |
| **Título** | Hora |
| **Descrição** | Hora da Interação |
| **Contexto** | **Real** |
| **Inicializador** | Time() |
| **Picture** | @R 99:99 |
| **Uso** | Usado |
| **Obrigat.** | Sim |
| **Browse** | Sim |
| **Visual** | A |

---

#### Campo: Z2_TIPO (Tipo de Interação)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_TIPO |
| **Tipo** | Caractere |
| **Tamanho** | 1 |
| **Decimal** | 0 |
| **Título** | Tipo |
| **Descrição** | Tipo de Interação |
| **Contexto** | **Real** |
| **Combo** | E=Email;L=Ligação;R=Reunião;V=Visita;W=WhatsApp |
| **F3** | Z2 |
| **Uso** | Usado |
| **Obrigat.** | Sim |
| **Browse** | Sim |
| **Visual** | A |

---

#### Campo: Z2_TIPODES (Descrição do Tipo) - **VIRTUAL**
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_TIPODES |
| **Tipo** | Caractere |
| **Tamanho** | 20 |
| **Decimal** | 0 |
| **Título** | Desc. Tipo |
| **Descrição** | Descrição do Tipo |
| **Contexto** | **Virtual** |
| **Inicializador** | X5Descri() |
| **Uso** | Usado |
| **Browse** | Sim |
| **Visual** | V |

**X5Descri():** Busca descrição na tabela SX5

---

#### Campo: Z2_ASSUNTO (Assunto)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_ASSUNTO |
| **Tipo** | Caractere |
| **Tamanho** | 100 |
| **Decimal** | 0 |
| **Título** | Assunto |
| **Descrição** | Assunto da Interação |
| **Contexto** | **Real** |
| **Uso** | Usado |
| **Obrigat.** | Sim |
| **Browse** | Sim |
| **Visual** | A |

---

#### Campo: Z2_DESCRIC (Descrição)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_DESCRIC |
| **Tipo** | Memo |
| **Tamanho** | 10 |
| **Decimal** | 0 |
| **Título** | Descrição |
| **Descrição** | Descrição Detalhada |
| **Contexto** | **Real** |
| **Uso** | Usado |
| **Obrigat.** | Não |
| **Browse** | Não |
| **Visual** | A |

**Tipo Memo:** Campo texto longo (armazenado em tabela auxiliar)

---

#### Campo: Z2_USUARIO (Usuário)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_USUARIO |
| **Tipo** | Caractere |
| **Tamanho** | 15 |
| **Decimal** | 0 |
| **Título** | Usuário |
| **Descrição** | Usuário que Registrou |
| **Contexto** | **Real** |
| **Inicializador** | RetCodUsr() |
| **Uso** | Usado |
| **Obrigat.** | Sim |
| **Browse** | Sim |
| **Visual** | V |

**RetCodUsr():** Retorna código do usuário logado

---

##  Passo 3: Configurar Índices no SIX

### Acessar o Configurador
```
Menu: Ambiente > Cadastros > Dicionário > Índices (SIX)
ou
Configurador > Dicionário de Dados > Índices
```

---

### Índices da SZ1

#### Índice 1 (Ordem 1)
| Propriedade | Valor |
|-------------|-------|
| **Tabela** | SZ1 |
| **Ordem** | 1 |
| **Chave** | Z1_FILIAL+Z1_CODIGO |
| **Descrição** | Filial + Código |
| **Apelidocpo** | Z1_FILIAL;Z1_CODIGO |
| **Único** | Sim |

**Índice Único:** Garante que não haja códigos duplicados

---

#### Índice 2 (Ordem 2) - Opcional
| Propriedade | Valor |
|-------------|-------|
| **Tabela** | SZ1 |
| **Ordem** | 2 |
| **Chave** | Z1_FILIAL+Z1_NOME |
| **Descrição** | Filial + Nome |
| **Apelidocpo** | Z1_FILIAL;Z1_NOME |
| **Único** | Não |

**Índice por Nome:** Facilita pesquisas alfabéticas

---

### Índices da SZ2

#### Índice 1 (Ordem 1)
| Propriedade | Valor |
|-------------|-------|
| **Tabela** | SZ2 |
| **Ordem** | 1 |
| **Chave** | Z2_FILIAL+Z2_CONTAT+Z2_SEQUEN |
| **Descrição** | Filial + Contato + Sequência |
| **Apelidocpo** | Z2_FILIAL;Z2_CONTAT;Z2_SEQUEN |
| **Único** | Sim |

**Relacionamento:** Este índice permite buscar todas as interações de um contato

---

#### Índice 2 (Ordem 2) - Opcional
| Propriedade | Valor |
|-------------|-------|
| **Tabela** | SZ2 |
| **Ordem** | 2 |
| **Chave** | Z2_FILIAL+DTOS(Z2_DATA)+Z2_HORA |
| **Descrição** | Filial + Data + Hora |
| **Apelidocpo** | Z2_FILIAL;Z2_DATA;Z2_HORA |
| **Único** | Não |

**Índice Cronológico:** Facilita listagens por data

---

## Passo 4: Configurar Domínio no SX5

### Acessar o Configurador
```
Menu: Ambiente > Cadastros > Tabelas Genéricas (SX5)
ou
Configurador > Dicionário de Dados > Tabelas Genéricas
```

---

### Domínio Z2 - Tipos de Interação

#### Incluir Tabela Z2
| Propriedade | Valor |
|-------------|-------|
| **Tabela** | Z2 |
| **Descrição** | Tipos de Interação com Contatos |

---

#### Itens da Tabela Z2

| Chave | Descrição (Português) | Descrição (Inglês) | Descrição (Espanhol) |
|-------|------------------------|---------------------|----------------------|
| **E** | Email | Email | Email |
| **L** | Ligação | Call | Llamada |
| **R** | Reunião | Meeting | Reunión |
| **V** | Visita | Visit | Visita |
| **W** | WhatsApp | WhatsApp | WhatsApp |

---

## Resumo da Configuração

### Tabelas Criadas
-  **SZ1** (Modo Compartilhado) - Cadastro de Contatos
- **SZ2** (Modo Compartilhado) - Interações

### Campos Criados
- **SZ1**: 9 campos (7 reais + 2 virtuais)
- **SZ2**: 10 campos (8 reais + 1 virtual + 1 memo)

### Índices Criados
- **SZ1**: Ordem 1 (Z1_FILIAL + Z1_CODIGO)
- **SZ2**: Ordem 1 (Z2_FILIAL + Z2_CONTAT + Z2_SEQUEN)

### Domínio Criado
- **SX5 - Z2**: 5 tipos de interação (E, L, R, V, W)

---

