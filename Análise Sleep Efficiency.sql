-- Databricks notebook source
--- Overview do dataset
select * from sleep_efficiency

-- COMMAND ----------

--- Consulta dos ID's com o maior consumo de alcool, hábito de fumar e zero frequência de exercicios, retornou 3 ID's com índices muito abaixo da média. Sleep eficiency médio dos 3 foi de 0,56 x a média do estudo de 0,8. Percentual de sono rem teve 2 p.p abaixo da média. No sono profundo a diferença foi de mais de 20 p.p (31 x 53). Sono leve também houve discrepância (49 x 24) e, por fim a média de despertares do estudo foi de 1,7 já nos 3 id's tivemos um com 1 despertar e dois com 4 despertares (quase 4x mais que a média)
select ID, gender, 
Age,
Alcohol_consumption, 
Smoking_status, 
Exercise_frequency,
Sleep_efficiency,
REM_sleep_percentage,
Deep_sleep_percentage,
Light_sleep_percentage,
Awakenings
from sleep_efficiency
where Alcohol_consumption = '5.0'
and Smoking_status = 'Yes'
and Exercise_frequency = '0.0'
order by Sleep_efficiency desc


-- COMMAND ----------

--- Fiz uma consulta com os possiveis "melhores ID's do estudo" que obtiveram zero consumo de alcool, não fumantes e frequência máxima de exercicios do estudo. Tivemos 6 ID's (Todos mulheres), a média de eficiência do sono foi de 0.9, quase o dobro dos "piores ID's (0,5).Sono rem a diferença foi de 0.2 p.p (22 x 20).No sono profundo a diferença foi de mais de 20 p.p, sono leve +30 p.p e, nos despertares apenas um ID teve um 1 despertar os outros não tiveram.
select ID, gender, 
Age
Alcohol_consumption, 
Smoking_status, 
Exercise_frequency,
Sleep_efficiency,
REM_sleep_percentage,
Deep_sleep_percentage,
Light_sleep_percentage,
Awakenings
from sleep_efficiency
where Alcohol_consumption = '0.0'
and Smoking_status = 'No'
and Exercise_frequency = '5.0'
order by Sleep_efficiency desc


-- COMMAND ----------

--- Análise de medidas centrais das fases do sono: Diferença de 6 anos a mais para os homens, duração do sono e eficiência do sono praticamente iguais. Mulheres tem um pouco mais de sono rem (rapid eyes movement: O sono REM é fundamental porque é nele que as memórias são processadas e o conhecimento é consolidado), porém elas tem quase 3 p.p a menos de Sono profundo e, consequentemente um pouco mais de sono leve do que os homens.

SELECT 
  count(id) AS qtd, gender as genero,
  round(avg(age), 1) AS media_idade, 
  round(avg(Sleep_duration), 1) AS media_duracao_sono,
  round(avg(Sleep_efficiency), 1) AS media_eficiencia_sono,
  round(avg(REM_sleep_percentage), 1) AS media_sono_rem,
  round(avg(Deep_sleep_percentage), 1) AS media_sono_profundo,
  round(avg(Light_sleep_percentage), 1) AS media_sono_leve,
  round(avg(Awakenings), 1) AS media_despertares
FROM sleep_efficiency
GROUP BY genero

-- COMMAND ----------

--- Correlação da qualidade do sono com o consumo de Cafeína: Não se evindenciou relação de baixa eficiência do sono com o consumo de cafeina, ao contrário, os 3 melhores resultados foram com as maiores quantidades da substância (100,200 e 75), porém a quantidade de 50mg ficou com o menor percentual (atrás de quem não consumiu nada e as pessoas que consumiram até 25 mg). Sendo assim não acredito que há efetiva correlação entre a qualidade do sono e uso de cafeina.

select distinct Caffeine_consumption as consumo_cafeina,
round(avg(Sleep_efficiency),2) as media_eficiencia_sono
from sleep_efficiency
group by consumo_cafeina
order by media_eficiencia_sono desc



-- COMMAND ----------

--- Nas correlações de uso de cafeína com a média de quantidade de sono Rem,Profundo e Leve trouxeram alguns dados interessante, porém, não identifiquei uma causalidade. Como exemplo o uso de 100mg teve a menor média de sono rem, a maior de sono produndo e a menor disparadamente do sono leve, porém 200mg que é uma quantidade maior teve uma média de sono profundo menor e sono leve maior. Corroborando com os resultados da análise anterior da eficiência do sono acredito não have correlação entre a cafeína e a qualidade do sono da amostra.Na média de despertares também não houve uma relação linear (apenas o consumo de 100mg não teve despertar, responsável pela alta quantidade de sono profundo e baixo sono)
select distinct Caffeine_consumption as consumo_cafeina,
round(avg(REM_sleep_percentage),1) as media_sono_rem,
round(avg(Deep_sleep_percentage),1) as media_sono_profundo,
round(avg(Light_sleep_percentage),1) as media_sono_leve,
round(avg(awakenings),1) as media_despertares
from sleep_efficiency
group by consumo_cafeina
order by media_sono_rem desc

