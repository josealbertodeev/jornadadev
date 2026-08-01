# Exerc¡cio 1 ? Dicion rio de Dados Completo (B“nus/Autoestudo)

## ?? Objetivo

Configurar no dicion rio do Protheus as duas tabelas do projeto de **CRM/GestÆo de Contatos**:
- **SZ1**: Cadastro de Contatos
- **SZ2**: Intera‡äes com Contatos (hist¢rico de liga‡äes, emails, reuniäes, etc.)

---

## ?? O que configurar

### 1. Tabelas no SX2 (Estrutura)
### 2. Campos no SX3 (Defini‡Æo de campos)
### 3. Öndices no SIX (Chaves de acesso)
### 4. Dom¡nio no SX5 (Lista de tipos de intera‡Æo)

---

## ??? Passo 1: Configurar Tabelas no SX2

### Acessar o Configurador
```
Menu: Ambiente > Cadastros > Dicion rio > Tabelas (SX2)
ou
Configurador > Dicion rio de Dados > Tabelas
```

### Tabela SZ1 - Cadastro de Contatos

| Campo | Valor |
|-------|-------|
| **Tabela** | SZ1 |
| **Descri‡Æo** | Cadastro de Contatos |
| **Modo de Acesso** | **Compartilhado** |
| **Tipo** | Cliente |
| **Aplicativo** | S = Sigamat |

**Por que Compartilhado?**
- Todos os contatos ficam dispon¡veis para todas as filiais da empresa
- Evita duplica‡Æo de dados
- Facilita relat¢rios consolidados

---

### Tabela SZ2 - Intera‡äes com Contatos

| Campo | Valor |
|-------|-------|
| **Tabela** | SZ2 |
| **Descri‡Æo** | Intera‡äes com Contatos |
| **Modo de Acesso** | **Compartilhado** |
| **Tipo** | Cliente |
| **Aplicativo** | S = Sigamat |

**Relacionamento:**
- SZ2 ‚ filho de SZ1 (1:N)
- Um contato (SZ1) pode ter v rias intera‡äes (SZ2)

---

## ?? Passo 2: Configurar Campos no SX3

### Acessar o Configurador
```
Menu: Ambiente > Cadastros > Dicion rio > Campos (SX3)
ou
Configurador > Dicion rio de Dados > Campos
```

---

### ? Campos da SZ1 (Contatos)

#### Campo: Z1_FILIAL (Filial)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z1_FILIAL |
| **Tipo** | Caractere |
| **Tamanho** | 2 |
| **Decimal** | 0 |
| **T¡tulo** | Filial |
| **Descri‡Æo** | Filial do Sistema |
| **Contexto** | **Real** |
| **Inicializador** | xFilial("SZ1") |
| **Uso** | Usado |
| **Obrigat.** | Sim |
| **Browse** | Sim |
| **Visual** | V |

---

#### Campo: Z1_CODIGO (C¢digo do Contato)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z1_CODIGO |
| **Tipo** | Caractere |
| **Tamanho** | 6 |
| **Decimal** | 0 |
| **T¡tulo** | C¢digo |
| **Descri‡Æo** | C¢digo do Contato |
| **Contexto** | **Real** |
| **Inicializador** | GetSXENum("SZ1","Z1_CODIGO") |
| **Valid** | ExistChav("SZ1",M->Z1_CODIGO) |
| **Uso** | Usado |
| **Obrigat.** | Sim |
| **Browse** | Sim |
| **Visual** | V |

**GetSXENum:** Gera c¢digo sequencial autom tico

---

#### Campo: Z1_NOME (Nome do Contato)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z1_NOME |
| **Tipo** | Caractere |
| **Tamanho** | 50 |
| **Decimal** | 0 |
| **T¡tulo** | Nome |
| **Descri‡Æo** | Nome do Contato |
| **Contexto** | **Real** |
| **Uso** | Usado |
| **Obrigat.** | Sim |
| **Browse** | Sim |
| **Visual** | A |
| **Picture** | @! |

**@!:** Converte para mai£sculas automaticamente

---

#### Campo: Z1_EMAIL (Email)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z1_EMAIL |
| **Tipo** | Caractere |
| **Tamanho** | 100 |
| **Decimal** | 0 |
| **T¡tulo** | Email |
| **Descri‡Æo** | Email do Contato |
| **Contexto** | **Real** |
| **Valid** | U_VALEMAIL(M->Z1_EMAIL) |
| **Uso** | Usado |
| **Obrigat.** | NÆo |
| **Browse** | Sim |
| **Visual** | A |

