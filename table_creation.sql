CREATE TABLE heroes (
	id INT PRIMARY KEY NOT NULL,
	name NVARCHAR(100) NOT NULL,
	localized_name NVARCHAR(100) NOT NULL,
	primary_attr NVARCHAR(3) NOT NULL,
	attack_type NVARCHAR(10) NOT NULL,
	roles NVARCHAR(MAX) NOT NULL,
	legs INT
)

 INSERT INTO heroes 
 SELECT id, name, localized_name, primary_attr, attack_type, roles, legs
 FROM OPENROWSET (BULK 'E:\dota\heroes.json', SINGLE_CLOB) AS j
 CROSS APPLY OPENJSON(BulkColumn)
 WITH( id INT, name NVARCHAR(100), localized_name NVARCHAR(100), primary_attr NVARCHAR(3), attack_type NVARCHAR(10), [roles] NVARCHAR(MAX) as JSON, legs INT) AS heroes




 CREATE TABLE heroes_stats (
	id INT PRIMARY KEY NOT NULL,
	name NVARCHAR(100) NOT NULL,
	localized_name NVARCHAR(100) NOT NULL,
	primary_attr NVARCHAR(3) NOT NULL,
	attack_type NVARCHAR(10) NOT NULL,
	roles NVARCHAR(MAX) NOT NULL,
	img NVARCHAR(100) NOT NULL,
	icon NVARCHAR(100) NOT NULL,
	base_health INT NOT NULL,
	base_health_regen FLOAT NOT NULL,
	base_mana INT NOT NULL,
	base_mana_regen FLOAT,
	base_armor FLOAT,
	base_mr INT NOT NULL,
	base_attack_min INT NOT NULL,
	base_attack_max INT NOT NULL,
	base_str INT NOT NULL,
	base_agi INT NOT NULL,
	base_int INT NOT NULL,
	str_gain FLOAT NOT NULL,
	agi_gain FLOAT NOT NULL,
	int_gain FLOAT NOT NULL,
	attack_range INT NOT NULL,
	projectile_speed INT,
	attack_rate FLOAT NOT NULL,
	move_speed INT NOT NULL,
	turn_rate FLOAT,
	cm_enabled BIT NOT NULL,
	legs INT,
	hero_id INT FOREIGN KEY REFERENCES heroes(id),
	turbo_picks INT,
	turbo_wins INT,
	pro_ban INT,
	pro_win INT,
	pro_pick INT,
	[1_pick] INT,
	[1_win] INT,
    [2_pick] INT,
	[2_win] INT,
	[3_pick] INT,
	[3_win] INT,
	[4_pick] INT,
	[4_win] INT,
	[5_pick] INT,
	[5_win] INT,
	[6_pick] INT,
	[6_win] INT,
	[7_pick] INT,
	[7_win] INT,
	[8_pick] INT,
	[8_win] INT,
	 null_pick INT,
	 null_win INT
)

 INSERT INTO heroes_stats 
 SELECT id, name, localized_name, primary_attr, attack_type, roles, img, icon, base_health, base_health_regen, base_mana, base_mana_regen, base_armor, base_mr,
 base_attack_min, base_attack_max, base_str, base_agi, base_int, str_gain, agi_gain, int_gain, attack_range, projectile_speed, attack_rate, move_speed,
 turn_rate, cm_enabled, legs, hero_id, turbo_picks, turbo_wins, pro_ban, pro_win, pro_pick, [1_pick], [1_win], [2_pick], [2_win], [3_pick], [3_win], [4_pick], [4_win], [5_pick], [5_win],
 [6_pick], [6_win], [7_pick], [7_win], [8_pick], [8_win], null_pick, null_win
 FROM OPENROWSET (BULK 'E:\dota\heroes_stats.json', SINGLE_CLOB) AS j
 CROSS APPLY OPENJSON(BulkColumn)
 WITH( id INT, name NVARCHAR(100), localized_name NVARCHAR(100), primary_attr NVARCHAR(3), attack_type NVARCHAR(10), [roles] NVARCHAR(MAX) as JSON, 
 	img NVARCHAR(100),
	icon NVARCHAR(100),
	base_health INT,
	base_health_regen FLOAT,
	base_mana INT,
	base_mana_regen FLOAT,
	base_armor FLOAT,
	base_mr INT,
	base_attack_min INT,
	base_attack_max INT,
	base_str INT,
	base_agi INT,
	base_int INT,
	str_gain FLOAT,
	agi_gain FLOAT,
	int_gain FLOAT,
	attack_range INT,
	projectile_speed INT,
	attack_rate FLOAT,
	move_speed INT,
	turn_rate FLOAT,
	cm_enabled BIT,
	legs INT,
	hero_id INT,
	turbo_picks INT,
	turbo_wins INT,
	pro_ban INT,
	pro_win INT,
	pro_pick INT,
	[1_pick] INT,
	[1_win] INT,
    [2_pick] INT,
	[2_win] INT,
	[3_pick] INT,
	[3_win] INT,
	[4_pick] INT,
	[4_win] INT,
	[5_pick] INT,
	[5_win] INT,
	[6_pick] INT,
	[6_win] INT,
	[7_pick] INT,
	[7_win] INT,
	[8_pick] INT,
	[8_win] INT,
	 null_pick INT,
	 null_win INT) AS heroes_stats



