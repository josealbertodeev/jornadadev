#include "protheus.ch"

/*/{Protheus.doc} STTZZ2
Rotina de manutencao (cadastro) da tabela ZZ2 - Ocorrencias do Fornecedor.

Segue o mesmo padrao da STTZZ1.PRW: AxCadastro cuida de Pesquisar, Incluir,
Alterar, Excluir e Visualizar; as validacoes de campo (ZZ2_CONFOR existe na
ZZ1, ZZ2_CODPRO existe na SB1, ZZ2_DATA nao pode ser futura) estao na
"Validacao" do SX3 de cada campo (Dados-e-Dicionario/SX3_Campos.csv,
coluna Valid) e disparam automaticamente durante o Incluir/Alterar.

O BEGIN SEQUENCE protege a gravacao da mesma forma que na STTZZ1: qualquer
erro inesperado mostra mensagem amigavel e grava log tecnico via
U_GravarLogTCC (STTZZLIB.PRW).

Nota: o enunciado completo do TCC descreve uma versao mais avancada desta
tela via mBrowse, com legenda de cores (percentual de nao conformidade vs.
ZZ1_TOLERA) e um botao "Ocorrencias" na STTZZ1 que abriria esta rotina ja
filtrada por um controle da ZZ1 (via STTZZ2FLT). Isso fica registrado aqui
como proxima melhoria (diferencial da rubrica), depois que o nucleo minimo
estiver garantido - a funcao STTZZ2FLT abaixo ja deixa a base pronta para
essa evolucao.
/*/

USER FUNCTION STTZZ2()

    Local cTitulo := "Ocorrencias do Fornecedor"

    dbSelectArea("ZZ2")
    ZZ2->(dbSetOrder(1)) // ZZ2_FILIAL + ZZ2_CONFOR + DTOS(ZZ2_DATA) + ZZ2_HORA

    BEGIN SEQUENCE

        AxCadastro("ZZ2", cTitulo, cTitulo, cTitulo)

    RECOVER USING oErro

        MsgAlert("Nao foi possivel concluir a operacao em Ocorrencias do " + ;
                 "Fornecedor. Tente novamente; se o problema persistir "   + ;
                 "procure o time de suporte.", "Ocorrencias do Fornecedor")

        U_GravarLogTCC("STTZZ2", oErro)

    END SEQUENCE

RETURN NIL

/*/{Protheus.doc} STTZZ2FLT
Versao filtrada da STTZZ2, pensada para ser chamada a partir de um botao
"Ocorrencias" na STTZZ1 (proxima melhoria - ver nota acima). Filtra a
ZZ2 apenas pelas ocorrencias vinculadas ao controle (ZZ1_CODIGO) informado.

@param cCodigoZZ1  Codigo do controle da ZZ1 (ZZ1_CODIGO) para filtrar
@return NIL
/*/

USER FUNCTION STTZZ2FLT(cCodigoZZ1)

    Local cTitulo := "Ocorrencias do Fornecedor"

    Default cCodigoZZ1 := ""

    dbSelectArea("ZZ2")
    ZZ2->(dbSetOrder(1))

    If !Empty(cCodigoZZ1)
        ZZ2->(dbSetFilter({|| ZZ2_CONFOR == cCodigoZZ1}, "ZZ2_CONFOR == '" + cCodigoZZ1 + "'"))
    EndIf

    BEGIN SEQUENCE

        AxCadastro("ZZ2", cTitulo, cTitulo, cTitulo)

    RECOVER USING oErro

        MsgAlert("Nao foi possivel concluir a operacao em Ocorrencias do " + ;
                 "Fornecedor. Tente novamente; se o problema persistir "   + ;
                 "procure o time de suporte.", "Ocorrencias do Fornecedor")

        U_GravarLogTCC("STTZZ2FLT", oErro)

    END SEQUENCE

    ZZ2->(dbClearFilter())

RETURN NIL
