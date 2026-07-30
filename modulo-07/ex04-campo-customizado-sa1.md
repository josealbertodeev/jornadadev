# Exercício 4 — Campo Customizado na SA1 🖥️

Este é um exercício **prático** que deve ser realizado no ambiente Protheus.

## Objetivo

Criar um campo customizado na tabela SA1 (Clientes), seguindo o mesmo padrão demonstrado em aula com o campo A1_VOVO, e validar que ele aparece automaticamente na tela do SmartClient **sem escrever nenhuma linha de código**.

## Pré-requisitos

- Acesso ao ambiente Protheus
- Permissão para usar o Configurador (SIGACFG)
- Acesso ao módulo de Faturamento (SIGAFAT) no SmartClient

## Campo a ser criado

**Nome sugerido:** A1_XAPELID (Apelido do Cliente)

 **Por que A1_XAPELID?**
- `A1_` → prefixo da tabela SA1 (regra obrigatória)
- `XAPELID` → identificador do campo (X é comum para customizações)
- O "X" no início é uma convenção adicional usada por alguns desenvolvedores para indicar campos customizados

## Passo a passo

### a. Definir tipo, tamanho e título do campo no Configurador

#### 1. Acessar o Configurador

1. Abra o **Configurador (SIGACFG)** no SmartClient
2. Navegue até **Arquivos > SX3 (Campos)**
3. Filtre pela tabela **SA1**

#### 2. Criar o novo campo

1. Clique em **Incluir** para adicionar um novo campo
2. Preencha as informações do campo:

**Dados do Campo A1_XAPELID:**

| Propriedade | Valor | Observação |
|-------------|-------|------------|
| **Tabela** | SA1 | Tabela de Clientes |
| **Campo** | A1_XAPELID | Nome do campo (sempre com prefixo A1_) |
| **Tipo** | C (Caractere) | Campo de texto |
| **Tamanho** | 20 | Suficiente para um apelido |
| **Decimal** | 0 | Não se aplica a caractere |
| **Título (PT)** | Apelido | Título que aparece na tela |
| **Descrição (PT)** | Apelido do Cliente | Descrição mais detalhada |
| **Título (ES)** | Apodo | Título em espanhol (internacionalização) |
| **Título (EN)** | Nickname | Título em inglês (internacionalização) |
| **Obrigatório** | Não | Campo opcional |
| **Browse** | Não | Não precisa aparecer na listagem |
| **Ordem** | (próximo disponível) | Ordem de exibição no formulário |
| **Pasta** | 1 ou criar nova | Pode criar uma aba "Complementos" |

#### 3. Propriedades adicionais (opcional)

- **Help (F3):** "Apelido ou nome fantasia pelo qual o cliente é conhecido"
- **Válido:** (deixe vazio por enquanto)
- **When:** (deixe vazio - campo sempre editável)
- **Inicializador:** (deixe vazio)
- **Picture:** @! (força maiúsculas) - opcional

#### 4. Criar uma nova aba (opcional - seguindo o exemplo da aula)

Se quiser organizar melhor, crie uma nova pasta/aba:

1. No campo **Pasta**, escolha criar nova
2. Nome sugerido: "Complementos" ou "Dados Extras"
3. O campo A1_XAPELID ficará nesta aba

#### 5. Salvar o campo

1. Revise todos os dados preenchidos
2. Clique em **Confirmar/Salvar**
3. O sistema pode pedir confirmação - aceite

#### 6. Atualizar a estrutura da tabela

**Opção 1 - Via menu:**
- Acesse **Miscelânea > Atualizações > Dicionário de Dados**
- Ou **Miscelânea > Cadastros > Fórmulas**
- Execute a rotina para forçar o reconhecimento

**Opção 2 - Reiniciar o AppServer (em desenvolvimento):**
- Em ambiente de desenvolvimento, reiniciar o servidor força a atualização

### b. Validar que o campo aparece na tela sem código

#### 1. Fechar e reabrir o SmartClient

1. Feche completamente o SmartClient
2. Abra novamente e faça login
3. Entre no módulo de **Faturamento (SIGAFAT)**

#### 2. Acessar o cadastro de clientes

1. Navegue até **Atualizações > Cadastros > Clientes**
2. Ou use o caminho que você conhece para acessar a SA1

#### 3. Verificar o campo novo

1. Abra um cliente existente (ex: o "Michael Jackson" que criamos em aula)
2. Ou clique em **Incluir** para criar um novo cliente
3. Procure pela aba onde você colocou o campo:
   - Se usou a pasta padrão, procure nas abas existentes
   - Se criou uma aba nova (ex: "Complementos"), clique nela
4. **O campo "Apelido" deve aparecer na tela!** 🎉

#### 4. Testar o campo

1. Digite um apelido de teste no campo (ex: "Zezinho")
2. Salve o cliente
3. Feche e reabra o cadastro
4. **O apelido deve estar gravado!**

#### 5. Validar no MPSDU (opcional - apenas desenvolvimento)

Para confirmar que o dado foi gravado fisicamente:

1. Abra o **MPSDU**
2. Localize a tabela **SA1**
3. Abra a estrutura da tabela
4. **O campo A1_XAPELID deve aparecer na estrutura!**
5. Abra os dados e localize o cliente que você editou
6. **O valor do apelido deve estar gravado no campo A1_XAPELID**

