# Exercício 1 — Conceitos Fundamentais

## a. Qual é a função do AppServer?

O AppServer é o servidor de aplicação responsável por processar as requisições dos usuários e executar o código ADVPL. Ele gerencia as conexões dos terminais (SmartClient), carrega o RPO, processa a lógica de negócio e faz a comunicação com o banco de dados. É o núcleo da arquitetura do sistema Protheus, atuando como intermediário entre a interface do usuário e os dados armazenados.

## b. O que é o RPO?

RPO (Repository of Objects) é o repositório de objetos compilados que contém todo o código ADVPL da aplicação. Ele armazena os programas, funções, menus, relatórios e recursos compilados em formato binário que serão executados pelo AppServer. O RPO é carregado na memória do servidor durante sua inicialização, permitindo a execução rápida das rotinas do sistema.

## c. Para que serve o Configurador (SIGACFG)?

O Configurador (SIGACFG) é o módulo responsável pela configuração inicial e parametrização do sistema Protheus. Ele permite cadastrar empresas, filiais, definir parâmetros do sistema (MV_PAR), configurar ambientes e realizar ajustes necessários para o funcionamento correto das rotinas. É através dele que se estabelece a estrutura organizacional e os comportamentos padrão do sistema.

## d. Qual a diferença entre campo Real e campo Virtual no SX3?

Campo Real é aquele que possui armazenamento físico na tabela do banco de dados, ocupando espaço e persistindo as informações gravadas. Já o campo Virtual não existe fisicamente na base de dados, sendo calculado em tempo de execução através de uma fórmula definida no dicionário (SX3). Os campos virtuais são úteis para exibir informações derivadas de outros campos sem ocupar espaço adicional no banco.
