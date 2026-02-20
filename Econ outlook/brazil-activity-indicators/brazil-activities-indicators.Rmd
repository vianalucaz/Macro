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

## Introdução

Observaremos os indicadores agregados de atividade econômica do Brasil entre os anos de 2019 e 2020.

### Instalação dos pacotes

```{r, message = FALSE, warning = FALSE}
if(!require("pacman")) install.packages("pacman")
pacman::p_load(lubridate, ggplot2, tidyr, dplyr, rbcb, sidrar, patchwork)
```

## Pesquisa Mensal do Comércio - PMC

### Importação de dados

```{r, message = FALSE, warning = FALSE}

dadosPMC20 <- sidrar::get_sidra(
  api = "/t/8880/n1/all/v/all/p/201901,201902,201903,201904,201905,201906,201907,201908,201909,201910,201911,201912/c11046/56733/d/v7169%205,v7170%205,v11708%201,v11709%201,v11710%201,v11711%201"
)

dadosPMC19 <- sidrar::get_sidra(
  api = "/t/8880/n1/all/v/all/p/201901,201902,201903,201904,201905,201906,201907,201908,201909,201910,201911,201912/c11046/56733/d/v7169%205,v7170%205,v11708%201,v11709%201,v11710%201,v11711%201"
)

# endereço da api pode ser obtido em https://sidra.ibge.gov.br/tabela/8880
```

### Tratamento de dados

```{r, message = FALSE, warning = FALSE}

#Para o ano de 2020
dadosPMC20 <- dadosPMC20 |> 
  dplyr::mutate(
    data = lubridate::ym(`Mês (Código)`),
    variavel = dplyr::recode(
      .x = Variável,
      "PMC - Número-índice (2022=100)" = "Nº índice",
      "PMC - Número-índice com ajuste sazonal (2022=100)" = "Nº índice s.a.",
      "PMC - Variação mês/mês imediatamente anterior, com ajuste sazonal (M/M-1)" = "Var. % margem",
      "PMC - Variação mês/mesmo mês do ano anterior (M/M-12)" = "Var. % interanual",
      "PMC - Variação acumulada no ano (em relação ao mesmo período do ano anterior)" = "Var. % acum. no ano",
      "PMC - Variação acumulada em 12 meses (em relação ao período anterior de 12 meses)" = "Var. % anual"
    ),
    valor = Valor,
    .keep = "none"
  ) |>
  tidyr::drop_na() |>
  dplyr::as_tibble()

#Para o ano de 2019
dadosPMC19 <- dadosPMC19 |>
  dplyr::mutate(
    data = lubridate::ym(`Mês (Código)`),
    variavel = dplyr::recode(
      .x = Variável,
      "PMC - Número-índice (2022=100)" = "Nº índice",
      "PMC - Número-índice com ajuste sazonal (2022=100)" = "Nº índice s.a.",
      "PMC - Variação mês/mês imediatamente anterior, com ajuste sazonal (M/M-1)" = "Var. % margem",
      "PMC - Variação mês/mesmo mês do ano anterior (M/M-12)" = "Var. % interanual",
      "PMC - Variação acumulada no ano (em relação ao mesmo período do ano anterior)" = "Var. % acum. no ano",
      "PMC - Variação acumulada em 12 meses (em relação ao período anterior de 12 meses)" = "Var. % anual"
    ),
    valor = Valor,
    .keep = "none"
  ) |>
  tidyr::drop_na() |>
  dplyr::as_tibble()

```

### Visualização

