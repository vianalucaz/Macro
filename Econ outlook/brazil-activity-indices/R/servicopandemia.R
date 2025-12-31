

# Pacotes -----------------------------------------------------------------
if(!require(pacman)) install.packages("pacman")
pacman::p_load(tidyr, dplyr, ggplot2, sidrar, lubridate, patchwork)

# Tratamento de dados -----------------------------------------------------

dados_brutos <- sidrar::get_sidra(api = "/t/5906/n1/all/v/all/p/201901,201902,201903,201904,201905,201906,201907,201908,201909,201910,201911,201912/c11046/56725/d/v7167%205,v7168%205,v11623%201,v11624%201,v11625%201,v11626%201")

dados <- dados_brutos |> 
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



# Visualização 2019 -------------------------------------------------------

gg <- ggplot(data = dados, aes(data, valor, colour = variavel))+
  geom_line(size = 1)+
  facet_wrap(facets = ~variavel, scales = "free")+
  labs(title = "Serviços 2019 e 2020", subtitle = "Evolução do Nível de Atividade e Indicadores de Crescimento pré e durante pandemia", x = NULL, y = "Indicador")+
  theme_bw()+
  theme(
    plot.title = element_text(face = "bold", size = 16, color = "black", margin = margin(b = 10)),
    plot.subtitle = element_text(size = 12, color = "grey40", margin = margin(b = 15)),
    legend.position = "none"
  )
  


# Tratamento de dados -----------------------------------------------------

df_bruto <- sidrar::get_sidra(api = "/t/5906/n1/all/v/all/p/202001,202002,202003,202004,202005,202006,202007,202008,202009,202010,202011,202012/c11046/56725/d/v7167%205,v7168%205,v11623%201,v11624%201,v11625%201,v11626%201")


df <- df_bruto |> 
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




# Visualização 2020 -------------------------------------------------------

gg1 <- ggplot(data = df, aes(data, valor, colour = variavel))+
  geom_line(size = 1)+
  facet_wrap(facets = ~variavel, scales = "free")+
  labs(x = NULL, y = "Indicador", caption = "Fonte: IBGE/PMS. Nota: Série atual (2022=100)")+
  theme_bw()+
  theme(
    legend.position = "none",
     plot.caption = element_text(hjust = 1, face = c("italic","bold"), size = 10, color = "black"))
  



gg/gg1


















