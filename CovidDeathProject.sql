SELECT *
FROM CovidDeathsProject;

-- 1 Select Data that we are going to be using

SELECT Location, date, total_cases,New_cases,total_deaths, population 
FROM CovidDeathsProject
ORDER BY Location, Date;

-- 2 lOOKING AT TOTAL CASES VS TOTAL DEATHS
-- (This Will Show Likelihood Ff Dying If You Contract COVID In Your Country, I Will Use My Country 'Uganda')

SELECT Location, date, total_cases,total_deaths,(CAST(total_deaths AS FLOAT)/CAST(total_cases AS FLOAT))*100 AS Death_Percentages 
FROM CovidDeathsProject
WHERE Location LIKE '%Uganda%'
ORDER BY 1,2;

-- 3 Looking at Total_Cases VS Population
SELECT Location, date, total_cases,Population, (Cast(total_cases as float)) / (Cast(population as float ))*100 AS Death_Percentages 
FROM CovidDeathsProject
WHERE Location LIKE '%Uganda%'
ORDER BY 1,2;

-- 4 SHOWING COUNTRIES WITH THE HIGHEST INFECTION CASES
SELECT Location, MAX(cast(total_cases as float))as TotalCaseCount 
FROM CovidDeathsProject
WHERE  Location NOT IN ('WORLD','Europe','North America','European Union','South America','Africa','Asia') 
GROUP BY Location,population 
ORDER BY TotalCaseCount desc;


-- 5 SHOWING COUNTRIES WITH THE HIGHEST DEATH COUNT 
SELECT Location, MAX(cast(total_deaths as float))as TotalDeathCount 
FROM CovidDeathsProject
WHERE Location NOT IN ('WORLD','Europe','North America','European Union','South America','Africa','Asia') 
GROUP BY Location 
ORDER BY TotalDeathCount desc;


-- 6 SHOWING CONTINENTS WITH THE HIGHEST INFECTION CASES
SELECT Location, MAX(cast(total_cases as float))as TotalCaseCount 
FROM CovidDeathsProject
WHERE Location IN ('Europe','North America','European Union','South America','Africa','Asia','Oceania') 
GROUP BY Location 
ORDER BY TotalCaseCount desc;


-- 7 SHOWING CONTINENTS WITH THE HIGHEST DEATH CASES
SELECT Location, MAX(cast(total_deaths as float))as TotalDeathCount 
FROM CovidDeathsProject
WHERE location IN  ('Europe','North America','European Union','South America','Africa','Asia','Oceania') 
GROUP BY Location 
ORDER BY TotalDeathCount desc;


-- 8 OVERAL GLOBAL CASES
Select SUM(cast(New_cases as float)) as total_cases, SUM(cast(New_deaths as float)) as total_deaths, 
       SUM(cast(New_deaths as float))/SUM(cast(New_cases as float))*100 as DeathPercentage
FROM CovidDeathsProject
ORDER BY 1,2;


-- 9LOOKING AT TOTAL POPULATION VS VACCINATIONS

SELECT  *
  FROM CovidVaccinationsProject;


SELECT dea.continent, dea.location, dea.date,dea.population, vacc.new_vaccinations,
         SUM(Cast(vacc.new_vaccinations as float)) OVER(Partition BY dea.Location ORDER BY dea.Location,dea.date) AS RollingPeopleVaccinated
FROM CovidDeathsProject dea 
JOIN CovidVaccinationsProject vacc 
     ON dea.Location = vacc.Location
     AND dea.date = vacc.date
WHERE dea.continent IS NOT NULL AND vacc.Location NOT IN ('Africa', 'Asia','North America', 'South America', 'Europe','European Union', 'Oceania', 'International', 'World') 
ORDER BY  dea.continent, vacc.location, vacc.date;


-- BELOW IS A CONTINUATION OF ABOVE USING CTE
WITH PopVsVacc (Continent, location, date, population, New_Vaccinations,RollingPeopleVaccinated)
AS
(
  SELECT dea.continent, dea.location, dea.date,dea.population, vacc.new_vaccinations,
         SUM(Cast(vacc.new_vaccinations as float)) OVER(Partition BY dea.Location ORDER BY dea.Location,dea.date) AS RollingPeopleVaccinated
FROM CovidDeathsProject dea 
JOIN CovidVaccinationsProject vacc ON dea.Location = vacc.Location
     AND dea.date = vacc.date
WHERE dea.continent IS NOT NULL AND vacc.Location NOT IN ('Africa', 'Asia','North America', 'South America', 'Europe','European Union', 'Oceania', 'International', 'World') 
-- ORDER BY  dea.continent, vacc.location, vacc.date
)
SELECT *,  (RollingPeopleVaccinated /population )*100 
FROM PopVsVacc;


-- 10 CREATING VIEW TO STORE DATA FOR LATER 
-- SHOWING CONTINENTS WITH THE HIGHEST DEATH COUNT PER POPULATION

CREATE VIEW TotalDeathCountPerPopulation AS
SELECT Continent, MAX(cast(total_deaths as float))as TotalDeathCount 
FROM CovidDeathsProject
WHERE continent IS NOT NULL
-- WHERE continent IN ( 'WORLD','Europe','North America','European Union','South America','Africa','Asia','Oceania','International')
GROUP BY Continent 
-- ORDER BY TotalDeathCount desc