```{r, message = FALSE, warning = FALSE}

# Para o ano de 2019 temos:
pmc1 <- ggplot2::ggplot(data = dadosPMC19, aes(data, valor, colour = variavel))+
  ggplot2::geom_line(size = 1)+
  ggplot2::facet_wrap(facets = ~variavel, scales = "free")+
  ggplot2::labs(title = "Comércio Varejista 2019 e 2020", subtitle = "Evolução do Nível de Atividade e Indicadores de Crescimento pré e durante pandemia", x = NULL, y = "Indicador")+
 ggplot2::theme_bw()+
  ggplot2::theme(
    plot.title = element_text(face = "bold", size = 16, margin = margin(b = 10)),
    plot.subtitle = element_text(size = 12, color = "grey30", margin = margin(b = 15)),
    legend.position = "none")


# Para o ano de 2020 temos:
pmc2 <- ggplot2::ggplot(data = dadosPMC20, aes(data, valor, colour = variavel,))+
  ggplot2::geom_line(size = 1)+
  ggplot2::facet_wrap(facets = ~variavel, scales = "free")+
  ggplot2::labs(x = NULL, y = "Indicador", caption = "Fonte: IBGE/PMC. Nota: Série atual (2022=100)")+
  ggplot2::theme_bw()+
  ggplot2::theme(
    legend.position = "none",
    plot.caption = element_text(hjust = 1, face = c("italic","bold"), size = 10, color = "black"))


pmc1/pmc2 #função do pacote patchwork








```

## Pesquisa Industrial Mensal - PIM

### Importando os dados

```{r, message=FALSE, warning=FALSE}

dadosPIM19 <- sidrar::get_sidra(
  api = "/t/8888/n1/all/v/all/p/201901,201902,201903,201904,201905,201906,201907,201908,201909,201910,201911,201912/c544/129314/d/v11601%201,v11602%201,v11603%201,v11604%201,v12606%205,v12607%205"
)

dadosPIM20 <- sidrar::get_sidra(
  api =  "/t/8888/n1/all/v/all/p/202001,202002,202003,202004,202005,202006,202007,202008,202009,202010,202011,202012/c544/129314/d/v11601%201,v11602%201,v11603%201,v11604%201,v12606%205,v12607%205"
)

# endereço da api pode ser obtido em https://sidra.ibge.gov.br/tabela/8888
```

### Tratando os dados

```{r, message = FALSE, warning = FALSE}

dadosPIM19 <- dadosPIM19 |> 
  dplyr::mutate(
    data = lubridate::ym(`Mês (Código)`),
    variavel = dplyr::recode(
      .x = Variável,
      "PIMPF - Número-índice (2022=100)" = "Nº índice",
      "PIMPF - Número-índice com ajuste sazonal (2022=100)" = "Nº índice s.a.",
      "PIMPF - Variação mês/mês imediatamente anterior, com ajuste sazonal (M/M-1)" = "Var. % margem",
      "PIMPF - Variação mês/mesmo mês do ano anterior (M/M-12)"  = "Var. % interanual",
      "PIMPF - Variação acumulada no ano (em relação ao mesmo período do ano anterior)"  = "Var. % acum. no ano",
      "PIMPF - Variação acumulada em 12 meses (em relação ao período anterior de 12 meses)" = "Var. % anual"
    ),
    valor = Valor,
    .keep = "none"
  ) |>
  tidyr::drop_na() |>
  dplyr::as_tibble()

dadosPIM20 <- dadosPIM20 |> 
  dplyr::mutate(
    data = lubridate::ym(`Mês (Código)`), 
    variavel = dplyr::recode(
      .x = Variável,
      "PIMPF - Número-índice (2022=100)" = "Nº índice",
      "PIMPF - Número-índice com ajuste sazonal (2022=100)" = "Nº índice s.a.",
      "PIMPF - Variação mês/mês imediatamente anterior, com ajuste sazonal (M/M-1)" = "Var. % margem",
      "PIMPF - Variação mês/mesmo mês do ano anterior (M/M-12)"  = "Var. % interanual",
      "PIMPF - Variação acumulada no ano (em relação ao mesmo período do ano anterior)"  = "Var. % acum. no ano",
      "PIMPF - Variação acumulada em 12 meses (em relação ao período anterior de 12 meses)" = "Var. % anual"
    ),
    valor = Valor,
    .keep = "none"
  ) |>
  tidyr::drop_na() |>
  dplyr::as_tibble()


```

### Visualização

