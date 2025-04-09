# Carregar pacotes
install.packages("ggplot2")
library(ggplot2)

# Carregar dados
dados <- water_potability

# Verificar NAs
colSums(is.na(dados))

# Substituir NAs por medianas
dados$ph[is.na(dados$ph)] <- median(dados$ph, na.rm = TRUE)
dados$Sulfate[is.na(dados$Sulfate)] <- median(dados$Sulfate, na.rm = TRUE)
dados$Trihalomethanes[is.na(dados$Trihalomethanes)] <- median(dados$Trihalomethanes, na.rm = TRUE)

# Histograma do pH
ggplot(dados, aes(x = ph)) +
  geom_histogram(bins = 30, fill = "skyblue", color = "black") +
  theme_minimal() +
  labs(title = "Distribuição do pH da Água", x = "pH", y = "Frequência")

# Boxplot de Solids por Potability
ggplot(dados, aes(x = factor(Potability), y = Solids, fill = factor(Potability))) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Sólidos Dissolvidos por Potabilidade", x = "Potável (1) ou Não (0)", y = "Sólidos")

# Gráfico de dispersão entre pH e Sulfate
ggplot(dados, aes(x = ph, y = Sulfate, color = factor(Potability))) +
  geom_point(alpha = 0.6) +
  theme_minimal() +
  labs(title = "Relação entre pH e Sulfato", x = "pH", y = "Sulfato")

# Aplicando o teste de Shapiro-Wilk para a variável pH
shapiro.test(dados$ph)

ggplot(dados, aes(x = ph)) +
  geom_histogram(aes(y = ..density..), bins = 30, fill = "lightblue", color = "black") +
  stat_function(fun = dnorm, args = list(mean = mean(dados$ph), sd = sd(dados$ph)), color = "red", size = 1) +
  labs(title = "Distribuição do pH com curva normal", x = "pH", y = "Densidade") +
  theme_minimal()

# Calcular correlação de Pearson entre ph e Sulfate
cor.test(dados$ph, dados$Sulfate, method = "pearson")

library(ggplot2)

ggplot(dados, aes(x = ph, y = Sulfate)) +
  geom_point(color = "darkblue", alpha = 0.6) +
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  theme_minimal() +
  labs(title = "Correlação entre pH e Sulfato",
       x = "pH", y = "Sulfato")

# Criar modelo de regressão linear simples
modelo_lm <- lm(Conductivity ~ Solids, data = dados)

# Resumo do modelo
summary(modelo_lm)

# Instalar pacote para métricas se necessário
install.packages("Metrics")
library(Metrics)

# Previsões
predicoes <- predict(modelo_lm, newdata = dados)

# R² (já vem no summary, mas pode calcular separado)
r2 <- summary(modelo_lm)$r.squared

# MAE e RMSE
mae_val <- mae(dados$Conductivity, predicoes)
rmse_val <- rmse(dados$Conductivity, predicoes)

# Exibir métricas
cat("R²:", r2, "\n")
cat("MAE:", mae_val, "\n")
cat("RMSE:", rmse_val, "\n")

library(ggplot2)

ggplot(dados, aes(x = Solids, y = Conductivity)) +
  geom_point(alpha = 0.5, color = "blue") +
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  theme_minimal() +
  labs(title = "Regressão Linear: Solids vs Conductivity",
       x = "Sólidos Dissolvidos", y = "Condutividade Elétrica")

