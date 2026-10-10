-- ============================================
-- TELECOM PORTFOLIO: 6 ANALYTICAL QUERIES
-- Database: PostgreSQL 18
-- ============================================

-- QUERY 1: Incident Analysis by Region
-- Shows incident volume and customer impact by region

WITH region_stat AS (
	SELECT
		r.region_name,
		COUNT(*) AS total_incidents,
		COUNT(CASE WHEN i.severity = 'Critical' THEN 1 END) AS critical_incidents,
		ROUND(AVG(i.affected_customers), 2) AS avg_customers_affected
	FROM incidents i
	JOIN locations l ON i.location_id = l.location_id
	JOIN regions r ON r.region_id = l.region_id
	GROUP BY r.region_name 
	ORDER BY total_incidents DESC
)
SELECT * FROM region_stat;

-- RESULTS:
-- region_name | total_incidents | critical_incidents | avg_customers_affected
-- Eastern     | 32              | 6                  | 3042.19
-- Central     | 32              | 3                  | 2671.88
-- Western     | 21              | 3                  | 3402.38

-- KEY INSIGHTS:
-- - Eastern region has most incidents (32) and most critical (6)
-- - Western region affects most customers per incident (avg 3402.38)
-- - Critical incidents concentrated in Eastern region

---

-- QUERY 2: Technician Performance Ranking
-- Top 10 technicians by repair volume and cost

WITH tech_stats AS (
	SELECT 
		t.technician_id,
		CONCAT(t.first_name, ' ', t.last_name) AS technician_name,
		COUNT(*) AS total_repairs,
		ROUND(AVG(r.cost), 2) AS avg_repair_cost
	FROM repairs r
	JOIN technicians t ON t.technician_id = r.technician_id
	WHERE r.status = 'Completed'
	GROUP BY t.technician_id, t.first_name, t.last_name
),
ranked_techs AS (
	SELECT *,
		RANK() OVER (ORDER BY total_repairs DESC) AS rank
	FROM tech_stats
)
SELECT * FROM ranked_techs
WHERE rank <= 10
ORDER BY rank;

-- RESULTS (first 16 rows due to ties at rank 10):
-- technician_id | technician_name  | total_repairs | avg_repair_cost | rank
-- 2              | Mary Johnson     | 4             | 3675.00         | 1
-- 29             | Zack Rodriguez   | 3             | 1950.00         | 2
-- 6              | Diana Moore      | 3             | 3766.67         | 2
-- ... (13 more tied at rank 2)

-- KEY INSIGHTS:
-- - Mary Johnson is top performer (4 completed repairs)
-- - 15 technicians tied for 2nd with 3 repairs each
-- - Results include all ties within rank 10 (RANK() behavior, not exactly 10 rows)
-- - Average repair costs range $900-$3,766.67

---

-- QUERY 3: Equipment Reliability by Type
-- Percentage of equipment units that experienced incidents

WITH equipment_stats AS (
	SELECT 
		et.type_name,
		COUNT(DISTINCT e.equipment_id) AS total_equipment,
		COUNT(DISTINCT i.incident_id) AS total_incidents,
		COUNT(DISTINCT CASE WHEN i.incident_id IS NOT NULL THEN e.equipment_id END) AS equipment_with_incidents
	FROM equipment e
	LEFT JOIN equipment_types et ON e.type_id = et.type_id
	LEFT JOIN incidents i ON e.equipment_id = i.equipment_id
	GROUP BY et.type_name
)
SELECT 
	type_name,
	total_equipment,
	equipment_with_incidents,
	total_incidents,
	ROUND((equipment_with_incidents::NUMERIC / total_equipment * 100), 2) AS equipment_with_incidents_percent,
	ROUND(100 - (equipment_with_incidents::NUMERIC / total_equipment * 100), 2) AS reliability_percent
FROM equipment_stats
ORDER BY reliability_percent DESC;

