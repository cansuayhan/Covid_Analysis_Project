/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

SELECT *
From Covid_Project.coviddeaths;

SELECT * 
From Covid_Project.covidvaccinations;

-- Select the data that we are going to be using 

Select Location, date, total_cases, new_cases, total_deaths, population
From Covid_Project.coviddeaths
order by 1,2;

-- Looking at Total Cases vs Total Deaths 
-- shows likelyhood of dying if you contract in your country

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From Covid_Project.coviddeaths
Where location like '%state%'
order by 1,2;


-- Looking at total cases vs population
-- Shows what percentage of population got covid 

Select Location, date, population, total_cases,( total_cases/ population)*100 as Covid_Percentage
From Covid_Project.coviddeaths
-- Where location like '%state%'
order by 1,2;


-- Looking at Countries with highest Infection Rate 

Select Location, population, MAX(total_cases) as Highest_Rank, MAX((total_cases/ population))*100 as Infect_Rate
From Covid_Project.coviddeaths
-- Where location like '%state%'
group by location, population  
order by Highest_Rank desc ;

-- Showing countries with Highest Death Count per Population

Select location, MAX(total_deaths) as Total_Death_Count 
From Covid_Project.coviddeaths
-- Where location like '%state%'
where continent is not null
group by location
order by Total_Death_Count desc ;

-- LETS BREAK THNGS DOWN BY CONTİNENT

Select continent, MAX(total_deaths) as Total_Death_Count 
From Covid_Project.coviddeaths
where continent is not null
group by continent
order by Total_Death_Count desc ;


-- Showing continents with the highest death count per population

Select continent, population, MAX(total_deaths) as Total_Death_Count 
From Covid_Project.coviddeaths
where continent is not null
group by continent, population
order by Total_Death_Count desc ;


-- global numbers
 

Select  date, sum(new_deaths) as total_deaths, sum(new_cases) as total_cases, sum(new_deaths)/sum(new_cases)*100 as new_death_ratio
From Covid_Project.coviddeaths
where continent is not null
group by date;


-- full table (vac and death together)

SELECT * 
From Covid_Project.coviddeaths dea
join Covid_Project.covidvaccinations vac
on dea.continent = vac.continent
 and dea.location = vac.location
 and dea.date = vac.date;
 
 -- Looking at total population vs Vaccination
 -- Shows Percentage of Population that has recieved at least one Covid Vaccine


 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, vac.new_vaccinations/dea.population*100 as vacc_ratio
 From Covid_Project.coviddeaths dea
join Covid_Project.covidvaccinations vac
on dea.continent = vac.continent
 and dea.location = vac.location
 and dea.date = vac.date
 order by 1,2,3;
 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,
dea.date ) as RollingPeopleVaccinated -- , (RollingPeopleVaccinated/population)*100 
From Covid_Project.coviddeaths dea
join Covid_Project.covidvaccinations vac
on dea.continent = vac.continent
 and dea.location = vac.location
 and dea.date = vac.date
 order by 1,2,3;
 
 
 -- USE CTE to perform Calculation on Partition By in previous query
 
With PopvsVacc
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,
dea.date ) as RollingPeopleVaccinated 
-- , (RollingPeopleVaccinated/population)*100 
From Covid_Project.coviddeaths dea
join Covid_Project.covidvaccinations vac
 on dea.continent = vac.continent
 and dea.location = vac.location
 and dea.date = vac.date
 )
 
 Select *, (RollingPeopleVaccinated/population)*100 as RollingVaccRatio
 From PopvsVacc;




