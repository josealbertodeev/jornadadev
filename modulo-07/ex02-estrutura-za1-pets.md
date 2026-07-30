# Exercício 2 — A Tabela ZA1 (Pets)

## a. Lista dos campos da ZA1 (nome, tipo, tamanho)

A tabela ZA1 criada em aula possui os seguintes campos:

| Campo | Tipo | Tamanho | Descrição |
|-------|------|---------|-----------|
| ZA1_FILIAL | Caractere | 2 | Código da filial (obrigatório em toda tabela do Protheus) |
| ZA1_NOME | Caractere | 30-40 | Nome do pet |
| ZA1_RACA | Caractere | 20-30 | Raça do pet |
| ZA1_NASC | Data | 8 | Data de nascimento do pet |

O campo ZA1_FILIAL é obrigatório porque toda tabela do Protheus precisa se encaixar no padrão multiempresa do sistema, permitindo que diferentes filiais de uma empresa gerenciem seus dados de forma separada ou compartilhada, conforme configurado.

## b. Índice que faria sentido para a ZA1

Um índice apropriado para a ZA1 seria: **ZA1_FILIAL + ZA1_NOME**

**Justificativa:** Assim como uma lista telefônica organiza os nomes alfabeticamente para facilitar a busca rápida, um índice por filial + nome do pet permite:
- Localizar rapidamente um pet específico dentro de uma filial sem precisar varrer toda a tabela
- Evitar duplicidade de pets com o mesmo nome na mesma filial (chave única)
- Garantir performance nas consultas, especialmente quando a tabela crescer com muitos registros

Outro índice útil poderia ser **ZA1_FILIAL + ZA1_RACA**, para listar rapidamente todos os pets de uma determinada raça em uma filial.

## c. Por que o prefixo da tabela é Z?

O prefixo **Z** é a convenção do Protheus para identificar **tabelas customizadas de cliente**. Isso significa:
- Tabelas que **não vêm de fábrica** com o ERP
- Foram criadas para atender necessidades específicas de um cliente ou de uma customização
- Diferenciam-se das tabelas padrão do sistema (como SA1, SB1, SC5, etc.)
- São identificadas imediatamente como customizações, facilitando a manutenção e atualização do sistema

Essa convenção é fundamental para que, durante atualizações do Protheus, as tabelas customizadas não sejam confundidas com tabelas padrão do sistema, evitando conflitos e perda de dados.

## d. Por que os campos começam com ZA1_?

Os campos começam com **ZA1_** (prefixo da tabela + underscore) seguindo uma regra fundamental do Protheus:

**Nome do campo = Prefixo da tabela + _ + Nome descritivo**

**Motivos dessa convenção:**
- Permite identificar, **apenas pelo nome do campo**, de qual tabela ele pertence
- Evita conflitos de nomes quando campos de diferentes tabelas são usados simultaneamente no código
- Facilita a leitura e manutenção do código ADVPL, tornando-o autodocumentado
- Mantém consistência com o padrão adotado em todo o sistema Protheus

**Exemplos:**
- `ZA1_NOME` → campo NOME da tabela ZA1
- `ZA1_RACA` → campo RACA da tabela ZA1
- `A1_COD` → campo COD da tabela SA1 (clientes)

Se os campos fossem nomeados apenas como "NOME" ou "RACA" (sem o prefixo ZA1_), seria impossível saber de qual tabela eles vêm ao ler o código, comprometendo a clareza e a manutenibilidade do sistema.
