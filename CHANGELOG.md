# Changelog

Record of notable changes to Project Kampong Backend.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

### [Unreleased]

### Added

- `hashId` generator utility, to generate hashed serial number and with decoding and encoding functionality.
- Show corresponding `hashId` values for 'Get All...' endpoints. If select query params is used, hashId field will not be generated. Note that this feature is not reliable for tables with more than one id field (ie. more than one columns with column name ending with `_id`). It is implemented such that it will take the first id column if multiple id columns are present. This is usually safe as existing tables have their first id column as their primary key. Nevertheless, its use on tables with multiple id columns is highly discouraged as it may lead to unpredictable outcomes.
- LoDash library for use of util functions.
- Listing Updates CRUD endpoints.
- Get single listing by hashId endpoint.
- Get single profile by hashId endpoint.
- Listing Skills create, read, delete endpoint.
- `adavancedResult` middleware now accepts `join` and `on` as optional arguments to form SQL joins.
- New testing route for multiple file upload.
- Get all listings owned by particular user (identified by `userId`).
- Database diagram in `public/kampong-db-diagram.png`.
- Soft delete for jobs and listings.
- Separate admin-only `Get all ... including soft delete` endpoint.

### Changed

- All 'Get All...' endpoints count now reflect the total count of database entries that fulfill the conditions, regardless of limit and offset.
- Route for original get single listing by listing id. (see API docs)
- Route for original get single profile by profile id. (see API docs)
- Updated API docs to show hashId displayed for relevant Get All endpoints.
- 'Get all skills for listing' renamed to 'Get all listing skills for listing' and URI changed from `/api/listings/:listing_id/skills` to `/api/listings/:listing_id/listing-skills`, for consistency in terminology of `Skill` and `ListingSkill`.
- File metadata when uploading to S3 now includes file's original name, and upload timestamp.
- Major refactor of file directories, methods to appropriate files. (see [#96](https://github.com/Project-Kampong/kampong-backend/pull/96))

### Fixed

- Multiple photo upload not storing URL location in database. This was an issue affecting the listings endpoints only.
- Bug where user cannot update own profile, and upload profile pic as `403` response was given.
- Bug (similar as above) where `403` response given when user is updating own participant entry.
- Bug where hashtags with '-' are not allowed. This affects the creation and update of hashtags. Hashtags must now start with '#' followed by a combination of alphanumeric characters, `-` and `_`, and be of length 3 to 20 excluding `#`.

## [0.0.2] - 2020-08-06

### Added

- Listing Stories schema, routing and endpoint.
- Hashtag schema, routing and endpoint.
- Add upload photo in create listings, header type changed from `application/json` to `multipart/form-data`.

### Changed

- Listings create and delete endpoint to also create and delete its corresponding listing story with same listing id.
- Minor update to README, indicating temporary API documentation location.

## [0.0.1] - 2020-08-03

### Added

- Initial changelog record.
- Initial README with setup instructions.
- Initial SQL schema plan.
- Auth CRUD endpoints.
- Registration, confirm account, forget and reset password endpoints.
- Admin-only Users CRUD endpoints.
- User profiles CRUD endpoints.
- Listings CRUD endpoints.
- Participants (Users-Listings) CRUD endpoints.
- Skills (Users-Listings) CRUD endpoints.
- Likes (Users-Listings) CRUD endpoints.
- Jobs (Users-Listings) CRUD endpoints.
- Participants (Users-Listings) CRUD endpoints.
- Listing FAQs CRUD endpoints.
- Connection with PostgreSQL, configurable by developer.
- Integration with email service as a utility service.
- Integration with S3 bucket for file uploads as a utility service.
- Error handling.
- Basic Role-Based Access Control (RBAC) of routes.
- Basic input-validation for existing endpoints.
- Basic handling of query parameters for GET ALL requests, only handling of strict equality for now.
- Seeder file script to populate database with mock data for testing.
- Sample config env files to be populated with appropriate values for deployment.
- Internal, dev-only test routes and methods.
- API documentation temporarily set up as front-end page to be served, for ease of testing by frontend.

[unreleased]: https://github.com/Project-Kampong/kampong-backend/compare/v0.0.2...HEAD
[0.0.2]: https://github.com/Project-Kampong/kampong-backend/releases/tag/v0.0.2
[0.0.1]: https://github.com/Project-Kampong/kampong-backend/releases/tag/v0.0.1
