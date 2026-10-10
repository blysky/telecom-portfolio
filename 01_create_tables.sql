-- ============================================
-- TELECOM DATABASE: CREATE TABLES
-- Database: PostgreSQL 18
-- ============================================

-- Create Regions table
CREATE TABLE regions (
    region_id SERIAL PRIMARY KEY,
    region_name VARCHAR(100) NOT NULL UNIQUE
);

-- Create Locations table
CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,
    region_id INTEGER NOT NULL,
    location_name VARCHAR(100) NOT NULL UNIQUE,
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

-- Create Equipment Types table
CREATE TABLE equipment_types (
    type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE
);

-- Create Equipment table
CREATE TABLE equipment (
    equipment_id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL,
    type_id INTEGER NOT NULL,
    serial_number VARCHAR(100) NOT NULL UNIQUE,
    installation_date DATE,
    FOREIGN KEY (location_id) REFERENCES locations(location_id),
    FOREIGN KEY (type_id) REFERENCES equipment_types(type_id)
);

-- Create Technicians table
CREATE TABLE technicians (
    technician_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    region_id INTEGER NOT NULL,
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

-- Create Incidents table
CREATE TABLE incidents (
    incident_id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL,
    equipment_id INTEGER NOT NULL,
    severity VARCHAR(20) NOT NULL CHECK (severity IN ('Critical', 'High', 'Medium', 'Low')),
    incident_start_time TIMESTAMP NOT NULL,
    incident_end_time TIMESTAMP,
    affected_customers INTEGER DEFAULT 0,
    FOREIGN KEY (location_id) REFERENCES locations(location_id),
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id)
);

-- Create Repairs table
CREATE TABLE repairs (
    repair_id SERIAL PRIMARY KEY,
    incident_id INTEGER,
    technician_id INTEGER NOT NULL,
    repair_start_time TIMESTAMP NOT NULL,
    repair_end_time TIMESTAMP NOT NULL,
    cost DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('In Progress', 'Completed', 'Pending')),
    FOREIGN KEY (incident_id) REFERENCES incidents(incident_id),
    FOREIGN KEY (technician_id) REFERENCES technicians(technician_id)
);

-- Create indexes for common queries
CREATE INDEX idx_incidents_location ON incidents(location_id);
CREATE INDEX idx_incidents_equipment ON incidents(equipment_id);
CREATE INDEX idx_incidents_severity ON incidents(severity);
CREATE INDEX idx_repairs_technician ON repairs(technician_id);
CREATE INDEX idx_repairs_incident ON repairs(incident_id);
CREATE INDEX idx_equipment_location ON equipment(location_id);
CREATE INDEX idx_equipment_type ON equipment(type_id);

-- Add comments for clarity
COMMENT ON TABLE incidents IS 'Network incidents tracked by location and equipment';
COMMENT ON TABLE repairs IS 'Repair actions taken by technicians in response to incidents';
COMMENT ON COLUMN incidents.severity IS 'Incident severity: Critical, High, Medium, or Low';
COMMENT ON COLUMN repairs.status IS 'Repair status: In Progress, Completed, or Pending';