CREATE TABLE lane_roles (
	hero_id INT FOREIGN KEY REFERENCES heroes(id),
	lane_role INT NOT NULL,
	time INT NOT NULL,
	games INT,
	wins INT
)

 INSERT INTO lane_roles 
 SELECT hero_id, lane_role, time, games, wins
 FROM OPENROWSET (BULK 'E:\dota\lane_roles.json', SINGLE_CLOB) AS j
 CROSS APPLY OPENJSON(BulkColumn)
 WITH(hero_id INT, lane_role INT, time INT, games INT, wins INT) AS lane_roles


 CREATE TABLE leagues (
	leagueid INT PRIMARY KEY NOT NULL,
	ticket NVARCHAR(100),
	banner NVARCHAR(100),
	tier NVARCHAR(100),
	name NVARCHAR(100)
)

 INSERT INTO leagues 
 SELECT leagueid, ticket, banner, tier, name
 FROM OPENROWSET (BULK 'E:\dota\leagues.json', SINGLE_CLOB) AS j
 CROSS APPLY OPENJSON(BulkColumn)
 WITH(leagueid INT, ticket NVARCHAR(100), banner NVARCHAR(100), tier NVARCHAR(100), name NVARCHAR(100)) AS leagues




CREATE TABLE lgd_heroes (
	hero_id INT FOREIGN KEY REFERENCES heroes(id),
	localized_name NVARCHAR(100) NOT NULL,
	games_played INT,
	wins INT
)

 INSERT INTO lgd_heroes 
 SELECT hero_id, localized_name, games_played, wins
 FROM OPENROWSET (BULK 'E:\dota\lgd_heroes.json', SINGLE_CLOB) AS j
 CROSS APPLY OPENJSON(BulkColumn)
 WITH(hero_id INT, localized_name NVARCHAR(100), games_played INT, wins INT) AS lgd_heroes




 CREATE TABLE lgd_matches (
	match_id BIGINT PRIMARY KEY,
	radiant_win BIT NOT NULL,
	radiant BIT NOT NULL,
	duration INT NOT NULL,
	start_time INT NOT NULL,
	leagueid INT FOREIGN KEY REFERENCES leagues(leagueid),
	league_name VARCHAR(100),
	cluster INT NOT NULL,
	opposing_team_id INT NOT NULL,
	opposing_team_name VARCHAR(100) NOT NULL,
	opposing_team_logo VARCHAR(100)
)



 INSERT INTO lgd_matches 
 SELECT match_id, radiant_win, radiant, duration, start_time, leagueid, league_name, cluster, opposing_team_id, opposing_team_name, opposing_team_logo
 FROM OPENROWSET (BULK 'E:\dota\lgd_matches.json', SINGLE_CLOB) AS j
 CROSS APPLY OPENJSON(BulkColumn)
 WITH(match_id BIGINT,
	radiant_win BIT,
	radiant BIT,
	duration INT,
	start_time INT,
	leagueid INT,
	league_name VARCHAR(100),
	cluster INT,
	opposing_team_id INT,
	opposing_team_name VARCHAR(100),
	opposing_team_logo VARCHAR(100)) AS lgd_matches


