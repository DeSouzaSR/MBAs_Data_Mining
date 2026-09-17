A escolha da distribuição espacial dos asteroides do Cinturão Principal e a caracterização das falhas de Kirkwood constitui um excelente projeto para o aperfeiçoamento da manipulação de dados astroestatísticos no ecossistema `tidyverse` em R. A identificação clara destas lacunas requer a análise precisa de elementos orbitais osculantes, nos quais a mecânica celeste encontra ressonâncias de movimento médio com Júpiter.

Para estruturar um pipeline de ingestão, tratamento e visualização de dados, vamos considerar o seguinte desenho metodológico:

### 1. Obtenção dos Dados

As duas principais fontes públicas e robustas para elementos orbitais de corpos menores são:

* **JPL Small-Body Database (SBDB) API:** Fornecida pelo Jet Propulsion Laboratory (NASA). Permite realizar consultas diretas via HTTP/REST utilizando a API `sbdb_query.api`. É possível extrair um *payload* JSON com filtros pré-definidos diretamente em R via pacotes como `httr2` e `jsonlite`.
* **Minor Planet Center (MPC) Database / Lowell Observatory (`astorb.dat`):** O banco `astorb.dat` (mantido pelo Lowell Observatory) ou o arquivo `MPCORB.DAT` fornecem os elementos orbitais osculantes de todos os asteroides numerados e não numerados. O formato é texto plano delimitado por largura fixa (FWF), ideal para testes de *parsing* eficiente no R.

### 2. Variáveis Orbitais Prioritárias e Fundamentação Física

Para mapear o Cinturão Principal e evidenciar as ressonâncias, selecione as seguintes variáveis:

* **$a$ (Semi-eixo maior, em UA):** É a variável fundamental. As falhas de Kirkwood aparecem explicitamente em ressonâncias de movimento médio com Júpiter (ex.: $3:1$ em $\sim 2{,}50\text{ UA}$, $5:2$ em $\sim 2{,}82\text{ UA}$, $5:3$ em $\sim 2{,}95\text{ UA}$, $2:1$ em $\sim 3{,}28\text{ UA}$).
* **$e$ (Excentricidade):** Crucial para filtrar órbitas instáveis ou com elevada incerteza, além de distinguir objetos das famílias dinâmicas.
* **$i$ (Inclinação, em graus):** Permite isolar o Cinturão Principal de populações de alta inclinação e auxilia no mapeamento tridimensional da distribuição espacial.
* **$H$ (Magnitude absoluta):** Serve como um *proxy* para o tamanho do corpo (assumindo um albedo médio constante). Permite analisar o viés de observação (completeza do catálogo para objetos menores).

### 3. Diretrizes para Limpeza, Mapeamento e Análise no Tidyverse

#### Ingestão e Limpeza (`readr`, `dplyr`, `purrr`)

* **Leitura eficiente:** Caso utilize o arquivo texto do `astorb` ou `MPCORB`, empregue `readr::read_fwf()` definindo estritamente as posições das colunas (`fwf_positions`).
* **Filtragem de escopo:** Aplique filtros em $a$ para isolar o Cinturão Principal tradicional ($2{,}0\text{ UA} < a < 3{,}5\text{ UA}$), excluindo Near-Earth Asteroids (NEAs) e Troianos de Júpiter ($a \sim 5{,}2\text{ UA}$).
* **Tratamento de ruído:** Remova objetos com excentricidades não físicas ($e \ge 1{,}0$) ou incertezas orbitais elevadas (caso o catálogo forneça parâmetros de qualidade da órbita, como a flag de incerteza da JPL/MPC).

#### Organização e Variáveis Derivadas (`dplyr`, `tidyr`)

* **Cálculo de Período Orbital ($P$):** Utilizando a Terceira Lei de Kepler ($P^2 = a^3$, para $P$ em anos e $a$ em UA), crie a coluna $P$.
* **Razão de Ressonância com Júpiter:** Sabendo que o semi-eixo maior de Júpiter é $a_J \approx 5{,}2038\text{ UA}$ ($P_J \approx 11{,}86\text{ anos}$), calcule a razão $P / P_J$. Isso permite correlacionar diretamente os histogramas com razões de números inteiros ($1:3, 2:5, 3:5, 1:2$).
* **Elementos Orbitais Próprios vs. Osculantes:** Note que os elementos orbitais osculantes sofrem perturbações de curto período. Para uma estrutura visual limpa das falhas, a análise dos elementos osculantes de catálogos grandes já é suficiente devido à densidade populacional, porém o uso de *elementos próprios* (se disponíveis) agrupa as famílias com maior precisão estatística.

#### Visualização de Dados (`ggplot2`)

* **Histogramas e Estimativa de Densidade por Kernel (KDE):** Utilize `geom_histogram()` com um número de bins elevado (`binwidth = 0.005` ou `0.01` UA) para evitar que a suavização de largura de banda encubra falhas estreitas. Sobreponha um `geom_density()`.
* **Diagramas de Fase ($a$ vs $e$ e $a$ vs $i$):** Crie gráficos de dispersão utilizando `geom_bin2d()` ou `geom_hex()` (`hexbin`). Devido ao volume massivo de dados ($> 10^6$ objetos), o uso de pontos individuais causa *overplotting* severo. A densidade por hexágonos expõe com clareza as regiões despovoadas nas ressonâncias.
* **Anotações Causal-Físicas:** Utilize `geom_vline()` em valores exatos das ressonâncias teóricas para validar o alinhamento das lacunas observadas com as previsões da mecânica celeste.
