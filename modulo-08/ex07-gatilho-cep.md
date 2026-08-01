# Exercício 7 — 🎉 A brincadeira do CEP: gatilho que preenche o endereço

## 📌 Objetivo

Criar um gatilho (SX7) no campo **A1_CEP** do cadastro de Clientes (SA1) que preenche automaticamente os campos de endereço (bairro, município e UF) quando o usuário digita o CEP e sai do campo.

**Como funciona:**
1. Usuário digita o CEP (ex: 18035-000)
2. Pressiona Tab (sai do campo)
3. **Mágica!** O sistema preenche sozinho:
   - **A1_BAIRRO** = Vila Santa Terezinha
   - **A1_MUN** = Sorocaba
   - **A1_EST** = SP

---

## 🧠 Parte Conceitual (respostas escritas)

### a. Qual a diferença entre campo, contra-domínio e regra num gatilho?

**Campo:**
- É o campo **origem** que dispara o gatilho
- Quando o usuário sai deste campo (Tab), o gatilho é executado
- No nosso exemplo: **A1_CEP**

**Contra-domínio:**
- É o campo **destino** que será preenchido automaticamente
- Recebe o valor calculado pela regra
- No nosso exemplo: **A1_BAIRRO**, **A1_MUN**, **A1_EST** (são 3 contra-domínios diferentes)

**Regra:**
- É a **expressão/fórmula** que calcula o valor a ser colocado no contra-domínio
- Pode ser uma função, POSICIONE, cálculo, etc.
- No nosso exemplo: `U_STCEP(M->A1_CEP,"BAIRRO")`, `U_STCEP(M->A1_CEP,"CIDADE")`, etc.

**Resumo:**
```
Campo (A1_CEP) → [Regra executa] → Contra-domínio (A1_BAIRRO) recebe valor
```

---

### b. Por que a regra usa M->A1_CEP e não SA1->A1_CEP?

**M->A1_CEP:**
- Acessa o valor que o usuário **está digitando agora** (ainda não gravado)
- É o valor **em memória**, no formulário ativo
- É o que queremos usar para buscar o endereço no momento da digitação

**SA1->A1_CEP:**
- Acessa o valor **já gravado** no banco de dados (registro anterior)
- Não serve para gatilho, pois queremos pegar o valor novo, não o antigo

**Exemplo prático:**
- Usuário está alterando um cliente que tinha CEP = 01000-000
- Digita o novo CEP = 18035-000
- M->A1_CEP = 18035-000 (o que digitou agora) ✅ Correto para usar
- SA1->A1_CEP = 01000-000 (o antigo, do banco) ❌ Errado para usar

**Conclusão:** Em gatilhos, validações e inicializadores, sempre use **M->** para pegar o valor atual do formulário.

---

### c. Os CEPs estão dentro do fonte. Cite dois problemas disso em produção e como você resolveria (pense em tabela do dicionário e em serviço externo).

#### 🔴 Problema 1: CEPs ficam desatualizados (hardcoded)
- CEPs mudam com o tempo (ruas novas, bairros renomeados, etc.)
- Para atualizar, precisa **recompilar** o código .prw
- Em produção, recompilar = risco, testes, deploy

**Solução 1a - Tabela no Dicionário:**
- Criar uma tabela customizada **ZCE** (Tabela de CEPs) no dicionário
- Campos: ZCE_CEP, ZCE_BAIRRO, ZCE_CIDADE, ZCE_UF
- Manutenção via cadastro (CRUD) sem recompilar
- Função U_STCEP busca na ZCE em vez do hardcoded

**Solução 1b - Serviço Externo (API):**
- Usar API de consulta de CEP (ex: ViaCEP, APICEP, etc.)
- Consulta online e sempre atualizada
- Exemplo: `https://viacep.com.br/ws/18035000/json/`
- Função U_STCEP faz requisição HTTP e retorna o resultado

#### 🔴 Problema 2: Memória e performance
- Lista de CEPs no código ocupa memória
- Carregar todos os CEPs ao compilar é ineficiente
- Dificulta manutenção (código grande e confuso)

**Solução 2a - Banco de dados:**
- CEPs em tabela ZCE com índice otimizado
- Busca rápida via dbSeek
- Não carrega tudo na memória

**Solução 2b - Cache + API:**
- Cache local dos CEPs mais usados
- Consulta API quando não está no cache
- Melhor performance + dados atualizados

**Resumo das soluções:**
1. **Curto prazo:** Criar tabela ZCE no dicionário (controle interno)
2. **Longo prazo:** Integrar com API externa (ex: ViaCEP) para dados sempre atualizados

---

### d. Se pedissem para preencher também o código do município (A1_COD_MUN), o que você faria?

**Resposta:**

Criaria um **4º gatilho** no campo A1_CEP com:
- **Sequência:** 004
- **Campo:** A1_CEP
- **Contra-domínio:** A1_COD_MUN
- **Regra:** `U_STCEP(M->A1_CEP,"COD_MUN")`

**No código (stcep.prw):**

Adicionaria mais um CASE no DO CASE para retornar o código do município:

```advpl
USER FUNCTION STCEP(cCEP, cTipo)
    LOCAL cRetorno := ""
    LOCAL cCEPLimpo := StrTran(StrTran(cCEP, "-", ""), ".", "")
    
    DO CASE
        CASE cCEPLimpo == "18035000"
            DO CASE
                CASE cTipo == "BAIRRO"
                    cRetorno := "Vila Santa Terezinha"
                CASE cTipo == "CIDADE"
                    cRetorno := "Sorocaba"
                CASE cTipo == "UF"
                    cRetorno := "SP"
                CASE cTipo == "COD_MUN"  // NOVO!
                    cRetorno := "50015"  // Código IBGE de Sorocaba
            ENDCASE
        // ... outros CEPs
    ENDCASE
    
RETURN cRetorno
```