**VALEMAIL:** Fun‡Æo customizada para validar formato de email

---

#### Campo: Z1_TELEFON (Telefone)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z1_TELEFON |
| **Tipo** | Caractere |
| **Tamanho** | 20 |
| **Decimal** | 0 |
| **T¡tulo** | Telefone |
| **Descri‡Æo** | Telefone do Contato |
| **Contexto** | **Real** |
| **Picture** | @R (99) 99999-9999 |
| **Uso** | Usado |
| **Obrigat.** | NÆo |
| **Browse** | Sim |
| **Visual** | A |

**@R:** M scara de edi‡Æo (formato de telefone)

---

#### Campo: Z1_EMPRESA (Empresa)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z1_EMPRESA |
| **Tipo** | Caractere |
| **Tamanho** | 100 |
| **Decimal** | 0 |
| **T¡tulo** | Empresa |
| **Descri‡Æo** | Empresa do Contato |
| **Contexto** | **Real** |
| **Uso** | Usado |
| **Obrigat.** | NÆo |
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
| **T¡tulo** | Cargo |
| **Descri‡Æo** | Cargo do Contato |
| **Contexto** | **Real** |
| **Uso** | Usado |
| **Obrigat.** | NÆo |
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
| **T¡tulo** | Dt. Cadastro |
| **Descri‡Æo** | Data de Cadastro |
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
| **T¡tulo** | Status |
| **Descri‡Æo** | Status do Contato |
| **Contexto** | **Virtual** |
| **Inicializador** | U_SZ1STATUS() |
| **Uso** | Usado |
| **Browse** | Sim |
| **Visual** | V |

**Campo Virtual:** Calculado em tempo real, nÆo gravado no banco

