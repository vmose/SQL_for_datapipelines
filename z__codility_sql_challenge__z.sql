-- CODILITY SQL CHALLENGE
-- Create a union table of the sum of points per team 
CREATE VIEW team_points AS
SELECT host_team AS team_id, SUM(host_points_tmp.host_points) AS team_points
FROM
(SELECT 
  host_team,
  CASE 
    WHEN host_goals > guest_goals THEN 3
    WHEN host_goals = guest_goals THEN 1
    ELSE 0
    END AS host_points
FROM matches) AS host_points_tmp
GROUP BY host_points_tmp.host_team

UNION ALL

SELECT guest_team AS team_id, SUM(guest_points_tmp.guest_points) AS team_points
FROM
(SELECT 
  guest_team,
  CASE 
    WHEN host_goals < guest_goals THEN 3
    WHEN host_goals = guest_goals THEN 1
    ELSE 0
    END AS guest_points
FROM matches) AS guest_points_tmp
GROUP BY guest_points_tmp.guest_team;

-- Calculate total points accumulated by each team across all matches
CREATE VIEW total_points AS 
SELECT team_id, SUM(team_points) as total_team_points
FROM team_points
GROUP BY team_id;

-- Map team names and fill NULL with 0
CREATE VIEW final_table AS
SELECT t.team_id, t.team_name, COALESCE(tp.total_team_points, 0) AS total_team_points
FROM teams t
LEFT JOIN total_points tp
ON t.team_id = tp.team_id;

-- Sort final table according to requirements
SELECT team_id, team_name, total_team_points
FROM final_table
ORDER BY total_team_points DESC, team_id ASC;