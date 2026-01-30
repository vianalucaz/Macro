---
title: "Deflacionando salário mínimo"
author: "Lucas Viana"
format:
  html:
    theme: cosmo
    toc: true
    toc-depth: 3
    number-sections: true
    code-fold: true
    code-tools: true
    df-print: paged
lang: pt-BR
execute:
  warning: false
  message: false
---

## Por que deflacionar?

A inflação podemos definir como o aumento generalizado dos preços de bens e serviços. Ela é calculada pelos índices de preços, chamados comumente como índices de inflação. Esses índices são calculados medindo a variação média dos preços de uma "cesta" de produtos e serviços ao longo do tempo. Assim no Brasil, os índices mais utilizados são: **Índice** Nacional de Preços ao Consumidor Amplo (IPCA, índice do IBGE e considerado o oficial), Índice Geral de Preços (IGP-M, índice da FGV) e Índice Nacional de Preços ao Consumidor (INPC, índice também do IBGE).

Desta forma, como entendemos que se o preço dos bens e serviços muda ao longo do tempo de que forma podemos compará-los? Para isso deflacionamos, isto é, corrigimos os valores monetários pela inflação a fim de comparar preços ou salários com o objetivo de revelar o poder de compra real, sendo algo essencial e rotineiro em análises econômicas. Neste caso, o salário será deflacionado através do R de duas formas: através do fator e através do pacote "deflateBR", além disso o índice utilizado será o IPCA.

::: callout-note
O **INPC** costuma ser uma escolha metodológica comum, pois reflete o consumo de famílias com renda mais baixa, de 1 a 5 salários mínimos, que é a base do salário mínimo.
:::

### Carregando pacotes

```{r, warning=FALSE, message=FALSE}
if(!require("pacman")) install.packages("pacman")
pacman::p_load("ipeadatar", "sidrar", "dplyr", "tidyr", "ggplot2", "deflateBR", "lubridate", "plotly")

```

### Carregando dados do IPEA e IBGE

A tabela utilizada para obter os dados do IBGE pode ser achada em [`https://sidra.ibge.gov.br/tabela/6691`](#0) e as séries de dados obtidos do IPEA podem ser consultados com `ipeadatar::available_series().`

```{r, warning=FALSE, message=FALSE}

salario <- ipeadatar::ipeadata("MTE12_SALMIN12") |>
  dplyr::filter(date >= as.Date("2015-01-01")) |> 
  dplyr::select(date, "sal_nominal" = value) |> 
  dplyr::as_tibble()

indice_IPCA <- sidrar::get_sidra(
  api = "/t/6691/n1/all/v/2266/p/last%20132/d/v2266%2013") |> 
  dplyr::mutate(
    "date" = lubridate::ym(`Mês (Código)`),
    "indice" = `Valor`,
    .keep = "none")

```

## Tratando os dados e deflacionando através do fator

Nesta etapa, realizamos o *join* das bases de dados e calculamos o **fator de deflação**. Utilizamos Dezembro de 2025 como data-base. O objetivo é normalizar os valores nominais históricos, permitindo uma comparação direta do poder de compra em termos reais, utilizando a moeda de dezembro de 2025 como referência constante.

```{r, warning=FALSE, message=FALSE}
salario_min <- dplyr::left_join(salario, indice_IPCA, by = "date") |> 
  tidyr::drop_na() |> 
  dplyr::mutate(
    fator = (indice[date == "2025-12-01"]/indice),
    sal_real = fator*sal_nominal
  )
```

## Deflacionando com deflateBR

O pacote deflateBR agiliza o processo de deflação, pois não precisaríamos baixar o IPCA pelo SIDRA e também não precisaríamos criar o fator, logo temos:

```{r, warning=FALSE, message=FALSE}
deflate <- deflateBR::deflate(nominal_values = salario_min$sal_nominal, 
                   nominal_dates = as.Date(salario_min$date %m+% months(1)),
                   real_date = format("12/2025"),
                   index = "ipca")


```

## Comparação

```{r, warning=FALSE, message=FALSE}
comparação <- salario_min |> 
  mutate(
    deflatebr = deflate,
    sal_real= sal_real,
    date = date,
    .keep = "none"
  )
```

```{r, echo = FALSE, warning=FALSE, message=FALSE}
head(comparação, 10)
```

## Visualização

```{r, warning=FALSE, message=FALSE}

p <- ggplot2::ggplot(salario_min, aes(x = date)) +
  geom_line(aes(y = sal_nominal, colour = "Nominal"), linewidth = 1) +
  geom_line(aes(y = sal_real, colour = "Real"), linewidth = 1) +
  scale_color_manual(values = c("Nominal" = "blue", "Real" = "red")) +
  labs(
    title = "Evolução do Salário Mínimo",
    subtitle = "Comparativo entre Salário Nominal e Real (Deflacionado)",
    x = "Ano",
    y = "Valor (R$)",
    colour = "Legenda:"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")
# utilizamos o pacote plotly para que o usuário passe o mouse e veja os valores exatos com o gráfico interativo.
plotly::ggplotly(p) 
```
<img width="1344" height="960" alt="evolucao_sal_min" src="https://github.com/user-attachments/assets/453862a8-1849-46bc-bafb-eccd445c7e45" />

