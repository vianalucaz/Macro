# Deflacionando o Salário Mínimo no Brasil

Este repositório é fruto de uma aula lecionada por mim a fim de apresentar um exercício aplicado de **deflação do salário mínimo brasileiro**, algo rotineiro em uma análise de conjuntura, utilizando o **IPCA** como índice de preços. 
O objetivo é explicar por que deflacionar e mostrar, de forma prática e reprodutível, como comparar valores monetários ao longo do tempo em termos reais, 
algo fundamental em análises econômicas.

O trabalho foi desenvolvido em **Quarto (.qmd)** com **R**, combinando coleta de dados, tratamento, deflação e visualização interativa.

---

## 🎯 Objetivo    

- Deflacionar o salário mínimo nominal brasileiro a partir de 2015  
- Comparar o salário **nominal** com o **salário real**  
- Demonstrar duas abordagens de deflação:
  1. **Cálculo manual do fator de deflação**
  2. Uso do pacote **`deflateBR`**
- Utilizar **dezembro de 2025** como data-base (moeda constante)
- Visualização interativa
  
---

## 🗂️ Fontes de Dados

- **Salário Mínimo Nominal**  
  - Fonte: IPEA  
  - Série: `MTE12_SALMIN12`  
  - Acesso via pacote `ipeadatar`

- **Índice de Preços (IPCA)**  
  - Fonte: IBGE / SIDRA  
  - Tabela: 6691  
  - Variável: Índice mensal (base 2012 = 100)

---

