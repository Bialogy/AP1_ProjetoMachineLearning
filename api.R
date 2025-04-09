# Carregar os modelos
modelo_lm <- readRDS("modelo_regressao_linear.rds")
modelo_log <- readRDS("modelo_regressao_logistica.rds")

#* @apiTitle API para Predição e Classificação da Qualidade da Água

#* Regressão Linear: Predição da Condutividade com base nos Sólidos
#* @param Solids Quantidade de sólidos dissolvidos
#* @get /predicao
function(Solids) {
  Solids <- as.numeric(Solids)
  if (is.na(Solids)) {
    return(list(erro = "Parâmetro inválido"))
  }
  
  previsao <- predict(modelo_lm, newdata = data.frame(Solids = Solids))
  return(list(Solids = Solids, Conductivity_Prevista = previsao))
}

#* Regressão Logística: Classificação da Potabilidade
#* @param ph
#* @param Hardness
#* @param Solids
#* @param Chloramines
#* @param Sulfate
#* @param Conductivity
#* @param Organic_carbon
#* @param Trihalomethanes
#* @param Turbidity
#* @get /classificacao
function(ph, Hardness, Solids, Chloramines, Sulfate,
         Conductivity, Organic_carbon, Trihalomethanes, Turbidity) {
  
  valores <- data.frame(
    ph = as.numeric(ph),
    Hardness = as.numeric(Hardness),
    Solids = as.numeric(Solids),
    Chloramines = as.numeric(Chloramines),
    Sulfate = as.numeric(Sulfate),
    Conductivity = as.numeric(Conductivity),
    Organic_carbon = as.numeric(Organic_carbon),
    Trihalomethanes = as.numeric(Trihalomethanes),
    Turbidity = as.numeric(Turbidity)
  )
  
  if (any(is.na(valores))) {
    return(list(erro = "Parâmetros inválidos"))
  }
  
  classe <- predict(modelo_log, newdata = valores)
  return(list(potabilidade_prevista = as.character(classe)))
}
