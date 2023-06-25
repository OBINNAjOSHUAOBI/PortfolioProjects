select *
from CovidDeaths
where continent is not null
order by 3,4

select *
from CovidVaccinations
order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1,2

select location, date, total_cases, total_deaths 
from CovidDeaths
where location like '%nigeria%'
order by 1,2

select location, date, population, total_cases,  (total_cases/population)*100 as PercentageCases
from CovidDeaths
where location like '%nigeria%'
order by 1,2

select location, population, max(total_cases) as HighestPrevalence,  max((total_cases/population))*100 as PrevalencePercentage
from CovidDeaths
where continent is not null
group by location, population
order by PrevalencePercentage desc

select location, max(cast (total_deaths as int)) as DeathCount
from CovidDeaths
where continent is not null
group by location
order by DeathCount desc

select location, max(cast (total_deaths as int)) as DeathCount
from CovidDeaths
where continent is null
group by location
order by DeathCount desc

select continent, max(cast (total_deaths as int)) as DeathCount
from CovidDeaths
where continent is not null
group by continent
order by DeathCount desc

select date, sum(new_cases) as total_cases, sum (cast(new_deaths as int)) as total_deaths
from CovidDeaths
where continent is not null
group by date
order by 1,2

select sum(new_cases) as total_cases, sum (cast(new_deaths as int)) as total_deaths, sum (cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from CovidDeaths
where continent is not null
--group by date
order by 1,2

select *
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location and dea.date = vac.date 


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 1,2,3


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as CumulativeVaccination
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 2,3

with PopvsVac (continent, location, date, population, new_vaccinations, CumulativeVaccination)
as
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as CumulativeVaccination
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
)
select *, (CumulativeVaccination/population)*100
from PopvsVac

create view CumulativeVacciatons as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as CumulativeVaccination
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
--order by 2,3

create view 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
order by 1,2,3