**Fun‡Æo U_SZ1STATUS():**
```advpl
USER FUNCTION SZ1STATUS()
    LOCAL cStatus := "Ativo"
    LOCAL nDias := 0
    LOCAL dUltimaInt := CTOD("//")
    
    // Busca data da £ltima intera‡Æo
    dbSelectArea("SZ2")
    dbSetOrder(1) // Z2_FILIAL + Z2_CONTAT
    IF dbSeek(xFilial("SZ2") + SZ1->Z1_CODIGO)
        // Percorre at‚ achar a mais recente
        WHILE !EOF() .AND. SZ2->Z2_CONTAT == SZ1->Z1_CODIGO
            IF SZ2->Z2_DATA > dUltimaInt
                dUltimaInt := SZ2->Z2_DATA
            ENDIF
            dbSkip()
        ENDDO
    ENDIF
    
    IF Empty(dUltimaInt)
        cStatus := "Sem Intera‡Æo"
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

#### Campo: Z1_ULTINT (éltima Intera‡Æo) - **VIRTUAL**
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z1_ULTINT |
| **Tipo** | Data |
| **Tamanho** | 8 |
| **Decimal** | 0 |
| **T¡tulo** | élt. Intera‡Æo |
| **Descri‡Æo** | Data da éltima Intera‡Æo |
| **Contexto** | **Virtual** |
| **Inicializador** | U_SZ1ULTINT() |
| **Uso** | Usado |
| **Browse** | Sim |
| **Visual** | V |

---

### ? Campos da SZ2 (Intera‡äes)

#### Campo: Z2_FILIAL (Filial)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_FILIAL |
| **Tipo** | Caractere |
| **Tamanho** | 2 |
| **Decimal** | 0 |
| **T¡tulo** | Filial |
| **Descri‡Æo** | Filial do Sistema |
| **Contexto** | **Real** |
| **Inicializador** | xFilial("SZ2") |
| **Uso** | Usado |
| **Obrigat.** | Sim |
| **Browse** | Sim |
| **Visual** | V |

---

#### Campo: Z2_CONTAT (C¢digo do Contato)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_CONTAT |
| **Tipo** | Caractere |
| **Tamanho** | 6 |
| **Decimal** | 0 |
| **T¡tulo** | Contato |
| **Descri‡Æo** | C¢digo do Contato |
| **Contexto** | **Real** |
| **Valid** | ExistCpo("SZ1",M->Z2_CONTAT) |
| **F3** | SZ1 |
| **Uso** | Usado |
| **Obrigat.** | Sim |
| **Browse** | Sim |
| **Visual** | A |

**F3:** Consulta padrÆo para buscar contatos

---

#### Campo: Z2_SEQUEN (Sequˆncia)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_SEQUEN |
| **Tipo** | Caractere |
| **Tamanho** | 3 |
| **Decimal** | 0 |
| **T¡tulo** | Sequˆncia |
| **Descri‡Æo** | Sequˆncia da Intera‡Æo |
| **Contexto** | **Real** |
| **Inicializador** | U_PROXSEQ() |
| **Uso** | Usado |
| **Obrigat.** | Sim |
| **Browse** | Sim |
| **Visual** | V |

**U_PROXSEQ():** Calcula pr¢ximo n£mero de sequˆncia para o contato

---

#### Campo: Z2_DATA (Data da Intera‡Æo)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_DATA |
| **Tipo** | Data |
| **Tamanho** | 8 |
| **Decimal** | 0 |
| **T¡tulo** | Data |
| **Descri‡Æo** | Data da Intera‡Æo |
| **Contexto** | **Real** |
| **Inicializador** | dDataBase |
| **Uso** | Usado |
| **Obrigat.** | Sim |
| **Browse** | Sim |
| **Visual** | A |

---

#### Campo: Z2_HORA (Hora da Intera‡Æo)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_HORA |
| **Tipo** | Caractere |
| **Tamanho** | 5 |
| **Decimal** | 0 |
| **T¡tulo** | Hora |
| **Descri‡Æo** | Hora da Intera‡Æo |
| **Contexto** | **Real** |
| **Inicializador** | Time() |
| **Picture** | @R 99:99 |
| **Uso** | Usado |
| **Obrigat.** | Sim |
| **Browse** | Sim |
| **Visual** | A |

---

#### Campo: Z2_TIPO (Tipo de Intera‡Æo)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_TIPO |
| **Tipo** | Caractere |
| **Tamanho** | 1 |
| **Decimal** | 0 |
| **T¡tulo** | Tipo |
| **Descri‡Æo** | Tipo de Intera‡Æo |
| **Contexto** | **Real** |
| **Combo** | E=Email;L=Liga‡Æo;R=ReuniÆo;V=Visita;W=WhatsApp |
| **F3** | Z2 |
| **Uso** | Usado |
| **Obrigat.** | Sim |
| **Browse** | Sim |
| **Visual** | A |

---

#### Campo: Z2_TIPODES (Descri‡Æo do Tipo) - **VIRTUAL**
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_TIPODES |
| **Tipo** | Caractere |
| **Tamanho** | 20 |
| **Decimal** | 0 |
| **T¡tulo** | Desc. Tipo |
| **Descri‡Æo** | Descri‡Æo do Tipo |
| **Contexto** | **Virtual** |
| **Inicializador** | X5Descri() |
| **Uso** | Usado |
| **Browse** | Sim |
| **Visual** | V |

**X5Descri():** Busca descri‡Æo na tabela SX5

---

#### Campo: Z2_ASSUNTO (Assunto)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_ASSUNTO |
| **Tipo** | Caractere |
| **Tamanho** | 100 |
| **Decimal** | 0 |
| **T¡tulo** | Assunto |
| **Descri‡Æo** | Assunto da Intera‡Æo |
| **Contexto** | **Real** |
| **Uso** | Usado |
| **Obrigat.** | Sim |
| **Browse** | Sim |
| **Visual** | A |

---

#### Campo: Z2_DESCRIC (Descri‡Æo)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_DESCRIC |
| **Tipo** | Memo |
| **Tamanho** | 10 |
| **Decimal** | 0 |
| **T¡tulo** | Descri‡Æo |
| **Descri‡Æo** | Descri‡Æo Detalhada |
| **Contexto** | **Real** |
| **Uso** | Usado |
| **Obrigat.** | NÆo |
| **Browse** | NÆo |
| **Visual** | A |

**Tipo Memo:** Campo texto longo (armazenado em tabela auxiliar)

---

#### Campo: Z2_USUARIO (Usu rio)
| Propriedade | Valor |
|-------------|-------|
| **Campo** | Z2_USUARIO |
| **Tipo** | Caractere |
| **Tamanho** | 15 |
| **Decimal** | 0 |
| **T¡tulo** | Usu rio |
| **Descri‡Æo** | Usu rio que Registrou |
| **Contexto** | **Real** |
| **Inicializador** | RetCodUsr() |
| **Uso** | Usado |
| **Obrigat.** | Sim |
| **Browse** | Sim |
| **Visual** | V |

**RetCodUsr():** Retorna c¢digo do usu rio logado

---

## ?? Passo 3: Configurar Öndices no SIX

### Acessar o Configurador
```
Menu: Ambiente > Cadastros > Dicion rio > Öndices (SIX)
ou
Configurador > Dicion rio de Dados > Öndices
```

---

### ? Öndices da SZ1

#### Öndice 1 (Ordem 1)
| Propriedade | Valor |
|-------------|-------|
| **Tabela** | SZ1 |
| **Ordem** | 1 |
| **Chave** | Z1_FILIAL+Z1_CODIGO |
| **Descri‡Æo** | Filial + C¢digo |
| **Apelidocpo** | Z1_FILIAL;Z1_CODIGO |
| **énico** | Sim |

**Öndice énico:** Garante que nÆo haja c¢digos duplicados

---

#### Öndice 2 (Ordem 2) - Opcional
| Propriedade | Valor |
|-------------|-------|
| **Tabela** | SZ1 |
| **Ordem** | 2 |
| **Chave** | Z1_FILIAL+Z1_NOME |
| **Descri‡Æo** | Filial + Nome |
| **Apelidocpo** | Z1_FILIAL;Z1_NOME |
| **énico** | NÆo |

**Öndice por Nome:** Facilita pesquisas alfab‚ticas

---

### ? Öndices da SZ2

#### Öndice 1 (Ordem 1)
| Propriedade | Valor |
|-------------|-------|
| **Tabela** | SZ2 |
| **Ordem** | 1 |
| **Chave** | Z2_FILIAL+Z2_CONTAT+Z2_SEQUEN |
| **Descri‡Æo** | Filial + Contato + Sequˆncia |
| **Apelidocpo** | Z2_FILIAL;Z2_CONTAT;Z2_SEQUEN |
| **énico** | Sim |

**Relacionamento:** Este ¡ndice permite buscar todas as intera‡äes de um contato

---

#### Öndice 2 (Ordem 2) - Opcional
| Propriedade | Valor |
|-------------|-------|
| **Tabela** | SZ2 |
| **Ordem** | 2 |
| **Chave** | Z2_FILIAL+DTOS(Z2_DATA)+Z2_HORA |
| **Descri‡Æo** | Filial + Data + Hora |
| **Apelidocpo** | Z2_FILIAL;Z2_DATA;Z2_HORA |
| **énico** | NÆo |

**Öndice Cronol¢gico:** Facilita listagens por data

---

## ?? Passo 4: Configurar Dom¡nio no SX5

### Acessar o Configurador
```
Menu: Ambiente > Cadastros > Tabelas Gen‚ricas (SX5)
ou
Configurador > Dicion rio de Dados > Tabelas Gen‚ricas
```

---

### ? Dom¡nio Z2 - Tipos de Intera‡Æo

#### Incluir Tabela Z2
| Propriedade | Valor |
|-------------|-------|
| **Tabela** | Z2 |
| **Descri‡Æo** | Tipos de Intera‡Æo com Contatos |

---

#### Itens da Tabela Z2

| Chave | Descri‡Æo (Portuguˆs) | Descri‡Æo (Inglˆs) | Descri‡Æo (Espanhol) |
|-------|------------------------|---------------------|----------------------|
| **E** | Email | Email | Email |
| **L** | Liga‡Æo | Call | Llamada |
| **R** | ReuniÆo | Meeting | Reuni¢n |
| **V** | Visita | Visit | Visita |
| **W** | WhatsApp | WhatsApp | WhatsApp |

---

## ? Resumo da Configura‡Æo

### Tabelas Criadas
- ? **SZ1** (Modo Compartilhado) - Cadastro de Contatos
- ? **SZ2** (Modo Compartilhado) - Intera‡äes

### Campos Criados
- ? **SZ1**: 9 campos (7 reais + 2 virtuais)
- ? **SZ2**: 10 campos (8 reais + 1 virtual + 1 memo)

### Öndices Criados
- ? **SZ1**: Ordem 1 (Z1_FILIAL + Z1_CODIGO)
- ? **SZ2**: Ordem 1 (Z2_FILIAL + Z2_CONTAT + Z2_SEQUEN)

### Dom¡nio Criado
- ? **SX5 - Z2**: 5 tipos de intera‡Æo (E, L, R, V, W)

---

