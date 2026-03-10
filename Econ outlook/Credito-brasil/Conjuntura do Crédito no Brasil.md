---
title: "Conjuntura do Crédito no Brasil"
author: "Lucas Viana"
format: 
  html:
    theme: "cosmo"
    toc: true
    toc-depth: 3
lang: pt-BR
execute: 
  warning: false
  message: false
editor: visual
---

# Conjuntura do Crédito no Brasil

------------------------------------------------------------------------

## 1. Introdução

Este projeto analisa a dinâmica recente do mercado de crédito brasileiro em termos reais, com foco na transmissão da política monetária via canal de crédito. O período analisado compreende **janeiro de 2019 a janeiro de 2026**, cobrindo o pré-pandemia, o choque de 2020, a recuperação e o atual ciclo de aperto monetário.

As dimensões analisadas são:

-   Concessões totais deflacionadas e dessazonalizadas
-   Inadimplência da carteira total
-   Taxa média de juros das operações de crédito
-   Composição PF vs. PJ nas concessões

> Os dados são provenientes do Sistema Gerenciador de Séries Temporais (SGS) do Banco Central do Brasil, acessados via API pelo pacote `GetBCBData`.

------------------------------------------------------------------------

## 2. Metodologia

### 2.1 Fontes e séries utilizadas

| Código SGS | Descrição                                    | Unidade     |
|------------|----------------------------------------------|-------------|
| 20631      | Concessões de crédito — Total                | R\$ milhões |
| 20632      | Concessões de crédito — Pessoas jurídicas    | R\$ milhões |
| 20633      | Concessões de crédito — Pessoas físicas      | R\$ milhões |
| 20714      | Taxa média de juros — Total                  | \% a.a.     |
| 21082      | Inadimplência da carteira de crédito — Total | \%          |

### 2.2 Tratamento das séries

**Deflação:** Os valores nominais de concessão de crédito foram deflacionados pelo IPCA, a preços de janeiro/2026, utilizando o pacote `deflateBR`. Isso permite comparações reais ao longo do tempo, eliminando o efeito da inflação sobre os volumes.

**Dessazonalização:** O método X-13ARIMA-SEATS foi aplicado via `ggseas::stat_seas()`. A remoção do componente sazonal permite isolar a tendência subjacente da série.

### 2.3 Instalação e carregamento de pacotes

```r
if(!require("pacman")) install.packages("pacman")
pacman::p_load(tidyr, dplyr, ggplot2, lubridate, deflateBR, GetBCBData, ggseas)

# O ggseas não está no CRAN. Instale via:
# remotes::install_github("ellisp/ggseas/pkg")
```

### 2.4 Importação dos dados

``` r
df <- GetBCBData::gbcbd_get_series(
  id          = sgts,
  first.date  = "2019-01-01",
  use.memoise = FALSE
) |>
  dplyr::select(
    data   = ref.date,
    valor  = value,
    series = series.name
  ) |>
  tibble::as_tibble()
```

------------------------------------------------------------------------

## 3. Análise

### 3.1 Concessões de Crédito — Total

``` r
df |>
  dplyr::filter(series == "Concessões de crédito - Total") |>
  dplyr::mutate(
    valor_real = deflateBR::deflate(
      nominal_values = valor,
      nominal_dates  = data,
      real_date      = "01/2026",
      index          = "ipca"
    )
  ) |>
  ggplot2::ggplot(aes(data, valor / 1000)) +      
  ggplot2::geom_line(aes(color = "Sazonalizado"), linewidth = 1) +
  ggseas::stat_seas(
    aes(color = "Dessazonalizado"),
    frequency = 12,
    start     = c(2019, 01),
    linewidth = 1
  ) +
  ggplot2::scale_color_manual(
    values = c("Sazonalizado" = "darkred", "Dessazonalizado" = "royalblue")
  ) +
  ggplot2::labs(
    title    = "Concessões de crédito — Total",
    subtitle = "Valores deflacionados pelo IPCA (jan/2026) e dessazonalizados pelo X-13ARIMA-SEATS",
    y        = "R$ bilhões (preços jan/2026)",
    x        = NULL,
    color    = NULL,
    caption  = "Fonte: Banco Central do Brasil (SGS)"
  ) +
  ggplot2::theme_bw() +
  ggplot2::theme(legend.position = "bottom")
```

