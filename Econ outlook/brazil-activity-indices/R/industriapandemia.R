
# Pacotes -----------------------------------------------------------------

if(!require(pacman)) install.packages("pacman")
p_load(lubridate, tidyr, dplyr, ggplot2, patchwork, sidrar)

# Tratamento de dados -----------------------------------------------------

dados_brutos <- sidrar::get_sidra(api = "/t/8888/n1/all/v/all/p/201901,201902,201903,201904,201905,201906,201907,201908,201909,201910,201911,201912/c544/129314/d/v11601%201,v11602%201,v11603%201,v11604%201,v12606%205,v12607%205")


dados <- dados_brutos |> 
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



# Visualização 2019 -------------------------------------------------------

gg <- ggplot2::ggplot(data = dados, aes(x = data, y = valor, colour = variavel))+
  geom_line(size = 1)+
  facet_wrap(facets = ~variavel, scales = "free")+ 
  labs(title = "Indústria Geral 2019 e 2020", subtitle = "Evolução do Nível de Atividade e Indicadores de Crescimento pré e durante pandemia", x = NULL, y = "Indicador")+
  theme_bw()+
  theme(
    plot.title = element_text(face = "bold", size = 16, color = "black", margin = margin(b = 10)),
    plot.subtitle = element_text(size = 12, color = "grey40", margin = margin(b = 15)),
    legend.position = "none"
  )




# Tratamento de dados -----------------------------------------------------

df_bruto <- sidrar::get_sidra(api = "/t/8888/n1/all/v/all/p/202001,202002,202003,202004,202005,202006,202007,202008,202009,202010,202011,202012/c544/129314/d/v11601%201,v11602%201,v11603%201,v11604%201,v12606%205,v12607%205")


df <- df_bruto |> 
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


# Visualização 2020 ------------------------------------------------------

gg1 <- ggplot2::ggplot(data = df, aes(x = data, y = valor, colour = variavel))+
  geom_line(size = 1)+
  facet_wrap(facets = ~variavel, scales = "free")+ 
  labs(caption = "Fonte: IBGE/PIM-PF. Nota: Série atual (2022=100)", x = NULL, y = "Indicador")+
  theme_bw()+
  theme(
    legend.position = "none",
    plot.caption = element_text(hjust = 1, face = c("italic","bold"), size = 10, color = "black"))

gg/gg1

















