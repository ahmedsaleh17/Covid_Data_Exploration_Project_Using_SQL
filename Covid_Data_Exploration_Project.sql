-- Discover the Covid Deaths Table :
SELECT *
FROM portfolio_project.coviddeaths
WHERE continent is not Null 
order by location , date ; 


-- Discover the Covid Vaccinations Table: 
SELECT * 
FROM portfolio_project.covidvaccinations
ORDER BY location , date;	

-- Select Data that we are going to use 
SELECT location , date , total_cases ,new_cases ,total_deaths , population
FROM portfolio_project.coviddeaths
WHERE continent is not Null
order by location , date ;

-- Find the percentage of deaths 
-- looking at Total Cases VS Total Deaths : 
SELECT location , date , total_cases , total_deaths , (total_deaths / total_cases)*100 as PercentageDeahts 
FROM portfolio_project.coviddeaths
WHERE continent is not Null
ORDER BY location ,date;

-- Total Cases VS Total Deaths in Egypt for Example : 
-- find the  days which have the most Percentage of deaths (deaths rate comparing by total cases) : 

SELECT location , date , total_cases , total_deaths , (total_deaths / total_cases)*100 as PercentageDeahts 
FROM portfolio_project.coviddeaths
WHERE location = 'Egypt' and continent is not Null
ORDER BY PercentageDeahts desc
LIMIT 10;

-- Looking at Total Cases VS Population :
-- Shows What is the percentage of people got covid : 


-- Shows what is the country has the max number of total cases  
SELECT location , population, MAX(total_cases) as HighestInfectionCount 
FROM portfolio_project.coviddeaths
WHERE continent is not Null
GROUP BY location , population
ORDER BY 3 DESC;

-- Looking at the country with highest infection rate compared to population 

SELECT location , population, MAX(total_cases) as HighestInfectionCount , MAX((total_cases/population))*100 as HighestInfectionRate 
FROM portfolio_project.coviddeaths
WHERE continent is not Null
GROUP BY location,population
ORDER BY HighestInfectionRate DESC; 

-- Showing Countries with the Highest Death Count Per Population 

SELECT location , MAX(CAST(total_deaths AS SIGNED)) as TotalDeathCount
FROM portfolio_project.coviddeaths
WHERE continent is not Null
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Showing Continent with the Highest Death Count Per Population 

SELECT 
    continent,
    MAX(CAST(total_deaths AS SIGNED)) AS TotalDeathCount
FROM
    portfolio_project.coviddeaths
WHERE
    continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;


-- showing total number of new_cases and new_deaths and find the DeathPercentage for the whole world:

SELECT 
    SUM(new_cases) AS total_newcases,
    SUM(new_deaths) AS total_newdeaths,
    (SUM(new_deaths) / SUM(new_cases)) * 100 AS NewDeathPercentage
FROM
    portfolio_project.coviddeaths
WHERE
    continent IS NOT NULL;


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
SELECT d.continent , d.location , d.date, d.population , v.new_vaccinations,
SUM(CONVERT(v.new_vaccinations ,SIGNED)) OVER (partition by d.location order by d.location , d.date) as RollingPeopleVaccinated
FROM portfolio_project.coviddeaths d
JOIN portfolio_project.covidvaccinations v
	ON d.location = v.location 
    and d.date = v.date
WHERE d.continent is not null ;   

-- Using CTE to perform Calculation on Partition By in previous query (Subqueries)

With PopvsVac as
(
SELECT d.continent , d.location , d.date, d.population , v.new_vaccinations,
SUM(CONVERT(v.new_vaccinations ,SIGNED)) OVER (partition by d.location order by d.location , d.date) as RollingPeopleVaccinated
FROM portfolio_project.coviddeaths d
JOIN portfolio_project.covidvaccinations v 
	ON d.location = v.location 
    and d.date = v.date
WHERE d.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100 
From PopvsVac ;


-- Temp Table: 
USE portfolio_project;
DROP TABLE IF EXISTS PercentPopulationVaccinated;

CREATE TEMPORARY TABLE PercentPopulationVaccinated  
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
SUM(CONVERT(v.new_vaccinations, SIGNED)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingPeopleVaccinated
FROM portfolio_project.coviddeaths d
JOIN portfolio_project.covidvaccinations v 
	ON d.location = v.location 
    AND d.date = v.date
WHERE d.continent IS NOT NULL
AND v.new_vaccinations != '' ; 
-- show the data in the temporary table i created 
select * 
from portfolio_project.PercentPopulationVaccinated
limit 10 ; 


-- Creating view to store data
CREATE VIEW PercentPopulationVaccinated  as
SELECT d.continent , d.location , d.date, d.population , v.new_vaccinations,
SUM(CONVERT(v.new_vaccinations ,SIGNED)) OVER (partition by d.location order by d.location , d.date) as RollingPeopleVaccinated
FROM portfolio_project.coviddeaths d
JOIN portfolio_project.covidvaccinations v 
	ON d.location = v.location 
    and d.date = v.date
WHERE d.continent is not null