-- RESULTS:
-- type_name       | total_equipment | equipment_with_incidents | total_incidents | equipment_with_incidents_percent | reliability_percent
-- Splitter        | 3               | 2                        | 5               | 66.67                            | 33.33
-- Router          | 8               | 7                        | 29              | 87.50                            | 12.50
-- Backup Power    | 5               | 5                        | 11              | 100.00                           | 0.00
-- Fiber Node      | 6               | 6                        | 17              | 100.00                           | 0.00
-- Switch          | 7               | 7                        | 23              | 100.00                           | 0.00

-- KEY INSIGHTS:
-- - Splitter is most reliable (66.67% of units never had incidents)
-- - Switch, Fiber Node, Backup Power all have 100% incident rate (all units affected)
-- - equipment_with_incidents_percent shows % of equipment units that had at least one incident
-- - This is NOT the same as traditional failure rate (which considers frequency)

---

-- QUERY 4: Repair Cost Trends (Running Total)
-- Cumulative repair costs over time

WITH repair_stat AS (
	SELECT 
		repair_start_time AS repair_date,
		repair_id,
		cost,
		SUM(cost) OVER (ORDER BY repair_start_time, repair_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_cost
	FROM repairs
	ORDER BY repair_start_time, repair_id
)
SELECT * 
FROM repair_stat;

-- RESULTS (first 5 + last 5):
-- repair_date             | repair_id | cost    | running_total_cost
-- 2024-01-12 10:45:00    | 11        | 2500.00 | 2500.00
-- 2024-01-15 14:35:00    | 1         | 3500.00 | 6000.00
-- 2024-01-18 11:15:00    | 21        | 2800.00 | 8800.00
-- 2024-01-20 09:20:00    | 2         | 2800.00 | 11600.00
-- 2024-01-20 13:30:00    | 31        | 4800.00 | 16400.00
-- ...
-- 2024-03-28 12:45:00    | 80        | 2700.00 | 180350.00
-- 2024-04-05 14:45:00    | 81        | 500.00  | 180850.00
-- 2024-04-10 10:30:00    | 82        | 1200.00 | 182050.00
-- 2024-04-15 14:00:00    | 83        | 3000.00 | 185050.00
-- 2024-04-20 15:15:00    | 85        | 1000.00 | 186850.00

-- KEY INSIGHTS:
-- - Total accumulated repair costs: $186,850
-- - Running total shows cost growth from Jan to Apr 2024
-- - Can track budget spend over time
-- - January-March account for most repairs; April has only 5

---

-- QUERY 5A: Incident Resolution Time by Severity (Individual Repairs Ranked)
-- Ranks individual repair durations within each severity level

WITH days_between AS (
	SELECT 
		i.severity,
		(r.repair_end_time - r.repair_start_time) AS time_to_resolve
	FROM repairs r
	LEFT JOIN incidents i ON r.incident_id = i.incident_id
	WHERE i.severity IS NOT NULL
),
incident_rank AS (
	SELECT *,
		RANK() OVER (PARTITION BY severity ORDER BY time_to_resolve DESC) AS ranked
	FROM days_between 
)
SELECT *
FROM incident_rank
ORDER BY severity, ranked;

-- SAMPLE RESULTS:
-- severity  | time_to_resolve | ranked
-- Critical  | 02:45:00        | 1
-- Critical  | 02:35:00        | 3
-- Critical  | 02:30:00        | 5
-- High      | 03:10:00        | 1
-- High      | 02:45:00        | 4
-- Low       | 01:15:00        | 1
-- Medium    | 02:20:00        | 3

-- KEY INSIGHTS:
-- - Low severity incidents resolve fastest (30min - 1h 15min)
-- - Critical incidents take 2h 10min - 2h 45min
-- - High severity has longest outlier (3h 10min)
-- - Resolution time varies significantly within each severity

---

-- QUERY 5B: Average Resolution Time Summary by Severity
-- Shows mean, min, max resolution time per severity level

WITH resolution_summary AS (
	SELECT 
		i.severity,
		COUNT(*) AS total_repairs,
		ROUND(AVG(EXTRACT(EPOCH FROM (r.repair_end_time - r.repair_start_time)) / 3600), 2) AS avg_hours,
		ROUND(MIN(EXTRACT(EPOCH FROM (r.repair_end_time - r.repair_start_time)) / 3600), 2) AS min_hours,
		ROUND(MAX(EXTRACT(EPOCH FROM (r.repair_end_time - r.repair_start_time)) / 3600), 2) AS max_hours
	FROM repairs r
	LEFT JOIN incidents i ON r.incident_id = i.incident_id
	WHERE i.severity IS NOT NULL AND r.status = 'Completed'
	GROUP BY i.severity
)
SELECT * FROM resolution_summary
ORDER BY avg_hours DESC;

-- RESULTS:
-- severity | total_repairs | avg_hours | min_hours | max_hours
-- Critical | 12            | 2.41      | 2.17      | 2.75
-- High     | 31            | 1.89      | 1.07      | 3.17
-- Medium   | 30            | 1.42      | 0.75      | 2.33
-- Low      | 12            | 0.79      | 0.50      | 1.25

-- KEY INSIGHTS:
-- - Critical incidents take longest (avg 2.41 hours)
-- - Low severity resolves fastest (avg 0.79 hours)
-- - All repairs completed same-day (max 3.17 hours)
-- - Severity level strongly correlates with resolution time

---

-- QUERY 6: Location Impact Analysis
-- Ranks locations by total customer impact from incidents

WITH total_incidents AS (
	SELECT 
		l.location_name,
		COUNT(*) AS total_incidents,
		COUNT(CASE WHEN i.severity = 'Critical' THEN 1 END) AS critical_count,
		SUM(i.affected_customers) AS total_affected_customers 
	FROM incidents i 
	LEFT JOIN locations l ON l.location_id = i.location_id
	GROUP BY l.location_name
),
avg_customer_affected AS (
	SELECT 
		*,
		ROUND(total_affected_customers::NUMERIC / total_incidents, 2) AS avg_customers_per_incident
	FROM total_incidents
),
ranked AS (
	SELECT 
		*,
		RANK() OVER (ORDER BY total_affected_customers DESC) AS impact_rank
	FROM avg_customer_affected
)
SELECT * FROM ranked
ORDER BY impact_rank;

-- RESULTS:
-- location_name           | total_incidents | critical_count | total_affected_customers | avg_customers_per_incident | impact_rank
-- NYC Downtown Hub        | 11              | 3              | 43000                    | 3909.09                    | 1
-- Los Angeles Central     | 10              | 2              | 42000                    | 4200.00                    | 2
-- Chicago Loop            | 11              | 2              | 38000                    | 3454.55                    | 3
-- Boston Central          | 11              | 2              | 29900                    | 2718.18                    | 4
-- San Francisco Bay       | 11              | 1              | 29450                    | 2677.27                    | 5
-- Dallas Downtown         | 11              | 1              | 26600                    | 2418.18                    | 6
-- Philadelphia Hub        | 10              | 1              | 24450                    | 2445.00                    | 7
-- Kansas City Hub         | 10              | 0              | 20900                    | 2090.00                    | 8

-- KEY INSIGHTS:
-- - NYC Downtown Hub has highest customer impact (43,000 total affected)
-- - LA Central has highest impact per incident (4,200 avg customers)
-- - Kansas City has lowest impact (no critical incidents)
-- - Most locations have 10-11 total incidents
-- - Critical incidents concentrated in top 4 locations (NYC, LA, Chicago, Boston)

---

-- QUERY 7: Incident Severity Escalation Patterns
-- Identifies equipment with escalating incident severity over time

WITH incident_timeline AS (
	SELECT 
		e.equipment_id,
		e.serial_number,
		i.severity,
		i.incident_start_time,
		LAG(i.severity) OVER (PARTITION BY e.equipment_id ORDER BY i.incident_start_time) AS prev_severity,
		LEAD(i.severity) OVER (PARTITION BY e.equipment_id ORDER BY i.incident_start_time) AS next_severity
	FROM incidents i
	JOIN equipment e ON i.equipment_id = e.equipment_id
),
severity_rank AS (
	SELECT 
		equipment_id,
		serial_number,
		severity,
		CASE WHEN severity = 'Critical' THEN 4
		     WHEN severity = 'High' THEN 3
		     WHEN severity = 'Medium' THEN 2
		     WHEN severity = 'Low' THEN 1 END AS severity_rank,
		CASE WHEN severity = 'Critical' THEN 4
		     WHEN severity = 'High' THEN 3
		     WHEN severity = 'Medium' THEN 2
		     WHEN severity = 'Low' THEN 1 END -
		CASE WHEN prev_severity = 'Critical' THEN 4
		     WHEN prev_severity = 'High' THEN 3
		     WHEN prev_severity = 'Medium' THEN 2
		     WHEN prev_severity = 'Low' THEN 1
		     ELSE 0 END AS escalation_level,
		prev_severity,
		incident_start_time
	FROM incident_timeline
	WHERE prev_severity IS NOT NULL
)
SELECT 
	serial_number,
	COUNT(*) AS total_incidents,
	COUNT(CASE WHEN escalation_level > 0 THEN 1 END) AS escalations,
	COUNT(CASE WHEN escalation_level < 0 THEN 1 END) AS improvements,
	ROUND(COUNT(CASE WHEN escalation_level > 0 THEN 1 END)::NUMERIC / COUNT(*) * 100, 2) AS escalation_rate_percent
FROM severity_rank
GROUP BY serial_number
HAVING COUNT(CASE WHEN escalation_level > 0 THEN 1 END) > 0
ORDER BY escalations DESC;

-- RESULTS (equipment with escalations):
-- serial_number  | total_incidents | escalations | improvements | escalation_rate_percent
-- G5678-LOC7     | 5               | 2           | 3            | 40.00
-- D1234-LOC4     | 3               | 1           | 1            | 33.33
-- B1234-LOC2     | 4               | 1           | 2            | 25.00
-- B9012-LOC2     | 1               | 1           | 0            | 100.00
-- H5678-LOC8     | 2               | 1           | 1            | 50.00
-- E5678-LOC5     | 2               | 1           | 1            | 50.00
-- F1234-LOC6     | 3               | 1           | 1            | 33.33
-- E7890-LOC5     | 3               | 1           | 1            | 33.33
-- G9012-LOC7     | 4               | 1           | 1            | 25.00
-- A9012-LOC1     | 1               | 1           | 0            | 100.00
-- F9012-LOC6     | 2               | 1           | 1            | 50.00
-- H1234-LOC8     | 3               | 1           | 2            | 33.33
-- C5678-LOC3     | 2               | 1           | 1            | 50.00
-- E1234-LOC5     | 3               | 1           | 1            | 33.33
-- A1234-LOC1     | 3               | 1           | 2            | 33.33
-- D5678-LOC4     | 2               | 1           | 1            | 50.00

-- KEY INSIGHTS:
-- - G5678-LOC7 shows most escalation patterns (40% of incidents escalated)
-- - B9012-LOC2 and A9012-LOC1 have 100% escalation (only 1 incident each, but it escalated)
-- - LAG/LEAD window functions track severity trend per equipment
-- - Identifies maintenance priority equipment that degrades over time

---

-- QUERY 8: Technician Efficiency Score
-- Ranks technicians by weighted performance: Cost 40%, Speed 40%, Quality 20%

WITH tech_metrics AS (
	SELECT 
		t.technician_id,
		CONCAT(t.first_name, ' ', t.last_name) AS technician_name,
		COUNT(*) AS total_repairs,
		ROUND(AVG(r.cost), 2) AS avg_repair_cost,
		ROUND(AVG(EXTRACT(EPOCH FROM (r.repair_end_time - r.repair_start_time)) / 3600), 2) AS avg_hours,
		COUNT(CASE WHEN r.incident_id IS NOT NULL THEN 1 END)::NUMERIC / COUNT(*) * 100 AS incident_resolution_rate
	FROM repairs r
	JOIN technicians t ON r.technician_id = t.technician_id
	WHERE r.status = 'Completed'
	GROUP BY t.technician_id, t.first_name, t.last_name
),
normalized_scores AS (
	SELECT 
		technician_id,
		technician_name,
		total_repairs,
		avg_repair_cost,
		avg_hours,
		incident_resolution_rate,
		-- Cost score (lower cost = higher score): 0-100, inverted
		ROUND(100 - ((avg_repair_cost - MIN(avg_repair_cost) OVER()) / 
		            (MAX(avg_repair_cost) OVER() - MIN(avg_repair_cost) OVER() + 1) * 100), 2) AS cost_score,
		-- Speed score (faster = higher score): 0-100, inverted
		ROUND(100 - ((avg_hours - MIN(avg_hours) OVER()) / 
		            (MAX(avg_hours) OVER() - MIN(avg_hours) OVER() + 1) * 100), 2) AS speed_score,
		-- Quality score (resolution rate): 0-100, direct
		ROUND(incident_resolution_rate, 2) AS quality_score
	FROM tech_metrics
),
efficiency_ranked AS (
	SELECT 
		technician_id,
		technician_name,
		total_repairs,
		ROUND(avg_repair_cost, 2) AS avg_repair_cost,
		ROUND(avg_hours, 2) AS avg_hours,
		ROUND(incident_resolution_rate, 2) AS resolution_rate_percent,
		ROUND(cost_score, 2) AS cost_score,
		ROUND(speed_score, 2) AS speed_score,
		ROUND(quality_score, 2) AS quality_score,
		-- Weighted efficiency score: Cost 40%, Speed 40%, Quality 20%
		ROUND((cost_score * 0.40) + (speed_score * 0.40) + (quality_score * 0.20), 2) AS efficiency_score,
		RANK() OVER (ORDER BY (cost_score * 0.40) + (speed_score * 0.40) + (quality_score * 0.20) DESC) AS rank
	FROM normalized_scores
)
SELECT * FROM efficiency_ranked
WHERE rank <= 10
ORDER BY rank;

-- RESULTS (top 10 technicians by efficiency):
-- technician_id | technician_name  | total_repairs | avg_repair_cost | avg_hours | resolution_rate_percent | cost_score | speed_score | quality_score | efficiency_score | rank
-- 33             | David Wilson     | 1             | 700.00          | 0.75      | 100.00                  | 94.81      | 100.00      | 100.00        | 97.92            | 1
-- 13             | Karen Martin     | 1             | 750.00          | 0.75      | 100.00                  | 93.51      | 100.00      | 100.00        | 97.40            | 2
-- 12             | Jack Harris      | 2             | 750.00          | 0.88      | 100.00                  | 93.51      | 95.61       | 100.00        | 95.65            | 3
-- 28             | Yara Garcia      | 2             | 775.00          | 0.88      | 100.00                  | 92.86      | 95.61       | 100.00        | 95.39            | 4
-- 11             | Iris White       | 3             | 900.00          | 1.11      | 100.00                  | 89.61      | 87.84       | 100.00        | 90.98            | 5
-- 34             | Ella Moore       | 1             | 500.00          | 1.50      | 100.00                  | 100.00     | 74.66       | 100.00        | 89.86            | 6
-- 14             | Leo Garcia       | 2             | 1350.00         | 1.21      | 100.00                  | 77.93      | 84.46       | 100.00        | 84.96            | 7
-- 23             | Tina Thomas      | 3             | 1283.33         | 1.42      | 100.00                  | 79.66      | 77.36       | 100.00        | 82.81            | 8
-- 27             | Xavier Martin    | 3             | 1366.67         | 1.58      | 100.00                  | 77.49      | 71.96       | 100.00        | 79.78            | 9
-- 18             | Oscar Davis      | 3             | 1900.00         | 1.25      | 100.00                  | 63.65      | 83.11       | 100.00        | 78.70            | 10

-- KEY INSIGHTS:
-- - David Wilson ranks #1 (97.92 efficiency score) — fast + cheap repairs
-- - Top performers have 100% incident resolution rate
-- - Ella Moore has lowest cost ($500) but slower speed (1.5 hours)
-- - Oscar Davis has highest cost ($1900) which hurts his efficiency ranking
-- - Efficiency formula balances cost-effectiveness with repair speed and quality
