# US-Household-Income

## Introdução à Análise de Dados: US Household Income e Statistics

Este projeto consistiu na análise de dois conjuntos de dados relacionados à demografia e à renda das residências nos Estados Unidos. Os arquivos analisados foram:

1. US Household Income: Contendo informações geográficas e características como ID, nome do estado, condado, cidade, localidade, área de terra e área de água.
2. US Household Statistics: Incluindo métricas estatísticas como média, mediana e desvio padrão de renda.

O objetivo principal foi identificar padrões regionais e explorar relações entre características geográficas e métricas de renda. Para tanto, foi utilizado SQL (MySQL) como ferramenta de manipulação e análise de dados, abrangendo etapas de limpeza, padronização e integração dos conjuntos de dados, seguidas por análises exploratórias que proporcionaram insights relevantes.

#### Processo de Preparação e Limpeza de Dados

Na preparação dos dados, foram identificadas e corrigidas diversas inconsistências, como:

- Colunas com caracteres estranhos ou incorretos nos cabeçalhos, que foram ajustadas para maior clareza.
- Dados duplicados, eliminados após um processo rigoroso de validação.
- Valores ausentes ou inconsistentes em colunas importantes, como Place e State_Name, ajustados com base em padrões regionais.
- Discrepâncias em nomes, como "georia" em vez de "Georgia" e "alabama" em vez de "Alabama", que foram padronizados.

Também foi realizada uma revisão detalhada de atributos como Type, corrigindo categorias digitadas incorretamente, como "Boroughs" para "Borough". Essas ações asseguraram a integridade e a consistência dos dados para análises posteriores.

#### Abordagem Analítica

Após a etapa de limpeza, foram realizadas análises exploratórias utilizando funções SQL, o que possibilitou a identificação de padrões e insights, tais como:

- Análise da área de terra e água por estado, na qual se destacou o Texas como o estado com a maior área terrestre e Michigan com a maior área de água, corroborando dados conhecidos.
- Cálculo das médias e medianas de renda por estado e por tipo de área (Type), evidenciando diferenças significativas. Por exemplo, áreas classificadas como "Municipality" apresentaram altos níveis de renda, enquanto "Community" mostrou os mais baixos, predominantemente em Porto Rico.
- Identificação das cidades com maior média de renda, destacando Delta Junction, no Alasca, embora tenha sido identificado um possível limite de valores nos dados originais.

#### Considerações Finais e Próximos Passos

Os insights obtidos revelaram diferenças importantes nos padrões de renda e demografia, ao mesmo tempo em que destacaram limitações nos dados, como lacunas e possíveis erros de coleta. Para uma análise mais completa, seria recomendável integrar dados adicionais, como custo de vida, tamanho médio das famílias e outras variáveis socioeconômicas.

## Funções SQL utilizadas

#### Funções de Seleção e Consulta
`SELECT`: Utilizada para visualizar os dados nas tabelas e realizar análises preliminares. Exemplos: seleção de todas as colunas, filtragem de registros específicos e distinção de valores.

`DISTINCT`: Usada para identificar valores únicos em uma coluna, como em nomes de estados ou códigos de área.

`COUNT`: Contagem de registros, especialmente útil para verificar duplicatas e calcular o número de registros por categoria.

`ROUND`: Aplicada para arredondar valores numéricos, como médias de renda.

#### Funções de Manipulação e Transformação de Dados
`UPDATE`: Utilizada para corrigir erros e padronizar valores em colunas, como nomes de estados ou categorias de tipo.

`ALTER TABLE`: Empregada para renomear colunas e corrigir problemas de nomenclatura.

`DELETE`: Utilizada para remover duplicatas após validação de registros.

#### Funções de Agregação
`SUM`: Calculada para somar valores, como as áreas de terra e água por estado.

`AVG`: Usada para calcular médias, como a renda média por estado.

`GROUP BY`: Agrupamento de dados para análises agregadas, como médias e somas por estado ou tipo de área.

`HAVING`: Aplicada para filtrar grupos com base em condições específicas, como a quantidade mínima de registros por categoria.

#### Funções Analíticas e Janela
`ROW_NUMBER()`: Utilizada para identificar registros duplicados e atribuir números de linha dentro de partições.

`COUNT(*) OVER(PARTITION BY ...)`: Função de janela para contar registros em cada partição, ajudando na validação de duplicatas.

#### Funções de Junção e Relacionamento
`JOIN`: Empregada para unir as duas tabelas com base na coluna ID, permitindo análises combinadas.

`INNER JOIN`: Usada para unir apenas os registros correspondentes entre as tabelas.

`RIGHT JOIN`: Aplicada para identificar registros presentes em uma tabela, mas ausentes na outra.

#### Funções de Ordenação e Limitação
`ORDER BY`: Usada para ordenar os resultados com base em colunas específicas, como áreas ou renda.

`LIMIT`: Aplicada para restringir o número de registros retornados, como no ranking dos estados com maior área ou renda.

Essas funções formaram a base para a análise de dados, proporcionando insights a partir de um conjunto de dados complexo e permitindo uma preparação robusta dos mesmos para estudo posterior.
