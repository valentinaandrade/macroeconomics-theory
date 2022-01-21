# API BCCh
# Codigo correspondiente a la ultima actualizacion a la fecha,
# actualizado por el BCCh de 27 de Agosto 2021

# setup -------------------------------------------------------------------
#https://si3.bcentral.cl/estadisticas/Principal1/Web_Services/index.htm
library(rjson)
library(dplyr)
library(purrr)
library(readxl)
library(fs)
library(stringr)
library(lubridate)
library(ggplot2)
library(tidyr)
library(rjson)


# PARAMETROS --------------------------------------------------------------

user <- 178956728
psw <- "cxynr4qyLLBw"

periodo_inicial <- 200701

ultima_fecha <- Sys.Date()

message("Actualizado al ", ultima_fecha)

series <- readxl::read_xls(path("data", "series.xls"), sheet = "series") %>%
  janitor::clean_names() %>%
  mutate(rn = row_number())

series %>% glimpse()

# series %>% count(nombre_de_la_serie, nombre_cuadro, codigo) %>% View

series_all <- map_df(.x = series$rn, .f = function(x){

  series_aux <- series %>% filter(rn == x)

  message(series_aux$nombre_de_la_serie, " - ", series_aux$codigo)

  timeseries <- series_aux$codigo

  url_aux <- str_c(
    "https://si3.bcentral.cl/SieteRestWS/SieteRestWS.ashx?user=",
    user,
    "&pass=",
    psw,
    #"&firstdate=2015-01-01&lastdate=2021-01-31&timeseries=", #Obtener fechas especificas
    "&lastdate=",
    ultima_fecha,
    "&timeseries=", #Obtener el historico hasta la fecha indicada.
    timeseries,
    "&function=GetSeries"
  )

  # Obtener datos

  json_data <- rjson::fromJSON(file=url_aux)

  df_data <- json_data$Series$Obs %>%
    map_df( .f = function(x1){
      x1 %>%
        as_tibble()
    }) %>%
    mutate( codigo = timeseries)

  series_aux <- series_aux %>%
    left_join(
      df_data,
      by = c("codigo")
    )

  series_aux

})

series_all %>% glimpse()

# Descarga original
descarga_original <- series_all

# Check StatusCode. Todos deben ser OK (puede ser ND no disponible)
descarga_original %>%
  count(statusCode)

descarga_original %>% filter(statusCode != "OK") %>% glimpse()

series_all <- series_all %>%
  mutate( periodo = as_date(indexDateString, format = "%d-%m-%Y")) %>%
  mutate( valor = as.numeric(value)) %>%
  select( -indexDateString, -value, -statusCode, -rn)

series_all %>%
  glimpse()

# Check Periodos
series_all %>%
  group_by(nombre_cuadro, nombre_de_la_serie) %>%
  summarise(periodo_min = min(periodo),
            periodo_max = max(periodo))

# Comprobar que "IPC General histórico, variación mensual" sea:
# `Índice IPC General`/lag(`Índice IPC General`) - 1
# redondeado a 1 decimal.
series_all %>%
  filter(
    nombre_de_la_serie %in% c("IPC General histórico, variación mensual", "Índice IPC General")
  ) %>%
  filter(periodo >= "2009-12-01") %>%
  select(periodo, nombre_de_la_serie, valor) %>%
  pivot_wider(names_from = "nombre_de_la_serie", values_from = "valor") %>%
  mutate(check = round((`Índice IPC General`/lag(`Índice IPC General`) - 1) * 100, 1) ) %>%
  mutate(check2 = (`Índice IPC General`/lag(`Índice IPC General`) - 1) * 100 ) %>%
  mutate(t = `IPC General histórico, variación mensual` - check) %>%
  count(t)


# Graficos varios
series_all %>%
  mutate(series_id = str_c(nombre_cuadro, "\n", nombre_de_la_serie)) %>%
  ggplot( aes( x = periodo, y = valor) ) +
  geom_line() +
  facet_wrap(series_id~., nrow = 4, scales =  "free") +
  theme(legend.position = "bottom")


# Calcular PIB Variacion mismo periodo anho anterior ----------------------
cod_pib <- "F032.PIB.FLU.R.CLP.EP13.Z.Z.0.T"

dpib <- series_all %>%
  filter(codigo == cod_pib) %>%
  mutate(yyyymm = as.numeric(stringr::str_sub(stringr::str_remove_all(as.character(periodo), "-"), 1,6))) %>%
  # Fecha = fecha + 12 meses. Con esto se obtendra el PIB de hace 12 meses atras
  mutate(yyyymm = yyyymm::ym_add_months(yyyymm, 12)) %>%
  select(capitulo, nombre_cuadro, codigo, nombre_de_la_serie, yyyymm, valor_m1y = valor)

