# Diário

## 18 de Setembro de 2026

Fiz o download ds dados e salvei em formato parquet.

O volume de $1{,}56 \times 10^6$ registros obtido a partir do repositório `
astorb` garante densidade estatística suficiente para a identificação das 
ressonâncias de movimento médio no Cinturão Principal.

### 1. Refinamento da Filtragem Espacial e Dinâmica

A restrição do intervalo do semi-eixo maior ($2{,}0\text{ UA} < a < 3{,}5\text{ UA}$) 
emove os Troianos e a maioria dos Near-Earth Asteroids (NEAs). No entanto, para 
isolar a população do Cinturão Principal (MBAs), a filtragem deve considerar 
simultaneamente as condições de periélio ($q = a(1-e)$) e afélio ($Q = a(1+e)$):

* **Remoção residual de NEAs (Atens, Apollos, Amors):** Defina a restrição adicional $q > 1{,}3\text{ UA}$. Isso garante a exclusão de objetos cruzadores de Marte ou da Terra que eventualmente possuam $a > 2{,}0\text{ UA}$.
* **Fronteira externa:** A restrição $a < 3{,}5\text{ UA}$ captura a população até os asteroides do grupo Cybele, mas vale notar a presença da ressonância $2:1$ em $a \approx 3{,}28\text{ UA}$. Para evitar a inclusão do grupo Hilda ($a \approx 3{,}9\text{ UA}$, em ressonância $3:2$), o limite em $3{,}5\text{ UA}$ é correto.

### 2. Critérios Estritos para Tratamento de Ruído e Erros Orbitais

No catálogo `astorb.dat`, a precisão dos elementos orbitais osculantes é parametrizada, entre outros indicadores, pelo arco de observação (*orbital arc*) e pelo código de incerteza da órbita (*CEU - Current Error Uncertainty* ou o parâmetro $U$ do MPC, variando de 0 a 9):

* **Filtro de Excentricidade:** A condição $0 \le e < 1{,}0$ elimina órbitas parabólicas e hiperbólicas. Para o Cinturão Principal, valores de $e > 0{,}4$ são atípicos e geralmente associados a órbitas ruidosas ou objetos em rotas de escape dinâmico.
* **Filtro de Qualidade da Órbita:** É recomendável filtrar objetos com arcos de observação extremamente curtos. Em `astorb`, remova registros em que a incerteza da posição ephemeris seja elevada ou restrinja a amostragem a asteroides numerados (que possuem órbitas consolidadas com arcos observacionais de múltiplas oposições).

### 3. Implementação Computacional em R (`tidyverse`)

Abaixo, apresento a estrutura algorítmica para a leitura e aplicação encadeada das condições de contorno via `dplyr` e `readr`:

```R
library(tidyverse)

# Exemplo de pipeline de filtragem e limpeza dos elementos osculantes
df_kirkwood <- astorb_raw %>%
  # Garantir conversão de tipos numéricos
  mutate(
    a = as.numeric(a),
    e = as.numeric(e),
    i = as.numeric(i),
    q = a * (1 - e)
  ) %>%
  # Filtragem simultânea de escopo e qualidade orbital
  filter(
    !is.na(a) & !is.na(e),
    a > 2.0 & a < 3.5,     # Limites do Cinturão Principal
    q > 1.3,               # Exclusão estrita de NEAs
    e >= 0.0 & e < 0.45    # Exclusão de excentricidades não físicas/extremas
  )

```

### Perguntas Norteadoras para o Desenho Experimental

Para avançarmos à etapa de análise exploratória e visualização da densidade espacial, sugiro refletirmos sobre as seguintes questões:

1. **Efeito do Arco de Observação:** A inclusão de asteroides não numerados (com arcos observacionais curtos) introduz ruído perceptível na largura equivalente das falhas de Kirkwood em relação ao subconjunto exclusivo de asteroides numerados?
2. **Seleção de Bandwidth para KDE:** Qual método de seleção automática de largura de banda (como a regra de Silverman ou *Cross-Validation*) você pretende utilizar no `ggplot2` ou `stats` para evitar o mascaramento da ressonância $5:2$ ($a \approx 2{,}82\text{ UA}$), que possui largura espectral estreita?

Qual aspecto da estrutura de dados ou da resolução dos histogramas de $a$ você gostaria de examinar no momento?