CREATE TABLE pro_players (
	account_id INT PRIMARY KEY NOT NULL,
	steamid BIGINT NOT NULL,
	avatar NVARCHAR(100) NOT NULL,
	avatarmedium NVARCHAR(100) NOT NULL,
	avatarfull NVARCHAR(100) NOT NULL,
	profileurl NVARCHAR(100) NOT NULL,
	personaname NVARCHAR(100) NOT NULL,
	last_login NVARCHAR(100),
	full_history_time NVARCHAR(100),
	cheese FLOAT,
	fh_unavailable FLOAT,
	loccountrycode NVARCHAR(2),
	last_match_time DATETIME,
	plus BIT,
	fantasy_role FLOAT,
	team_id INT,
	team_name NVARCHAR(100),
	team_tag NVARCHAR(50),
	is_locked BIT,
	is_pro BIT,
	locked_until BIT
)


 INSERT INTO pro_players 
 SELECT account_id, steamid, avatar, avatarmedium, avatarfull, profileurl, personaname, last_login, full_history_time, cheese, fh_unavailable,
 loccountrycode, last_match_time, plus, fantasy_role, team_id, team_name, team_tag, is_locked, is_pro, locked_until
 FROM OPENROWSET (BULK 'E:\dota\pro_players.json', SINGLE_CLOB) AS j
 CROSS APPLY OPENJSON(BulkColumn)
 WITH(	account_id INT,
	steamid BIGINT,
	avatar NVARCHAR(100),
	avatarmedium NVARCHAR(100),
	avatarfull NVARCHAR(100),
	profileurl NVARCHAR(100),
	personaname NVARCHAR(100),
	last_login NVARCHAR(100),
	full_history_time NVARCHAR(100),
	cheese FLOAT,
	fh_unavailable BIT,
	loccountrycode NVARCHAR(2),
	last_match_time DATETIME,
	plus BIT,
	fantasy_role FLOAT,
	team_id INT,
	team_name NVARCHAR(100),
	team_tag NVARCHAR(50),
	is_locked BIT,
	is_pro BIT,
	locked_until BIT) AS pro_players


CREATE TABLE teams (
	team_id INT PRIMARY KEY NOT NULL,
	rating FLOAT,
	wins INT,
	losses INT,
	last_match_time NVARCHAR(100),
	name NVARCHAR(100),
	tag NVARCHAR(50),
	logo_url NVARCHAR(100)
)


INSERT INTO teams 
 SELECT team_id, rating, wins, losses, last_match_time, name, tag, logo_url
 FROM OPENROWSET (BULK 'E:\dota\teams.json', SINGLE_CLOB) AS j
 CROSS APPLY OPENJSON(BulkColumn)
 WITH(team_id INT,
	rating FLOAT,
	wins INT,
	losses INT,
	last_match_time NVARCHAR(100),
	name NVARCHAR(100),
	tag NVARCHAR(50),
	logo_url NVARCHAR(100)) AS teams



CREATE TABLE nisha_rankings (
	account_id BIGINT NOT NULL,
	match_id BIGINT NOT NULL,
	solo_competitive_rank INT,
	competitive_rank INT,
	time DATETIME 
)


INSERT INTO nisha_rankings 
 SELECT account_id, match_id, solo_competitive_rank, competitive_rank, time
 FROM OPENROWSET (BULK 'E:\dota\nisha_rankings.json', SINGLE_CLOB) AS j
 CROSS APPLY OPENJSON(BulkColumn)
 WITH(account_id INT,
	match_id BIGINT,
	solo_competitive_rank BIGINT,
	competitive_rank INT,
	time DATETIME) AS nisha_rankings


CREATE TABLE nisha_matches (
	match_id BIGINT NOT NULL,
	player_slot INT,
	radiant_win BIT,
	duration INT,
	game_mode INT,
	lobby_type INT,
	hero_id INT FOREIGN KEY REFERENCES heroes(id),
	start_time  NVARCHAR(100),
	version INT,
	kills INT,
	deaths INT,
	assists INT,
	skill INT,
	average_rank INT,
	leaver_status BIT,
	party_size INT
)