dpib <- series_all %>%
  filter(codigo == cod_pib) %>%
  mutate(yyyymm = as.numeric(stringr::str_sub(stringr::str_remove_all(as.character(periodo), "-"), 1,6))) %>%
  # Con esto se obtiene el PIB de hace 12 meses atras
  left_join(
    dpib,
    by = c("capitulo", "nombre_cuadro", "codigo", "nombre_de_la_serie", "yyyymm")
  ) %>%
  filter(!is.na(valor_m1y)) %>%
  # Variacion mismo periodo año anterior
  mutate(PIB_var = (valor/valor_m1y - 1)*100) %>%
  select(-yyyymm, -valor_m1y, -valor) %>%
  rename(valor = PIB_var) %>%
  mutate(nombre_de_la_serie = "PIB variacion mismo periodo año anterior")

dperiodos_pib <- dpib %>%
  summarise(
    pmin = min(as.numeric(stringr::str_sub(stringr::str_remove_all(as.character(periodo), "-"), 1,6))),
    pmax = max(as.numeric(stringr::str_sub(stringr::str_remove_all(as.character(periodo), "-"), 1,6))),
  ) %>%
  mutate(pmax = yyyymm::ym_add_months(pmax, 2))

message("Serie PIB variacion mismo periodo año anterior, entre: ", dperiodos_pib[1], " y ", dperiodos_pib[2])

# Completar todos los periodos. Trimestral -> Mensual
dpib <- data.frame(per = yyyymm::ym_seq(dperiodos_pib$pmin, dperiodos_pib$pmax)) %>%
  as_tibble() %>%
  left_join(
    dpib %>%
      mutate(per = as.numeric(stringr::str_sub(stringr::str_remove_all(as.character(periodo), "-"), 1,6)))
  ) %>%
  tidyr::fill(everything(), .direction = "down") %>%
  mutate(periodo = yyyymm::ym_to_date(per)) %>%
  select(-per) %>%
  mutate(periodo = as.numeric(stringr::str_sub(stringr::str_remove_all(as.character(periodo), "-"), 1,6))) %>%
  select(periodo, everything())

dpib %>%
  mutate(periodo = yyyymm::ym_to_date(periodo)) %>%
  mutate(series_id = str_c(nombre_cuadro, "\n", nombre_de_la_serie)) %>%
  ggplot( aes( x = periodo, y = valor) ) +
  geom_line() +
  labs(title = "PIB variacion mismo periodo año anterior")

# # Agregar
# series_all <- series_all %>%
#   bind_rows(
#     dpib %>% select(-per)
#   )


# Obtener TCN mensual -----------------------------------------------------
cod_tcn <- "F073.TCO.PRE.Z.D"

dTCN <- series_all %>%
  filter(codigo == cod_tcn) %>%
  filter(!is.na(valor)) %>%
  mutate(per = as.numeric(stringr::str_sub(stringr::str_remove_all(as.character(periodo), "-"), 1,6))) %>%
  group_by(capitulo, nombre_cuadro, codigo, nombre_de_la_serie, per) %>%
  # Mensualizar valores. Promedio mensual
  summarise(valor = mean(valor)) %>%
  ungroup() %>%
  mutate(nombre_de_la_serie = "TCN promedio mensual") %>%
  mutate(per = as_date(str_c(per, "01"), format = "%Y%m%d")) %>%
  rename(periodo =  per) %>%
  mutate(periodo = as.numeric(stringr::str_sub(stringr::str_remove_all(as.character(periodo), "-"), 1,6))) %>%
  select(periodo, everything())

dTCN %>%
  mutate(periodo = yyyymm::ym_to_date(periodo)) %>%
  mutate(series_id = str_c(nombre_cuadro, "\n", nombre_de_la_serie)) %>%
  ggplot( aes( x = periodo, y = valor) ) +
  geom_line() +
  labs(title = "TCN promedio mensual")

# Tasa de Desempleo mensual -----------------------------------------------
# La data ya viene mensualizada desde la API.
cod_desempleo = "F049.DES.TAS.INE9.10.M"

dDesempleo <- series_all %>%
  filter(codigo == cod_desempleo) %>%
  filter(!is.na(valor)) %>%
  mutate(periodo = as.numeric(stringr::str_sub(stringr::str_remove_all(as.character(periodo), "-"), 1,6))) %>%
  select(periodo, everything())

dDesempleo %>% glimpse()

dDesempleo %>%
  mutate(periodo = yyyymm::ym_to_date(periodo)) %>%
  mutate(series_id = str_c(nombre_cuadro, "\n", nombre_de_la_serie)) %>%
  ggplot( aes( x = periodo, y = valor) ) +
  geom_line() +
  labs(title = "Tasa de desempleo (porcentaje)")

# IPC variacion mensual ---------------------------------------------------
# La data ya viene mensualizada desde la API.
series_all %>%
  filter(
    nombre_de_la_serie %in% c("IPC General histórico, variación mensual")
  ) %>%
  filter(periodo >= "2009-12-01") %>% count(codigo)

cod_IPC = "F074.IPC.VAR.Z.Z.C.M"

dIPC <- series_all %>%
  filter(codigo == cod_IPC) %>%
  filter(!is.na(valor)) %>%
  mutate(periodo = as.numeric(stringr::str_sub(stringr::str_remove_all(as.character(periodo), "-"), 1,6))) %>%
  select(periodo, everything())

dIPC %>% glimpse()