-- COMMAND ----------

--- Já na comparação do consumo de alcool com a eficiência do sono se evidencia uma queda em relação com o consumo, zero consumo e 1 foram as únicas quantidades de uso de alcool com percentual de eficiência do sono acima de 0.8. 4 e 5 tiveram percentuais abaixo de 0.7
select distinct Alcohol_consumption as Consumo_alcool, 
round(avg(Sleep_efficiency),2) as media_eficiencia_sono
from sleep_efficiency
group by Consumo_alcool
order by media_eficiencia_sono desc

-- COMMAND ----------

--- Analisando as médias de sono REM, Profundo e Leve comprova-se o impacto do consumo de alcool, as quantidades de 4 e 5 tiveram os piores percentuais de sono rem, no sono produndo estiveram entre os 3 piores, em snono leve os maiores percentuais junto ao consumo 2, e ambos tiveram mais de despertares em média. Já o consumo 0 e 1 estiveram nas melhores médias de cada quesito.
select distinct Alcohol_consumption as Consumo_alcool,
round(avg(REM_sleep_percentage),1) as media_sono_rem,
round(avg(Deep_sleep_percentage),1) as media_sono_profundo,
round(avg(Light_sleep_percentage),1) as media_sono_leve,
round(avg(awakenings),1) as media_despertares
from sleep_efficiency
group by Consumo_alcool
order by Consumo_alcool asc

-- COMMAND ----------

---O Hábito de fumar também trouxe perda na eficiência do sono comparado com as pessoas que não fumavam, diferença 0,9 p.p
select distinct smoking_status as Condicao_fumante,
round(avg(Sleep_efficiency),2) as media_eficiencia_sono
from sleep_efficiency
group by Condicao_fumante
order by media_eficiencia_sono desc

-- COMMAND ----------

----Na análise de Sono rem o consumo de cigarro teve um percentual quase igual a quem não fuma (nas outras análises o sono rem também não parece sofrer alterações correlacionadas), entretanto, os percentuais de sono profundo e sono leve teve bastante alteração entre quem fuma e os que não fumam (médias próximas de 0,8 p.p de diferença pró não fumantes).
select distinct smoking_status as Condicao_fumante, 
round(avg(REM_sleep_percentage),1) as media_sono_rem,
round(avg(Deep_sleep_percentage),1) as media_sono_profundo,
round(avg(Light_sleep_percentage),1) as media_sono_leve,
round(avg(awakenings),1) as media_despertares
from sleep_efficiency
group by Condicao_fumante
order by Condicao_fumante asc

-- COMMAND ----------

--- Frequência de exercicios também se mostrou altamente correlacionavel com a média de eficiência do sono, sendo as melhores taxas para a média de 4 e 5 e os piores para as amostas de 0 e 1.
select distinct exercise_frequency as Frequencia_exercicio,
round(avg(Sleep_efficiency),2) as media_eficiencia_sono
from sleep_efficiency
group by Frequencia_exercicio
order by media_eficiencia_sono desc

-- COMMAND ----------

--- Novamente, o sono rem não mostrou correlação com a frequência de exercicio, já a quantida de sono profundo também teve as melhores faixas para as amostras com maior percentual de exercicios. As amostras que tem frequência 0 tiveram o menor percentual de sono produndo, maior de sono leve e a maior quantidade de despertares.
select distinct exercise_frequency as Frequencia_exercicio, 
round(avg(REM_sleep_percentage),1) as media_sono_rem,
round(avg(Deep_sleep_percentage),1) as media_sono_profundo,
round(avg(Light_sleep_percentage),1) as media_sono_leve,
round(avg(awakenings),1) as media_despertares
from sleep_efficiency
group by Frequencia_exercicio
order by Frequencia_exercicio asc

-- COMMAND ----------

--- Conclusão; Analisando as amostras, não podemos afirmar que há correlação de consumo de cafeína com a eficiência do sono (Mesmo tendo estudos relatando que o consumo de cafeína próximo ao horário de dormir possa atrapalhar a qualidade do sono), entretanto, o hábito de fumar,consumo de alcool e falta de exercicios fisícos estão altamente correlacionados com a má qualidade do sono e eficiência do sono.
