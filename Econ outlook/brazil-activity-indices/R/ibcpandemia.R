
# Pacotes -----------------------------------------------------------------

if(!require(pacman)) install.packages("pacman")
p_load(lubridate, ggplot2, tidyr, dplyr, rbcb)


# Tratamento de dados ------------------------------------------------------


dados_brutos <- rbcb::get_series(
  c(ibc = 24364), #IBC-Br com ajuste sazonal,
  start_date = "2019-01-01",
  end_date = "2020-12-31"
)

dados <- dados_brutos |>
  dplyr::mutate(
    IBC  = ibc,
    data = lubridate::ym(format(date, "%Y-%m")),
    .keep = "none"
  )|>
  tidyr::as_tibble()  


# visualização ------------------------------------------------------------

ggplot2::ggplot(dados, aes(data, IBC))+
  geom_line(size = 1, colour = "blue")+
  labs(title = "Índice de Atividade Econômica do BC", subtitle = "(2019-2020)",
       caption = " Fonte: IBC-Br/BACEN",
       y = "IBC", x = NULL)+
  theme_bw()+
  scale_x_date(date_breaks = "3 months", date_labels = "%Y-%m" )+
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(face = "italic", size = 10, colour = "grey20"),
    plot.caption = element_text(face = "italic", size = 8))
  



