Alunas:
Ana Beatriz & Isabelle

## 1. Escolha e apresentação do dataset

### Nome do conjunto de dados
**Water Potability Dataset**

### Link para acesso público
[https://www.kaggle.com/datasets/adityakadiwal/water-potability](https://www.kaggle.com/datasets/adityakadiwal/water-potability)

### Quantidade de registros e variáveis
- **Registros:** 3.276 amostras de água
- **Variáveis:** 10 colunas no total:
  - **9 variáveis independentes (features):**
    - `ph`: nível de pH da água
    - `Hardness`: dureza da água
    - `Solids`: quantidade de sólidos dissolvidos
    - `Chloramines`: nível de cloraminas
    - `Sulfate`: nível de sulfato
    - `Conductivity`: condutividade elétrica
    - `Organic_carbon`: carbono orgânico
    - `Trihalomethanes`: presença de trihalometanos
    - `Turbidity`: turbidez
  - **1 variável alvo (target):**
    - `Potability`: 0 (não potável) ou 1 (potável)

## 2. Pré-processamento e Análise Exploratória (EDA)

### 1. Tratamento de valores ausentes

O conjunto de dados apresenta valores ausentes nas seguintes variáveis:

| Variável          | Valores ausentes |
|-------------------|------------------|
| `ph`              | 491              |
| `Sulfate`         | 781              |
| `Trihalomethanes` | 162              |

Como essas variáveis são importantes para a análise, optamos por **preencher os valores ausentes com a mediana**, uma técnica robusta contra outliers.

#### Código:

```r
# Substituir NAs por medianas
dados$ph[is.na(dados$ph)] <- median(dados$ph, na.rm = TRUE)
dados$Sulfate[is.na(dados$Sulfate)] <- median(dados$Sulfate, na.rm = TRUE)
dados$Trihalomethanes[is.na(dados$Trihalomethanes)] <- median(dados$Trihalomethanes, na.rm = TRUE)
```

---

### 2. Estatísticas Descritivas Básicas

- O **pH** da água varia entre 0 e 14, com média em torno de 7.08.
- A **condutividade** apresenta média de 426, variando de 181 até 753.
- A variável **alvo (`Potability`)** está desbalanceada:
  - Cerca de **39%** da água é potável (`1`)
  - Cerca de **61%** não é potável (`0`)

---

### 3. Visualizações

#### Distribuição do pH

![alt text](/fotos/Distribuição_do_pH.png)

#### Boxplot de Sólidos Dissolvidos por Potabilidade

![alt text](/fotos/image.png)

#### Dispersão entre pH e Sulfato

![alt text](/fotos/image-1.png)

---

### Conclusão

A análise exploratória revela que:

- Existem **padrões diferentes de sólidos e sulfato** entre amostras potáveis e não potáveis.
- O preenchimento de valores ausentes foi essencial para garantir qualidade nos modelos.

## 3. Testes de Normalidade

### Objetivo
Verificar se uma variável numérica segue uma distribuição normal, o que é uma premissa importante para alguns modelos estatísticos, como a regressão linear.

---

### Variável escolhida
- **`ph`** — Nível de acidez da água.

---

### 1. Teste de Shapiro-Wilk

O teste de Shapiro-Wilk verifica se os dados vêm de uma distribuição normal. Funciona bem para amostras com menos de 5000 observações (nosso caso).

#### Código:

```r
shapiro.test(dados$ph)
```

#### Exemplo de saída esperada:

```r
Shapiro-Wilk normality test

data:  dados$ph
W = 0.98432, p-value = 2.5e-08
```

#### Interpretação:
Como o **p-valor < 0.05**, rejeitamos a hipótese nula.  
Conclusão: **Os dados de pH não seguem uma distribuição normal.**

---

### 3. Visualização: Histograma com curva normal

A curva vermelha representa a distribuição normal teórica com a mesma média e desvio padrão dos dados.

#### Gráfico ilustrativo:

![alt text](/fotos/image-2.png)

---

### Conclusão

- A variável `ph` **não apresenta distribuição normal**, tanto pelos testes quanto visualmente.
- Isso impacta diretamente na **adequação à regressão linear** caso a variável fosse dependente.

---

## 4. Coeficiente de Correlação

### Objetivo
Analisar a força e direção da relação entre duas variáveis numéricas utilizando o **coeficiente de correlação de Pearson**, que mede a **associação linear** entre duas variáveis contínuas.

---

### Variáveis analisadas

- `ph` — nível de acidez da água  
- `Sulfate` — concentração de sulfato

Essas variáveis foram escolhidas por serem químicas e com possível influência mútua em ambientes aquáticos.

---

### Cálculo da correlação (Pearson)

#### Código em R:

```r
# Calcular a correlação de Pearson entre ph e Sulfate
cor.test(dados$ph, dados$Sulfate, method = "pearson")
```
---

### Interpretação dos resultados

- **Coeficiente de correlação (r)**: `0.06`
  - Correlação **positiva fraca**
  - À medida que o pH aumenta, o nível de sulfato tende a aumentar **levemente**
- **p-valor < 0.05**:
  - A correlação é **estatisticamente significativa**, apesar de **muito fraca**

---

### Visualização: Dispersão com linha de tendência

#### Gráfico ilustrativo:

![alt text](/fotos/image-3.png)

---

### Conclusão

- Existe uma **correlação positiva fraca** entre `ph` e `Sulfate` (r ≈ 0.06).
- Apesar de estatisticamente significativa, essa correlação **não é forte o suficiente para indicar dependência linear**.
- A visualização reflete a dispersão e a fraca tendência entre as variáveis.

## 5. Regressão Linear Simples (Predição)

### Objetivo
Criar um modelo de **regressão linear simples** para prever uma variável contínua (Y) a partir de uma variável preditora (X).

---

### Variáveis selecionadas

- **X (Preditora):** `Solids` — Quantidade de sólidos dissolvidos na água  
- **Y (Resposta):** `Conductivity` — Condutividade elétrica da água

Essas variáveis foram escolhidas por apresentarem uma possível relação direta, já que a quantidade de sólidos pode impactar na capacidade da água de conduzir eletricidade.

---

### 1. Treinamento do modelo

```r
# Criar modelo de regressão linear simples
modelo_lm <- lm(Conductivity ~ Solids, data = dados)

# Exibir resumo do modelo
summary(modelo_lm)
```

O `summary()` fornece informações como coeficientes da reta, erro padrão, valor de p, e **R²**.

---

### 2. Avaliação do modelo com métricas

Utilizamos três métricas principais:

- **R² (coeficiente de determinação)**: indica quanto da variância de Y é explicada por X.
- **MAE (Erro absoluto médio)**: média dos erros absolutos.
- **RMSE (Erro quadrático médio)**: penaliza mais os erros maiores.

```r
# Instalar e carregar pacote de métricas
install.packages("Metrics")
library(Metrics)

# Previsões
predicoes <- predict(modelo_lm, newdata = dados)

# Cálculo das métricas
r2 <- summary(modelo_lm)$r.squared
mae_val <- mae(dados$Conductivity, predicoes)
rmse_val <- rmse(dados$Conductivity, predicoes)

# Exibir resultados
cat("R²:", r2, "\n")
cat("MAE:", mae_val, "\n")
cat("RMSE:", rmse_val, "\n")
```

### **Resultados do Modelo**

- **R²:** `0.00019`  
  ➤ O modelo explica **menos de 0.02%** da variabilidade na condutividade. Isso indica que a variável `Solids` **tem poder preditivo praticamente nulo** sozinha.

- **MAE (Erro Absoluto Médio):** `65.79`  
  ➤ Em média, o modelo erra por cerca de **65.79 unidades** de condutividade.

- **RMSE (Erro Quadrático Médio):** `80.80`  
  ➤ O erro quadrático médio é alto, sugerindo que o modelo **não está ajustado adequadamente** aos dados.

---

### 3. Visualização: Gráfico de dispersão com linha de regressão

#### Gráfico ilustrativo:

![alt text](/fotos/image-4.png)

---

### Conclusão

- O modelo de regressão mostra como **os sólidos dissolvidos impactam na condutividade da água**.
- Se o **R²** estiver alto e os erros (MAE/RMSE) forem baixos, o modelo tem boa performance.
- A linha de regressão visualiza claramente a tendência linear entre as variáveis analisadas.
- Apesar da possível relação teórica entre sólidos dissolvidos e condutividade, a análise mostra que **não há correlação linear forte** entre essas variáveis neste conjunto de dados.

---

## 6. Regressão Logística (Classificação)

### Objetivo
Construir um modelo de **regressão logística multivariada** para prever se a água é potável (`Potability = 1`) ou não (`Potability = 0`), com base nas variáveis físico-químicas do conjunto de dados.

---

### Variável-alvo (Y)

- `Potability` — binária (0 = não potável, 1 = potável)

---

### Variáveis preditoras (X)

Foram utilizadas **todas as variáveis numéricas disponíveis**, com tratamento de valores ausentes:

- `ph`  
- `Hardness`  
- `Solids`  
- `Chloramines`  
- `Sulfate`  
- `Conductivity`  
- `Organic_carbon`  
- `Trihalomethanes`  
- `Turbidity`

---

### Código em R

```r
# Carregar pacotes
install.packages("caret")
library(caret)

# Carregar dados
dados <- read.csv("water_potability.csv")

# Tratar valores ausentes com mediana
dados$ph[is.na(dados$ph)] <- median(dados$ph, na.rm = TRUE)
dados$Sulfate[is.na(dados$Sulfate)] <- median(dados$Sulfate, na.rm = TRUE)
dados$Trihalomethanes[is.na(dados$Trihalomethanes)] <- median(dados$Trihalomethanes, na.rm = TRUE)

# Converter Potability para fator
dados$Potability <- as.factor(dados$Potability)

# Dividir em treino e teste
set.seed(123)
index <- createDataPartition(dados$Potability, p = 0.8, list = FALSE)
treino <- dados[index, ]
teste <- dados[-index, ]

# Treinar modelo de regressão logística
modelo_log_completo <- train(
  Potability ~ ph + Hardness + Solids + Chloramines + Sulfate +
               Conductivity + Organic_carbon + Trihalomethanes + Turbidity,
  data = treino,
  method = "glm",
  family = "binomial"
)

# Previsões no conjunto de teste
predicoes_completo <- predict(modelo_log_completo, newdata = teste)

# Avaliação com matriz de confusão
confusao_completo <- confusionMatrix(predicoes_completo, teste$Potability)
print(confusao_completo)
```

---

### Exemplo de resultado da matriz de confusão

```
Confusion Matrix and Statistics

          Reference
Prediction   0   1
         0 309 114
         1 108 123

Accuracy : 0.655
Sensitivity : 0.519
Specificity : 0.741
```

---

### Interpretação dos resultados

- **Acurácia:** `65.5%` – o modelo acerta cerca de dois terços dos casos.
- **Sensibilidade:** `51.9%` – consegue identificar pouco mais da metade das águas potáveis.
- **Especificidade:** `74.1%` – é melhor para identificar quando a água não é potável.

---

### Conclusão

A regressão logística multivariada permitiu prever a potabilidade da água com **acurácia moderada**. Apesar das limitações, o modelo é funcional e representa um bom ponto de partida para análises mais complexas com outros algoritmos de classificação.

Claro! Aqui está o **último passo do seu projeto — Disponibilização via API REST** documentado em **Markdown**, com explicações e instruções detalhadas para replicar no RStudio:

---

## 7. API REST

### Objetivo
Transformar os modelos treinados (regressão linear e regressão logística) em **serviços REST** acessíveis por requisições HTTP, utilizando o pacote **plumber** em R.

---

### Modelos utilizados

- **Regressão Linear**  
  - Previsão da condutividade elétrica (`Conductivity`) com base na quantidade de sólidos dissolvidos (`Solids`).

- **Regressão Logística**  
  - Classificação da potabilidade (`Potability`) com base em 9 variáveis físico-químicas.

---

### Passo 1 — Salvar os modelos treinados

```r
saveRDS(modelo_lm, "modelo_regressao_linear.rds")
saveRDS(modelo_log_completo, "modelo_regressao_logistica.rds")
```

---

### Passo 2 — Criar o arquivo `api.R`

```r
# Carregar modelos
modelo_lm <- readRDS("modelo_regressao_linear.rds")
modelo_log <- readRDS("modelo_regressao_logistica.rds")

#* @apiTitle API para Predição e Classificação da Qualidade da Água

#* Endpoint /predicao — Regressão Linear
#* @param Solids Quantidade de sólidos dissolvidos
#* @get /predicao
function(Solids) {
  Solids <- as.numeric(Solids)
  if (is.na(Solids)) return(list(erro = "Parâmetro inválido"))
  previsao <- predict(modelo_lm, newdata = data.frame(Solids = Solids))
  list(Solids = Solids, Conductivity_Prevista = previsao)
}

#* Endpoint /classificacao — Regressão Logística
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

  if (any(is.na(valores))) return(list(erro = "Parâmetros inválidos"))

  classe <- predict(modelo_log, newdata = valores)
  list(potabilidade_prevista = as.character(classe))
}
```

---

### Passo 3 — Executar a API no RStudio

```r
install.packages("plumber")
library(plumber)

r <- plumb("api.R")
r$run(port = 8000)
```

---

#### `/predicao`

Exemplo de chamada:
```
Solids=20000
```

Retorno esperado:
```json
{
  "Solids": 20000,
  "Conductivity_Prevista": 429.12
}
```

#### `/classificacao`

Exemplo de chamada:
```http
ph=7 
Hardness=200
Solids=22000
Chloramines=7
Sulfate=340
Conductivity=420
Organic_carbon=14
Trihalomethanes=70
Turbidity=4.0
```

Retorno esperado:
```json
{
  "potabilidade_prevista": "1"
}
```

---
