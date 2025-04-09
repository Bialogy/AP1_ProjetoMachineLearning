# Carregar pacotes
install.packages("caret")
library(caret)

# Carregar os dados
dados <- water_potability

# Tratar valores ausentes com mediana
dados$ph[is.na(dados$ph)] <- median(dados$ph, na.rm = TRUE)
dados$Sulfate[is.na(dados$Sulfate)] <- median(dados$Sulfate, na.rm = TRUE)
dados$Trihalomethanes[is.na(dados$Trihalomethanes)] <- median(dados$Trihalomethanes, na.rm = TRUE)

# Transformar a variável alvo em fator
dados$Potability <- as.factor(dados$Potability)

# Dividir os dados em treino e teste
set.seed(123)
index <- createDataPartition(dados$Potability, p = 0.8, list = FALSE)
treino <- dados[index, ]
teste <- dados[-index, ]

# Treinar modelo de regressão logística multivariada
modelo_log_completo <- train(
  Potability ~ ph + Hardness + Solids + Chloramines + Sulfate +
    Conductivity + Organic_carbon + Trihalomethanes + Turbidity,
  data = treino,
  method = "glm",
  family = "binomial"
)

# Fazer previsões no conjunto de teste
predicoes_completo <- predict(modelo_log_completo, newdata = teste)

# Avaliar desempenho com matriz de confusão
confusao_completo <- confusionMatrix(predicoes_completo, teste$Potability)
print(confusao_completo)

