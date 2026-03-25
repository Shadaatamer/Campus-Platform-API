ALTER TABLE classes
ADD COLUMN IF NOT EXISTS year INT;

UPDATE classes
SET year = NULLIF(REGEXP_REPLACE(semester, '\D', '', 'g'), '')::INT
WHERE year IS NULL;

ALTER TABLE classes
ADD CONSTRAINT classes_year_range_chk CHECK (year BETWEEN 2000 AND 2100);
