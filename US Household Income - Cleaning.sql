-- US Household Income Data Cleaning

-- Dando uma olhada geral nas tabelas para ver como foi trazido para o MySQL

SELECT * 
FROM us_project.us_household_income_statistics;

SELECT * 
FROM us_project.us_household_income;

-- Tem um erro no nome da primeira coluna do "US_Household_Income_Statistics" que está com caracteres estranhos que teremos que corrigir

ALTER TABLE us_project.us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`;

-- Vamos comparar as duas tabelas para ver se está batendo a quantidade de IDs

SELECT COUNT(id) 
FROM us_project.us_household_income_statistics;

SELECT COUNT(id)
FROM us_project.us_household_income;

-- Nota-se que está faltando uns 200 IDs e, sendo dados puxados diretamente do site do governo, vamos ter alguns problemas mesmo. Vamos seguir.

-- Vamos procurar por duplicatas

SELECT id, COUNT(id)
FROM us_project.us_household_income
GROUP BY id
HAVING COUNT(id) > 1;

-- Agora que encontramos as duplicadas vamos ter que exluí-las
-- Antes vamos dar uma olha em uma das duplicadas pra ver as informações contigas nessas linhas

SELECT *
FROM us_household_income
WHERE id = '10226';

-- OK os dados são exatamente os mesmos
-- Vamos só dar mais uma olhada nos demais, já que são poucos

SELECT *
FROM
(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num, COUNT(*) OVER(PARTITION BY id) AS total_count
	FROM us_household_income
) AS duplicadas
WHERE total_count > 1;

-- Pronto pudemos verificar no olho que realmente há linha duplicadas com códigos de id diferentes
-- Vamos agora entao excluir as duplicadas
-- Somente vamos conferir que as linhas selecionadas são realmente as que queremos exluir e em seguidas vamos exluir

SELECT *
FROM
(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num, COUNT(*) OVER(PARTITION BY id) AS total_count
	FROM us_household_income
) AS duplicadas
WHERE row_num > 1;

-- Conferido e realmente são essas

DELETE FROM us_household_income
WHERE row_id IN
(
	SELECT row_id
	FROM
	(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num, COUNT(*) OVER(PARTITION BY id) AS total_count
	FROM us_household_income
	) AS duplicadas
	WHERE row_num > 1
);

 -- Tinhamos 6 linhas retornadas nas pequisas e tivemos 6 linhas exluidas, então funcionou, vamos só conferir que realmente não tem mais duplicadas na busca
 
 SELECT *
FROM
(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num, COUNT(*) OVER(PARTITION BY id) AS total_count
	FROM us_household_income
) AS duplicadas
WHERE row_num > 1;
 
 -- Pronto, nao tivemos nenhum retorno na tabela de duplicatas, vamos seguir
 -- Vamos ver agora como está na outra tabela
 
  SELECT *
FROM
(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num, COUNT(*) OVER(PARTITION BY id) AS total_count
	FROM us_household_income_statistics
) AS duplicadas
WHERE row_num > 1;

-- Não temos duplicatas
-- Durante a varredura nas tabelas eu havia visto um "Alabama" com a primeira letra minuscula, diferenciando das demais, vamos dar uma olhada nos nomes dos estados pra tentar corrigir as imperfeições

SELECT DISTINCT State_Name
FROM us_household_income
ORDER BY 1;

-- Bom, parece que o próprio SQL ignorou a letra minuscula e está considernado como o nome correto, mas percebi que tem um estado de "georia" que está errado, pois devia ser "Georgia"

UPDATE us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

-- OK corrigido
-- Vamos só corrigir o "alabama" por padrinização, nao sei se posteriormente poderia nos atrapalhar

UPDATE us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';
 
 -- Vamos ver agora se a coluna de State_ab não tem nada fora do padrão
 
SELECT DISTINCT State_ab
FROM us_household_income
ORDER BY 1;
 
 -- Parece Ok
 -- Acabei vendo uma celula em branco na coluna de Place, vamos dar uma olhada e preencher com uma informação válida caso seja possível
 
SELECT *
FROM us_household_income
WHERE Place = ''
ORDER BY 1;

SELECT *
FROM us_household_income
WHERE County = 'Autauga County'
ORDER BY 1;

-- Bascicamente todos os County de Autauga County tem um mesmo Place, exceto pela City Deatsville

SELECT *
FROM us_household_income
WHERE City = 'Deatsville'
ORDER BY 1;

-- Como a linha que tem Place em branco nao é da City Deatsville, vamos seguir com o preenchimento

UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont';

-- Vamos dar agora uma olhada na coluna Type

SELECT DISTINCT Type
FROM us_household_income
ORDER BY 1;

-- Tem dois nomes muito parecidos que parece ser erro de digitação: CDP e CPD / Borough e Boroughs
-- Como não conhecemos a fundo o produto que estamos trabalhando, vamos deixar o CDP e CPD e atualizar somente os Borough

UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs';

-- Vamos dar uma olhada rapida na coluna de City
-- Tem muitas cidades, mas como são dos Estados Unidos e não temos certeza do nome, vamos deixar assim por enquanto
-- Vamos dar uma olhada se não temos informações faltantes nas colunas ALand e AWater

SELECT DISTINCT ALand
FROM us_household_income
WHERE (Aland = 0 OR ALand = '' OR ALand IS NULL)
; -- OK só temos 0s, sem NULLo ou ''

SELECT DISTINCT AWater
FROM us_household_income
WHERE (AWater = 0 OR AWater = '' OR AWater IS NULL)
; -- OK só temos 0s, sem NULLo ou ''

SELECT ALand, AWater
FROM us_household_income
WHERE (AWater = 0 OR AWater = '' OR AWater IS NULL)
AND (ALand = 0 OR ALand = '' OR ALand IS NULL)
; -- OK não temos nenhuma linha onde os 2 estão em branco, então poderemos trabalhar sem muitos problemas

-- Vamos dar mais uma olhada na tabela pra ver se está ok

SELECT *
FROM us_household_income;

-- Vamos só fazer a mesma conferencia para Latitude e Longitude

SELECT Lat, Lon
FROM us_household_income
WHERE (Lat = 0 OR Lat = '' OR Lat IS NULL)
AND (Lon = 0 OR Lon = '' OR Lon IS NULL)
; -- OK não temos nenhuma linha onde os 2 estão em branco

-- Conferir as colunas de Zip_Code e Area_Code

SELECT DISTINCT Zip_Code
FROM us_household_income
WHERE (Zip_Code = 0 OR Zip_Code = '' OR Zip_Code IS NULL)
; -- OK não temos valores incorretos

SELECT DISTINCT Area_Code
FROM us_household_income
WHERE (Area_Code = 0 OR Area_Code = '' OR Area_Code IS NULL)
; -- OK não temos valores incorretos

SELECT *
FROM us_household_income_statistics;

-- A tabela de us_household_income_statistics parece estar ok para se trabalhar