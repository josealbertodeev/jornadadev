# Autoavaliação — TCC Jornada DEV START

**Aluno:** José Alberto 

**Projeto:** Controle de Não Conformidades de Fornecedores (ISO 9001)

## O que entreguei

- Dicionário completo das tabelas `ZZ1` (10 campos, 3 índices) e `ZZ2`
  (13 campos, 3 índices), incluindo os 6 gatilhos automáticos, em CSV.
- `STTZZ1.PRW` — rotina de manutenção da ZZ1 via `AxCadastro`.
- `STTZZ2.PRW` — rotina de manutenção da ZZ2 via `AxCadastro`, com uma
  versão filtrada (`STTZZ2FLT`) preparada para uso futuro por botão.
- `STTZZLIB.PRW` — biblioteca com 5 funções reutilizadas pelas duas rotinas.
- Validações de campo (fornecedor existe na SA2/ZZ1, produto existe na SB1,
  tolerância entre 0-100, datas não futuras) via SX3.
- Tratamento de erro com `BEGIN SEQUENCE / RECOVER`, mensagem amigável e log
  técnico em ambas as rotinas.
- Estrutura de menu no SIGACOM (`Cadastros > Controle ISO 9001`), apontando
  para `STTZZ1` e `STTZZ2`.
- Consultas padrão (SXB) para ZZ1, SA2 e SB1.

## Revisão e teste manual (dry run)

Sem ambiente estável disponível, fiz uma revisão de código linha a linha
simulando o fluxo de execução (inclusão válida, inclusão com erro de
gravação, e os casos de borda das funções da biblioteca). Encontrei e
corrigi um bug real: `STTZZLIB.PRW` usava as constantes `FO_WRITE` e
`FS_END` (usadas em `GravarLogTCC`) sem importar `fileio.ch` — o arquivo
não compilaria. Também validei separadamente a matemática de
`PercNaoConforme` e `CertificadoVencendo` (incluindo o caso de divisão por
zero quando não há itens ainda), e conferi que todos os nomes de campo
usados nos `.PRW` batem com os do dicionário em CSV.

## O que não entreguei (e por quê)

- **Não gerei os `.dbf` nem prints das telas rodando.** O ambiente Protheus
  local apresentou um problema recorrente: mesmo depois de cadastrar e
  confirmar a estrutura das tabelas ZZ1/ZZ2 corretamente no Configurador
  (duas vezes seguidas, verificado tela a tela), o dicionário voltava para
  um snapshot anterior sem elas — inclusive depois de reiniciar o AppServer
  e confirmar "salvar alterações". Decidi não insistir mais nisso para não
  comprometer o prazo, e segui pelo caminho de entrega em CSV + código
  previsto no próprio enunciado para quem não conseguiu manter o ambiente
  estável.
- **Legenda colorida (mBrowse) e botão "Ocorrências" entre ZZ1 e ZZ2** —
  optei por `AxCadastro`, mais simples, para garantir que o núcleo mínimo
  ficasse pronto com segurança dentro do prazo. A função `STTZZ2FLT` já
  deixa a base pronta para essa evolução, se eu tiver tempo de voltar nela.
- **Integridade referencial na exclusão da ZZ1** e **classe ADVPL (POO)** —
  diferenciais que não cheguei a implementar.

