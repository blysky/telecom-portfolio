# Telecom incident analysis

I built this to practise SQL on a dataset shaped like a telecom operations log:
equipment, incidents, technicians, repairs, and the regions and locations they
belong to. The data is synthetic. I generated it for this project, so the numbers
describe the database, not a real network.

The database holds 85 incidents, 85 repairs, and 41 technicians across 3 regions.
The eight queries in `03_analysis_queries.sql` answer questions like which region
has the most critical incidents, which technicians do the most repairs, and which
equipment types fail most often.

I also built three Tableau dashboards from the same data:
https://public.tableau.com/app/profile/nima.fathi

## Loading the data

The first two SQL files are an early, smaller sample. The insert file loads only
70 incidents and fails on the repairs table, so don't use it for analysis. Load the
full dump instead:

```
docker run -d --name pg-telecom -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres:16
docker exec pg-telecom psql -U postgres -c "CREATE DATABASE telecom;"
docker cp telecom_full_dump.sql pg-telecom:/tmp/dump.sql
docker exec pg-telecom psql -U postgres -d telecom -f /tmp/dump.sql
```

To check it loaded, count the incidents. You should get 85:

```
docker exec pg-telecom psql -U postgres -d telecom -c "SELECT COUNT(*) FROM incidents;"
```