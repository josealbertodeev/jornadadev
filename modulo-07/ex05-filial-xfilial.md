# Exercício 5 — A1_FILIAL e xFilial() ⭐ 🧠

## a. Por que existe o campo A1_FILIAL na tabela SA1 (e por que toda tabela do Protheus, incluindo a ZA1 que criamos, precisa de um campo de filial)?

O campo A1_FILIAL existe porque o Protheus foi projetado para ser um sistema **multiempresa e multifilial** desde sua concepção. Uma mesma instalação do Protheus pode gerenciar dados de várias empresas e suas respectivas filiais simultaneamente. O campo de filial serve como parte da chave primária de cada registro, permitindo que o sistema identifique a qual filial aquele dado pertence e garantindo que os usuários de cada filial vejam apenas seus próprios dados (ou dados compartilhados, conforme configuração). Sem o campo de filial, seria impossível segregar os dados por filial, comprometendo a integridade e a segurança do sistema em ambientes corporativos com múltiplas unidades de negócio.

## b. O que a função xFilial() tem a ver com isso? O que aconteceria se não a usássemos?

A função `xFilial()` é responsável por retornar o código correto da filial que deve ser gravado no registro, respeitando a configuração de **compartilhamento** da tabela. Se a tabela for compartilhada entre filiais, xFilial() retorna uma string vazia (""); se for exclusiva por filial, retorna o código da filial atual (ex: "01", "02"). Se não usássemos xFilial() e gravássemos o código da filial diretamente (hard-coded), correríamos o risco de gravar dados em filiais erradas ou criar registros duplicados em tabelas compartilhadas, além de quebrar a lógica de compartilhamento configurada no dicionário de dados (SX2), gerando inconsistências graves no banco.

---

