TELECOM DATABASE PORTFOLIO

Personal SQL portfolio project analyzing telecom incident data, technician performance, and equipment reliability. This is a self-designed database tracking network infrastructure across multiple regions.

================================================================================
PROJECT OVERVIEW
================================================================================

Built a custom PostgreSQL database to model a real-world telecom scenario:
- Regions & Locations — 3 regions, 9 locations across North America
- Equipment — 27 pieces across 5 equipment types (Router, Switch, Fiber Node, Splitter, Backup Power)
- Incidents — 80 network incidents tracked by severity and customer impact
- Repairs — 85 repair records linked to technicians and incidents
- Technicians — 41 field technicians assigned across regions

================================================================================
DATABASE SETUP
================================================================================

QUICK START

1. Create the database:
   psql -U username -d postgres -f 01_create_tables.sql

2. Insert sample data:
   psql -U username -d postgres -f 02_insert_data.sql

3. Run analysis queries:
   psql -U username -d postgres -f 03_analysis_queries.sql

FILES

- 01_create_tables.sql — Schema definition with relationships and indexes
- 02_insert_data.sql — Sample data (80 incidents, 85 repairs, 41 technicians)
- 03_analysis_queries.sql — 8 analytical queries with results and insights

================================================================================
PORTFOLIO QUERIES
================================================================================

Query 1: Incident Analysis by Region
What: Incident volume + critical severity by region
Skills: JOINs, CASE, GROUP BY

Query 2: Technician Performance Ranking
What: Top technicians by repair volume and cost
Skills: CTEs, RANK(), aggregates

Query 3: Equipment Reliability by Type
What: % of equipment units that experienced incidents
Skills: JOINs, DISTINCT, calculations

Query 4: Repair Cost Trends
What: Cumulative repair costs over time
Skills: Running SUM, window functions

Query 5A: Resolution Time Ranked
What: Individual repairs ranked by duration per severity
Skills: Window functions, PARTITION BY

Query 5B: Resolution Time Summary
What: Average/min/max resolution time by severity
Skills: Date math, aggregates

Query 6: Location Impact Analysis
What: Locations ranked by total customer impact
Skills: Multiple CTEs, ranking

Query 7: Severity Escalation Patterns
What: Equipment with escalating incident severity
Skills: LAG/LEAD, severity trending

Query 8: Technician Efficiency Score
What: Top 10 technicians ranked by weighted metrics
Skills: Normalization, multi-factor scoring

================================================================================
SKILLS DEMONSTRATED
================================================================================

DATA MANIPULATION
- Multi-table JOINs (3-4 tables per query)
- Common Table Expressions (CTEs) — single and multiple
- Subqueries and filtering

ANALYTICS
- Window Functions: RANK(), running SUM()
- Aggregates: COUNT(), SUM(), AVG(), with CASE conditions
- Date arithmetic for intervals

BUSINESS LOGIC
- Percentage calculations (equipment failure rates)
- Customer impact analysis
- Performance ranking with tie handling
- Cumulative cost tracking

SQL DIALECT
- PostgreSQL 18
- Type casting (::NUMERIC for decimal division)
- Window frame syntax (ROWS BETWEEN)
- Date/time functions

================================================================================
KEY FINDINGS
================================================================================

INCIDENT MANAGEMENT
- NYC Downtown Hub has highest customer impact (43,000 affected across 11 incidents)
- Eastern region drives most incidents (32 total, 6 critical)

TECHNICIAN PERFORMANCE
- Mary Johnson is top performer (4 completed repairs, $3,675 average cost)
- 15 technicians tied for 2nd place (3 repairs each)

EQUIPMENT RELIABILITY
- Splitter is most reliable (33% have experienced issues)
- Switch and Fiber Node have 100% incident rates (all units affected at least once)
- Note: Metric measures % of units with incidents, not frequency

OPERATIONS
- Total repair costs: $186,850 (Jan-Apr 2024)
- Resolution time: Critical 2.4h avg, Low 0.8h avg
- All repairs completed same-day (max 3.2 hours)

EQUIPMENT ESCALATION
- G5678-LOC7 shows worst escalation trend (40% of incidents escalated)
- 16 equipment units experienced severity escalations
- Identifies maintenance priorities based on degradation patterns

TECHNICIAN EFFICIENCY
- David Wilson is top performer (97.92 efficiency score)
- Scoring balances cost, speed, and quality equally (40/40/20)
- Top 10 technicians all maintain 100% incident resolution rate

================================================================================
DATABASE SCHEMA
================================================================================

regions (region_id, region_name)
  └─ locations (location_id, region_id, location_name)
      └─ incidents (incident_id, location_id, equipment_id, severity, affected_customers)
      └─ equipment (equipment_id, location_id, type_id, serial_number)
          └─ equipment_types (type_id, type_name)

technicians (technician_id, first_name, last_name, region_id)
  └─ repairs (repair_id, incident_id, technician_id, cost, status)

================================================================================
HOW TO USE THESE FILES
================================================================================

FOR LEARNING SQL
- Start with Query 1 (simple JOINs + aggregates)
- Progress to Query 4 (window functions)
- Review Query 6 (multiple CTEs)
- Try Queries 7-8 (advanced LAG/LEAD, normalization)

FOR YOUR PORTFOLIO
- Run all 8 queries to show breadth of SQL skills
- Screenshot or export results
- Include results in LinkedIn or resume

FOR EXTENDING
- Add queries for: incident trends, technician scheduling, equipment maintenance
- Consider: adding dates dimension, cost budgeting, SLA tracking

================================================================================
TECHNOLOGIES USED
================================================================================

- Database: PostgreSQL 18
- Data: 85 records (sample/synthetic)
- SQL Concepts: CTEs, window functions, multi-table joins, aggregates

================================================================================
AUTHOR
================================================================================

Nima
Toronto, ON
October 2026

Questions or feedback? Feel free to fork and extend this project.
