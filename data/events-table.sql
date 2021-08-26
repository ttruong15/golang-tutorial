CREATE TABLE IF NOT EXISTS events (
	id SERIAL PRIMARY KEY,
	event_id INT,
	event_type TEXT,
	entity_type CHAR(50),
	entity_id INT,
	event_data JSON,
	created DATETIME
);
