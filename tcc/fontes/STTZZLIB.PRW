#include "protheus.ch"
#include "fileio.ch"

/*/{Protheus.doc} STTZZLIB
Biblioteca de funcoes comuns do TCC (Controle de Nao Conformidades de
Fornecedores). Reune tudo que STTZZ1.PRW e STTZZ2.PRW precisam repetir,
para nao duplicar codigo entre as duas rotinas.

Funcoes disponiveis:
  - NomeFornecedor(cFornec, cLoja)   -> nome do fornecedor via SA2
  - NomeProduto(cCodPro)             -> descricao do produto via SB1
  - PercNaoConforme(nOk, nNok)       -> % de nao conformidade
  - CertificadoVencendo(dValCer)     -> .T. se vence em ate 30 dias
  - GravarLogTCC(cFuncao, oErro)     -> log tecnico de erro (BEGIN SEQUENCE)
/*/

/*/{Protheus.doc} NomeFornecedor
Busca o nome do fornecedor na SA2 a partir do codigo e loja.
Usada pelos gatilhos de ZZ1_NOMEFO e ZZ2_NOMEFO e por qualquer tela que
precise exibir o nome sem duplicar o POSICIONE em varios lugares.

@param cFornec  Codigo do fornecedor (SA2)
@param cLoja    Loja do fornecedor (SA2)
@return Caractere com o nome do fornecedor, ou "" se nao encontrado
/*/

USER FUNCTION NomeFornecedor(cFornec, cLoja)

    Local cNome := ""

    Default cFornec := ""
    Default cLoja    := ""

    If !Empty(cFornec)
        cNome := Posicione("SA2", 1, xFilial("SA2") + cFornec + cLoja, "A2_NOME")
    EndIf

RETURN cNome

/*/{Protheus.doc} NomeProduto
Busca a descricao do produto na SB1 a partir do codigo.

@param cCodPro  Codigo do produto (SB1)
@return Caractere com a descricao do produto, ou "" se nao encontrado
/*/

USER FUNCTION NomeProduto(cCodPro)

    Local cDescr := ""

    Default cCodPro := ""

    If !Empty(cCodPro)
        cDescr := Posicione("SB1", 1, xFilial("SB1") + cCodPro, "B1_DESC")
    EndIf

RETURN cDescr

/*/{Protheus.doc} PercNaoConforme
Calcula o percentual de itens nao conformes sobre o total recebido.
Usada na legenda da ZZ2 para comparar contra a tolerancia (ZZ1_TOLERA).

Formula: % NC = (Qtd Nao Conforme / (Qtd Conforme + Qtd Nao Conforme)) * 100

@param nOk   Quantidade conforme
@param nNok  Quantidade nao conforme
@return Numerico com o percentual (0 se nao houver itens)
/*/

USER FUNCTION PercNaoConforme(nOk, nNok)

    Local nPerc := 0
    Local nTotal := 0

    Default nOk  := 0
    Default nNok := 0

    nTotal := nOk + nNok

    If nTotal > 0
        nPerc := (nNok / nTotal) * 100
    EndIf

RETURN nPerc

/*/{Protheus.doc} CertificadoVencendo
Informa se a validade do certificado esta a 30 dias ou menos de vencer
(ou ja vencida). Usada na legenda da ZZ1 (vermelho/amarelo/verde).

@param dValCer  Data de validade do certificado (ZZ1_VALCER)
@return .T. se o certificado vence em ate 30 dias (ou ja venceu), .F. caso
        contrario
/*/

USER FUNCTION CertificadoVencendo(dValCer)

    Local lVencendo := .F.

    Default dValCer := CToD("")

    If !Empty(dValCer)
        lVencendo := (dValCer <= (dDataBase + 30))
    EndIf

RETURN lVencendo

/*/{Protheus.doc} GravarLogTCC
Grava um log tecnico simples de erro, para ser chamado no RECOVER de um
BEGIN SEQUENCE. Nao substitui o log nativo do Protheus (ConOut/aLog): o
objetivo aqui e ter um rastro minimo, legivel, gravado em arquivo texto,
que sirva de evidencia de que o tratamento de erro esta funcionando.

@param cFuncao  Nome da rotina onde o erro ocorreu (ex: "STTZZ1")
@param oErro    Objeto de erro recebido pelo RECOVER USING
@return NIL
/*/

USER FUNCTION GravarLogTCC(cFuncao, oErro)

    Local cArquivo := "\LOGTCC.TXT"
    Local nHandle  := 0
    Local cLinha   := ""
    Local cDescr   := ""

    Default cFuncao := "???"

    cDescr := If(oErro != NIL, oErro:Description, "Erro nao especificado")

    cLinha := DToC(Date()) + " " + Time() + " | " + cFuncao + " | " + cDescr + CRLF

    If !File(cArquivo)
        nHandle := FCreate(cArquivo)
    Else
        nHandle := FOpen(cArquivo, FO_WRITE)
        FSeek(nHandle, 0, FS_END)
    EndIf

    If nHandle > 0
        FWrite(nHandle, cLinha)
        FClose(nHandle)
    EndIf

    ConOut("STTZZLIB - Erro em " + cFuncao + ": " + cDescr)

RETURN NIL
