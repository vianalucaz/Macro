
# pacotes -----------------------------------------------------------------


if(!require(pacman)) install.packages("pacman")
p_load(tidyr, ggplot2, lubridate, sidrar, dplyr)


# Tratamento de dados -----------------------------------------------------

df_bruto <- sidrar::get_sidra(
  api = "/t/6318/n1/all/v/1641/p/201901,201902,201903,201904,201905,201906,201907,201908,201909,201910,201911,201912,202001,202002,202003,202004,202005,202006,202007,202008,202009,202010,202011,202012/c629/all"
)

df <- df_bruto |> 
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



# Visualização ------------------------------------------------------------

ggplot2::ggplot(data = df, aes(data, tx_desocupacao))+
  geom_line(size = 1, colour = "blue")+
  labs(title = "Taxa de desocupação", subtitle = "(2019-2020)", caption = "Fonte: PNADC/IBGE",
       x = NULL, y = "%")+
  theme_bw()+
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 14, colour = "grey40"),
    plot.caption = element_text(face = "italic", size = 8)
  )+
  scale_x_date(date_breaks = "3 months", date_labels = "%Y-%m")
  












