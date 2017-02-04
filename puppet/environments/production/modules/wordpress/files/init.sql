DROP DATABASE IF EXISTS roofingwp;
CREATE DATABASE roofingwp;

CREATE USER 'scribe'@'localhost' IDENTIFIED BY '7D0RhpPXbk1WTrVM1mdWZmhDvrINjJSbRrJvq4nubonAheHlZW';

GRANT ALL PRIVILEGES ON roofingwp.* TO 'scribe'@'localhost';
FLUSH PRIVILEGES;
