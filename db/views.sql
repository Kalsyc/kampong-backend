DROP VIEW IF EXISTS ListingsView CASCADE;
DROP VIEW IF EXISTS OrganisationsView CASCADE;
DROP VIEW IF EXISTS JobsView CASCADE;

CREATE VIEW ListingsView AS
  SELECT *
  FROM Listings
  WHERE is_deleted IS NULL;

CREATE VIEW OrganisationsView AS
  SELECT *
  FROM Organisations
  WHERE is_deleted IS NULL;

CREATE VIEW JobsView AS
  SELECT *
  FROM Jobs
  WHERE is_deleted IS NULL;
