# Exercício 3 — Recriando a ZA1 no Configurador 🖥️

Este é um exercício **prático** que deve ser realizado no ambiente Protheus.

## Objetivo

Recriar a tabela ZA1 (Pets) no Configurador, aplicando na prática os conceitos aprendidos em aula sobre dicionário de dados.

## Pré-requisitos

- Acesso ao ambiente Protheus
- Permissão para usar o Configurador (SIGACFG)
- Acesso ao MPSDU para validação

## Passo a passo

### a. Cadastrar a estrutura no dicionário (SX2/SX3)

#### 1. Criar a tabela no SX2 (Mapeamento de Tabelas)

1. Abra o **Configurador (SIGACFG)** no SmartClient
2. Acesse **Arquivos > SX2 (Tabelas)**
3. Clique em **Incluir**
4. Preencha os dados da tabela:
   - **Tabela:** ZA1
   - **Nome:** Cadastro de Pets
   - **Caminho:** Seguir o mesmo padrão da SA1 (geralmente `\DATA\`)
   - **Modo de acesso:** 
     - Compartilhamento: Definir conforme ambiente (Exclusivo ou Compartilhado)
   - **Filial:** Definir se será por filial ou compartilhado entre filiais
5. Salve o registro

#### 2. Criar os campos no SX3 (Definição de Campos)

1. Ainda no Configurador, acesse **Arquivos > SX3 (Campos)**
2. Filtre pela tabela **ZA1**
3. Crie os seguintes campos:

**Campo 1: ZA1_FILIAL** (obrigatório)
- **Campo:** ZA1_FILIAL
- **Tipo:** C (Caractere)
- **Tamanho:** 2
- **Decimal:** 0
- **Título (PT):** Filial
- **Descrição:** Código da Filial
- **Obrigatório:** Sim
- **Inicializador:** xFilial("ZA1")

**Campo 2: ZA1_NOME**
- **Campo:** ZA1_NOME
- **Tipo:** C (Caractere)
- **Tamanho:** 40
- **Decimal:** 0
- **Título (PT):** Nome do Pet
- **Descrição:** Nome do Animal
- **Obrigatório:** Sim
- **Ordem:** 01

**Campo 3: ZA1_RACA**
- **Campo:** ZA1_RACA
- **Tipo:** C (Caractere)
- **Tamanho:** 30
- **Decimal:** 0
- **Título (PT):** Raça
- **Descrição:** Raça do Animal
- **Obrigatório:** Não
- **Ordem:** 02

**Campo 4: ZA1_NASC**
- **Campo:** ZA1_NASC
- **Tipo:** D (Data)
- **Tamanho:** 8
- **Decimal:** 0
- **Título (PT):** Dt. Nascimento
- **Descrição:** Data de Nascimento
- **Obrigatório:** Não
- **Ordem:** 03

4. Salve cada campo após preencher

#### 3. Criar índice para a tabela

1. Acesse **Arquivos > SIX (Índices)**
2. Crie o índice principal:
   - **Tabela:** ZA1
   - **Ordem:** 1
   - **Chave:** ZA1_FILIAL+ZA1_NOME
   - **Descrição:** Filial + Nome
   - **Único:** Sim (para evitar duplicidade)

### b. Forçar reconhecimento da tabela pelo framework

1. Acesse no SmartClient: **Miscelânea > Cadastros > Fórmulas**
2. Ou execute no menu: **Atualizações > Dicionário de Dados**
3. A rotina de fórmulas força o sistema a reconhecer as novas estruturas criadas
4. Aguarde o processamento e validação
5. Reinicie o SmartClient se necessário

**Nota:** Em alguns ambientes, pode ser necessário:
- Executar a rotina **UPDDISTR** para distribuir as atualizações
- Ou reiniciar o AppServer (em ambiente de desenvolvimento)

### c. Conferir a estrutura final no MPSDU

1. Abra o **MPSDU** (ferramenta de acesso direto aos dados)
2. Localize o arquivo da tabela **ZA1**
3. Verifique se a estrutura contém todos os campos:
   - ZA1_FILIAL (C, 2)
   - ZA1_NOME (C, 40)
   - ZA1_RACA (C, 30)
   - ZA1_NASC (D, 8)
