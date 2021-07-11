select *
from ProtfolioProject..CovidDeath$
order by 3,4

--select *
--from ProtfolioProject..CovidVaccination$
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from ProtfolioProject..CovidDeaths$
order by 1,2

--Looking at total cases vs total Deaths
--Shows likelihood of dying if you contract covid in your country
select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from ProtfolioProject..CovidDeaths$
where Location like '%india%'
order by 1,2

--Looking at total cases vs population
select Location,date,population,total_cases,(total_cases/population)*100 as deathpercentage
from ProtfolioProject..CovidDeaths$
where location like '%india%'
order by 1,2

--looking at countries with highest infection rate compares to population 

select Location,population,MAX(total_cases)as highestinfectioncount, max((total_cases/population))*100 as
  percentpopulationinfected 
from ProtfolioProject..CovidDeaths$
--where location like '%states%'
group by location,population
order by percentpopulationinfected desc

--showing countries with highest death count per population 

select Location,MAX(cast(total_deaths as int)) as totaldeathcount
from ProtfolioProject..CovidDeaths$
--where location like '%states%'
where continent is not null
group by location
order by totaldeathcount desc

--lets break things down by continent

select continent,MAX(cast(total_deaths as int)) as totaldeathcount
from ProtfolioProject..CovidDeaths$
--where location like '%states%'
where continent is not null
group by continent
order by totaldeathcount desc 

--GLOBAL NUMBERS 

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathsPercentage
from ProtfolioProject..CovidDeaths$
--where location like '%states%'
where continent is not null
group by date
order by 1,2

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathsPercentage
from ProtfolioProject..CovidDeaths$
--where location like '%states%'
where continent is not null
--group by date
order by 1,2

select * 
From ProtfolioProject..CovidVaccination$

select * 
From ProtfolioProject..CovidDeaths$ dea
Join ProtfolioProject..CovidVaccination$ vac
    On dea.location = vac.location
	and dea.date = vac.date

--Looking at Total Population vs Vaccinations
    
select dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations
From ProtfolioProject..CovidDeaths$ dea
Join ProtfolioProject..CovidVaccination$ vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

select dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations
,SUM(convert(int,vac.new_vaccinations)) over (Partition by dea.Location order by dea.location,dea.date) as
rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
From ProtfolioProject..CovidDeaths$ dea
Join ProtfolioProject..CovidVaccination$ vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- use CTE

With PopvsVac (continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as 
(
select dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations
,SUM(convert(int,vac.new_vaccinations)) over (Partition by dea.Location order by dea.location,dea.date) as
rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
From ProtfolioProject..CovidDeaths$ dea
Join ProtfolioProject..CovidVaccination$ vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *,(rollingpeoplevaccinated/population)*100
from PopvsVac

--TEMP TABLE
drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)


insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations
,SUM(convert(int,vac.new_vaccinations)) over (Partition by dea.Location order by dea.location,dea.date) as
rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
From ProtfolioProject..CovidDeaths$ dea
Join ProtfolioProject..CovidVaccination$ vac
    On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *,(rollingpeoplevaccinated/population)*100
from #percentpopulationvaccinated

--creating view to store data for later visualizations
 
create view percentpopulationvaccinated as
select dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations
,SUM(convert(int,vac.new_vaccinations)) over (Partition by dea.Location order by dea.location,dea.date) as
rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
From ProtfolioProject..CovidDeaths$ dea
Join ProtfolioProject..CovidVaccination$ vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * 
from percentpopulationvaccinated