---
title: "Painel de Indicadores Macroeconômicos do Mercosul"
output: 
  flexdashboard::flex_dashboard:
    orientation: columns
    vertical_layout: fill
    theme: spacelab
runtime: shiny
---

```{r setup, include=FALSE}
if(!require(pacman)) install.packages("pacman")
p_load(dplyr, tidyr, ggplot2, shinyWidgets, highcharter, flexdashboard, readr, stringr)

dados <- read_csv("merco_data.csv", show_col_types = FALSE) |> 
  filter(!is.na(pais)) |> 
  mutate(
    valor = round(as.numeric(valor), digits = 2), 
    data = as.Date(data)                          
  ) |> 
  mutate(atualizacao = as.Date("2025-12-19"))




```

## Column {.sidebar}

O presente painel reúne os principais indicadores macroeconômicos dos países que compõem o Mercosul, tanto Estados fundadores quanto associados, permitindo uma análise integrada da conjuntura regional.

Foram selecionadas as seguintes variáveis: juros reais, taxa de desemprego, câmbio, inflação e crescimento do PIB.

```{r}
# Botão selecionar países
shinyWidgets::pickerInput(
  inputId = "pais",
  label = "Selecione os países (até 2):",
  choices = sort(unique(dados$pais)),
  selected = c("Brazil", "Argentina"), 
  multiple = TRUE, 
  options = list(
    "max-options" = 2,
    "live-search" = TRUE,
    "none-selected-text" = "Nada selecionado"
  )
)

# Botão selecionar variável
shinyWidgets::pickerInput(
  inputId = "variavel",
  label = "Selecione a variável:",
  choices = sort(unique(dados$variavel)),
  selected = unique(dados$variavel)[1], 
  multiple = FALSE
)

# Botão selecionar tipo de gráfico
shinyWidgets::pickerInput(
  inputId = "grafico",
  label = "Selecione o estilo:",
  choices = c("Linha" = "line", "Coluna" = "column", "Área" = "area"), 
  selected = "line"
)

```

***

**Última atualização:** `r format(max(dados$atualizacao, na.rm=TRUE), format = "%d/%m/%Y")`

**Fonte:** World Bank

**Elaboração:** [Lucas Viana](https://github.com/vianalucaz)

## Column

### Gráfico 1 {.no-title}

```{r}
highcharter::renderHighchart({
  shiny::req(input$pais[1], input$variavel)
  
  dados |>  
    dplyr::filter(pais == input$pais[1], variavel == input$variavel) |> 
    highcharter::hchart(type = input$grafico, 
                        highcharter::hcaes(x = data, y = valor), 
                        name = input$pais[1]) |> 
    highcharter::hc_navigator(enabled = TRUE) |> 
    highcharter::hc_add_theme(hc_theme_smpl()) |> 
    highcharter::hc_tooltip(shared = TRUE) |> 
    highcharter::hc_title(text = paste0(input$pais[1], " - ", input$variavel))
})

```

### Gráfico 2 {.no-title}

```{r}
highcharter::renderHighchart({
  shiny::req(input$pais[2], input$variavel)

  dados |> 
    dplyr::filter(pais == input$pais[2], variavel == input$variavel) |> 
    highcharter::hchart(type = input$grafico, 
                        highcharter::hcaes(x = data, y = valor), 
                        name = input$pais[2]) |> 
    highcharter::hc_navigator(enabled = TRUE) |> 
    highcharter::hc_add_theme(hc_theme_smpl()) |> 
    highcharter::hc_tooltip(shared = TRUE) |> 
    highcharter::hc_title(text = paste0(input$pais[2], " - ", input$variavel))
})

```
