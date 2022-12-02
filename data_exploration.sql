--Heroes' wins in each minute and total wins
SELECT h_stats.localized_name, l_roles.time, SUM(l_roles.games) AS total_games, SUM(l_roles.wins) AS won_games FROM dbo.heroes_stats AS h_stats LEFT JOIN dbo.lane_roles AS l_roles 
ON h_stats.hero_id=l_roles.hero_id
WHERE l_roles.time IS NOT NULL
GROUP BY 
GROUPING SETS (
(h_stats.localized_name, l_roles.time),
(h_stats.localized_name)
)


--LGD's winrate for each year
SELECT a.year, CAST(CAST(a.won AS float)/CAST(a.total AS float)*100 AS DECIMAL(4,2)) AS winrate FROM
(SELECT YEAR(DATEADD(s, matches.start_time, '1970-01-01')) AS year, 
	   COUNT(CASE WHEN matches.match_status='won' THEN 1 ELSE NULL END) as won,
	   COUNT(CASE WHEN matches.match_status='lost' THEN 1 ELSE NULL END) as lost,
	   COUNT(*) as total
FROM (SELECT *,
CASE WHEN radiant_win='False' AND radiant='False' THEN 'won'
	 WHEN radiant_win='False' AND radiant='True' THEN 'lost'
	 WHEN radiant_win='True' AND radiant='True' THEN 'won'
	 WHEN radiant_win='True' AND radiant='False' THEN 'lost'
	 END AS match_status
FROM dbo.lgd_matches) matches
GROUP BY YEAR(DATEADD(s, matches.start_time, '1970-01-01'))
) a
ORDER BY 1

--LGD's winrate against each team

SELECT a.opposing_team_name, FORMAT(CAST(a.won AS float)/CAST(a.total AS float)*100,'N2')  AS winrate FROM
(SELECT opposing_team_name, 
	   COUNT(CASE WHEN matches.match_status='won' THEN 1 ELSE NULL END) as won,
	   COUNT(CASE WHEN matches.match_status='lost' THEN 1 ELSE NULL END) as lost,
	   COUNT(*) as total
FROM (SELECT *,
CASE WHEN radiant_win='False' AND radiant='False' THEN 'won'
	 WHEN radiant_win='False' AND radiant='True' THEN 'lost'
	 WHEN radiant_win='True' AND radiant='True' THEN 'won'
	 WHEN radiant_win='True' AND radiant='False' THEN 'lost'
	 END AS match_status
FROM dbo.lgd_matches) matches
GROUP BY opposing_team_name
) a
ORDER BY 1


WITH DR_CTE AS (
SELECT *,
CASE WHEN radiant_win='False' AND radiant='False' THEN 'dire won'
	 WHEN radiant_win='False' AND radiant='True' THEN 'dire lost'
	 WHEN radiant_win='True' AND radiant='True' THEN 'radiant won'
	 WHEN radiant_win='True' AND radiant='False' THEN 'radiant lost'
	 END AS match_status
FROM dbo.lgd_matches
)

--LGD's winrate on dire and radiant side
SELECT (CAST(sub.dire_won AS FLOAT)/ CAST(sub.dire_lost+sub.dire_won AS FLOAT)*100) AS dire_winrate, 
	   (CAST(sub.radiant_won AS FLOAT)/ CAST(sub.radiant_lost+sub.radiant_won AS FLOAT)*100) AS radiant_winrate
	   FROM (
SELECT COUNT(CASE WHEN match_status='dire won' THEN 1 ELSE NULL END) as dire_won,
	   COUNT(CASE WHEN match_status='dire lost' THEN 1 ELSE NULL END) as dire_lost,
	   COUNT(CASE WHEN match_status='radiant won' THEN 1 ELSE NULL END) as radiant_won,
	   COUNT(CASE WHEN match_status='radiant lost' THEN 1 ELSE NULL END) as radiant_lost
FROM DR_CTE
) sub



GO
CREATE FUNCTION dbo.calculate_max1(@val1 INT, @val2 INT)
RETURNS INT
AS
BEGIN
  IF @val1 > @val2
    RETURN @val1
  RETURN isnull(@val2,@val1)
END
GO 

WITH KDA_CTE AS
(
SELECT hero_id, kills+assists/dbo.calculate_max1(deaths,1) AS kda FROM dbo.nisha_matches
)

-- Nisha's average kda for each hero
SELECT heroes.localized_name, AVG(CAST(kda AS FLOAT)) as avg_kda FROM KDA_CTE INNER JOIN dbo.heroes AS heroes ON KDA_CTE.hero_id=heroes.id
GROUP BY heroes.localized_name
ORDER BY avg_kda DESC


--Nisha's kda grouped by heroes attributes
SELECT heroes.primary_attr, AVG(CAST(kda AS FLOAT)) as avg_kda FROM KDA_CTE INNER JOIN dbo.heroes AS heroes ON KDA_CTE.hero_id=heroes.id
GROUP BY heroes.primary_attr
ORDER BY avg_kda DESC


-- Nisha's winratio on support heroes
SELECT localized_name, (CAST(win AS FLOAT)/CAST(games AS FLOAT))*100 AS core_wins
FROM dbo.nisha_heroes INNER JOIN dbo.heroes ON dbo.nisha_heroes.hero_id=dbo.heroes.id 
WHERE roles LIKE '%Support%' AND games <> 0


--Number of pro players grouped by region and country
SELECT countries.COUNTRY_NAME, countries.UN_SUBREGION_NAME, COUNT(*) as players_by_country FROM dbo.pro_players as players INNER JOIN dbo.cdh_country_codes$ as countries
ON players.loccountrycode=countries.COUNTRY_CHAR3_CODE
WHERE (players.loccountrycode NOT LIKE 0) AND (players.loccountrycode <> '') AND LEFT(last_login,4)='2022'
GROUP BY 
GROUPING SETS (
(countries.COUNTRY_NAME),
(countries.UN_SUBREGION_NAME)
)