```{r, message=FALSE, warning=FALSE}

pim1 <- ggplot2::ggplot(data = dadosPIM19, aes(x = data, y = valor, colour = variavel))+
  geom_line(size = 1)+
  facet_wrap(facets = ~variavel, scales = "free")+ 
  labs(title = "Indústria Geral 2019 e 2020", subtitle = "Evolução do Nível de Atividade e Indicadores de Crescimento pré e durante pandemia", x = NULL, y = "Indicador")+
  theme_bw()+
  theme(
    plot.title = element_text(face = "bold", size = 16, color = "black", margin = margin(b = 10)),
    plot.subtitle = element_text(size = 12, color = "grey40", margin = margin(b = 15)),
    legend.position = "none"
  )

pim2 <- ggplot2::ggplot(data = dadosPIM20, aes(x = data, y = valor, colour = variavel))+
  geom_line(size = 1)+
  facet_wrap(facets = ~variavel, scales = "free")+ 
  labs(caption = "Fonte: IBGE/PIM-PF. Nota: Série atual (2022=100)", x = NULL, y = "Indicador")+
  theme_bw()+
  theme(
    legend.position = "none",
    plot.caption = element_text(hjust = 1, face = c("italic","bold"), size = 10, color = "black"))

pim1/pim2

```

## Pesquisa Mensal de Serviços - PMS

### Importação de dados

```{r, message=FALSE, warning=FALSE}

dadosPMS19 <- sidrar::get_sidra(api = "/t/5906/n1/all/v/all/p/201901,201902,201903,201904,201905,201906,201907,201908,201909,201910,201911,201912/c11046/56725/d/v7167%205,v7168%205,v11623%201,v11624%201,v11625%201,v11626%201")

dadosPMS20 <- sidrar::get_sidra(api = "/t/5906/n1/all/v/all/p/202001,202002,202003,202004,202005,202006,202007,202008,202009,202010,202011,202012/c11046/56725/d/v7167%205,v7168%205,v11623%201,v11624%201,v11625%201,v11626%201")
```

### Tratando os dados

```{r, message=FALSE, warning=FALSE}
#Para o ano de 2019, temos:
dadosPMS19 <- dadosPMS19 |> 
  dplyr::mutate(
    valor = Valor,
    data = lubridate::ym(`Mês (Código)`),
    variavel = dplyr::recode(
      .x = Variável,
      "PMS - Número-índice (2022=100)" = "Nº índice",
      "PMS - Número-índice com ajuste sazonal (2022=100)" = "Nº índice s.a.",
      "PMS - Variação mês/mês imediatamente anterior, com ajuste sazonal (M/M-1)" = "Var. % na margem",
      "PMS - Variação mês/mesmo mês do ano anterior (M/M-12)" = "Var. % interanual",
      "PMS - Variação acumulada no ano (em relação ao mesmo período do ano anterior)" = "Var. % acumulada no ano",
      "PMS - Variação acumulada em 12 meses (em relação ao período anterior de 12 meses)" = "Var. % anual"
    ),
    .keep = "none",
  ) |> 
  tidyr::drop_na() |> 
  tidyr::as_tibble()


#Para o ano de , temos:
dadosPMS20 <- dadosPMS20 |> 
  dplyr::mutate(
    valor = Valor,
    data = lubridate::ym(`Mês (Código)`),
    variavel = dplyr::recode(
      .x = Variável,
      "PMS - Número-índice (2022=100)" = "Nº índice",
      "PMS - Número-índice com ajuste sazonal (2022=100)" = "Nº índice s.a.",
      "PMS - Variação mês/mês imediatamente anterior, com ajuste sazonal (M/M-1)" = "Var. % na margem",
      "PMS - Variação mês/mesmo mês do ano anterior (M/M-12)" = "Var. % interanual",
      "PMS - Variação acumulada no ano (em relação ao mesmo período do ano anterior)" = "Var. % acumulada no ano",
      "PMS - Variação acumulada em 12 meses (em relação ao período anterior de 12 meses)" = "Var. % anual"
    ),
    .keep = "none",
  ) |> 
  tidyr::drop_na() |> 
  tidyr::as_tibble()

```

## Visualização

