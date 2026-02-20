# Análise da Atividade Econômica Brasileira (2019-2020)

Este repositório contém scripts em R para a coleta, tratamento e visualização de indicadores conjunturais da economia brasileira durante o período pré e trans-pandemia (2019-2020). O objetivo é observar o impacto do choque de 2020 nos setores de Indústria, Comércio e Serviços, além do mercado de trabalho. Além disso, os gráficos foram anexado no arquivo `.md` com objetivo de dar um "preview" do resultado do gráfico gerado. Os endereços url utilizados para obter os dados das api foram colocados nos comentários caso queiram alterá-los e reproduzi-los com datas diferentes.

## 📊 Indicadores Analisados

* **PIM-PF:** Pesquisa Industrial Mensal (Produção Física).
* **PMC:** Pesquisa Mensal do Comércio.
* **PMS:** Pesquisa Mensal de Serviços.
* **IBC-Br:** Índice de Atividade Econômica do Banco Central (Proxy do PIB).
* **PNADC:** Taxa de Desocupação (Mercado de Trabalho).

## 🛠️ Pacotes Utilizados

O projeto foi desenvolvido em **R** utilizando a estrutura do **Quarto** (`.qmd`). Os principais pacotes utilizados foram:

* `sidrar`: Interface com a API do SIDRA/IBGE.
* `rbcb`: Acesso aos dados do Sistema Gerenciador de Séries Temporais do Banco Central.
* `tidyverse` (`dplyr`, `tidyr`, `ggplot2`, `lubridate`): Manipulação e visualização de dados.
* `patchwork`: Composição de múltiplos gráficos em um único painel.

## 📈 Visualizações Geradas

O script gera painéis comparativos que permitem observar a queda abrupta da atividade econômica no primeiro semestre de 2020 e a velocidade de recuperação setorial.

