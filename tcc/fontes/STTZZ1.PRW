#include "protheus.ch"

/*/{Protheus.doc} STTZZ1
Rotina de manutencao (cadastro) da tabela ZZ1 - Controle de Fornecimento.

Usa AxCadastro, o helper padrao do Protheus que ja entrega Pesquisar,
Incluir, Alterar, Excluir e Visualizar sem precisar montar mBrowse na mao.

As validacoes de campo (ZZ1_FORNEC existe na SA2, ZZ1_TOLERA entre 0 e 100,
ZZ1_VALCER nao pode ser anterior a hoje) estao cadastradas na "Validacao"
do SX3 de cada campo (ver Dados-e-Dicionario/SX3_Campos.csv, coluna Valid) -
e por isso disparam automaticamente durante o Incluir/Alterar do AxCadastro,
sem precisar repetir a logica aqui.

O BEGIN SEQUENCE abaixo protege a chamada inteira do AxCadastro: qualquer
erro inesperado durante a gravacao (queda de rede, trava de registro, etc)
cai no RECOVER, mostra uma mensagem amigavel ao usuario e grava um log
tecnico via U_GravarLogTCC (biblioteca STTZZLIB.PRW), em vez de estourar
uma tela de erro crua do Protheus.
/*/

USER FUNCTION STTZZ1()

    Local cTitulo := "Controle de Fornecimento"

    dbSelectArea("ZZ1")
    ZZ1->(dbSetOrder(1)) // ZZ1_FILIAL + ZZ1_CODIGO (chave primaria)

    BEGIN SEQUENCE

        AxCadastro("ZZ1", cTitulo, cTitulo, cTitulo)

    RECOVER USING oErro

        MsgAlert("Nao foi possivel concluir a operacao na Controle de "  + ;
                 "Fornecimento. Tente novamente; se o problema persistir "+ ;
                 "procure o time de suporte.", "Controle de Fornecimento")

        U_GravarLogTCC("STTZZ1", oErro)

    END SEQUENCE

RETURN NIL
