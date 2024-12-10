-- US Household Income Exploratoty Data Analysis

SELECT *
FROM us_household_income;

SELECT *
FROM us_household_income_statistics;

-- Nesse conjunto de dados, podemos ver por exemplo quanto de agua e terra cada estado tem, vamos começar por aí

SELECT State_Name, City, ALand, AWater
FROM us_household_income;

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 2 DESC;

-- Dessa primeira analise podemos ver que o estado do Texas tem a maior área de terra, seguido por California. Faz até sentido quando observamos pelo mapa

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 3 DESC;

-- Michigan é conhecido por ter os maiores lagos, então também faz sentido ter a maior área de agua
-- Podemos também fazer um ranking dos 10 estados com maiores areas de terra e agua

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10;

-- Vamos juntar as 2 tabelas para termos analises maiores

SELECT *
FROM us_household_income AS u
JOIN us_household_income_statistics AS us
	ON u.id = us.id;

-- Quando importamos os dados no MySQL vimos que haviam mais dados em uma tabela no que na outra, entao vamos ver o que ficou faltando

SELECT *
FROM us_household_income AS u
RIGHT JOIN us_household_income_statistics AS us
	ON u.id = us.id
WHERE u.id IS NULL;

-- Daqui teríamos 2 soluções, voltar no DataSet pra ajustar os dados que estão faltando, no excel por exemplo ou, caso não tenhamos acesso ou propriedade para preencher, somente "se livrar" dessas 240 linhas encontradas e trabalhar sem elas.
-- Para esse estudo vamos seguir com a segunda opção e seguir trabalhando na analise
-- Observei que há linhas sem valores nas colunas Mean, Median e Stdev. Vamos trabalhar sem essas linhas também, já que nao teremos dados pra preencher aí

SELECT *
FROM us_household_income AS u
INNER JOIN us_household_income_statistics AS us
	ON u.id = us.id
WHERE Mean <> 0;

-- Pronto, temos nossos dados que vamos trabalhar e faremos a partir daí

SELECT u.State_Name, County, Type, `Primary`, Mean, Median
FROM us_household_income AS u
INNER JOIN us_household_income_statistics AS us
	ON u.id = us.id
WHERE Mean <> 0;

-- Vamos dar uma olhada nas medias de income por estado

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_household_income AS u
INNER JOIN us_household_income_statistics AS us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2;

-- Vemos que a media de incomes de estados como Mississipi são realmente bem baixos, 50k por household é quase 25k pra cada pessoa, se considerarmos um casal

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_household_income AS u
INNER JOIN us_household_income_statistics AS us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 DESC;

-- District of Columbia tem quase o dobro de Mississipi
-- Claro que ambas analises sozinhas não significam muito, pois nao tem os dados de custo de vida em cada estado
-- Vamos ver pela mediana, pra saber qual estados possui os salarios mais altos

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_household_income AS u
INNER JOIN us_household_income_statistics AS us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 3 DESC;

-- Os maiores salarios estao por volta de New Jersey e Wyoming

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_household_income AS u
INNER JOIN us_household_income_statistics AS us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 3;

-- Ja os menores estão em Arkansas (nao estamos considerando Puerto Rico)
-- Vamos fazer a mesma analise pela coluna Type pra ver em que tipo de cidade por exemplo temos o maior e menor salario

SELECT Type, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_household_income AS u
INNER JOIN us_household_income_statistics AS us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY Type
ORDER BY 2 DESC;

-- Vemos que o tipo de area Municipality tem a maior media de salario
-- Mas vamos ver a quantidade de salarios que temos em cada para nao levantar conclusões precipitadas

SELECT Type, COUNT(Type), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_household_income AS u
INNER JOIN us_household_income_statistics AS us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY Type
ORDER BY 3 DESC;

-- Tá, entao a media está muito alta, já que só tem 1 dado. Não podemos levar em consideração essa analise incial que tinhamos feito
-- Se considerarmos os salarios com maior fonte de dados, o tipo Borough e Track possuem a maior média de salario
-- Os salarios em tipos Urban e Community não parecem muito sustentaveis, são salarios bem baixos

SELECT Type, COUNT(Type), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_household_income AS u
INNER JOIN us_household_income_statistics AS us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY Type
ORDER BY 4 DESC;

-- Pela mediana temos que em tipos CDP tem salarios bem altos
-- Enquanto que em tipos Urban e Community mantem os salarios baixos
-- Vamos dar uma olhada nesses tipos com salarios baixos

SELECT *
FROM us_household_income
WHERE Type = 'Community';

-- Ok, são todos de Porto Rico... faz sentido e não estamos levando Porto Rico em analise (Porto Rico é um terrirório nao incorporado dos Estados Unidos)
-- Para melhorar os estudos, vamos retirar os Tipos que possum poucos dados

SELECT Type, COUNT(Type), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_household_income AS u
INNER JOIN us_household_income_statistics AS us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY Type
HAVING COUNT(Type) > 100
ORDER BY 4 DESC;

-- Vamos ver em nivel de cidade, os maiores salarios

SELECT City, u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_household_income AS u
INNER JOIN us_household_income_statistics AS us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY City, u.State_Name
ORDER BY 3 DESC;

-- Delta Juction está no Alaska e tem a maior média de salario e parece ter os maiores salarios tambén, pela mediana... mas todos estão com 300k, as vezes algum limitante da fonte de dados
-- Seria algo a se estudar mais a fundo, porque temos esse limite de 300k