```{r, message=FALSE, warning=FALSE}

pms1 <- ggplot(data = dadosPMS19, aes(data, valor, colour = variavel))+
  geom_line(size = 1)+
  facet_wrap(facets = ~variavel, scales = "free")+
  labs(title = "Serviços 2019 e 2020", subtitle = "Evolução do Nível de Atividade e Indicadores de Crescimento pré e durante pandemia", x = NULL, y = "Indicador")+
  theme_bw()+
  theme(
    plot.title = element_text(face = "bold", size = 16, color = "black", margin = margin(b = 10)),
    plot.subtitle = element_text(size = 12, color = "grey40", margin = margin(b = 15)),
    legend.position = "none"
  )
  
  

pms2 <- ggplot(data = dadosPMS20, aes(data, valor, colour = variavel))+
  geom_line(size = 1)+
  facet_wrap(facets = ~variavel, scales = "free")+
  labs(x = NULL, y = "Indicador", caption = "Fonte: IBGE/PMS. Nota: Série atual (2022=100)")+
  theme_bw()+
  theme(
    legend.position = "none",
     plot.caption = element_text(hjust = 1, face = c("italic","bold"), size = 10, color = "black"))

pms1/pms2

```

## Índice de Atividade Econômica do Banco Central – Brasil (IBC-Br)

### Importando os dados

```{r, message=FALSE, warning=FALSE}

dadosibc <- rbcb::get_series(
  c(ibc = 24364), #IBC-Br com ajuste sazonal,
  start_date = "2019-01-01",
  end_date = "2020-12-31"
)

```

### Tratando os dados

```{r, message=FALSE, warning=FALSE}

dadosibc <- dadosibc |>
  dplyr::mutate(
    IBC  = ibc,
    data = lubridate::ym(format(date, "%Y-%m")),
    .keep = "none"
  )|>
  tidyr::as_tibble()  


```

### Visualização

```{r, message=FALSE, warning=FALSE}

ggplot2::ggplot(dadosibc, aes(data, IBC))+
  geom_line(size = 1, colour = "royalblue")+
  labs(title = "Índice de Atividade Econômica do BC", subtitle = "(2019-2020)",
       caption = " Fonte: IBC-Br/BACEN",
       y = "IBC", x = NULL)+
  theme_bw()+
  scale_x_date(date_breaks = "3 months", date_labels = "%Y-%m" )+
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(face = "italic", size = 10, colour = "grey20"),
    plot.caption = element_text(face = "italic", size = 8))

```

## Taxa de Desocupação

### Importação de dados

```{r, message=FALSE, warning=FALSE}

dados_des <- sidrar::get_sidra(
  api = "/t/6318/n1/all/v/1641/p/201901,201902,201903,201904,201905,201906,201907,201908,201909,201910,201911,201912,202001,202002,202003,202004,202005,202006,202007,202008,202009,202010,202011,202012/c629/all"
)

```

### Tratamento de dados

```{r, message=FALSE, warning=FALSE}

dados_des <- dados_des |> 
  dplyr::mutate(
    data = lubridate::ym(`Trimestre Móvel (Código)`),
    condicao = `Condição em relação à força de trabalho e condição de ocupação`,
    valor = Valor,
    .keep = "none",
  ) |>
  tidyr::pivot_wider(
    id_cols = data,
    names_from = condicao,
    values_from = valor,
  ) |> 
  dplyr::mutate(
    tx_desocupacao = `Força de trabalho - desocupada` / `Força de trabalho` * 100
  )

```

### Visualização

```{r, warning=FALSE, message=FALSE}

ggplot2::ggplot(dados_des, aes(data, tx_desocupacao))+
  geom_line(size = 1, colour = "royalblue")+
  labs(title = "Taxa de desocupação", subtitle = "(2019-2020)", caption = "Fonte: PNADC/IBGE",
       x = NULL, y = "%")+
  theme_bw()+
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 14, colour = "grey40"),
    plot.caption = element_text(face = "italic", size = 8)
  )+
  scale_x_date(date_breaks = "3 months", date_labels = "%Y-%m")

```