![concessaocredito](https://github.com/user-attachments/assets/fca5ec0e-6d9c-4ad3-845f-9638d8356a0f)

**Leitura econômica:** O volume real de concessões praticamente dobrou entre 2019 e 2026, passando de \~R\$ 300 bi para \~R\$ 700 bi. Esse crescimento é expressivo por ocorrer *simultaneamente* ao ciclo de aperto monetário mais intenso desde o Plano Real. Uma hipótese estrutural relevante é a expansão do crédito direcionado — consignado, habitacional e BNDES —, que é menos sensível à Selic e pode estar atenuando o canal de crédito da política monetária.

------------------------------------------------------------------------

### 3.2 Participação PF e PJ nas Concessões

``` r
df |>
  dplyr::filter(series %in% c(
    "Concessões de crédito - Total",
    "Concessões de crédito - PJ",
    "Concessões de crédito - PF"
  )) |>
  tidyr::pivot_wider(
    id_cols    = "data",
    names_from = "series",
    values_from = "valor"
  ) |>
  dplyr::transmute(
    data        = data,
    `Pessoa Física`   = `Concessões de crédito - PF` / `Concessões de crédito - Total` * 100,
    `Pessoa Jurídica` = `Concessões de crédito - PJ` / `Concessões de crédito - Total` * 100
  ) |>
  tidyr::pivot_longer(cols = -data, names_to = "series", values_to = "valor") |>
  ggplot2::ggplot(aes(data, valor, fill = series)) +
  ggplot2::geom_area() +
  ggplot2::scale_fill_manual(values = c("Pessoa Física" = "#FA8072", "Pessoa Jurídica" = "#20B2AA")) +
  ggplot2::labs(
    title   = "Participação na concessão de crédito",
    y       = "%",
    x       = NULL,
    fill    = NULL,
    caption = "Fonte: Banco Central do Brasil (SGS)"
  ) +
  ggplot2::theme_bw() +
  ggplot2::theme(legend.position = "bottom")
```
![participacaocredito](https://github.com/user-attachments/assets/04874430-9103-4593-95fe-ac78d39d5ebd)

**Leitura econômica:** A composição PF/PJ manteve-se notavelmente estável ao longo de 7 anos, oscilando em torno de 45-55%. O pico de participação de PJ em 2020 (\~58%) é consistente com a operacionalização de linhas emergenciais anticíclicas (PRONAMPE, FGI). A leve queda recente da participação de PJ pode refletir maior seletividade das instituições financeiras dado o cenário de inadimplência em ascensão.

------------------------------------------------------------------------

### 3.3 Taxa Média de Juros

``` r
df |>
  dplyr::filter(series == "Taxa média de juros") |>
  ggplot2::ggplot(aes(data, valor)) +
  ggplot2::geom_line(linewidth = 1, colour = "royalblue") +
  ggplot2::annotate("rect",
    xmin = as.Date("2020-02-01"), xmax = as.Date("2021-10-01"),
    ymin = -Inf, ymax = Inf,
    alpha = 0.08, fill = "steelblue"
  ) +
  ggplot2::annotate("text",
    x = as.Date("2020-10-01"), y = 32,
    label = "Ciclo de cortes\npandêmico", size = 3, color = "steelblue"
  ) +
  ggplot2::labs(
    title   = "Taxa média de juros das operações de crédito",
    y       = "% a.a.",
    x       = NULL,
    caption = "Fonte: Banco Central do Brasil (SGS)"
  ) +
  ggplot2::theme_bw()
```
![taxamedia](https://github.com/user-attachments/assets/a7f896df-9ba1-422a-a8b0-93e3faa8339b)

**Leitura econômica:** Dois ciclos distintos são visíveis. O primeiro, de queda acentuada até o piso histórico de \~19% a.a. em meados de 2020, reflete a política monetária expansionista adotada em resposta à pandemia. O segundo, de alta até \~32% a.a. em 2025-2026, documenta o ciclo de aperto iniciado em 2021 para reancoragem das expectativas de inflação. O nível atual supera o pico de 2023 (\~31,5%), o que, combinado ao crescimento contínuo das concessões, sugere que a demanda por crédito permanece resiliente a despeito do custo elevado — possivelmente por necessidade de refinanciamento de dívidas.

------------------------------------------------------------------------

### 3.4 Inadimplência da Carteira de Crédito

``` r
df |>
  dplyr::filter(series == "Inadimplência") |>
  ggplot2::ggplot(aes(data, valor)) +
  ggplot2::geom_line(linewidth = 1, colour = "royalblue") +
  ggplot2::geom_hline(yintercept = 3.0, linetype = "dashed", color = "gray50", linewidth = 0.7) +
  ggplot2::annotate("text",
    x = as.Date("2019-06-01"), y = 3.1,
    label = "Nível pré-pandemia (~3,0%)", size = 3, color = "gray40"
  ) +
  ggplot2::labs(
    title   = "Inadimplência da carteira de crédito — Total",
    y       = "%",
    x       = NULL,
    caption = "Fonte: Banco Central do Brasil (SGS)"
  ) +
  ggplot2::theme_bw()
```
![inadimplencia](https://github.com/user-attachments/assets/5f782ba3-3cf1-436e-b2cd-bff13d97cbf6)

**Leitura econômica:** Este é o gráfico de maior conteúdo informacional da análise. A queda abrupta para \~2,1% em 2020-2021 não deve ser lida como melhora da qualidade do crédito — ela é, em grande medida, um artefato das medidas de suporte: repactuações compulsórias, moratórias regulatórias e transferências diretas (Auxílio Emergencial). O risco latente foi acumulado, não eliminado. A trajetória de alta que se inicia em 2021, acelerando em 2022-2023 e retomando impulso em 2025-2026, é a materialização *defasada* desse risco, amplificada pelo aperto monetário. O nível atual (\~4,1%) supera o pico pós-pandemia de \~3,55% registrado em 2023, e já está 37 bps acima do nível pré-pandemia.

------------------------------------------------------------------------

## 4. Conclusão

A análise conjunta das quatro dimensões revela uma tensão estrutural no mercado de crédito brasileiro:

**Expansão real do crédito resistente ao aperto monetário.** O volume real de concessões dobrou entre 2019 e 2026, mesmo com a taxa média de juros escalando de 19% para 32% a.a. Isso é evidência de que o canal de crédito opera com eficácia reduzida — parcialmente explicado pelo peso do crédito direcionado na composição total da carteira.

**Piora da qualidade da carteira.** A inadimplência atingiu o maior nível da série analisada em 2026, superando inclusive os picos observados no ciclo anterior. A combinação de juros altos com expansão do estoque de crédito cria condições propícias para deterioração adicional.

**Possível mudança estrutural.** A desconexão entre política monetária e volume de crédito, se persistente, tem implicações para a calibração da Selic como instrumento de controle da demanda agregada. O BCB tem monitorado esse movimento, como evidenciado pela atenção crescente ao risco sistêmico do sistema financeiro — materializada na intervenção em instituições com modelos de negócio de alto risco de crédito.¹

------------------------------------------------------------------------


*Elaborado por Lucas Viana \| Dados: SGS/BCB via GetBCBData \| Deflator: IPCA via deflateBR*
