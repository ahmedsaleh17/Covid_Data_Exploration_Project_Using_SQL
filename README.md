# COVID-19 Data Exploration Project Using SQL

A comprehensive data analysis project exploring global COVID-19 statistics through advanced SQL queries. This project demonstrates proficiency in data manipulation, aggregation, and analysis using MySQL.

## 📊 Project Overview

This project analyzes COVID-19 pandemic data spanning deaths and vaccination statistics across countries and continents. Through structured SQL queries, we uncover trends, calculate infection rates, death percentages, and vaccination progress to derive meaningful insights from the global health crisis.

## 🗂️ Dataset Structure

### Data Sources
- **CovidDeaths.csv** - Contains death-related metrics including cases, deaths, and population data by location and date
- **CovidVaccinations.csv** - Contains vaccination progress data with new vaccinations administered by location and date

### Tables Created
- `coviddeaths` - Deaths and case statistics indexed by location and date
- `covidvaccinations` - Vaccination progress indexed by location and date

## 🔍 Key Analyses Included

### 1. **Mortality Analysis**
- Death percentage calculations (Deaths vs Total Cases)
- Highest death count per country and continent
- Death rate trends over time
- Location-specific analysis (e.g., Egypt death rate tracking)

### 2. **Infection Rate Analysis**
- Total cases vs population comparison
- Percentage of population infected by country
- Highest infection counts globally
- Infection rate per capita ranking

### 3. **Global Statistics**
- World-wide new cases and deaths aggregation
- Global death percentage calculation
- Continental breakdown of death counts

### 4. **Vaccination Progress Tracking**
- Rolling vaccination counts by location
- Percentage of population vaccinated
- Vaccination progress over time
- Vaccination milestones by country

## 🛠️ SQL Techniques Demonstrated

- **JOINs** - Combining deaths and vaccination datasets
- **Window Functions** - Rolling sums for vaccination tracking
- **CTEs (Common Table Expressions)** - Complex calculations with PopulationVaccinated query
- **Temporary Tables** - Performance optimization for repeated calculations
- **Views** - Creating stored queries for data reusability (PercentPopulationVaccinated view)
- **Aggregation** - GROUP BY, SUM, MAX functions
- **Filtering** - WHERE clauses, NULL handling, AND/OR logic
- **Sorting & Limiting** - ORDER BY, LIMIT clauses

## 📈 Key Queries at a Glance

| Query | Purpose |
|-------|---------|
| Data Discovery | Explore structure of both datasets |
| Death Percentage | `(total_deaths / total_cases) * 100` |
| Infection Rate | `MAX((total_cases/population)) * 100` |
| Continent Analysis | Aggregate statistics by continent vs country |
| Vaccination Progress | Track rolling vaccinations with window functions |
| Population Vaccination % | Compare vaccinated population against total population |

## 🚀 Getting Started

### Prerequisites
- MySQL Server installed
- Access to the CSV data files (CovidDeaths.csv, CovidVaccinations.csv)

### Setup Instructions

1. **Create Database**
   ```sql
   CREATE DATABASE portfolio_project;
   USE portfolio_project;
   ```

2. **Import Data**
   - Import CovidDeaths.csv to `coviddeaths` table
   - Import CovidVaccinations.csv to `covidvaccinations` table

3. **Run Queries**
   - Open `Covid_Data_Exploration_Project.sql`
   - Execute queries sequentially to explore data and insights

## 📋 Sample Query Examples

### Find Highest Infection Rate by Country
```sql
SELECT location, population, 
       MAX(total_cases) as HighestInfectionCount,
       MAX((total_cases/population))*100 as HighestInfectionRate 
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY HighestInfectionRate DESC;
```

### Track Vaccination Progress with Rolling Sum
```sql
SELECT d.location, d.date, d.population, v.new_vaccinations,
       SUM(CONVERT(v.new_vaccinations, SIGNED)) OVER 
       (PARTITION BY d.location ORDER BY d.location, d.date) as RollingPeopleVaccinated
FROM coviddeaths d
JOIN covidvaccinations v 
  ON d.location = v.location AND d.date = v.date
WHERE d.continent IS NOT NULL;
```

### Calculate Vaccination Coverage Percentage Using CTE
```sql
WITH PopvsVac AS (
  SELECT d.location, d.population, v.new_vaccinations,
         SUM(CONVERT(v.new_vaccinations, SIGNED)) OVER 
         (PARTITION BY d.location ORDER BY d.date) as RollingVaccinated
  FROM coviddeaths d
  JOIN covidvaccinations v 
    ON d.location = v.location AND d.date = v.date
  WHERE d.continent IS NOT NULL
)
SELECT *, (RollingVaccinated/Population)*100 as VaccinationPercentage 
FROM PopvsVac;
```

## 💡 Key Insights

- **Global Tracking**: Analyzes 195+ countries and territories
- **Temporal Analysis**: Tracks pandemic progression from initial outbreak through vaccination rollout
- **Comparative Metrics**: Death rates, infection rates, and vaccination progress compared across regions
- **Data Quality**: Handles NULL values and continent filtering for accurate analysis

## 📚 Skills Demonstrated

- ✅ Advanced SQL Query Construction
- ✅ Data Cleaning & Validation
- ✅ Complex Joins & Relationships
- ✅ Window Functions & Partitioning
- ✅ Performance Optimization (Temp Tables & Views)
- ✅ Analytical Thinking & Problem Solving
- ✅ Data Visualization through Query Results

## 📁 File Structure
```
Covid_Data_Exploration_Project_Using_SQL/
├── Covid_Data_Exploration_Project.sql  # Main SQL queries
├── CovidDeaths.csv                     # Death statistics dataset
├── CovidVaccinations.csv               # Vaccination dataset
└── README.md                           # This file
```

## 🎯 Use Cases

Perfect for:
- **Portfolio Building** - Showcase SQL and analytical skills
- **Learning SQL** - Step-by-step real-world data analysis
- **Data Analysis Projects** - Template for handling large datasets
- **Business Intelligence** - Extract actionable insights from pandemic data

## 📝 Notes

- All queries filter by `continent IS NOT NULL` to focus on country-level analysis
- Data contains historical records up to vaccination availability
- Some queries are demonstrative; production use may require optimization for very large datasets
