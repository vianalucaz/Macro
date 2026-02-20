### Conjuntura do Mercado de Crédito no Brasil (2019-2026)
Este repositório contém um relatório técnico da evolução do mercado de crédito brasileiro entre 2019 e 2026, focando na transmissão da política monetária e na resiliência do volume de concessões frente ao ciclo de aperto de juros.

📊 Principais Insights da Análise
1. **Expansão Real do Crédito:**

- Apesar da volatilidade econômica, o volume de concessões apresentou um crescimento real robusto.
- Crescimento: De ~R$ 300 bilhões em 2019 para quase **R$ 700 bilhões** em 2026 (valores deflacionados pelo IPCA).
- Resiliência: O canal de crédito demonstrou baixa sensibilidade à elevação da taxa Selic.

2. **Juros vs. Inadimplência:**
- Com a Taxa Média de Juros atingindo patamares próximos a 32% a.a. em 2026, a inadimplência rompeu a barreira dos 4%, sinalizando uma deterioração na capacidade de pagamento dos tomadores.

3. **Composição PF vs. PJ:**
- Estabilidade: A divisão entre Pessoa Física e Jurídica mantém-se equilibrada (próxima de 50/50).

🛠️ Metodologia:

- Extração de Dados: Conexão direta com a API do Banco Central (SGS) via pacote `GetBCBData`.
- Tratamento de Inflação: Todos os valores foram deflacionados para preços de Janeiro de 2026 utilizando o pacote `deflateBR` (IPCA), porém pode ser realizado através do pacote `sidrar`.
- Ajuste Sazonal: Utilização do algoritmo X13-SEATS-ARIMA (via `ggseas`) para isolar a tendência estrutural do ruído sazonal (ex: picos de consumo de final de ano).
- Visualização: Gráficos em `ggplot2` com aplicação de geom_area para análise de mix e stat_seas do pacote `ggseas` para séries temporais.