INSERT INTO nisha_matches 
 SELECT match_id, player_slot, radiant_win, duration, game_mode, lobby_type, hero_id, start_time, version, kills, deaths, assists, skill, average_rank, leaver_status, party_size
 FROM OPENROWSET (BULK 'E:\dota\nisha_matches.json', SINGLE_CLOB) AS j
 CROSS APPLY OPENJSON(BulkColumn)
 WITH(	match_id BIGINT,
	player_slot INT,
	radiant_win BIT,
	duration INT,
	game_mode INT,
	lobby_type INT,
	hero_id INT,
	start_time NVARCHAR(100),
	version INT,
	kills INT,
	deaths INT,
	assists INT,
	skill INT,
	average_rank INT,
	leaver_status BIT,
	party_size INT) AS nisha_rankings




CREATE TABLE nisha_heroes (
	hero_id INT,
	last_played BIGINT,
	games INT,
	win INT,
	with_games INT,
	with_win INT,
	against_games INT,
	against_win INT
)


INSERT INTO nisha_heroes 
 SELECT hero_id, last_played, games, win, with_games, with_win, against_games, against_win
 FROM OPENROWSET (BULK 'E:\dota\nisha_heroes.json', SINGLE_CLOB) AS j
 CROSS APPLY OPENJSON(BulkColumn)
 WITH(hero_id INT,
	last_played BIGINT,
	games INT,
	win INT,
	with_games INT,
	with_win INT,
	against_games INT,
	against_win INT) AS nisha_heroes


CREATE TABLE lgd_players (
	account_id INT,
	name NVARCHAR(100),
	games_played INT,
	wins INT,
	is_current_team_member BIT
)


INSERT INTO lgd_players 
 SELECT account_id, name, games_played, wins, is_current_team_member
 FROM OPENROWSET (BULK 'E:\dota\lgd_players.json', SINGLE_CLOB) AS j
 CROSS APPLY OPENJSON(BulkColumn)
 WITH(account_id INT,
	name NVARCHAR(100),
	games_played INT,
	wins INT,
	is_current_team_member BIT) AS lgd_players



CREATE TABLE nisha_hero_rankings (
	hero_id INT FOREIGN KEY REFERENCES heroes(id),
	score FLOAT,
	percent_rank FLOAT,
	card INT
)


INSERT INTO nisha_hero_rankings 
 SELECT hero_id, score, percent_rank, card
 FROM OPENROWSET (BULK 'E:\dota\nisha_hero_rankings.json', SINGLE_CLOB) AS j
 CROSS APPLY OPENJSON(BulkColumn)
 WITH(	hero_id INT,
	score FLOAT,
	percent_rank FLOAT,
	card INT) AS nisha_hero_rankings



CREATE TABLE pro_matches (
	match_id BIGINT PRIMARY KEY NOT NULL,
	duration INT,
	start_time BIGINT NOT NULL,
	radiant_team_id BIGINT NOT NULL,
	radiant_name NVARCHAR(100),
	dire_team_id BIGINT NOT NULL,
	dire_name NVARCHAR(100),
	leagueid INT FOREIGN KEY REFERENCES leagues(leagueid),
	league_name NVARCHAR(100),
	series_id INT,
	series_type INT,
	radiant_score INT,
	dire_score INT,
	radiant_win BIT
)


INSERT INTO pro_matches 
 SELECT match_id, duration, start_time, radiant_team_id, radiant_name, dire_team_id, dire_name, leagueid, league_name, series_id, series_type, radiant_score, dire_score, radiant_win
 FROM OPENROWSET (BULK 'E:\dota\pro_matches.json', SINGLE_CLOB) AS j
 CROSS APPLY OPENJSON(BulkColumn)
 WITH(match_id BIGINT,
	duration INT,
	start_time BIGINT,
	radiant_team_id BIGINT,
	radiant_name NVARCHAR(100),
	dire_team_id BIGINT,
	dire_name NVARCHAR(100),
	leagueid INT,
	league_name NVARCHAR(100),
	series_id INT,
	series_type INT,
	radiant_score INT,
	dire_score INT,
	radiant_win BIT) AS pro_matches