# Mercado Laboral: FT, Ocupados, Desocupados ------------------------------

# Fuerza de Trabajo (FT) Total
cod_FT <- "F049.FTR.PMT.INE9.01.M"

dFT <- series_all %>%
  filter(codigo == cod_FT) %>%
  filter(!is.na(valor)) %>%
  mutate(periodo = as.numeric(stringr::str_sub(stringr::str_remove_all(as.character(periodo), "-"), 1,6))) %>%
  select(periodo, everything())

dFT %>% glimpse()

# Ocupados
cod_Ocupados <- "F049.OCU.PMT.INE9.01.M"

dOcupados <- series_all %>%
  filter(codigo == cod_Ocupados) %>%
  filter(!is.na(valor)) %>%
  mutate(periodo = as.numeric(stringr::str_sub(stringr::str_remove_all(as.character(periodo), "-"), 1,6))) %>%
  select(periodo, everything())

dOcupados %>% glimpse()

# Desocupados
cod_Desocupados <- "F049.DES.PMT.INE9.01.M"

dDesocupados <- series_all %>%
  filter(codigo == cod_Desocupados) %>%
  filter(!is.na(valor)) %>%
  mutate(periodo = as.numeric(stringr::str_sub(stringr::str_remove_all(as.character(periodo), "-"), 1,6))) %>%
  select(periodo, everything())

dDesocupados %>% glimpse()

# Unir data ----------------------------------------------------------------
# Comenzar desde 'periodo_inicial' (2007-01)
data_all <- dDesempleo %>%
  bind_rows(
    dpib,
    dTCN,
    dIPC,
    dFT,
    dOcupados,
    dDesocupados
  ) %>%
  select(periodo, nombre_de_la_serie, valor) %>%
  pivot_wider(names_from = "nombre_de_la_serie", values_from = "valor") %>%
  arrange(periodo) %>%
  filter(periodo >= periodo_inicial)

data_all %>% glimpse()


# Agregar info historica Tasa desempleo ----------------------------------

# Completar campos faltantes: tasa_desempleo (y sus componentes) con info historica
# obtenida desde el INE

desempleo_antes_2010 <- readxl::read_xls("data/total-pais---poblacion-de-15-anos-o-mas-segun-situacion-en-la-fuerza-de-trabajo-1986-2009.xls",
                                         sheet = "SFDT AMBOS SEXOS (2)",
                                         range = "D9:N298")

desempleo_antes_2010 <- desempleo_antes_2010 %>%
  select(periodo = Periodo,
         tasa_desempleo_hist = `Tasa Desocupación`,
         fuerza_trabajo_hist = `Fuerza de Trabajo`,
         ocupados_hist = Ocupados,
         desocupados_hist = `Desocupados Total`) %>%
  mutate( periodo = year(periodo)*100 + month(periodo) )

data_all %>% glimpse()
desempleo_antes_2010 %>% tail() %>% glimpse()

# Agregar info historica
data_all <- data_all %>%
  left_join(desempleo_antes_2010, by = "periodo") %>%
  mutate(
    `Tasa  de  desempleo  (porcentaje)` = ifelse(is.na(`Tasa  de  desempleo  (porcentaje)`), tasa_desempleo_hist, `Tasa  de  desempleo  (porcentaje)`),
    `Fuerza de trabajo  Total` = ifelse(is.na(`Fuerza de trabajo  Total`), fuerza_trabajo_hist, `Fuerza de trabajo  Total`),
    Ocupados       = ifelse(is.na(Ocupados), ocupados_hist, Ocupados),
    Desocupados    = ifelse(is.na(Desocupados), desocupados_hist, Desocupados)
  ) %>%
  select(-contains("_hist"))

# Imputar Tasa desempleo (y derivados) en Febrero 2010. Dato faltante
data_all <- data_all %>%
  filter(periodo <= 202001) %>%
  mutate(
    Ocupados = zoo::na.approx(Ocupados),
    Desocupados = zoo::na.approx(Desocupados),
  ) %>%
  mutate(
    `Fuerza de trabajo  Total` = Ocupados + Desocupados,
    `Tasa  de  desempleo  (porcentaje)` = Desocupados / `Fuerza de trabajo  Total` * 100
  ) %>%
  bind_rows(
    data_all %>%
      filter(periodo > 202001)
  ) %>%
  arrange(periodo)


# Export ------------------------------------------------------------------
saveRDS(data_all, path("data", "macro.rds"))
# writexl::write_xlsx(data_all, path("data", "data_all.xlsx"))
# data.table::fwrite(data_all, path("data", "data_all.txt"), sep=";", dec=".")

# pivot_wider todas las series --------------------------------------------

data_all %>% glimpse()

data_all %>%
  tail() %>%
  select(1, 2, 6:8) %>%
  mutate(t = Ocupados + Desocupados)

data_all %>%
  mutate(periodo = as_date(paste0(periodo, "01"))) %>%
  pivot_longer(names_to = "variable", values_to = "values", -periodo) %>%
  ggplot(aes( x = periodo, y = values )) +
  geom_line() +
  facet_wrap(~variable, scales = "free_y")
