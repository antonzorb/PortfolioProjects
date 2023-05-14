--select * from coviddeaths
--select *from CovidVaccinations


--Select data that i am gonna use
select location,date, total_cases,new_cases,total_deaths,population
from coviddeaths
order by 1,2

--Death Percentage - Greece

select location,date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from coviddeaths
where lower(location) like '%greece%'
order by 1,2


--Total Cases vs Population

select location,date,total_cases,population,(total_cases/population)*100 as CasesPercentage
from coviddeaths
where lower(location) like '%greece%'
order by 1,2


--Looking at Countries with highest infection rate per Population
select location,max(total_cases)as HighestInfectionCount,population,max((total_cases/population))*100 as PercentPopulationInfected
from coviddeaths
where continent is not null
group by location,population
order by 4 desc


--Looking at Countries with highest Death Count per population

select location,max(cast(total_deaths as int))as TotalDeathCount,population,max((total_deaths/population))*100 as PercentPopulationDied
from coviddeaths
where continent is not null
group by location,population
order by 4 desc


-- Group by Continent

select continent,max(cast(total_deaths as int))as TotalDeathCount
from coviddeaths
where continent is not null
group by continent
order by TotalDeathCount desc


--Global Numbers

select date,sum(new_cases)as SumNewCases,sum(cast(new_deaths as int))as SumNewDeaths, (sum(cast(new_deaths as int)) / sum(new_cases))*100 as pct
from coviddeaths
group by date
having sum(new_cases) is not null
order by 1,2


--Death Percentage across the world by day

select date,sum(new_cases)as TotalCases,sum(cast(new_deaths as int))as TotalDeaths,(sum(cast(new_deaths as int)) / sum(new_cases))*100 as DeathPct
from coviddeaths
where continent is not null
group by date
having sum(new_cases) is not null
order by 1,2


--Total Cases vs Total Deaths and pct -Worldwide

select sum(new_cases)as TotalCases,sum(cast(new_deaths as int))as TotalDeaths,(sum(cast(new_deaths as int)) / sum(new_cases))*100 as DeathPct
from coviddeaths
where continent is not null
order by 1,2



--Looking at Total Population vs Vaccinations by the help of cte

with PopvsVac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select d.continent,d.location,d.date,d.population,c.new_vaccinations
,sum(convert(int,new_vaccinations)) over(partition by d.location order by d.location,d.date) as RollingPeopleVaccinated
from coviddeaths d
join covidVaccinations c
on d.location = c.location
and d.date = c.date
where d.continent is not null
)

select *, ((rollingpeoplevaccinated/population)/100) as RollingPeopleVaccinated_Pct
from PopvsVac



--Create View to store data for later visualizations

create view PercentPopulationVaccinated as
select d.continent,d.location,d.date,d.population,c.new_vaccinations
,sum(convert(int,new_vaccinations)) over(partition by d.location order by d.location,d.date) as RollingPeopleVaccinated
from coviddeaths d
join covidVaccinations c
on d.location = c.location
and d.date = c.date
where d.continent is not null


select * from
percentpopulationvaccinated








