select * from CovidDeaths;

select * from CovidVaccinations;

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths;

--   Lokking at the Total Cases Vs Total Deaths
--   Shows % of death as cases are increasing in india.

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as 'death_percentage'
from CovidDeaths where location = 'india' order by date;


--   Looking at total_cases vs population.


select location, date, population, total_cases, (total_cases/population)*100 as 'cases_percentage'
from CovidDeaths where location = 'india' order by date;


--   Looking at countries with highest infection rate compared to population

select location, population, max(total_cases) as 'highest_infection_count', max((total_cases/population)*100) as '%population_affected'
from CovidDeaths
group by location, population
order by max((total_cases/population)*100) desc;


--  looking for countries with highest death count per population

alter table coviddeaths 
alter column total_deaths int;

select location, population, max(total_deaths) as 'total death count', max((total_deaths/population)*100) as 'death rate'
from CovidDeaths
where continent is not null
group by location, population
order by  max(total_deaths) desc;

-- showing continent with highest death counts

create view continent_cases
as
select continent, max(total_deaths) as 'total death count'
from CovidDeaths
where continent is not null
group by continent;

-- Global Numbers

alter table coviddeaths 
alter column new_deaths int;

create view global_numbers
as
select date, sum(new_cases) as 'total cases', sum(new_deaths) as 'total deaths'
from CovidDeaths
group by date;

--  Lokking at global population Vs total vaccinated population

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as 'total_popualtion_vaccinated'
from CovidDeaths dea
inner join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 1,2,3;



-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations,total_popualtion_vaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as 'total_popualtion_vaccinated'
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (total_popualtion_vaccinated/Population)*100 as 'Percent_population_vaccinated' 
From PopvsVac;

-- Using Temp Table to perform Calculation on Partition By in previous query


Create Table PopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
Date date,
Population int,
New_vaccinations int,
population_vaccinated int
)

Insert into PopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as 'total_popualtion_vaccinated'
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date




-- Creating View to store data for later visualizations

Create View PerPopulationVaccinated
 as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as 'total_popualtion_vaccinated'
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null;

