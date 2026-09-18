library(dplyr)
library(arrow)

input_file <- 'data/processed/astorb_reduced.parquet'

# We will use the direct-read-to-RAM strategy. If the file were very large, I 
# would adopt the strategy of using lazy disk mapping (open_dataset).
astorb <- read_parquet(input_file)


# Verificação de NA's -----------------------------------------------------

summary(astorb)

# Contagem de NA's
na_counts <- colSums(is.na(astorb))
na_counts[na_counts > 0]

# Só temos NA's nos numeros de identificação


# Verificar domínio do semieixo maior -------------------------------------
hist(astorb$a)


# Verificar se há ruido na excentricidade, ou seja, e >= 1.0 --------------
astorb[astorb$e >= 1.0,]

