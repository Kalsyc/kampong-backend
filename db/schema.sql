DROP TABLE IF EXISTS Roles CASCADE;
DROP TABLE IF EXISTS Users CASCADE;
DROP TABLE IF EXISTS PendingUsers CASCADE;
DROP TABLE IF EXISTS ForgetPasswordUsers CASCADE;
/* DROP TABLE IF EXISTS Admins CASCADE; */
DROP TABLE IF EXISTS Profiles CASCADE;
DROP TABLE IF EXISTS Skills CASCADE;
DROP TABLE IF EXISTS ProfileSkills CASCADE;
DROP TABLE IF EXISTS Organisations CASCADE;
DROP TABLE IF EXISTS Memberships CASCADE;
DROP TABLE IF EXISTS Listings CASCADE;
DROP TABLE IF EXISTS Features CASCADE;
DROP TABLE IF EXISTS HashTags CASCADE;
DROP TABLE IF EXISTS ListingSkills CASCADE;
DROP TABLE IF EXISTS Jobs CASCADE;
DROP TABLE IF EXISTS FAQs CASCADE;
DROP TABLE IF EXISTS Likes CASCADE;
DROP TABLE IF EXISTS ListingAdmins CASCADE;
DROP TABLE IF EXISTS Participants CASCADE;
DROP TABLE IF EXISTS Subscriptions CASCADE;
DROP TABLE IF EXISTS Milestones CASCADE;

CREATE TABLE Roles (
    role VARCHAR PRIMARY KEY
);

CREATE TABLE Users (
    user_id SERIAL,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR,
    email VARCHAR(320) UNIQUE NOT NULL,
    password VARCHAR NOT NULL,
    role VARCHAR NOT NULL DEFAULT 'user',

    PRIMARY KEY (user_id),
    FOREIGN KEY (role) REFERENCES Roles ON DELETE SET DEFAULT
);

CREATE TABLE PendingUsers (
    pending_user_id SERIAL,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR,
    email VARCHAR(320) UNIQUE NOT NULL,
    password VARCHAR NOT NULL,
    token VARCHAR UNIQUE NOT NULL,
    expiry TIMESTAMP NOT NULL DEFAULT NOW(),

    PRIMARY KEY (pending_user_id)
);

CREATE TABLE ForgetPasswordUsers (
    forgetpass_user_id SERIAL,
    email VARCHAR(320) UNIQUE NOT NULL,
    token VARCHAR UNIQUE NOT NULL,
    expiry TIMESTAMP NOT NULL DEFAULT NOW(),

    PRIMARY KEY (forgetpass_user_id)
);

/*
CREATE TABLE Admins (
    user_id INTEGER,

    PRIMARY KEY (user_id),
    FOREIGN KEY (user_id) REFERENCES Users ON DELETE CASCADE
);
*/

CREATE TABLE Profiles (
    user_id INTEGER,
    nickname VARCHAR NOT NULL,
    profile_picture VARCHAR,
    about TEXT,
    gender VARCHAR CHECK (gender IN ('m', 'f', 'o', 'u')) DEFAULT 'u', /* m = male, f = female, o = others, u = undisclosed */
    dob TIMESTAMP, /* change to timestamp */
    interest TEXT,
    phone VARCHAR,
    facebook_link VARCHAR,
    twitter_link VARCHAR,
    instagram_link VARCHAR,
    linkedin_link VARCHAR,
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    created_on TIMESTAMP NOT NULL DEFAULT NOW(),

    PRIMARY KEY (user_id),
    FOREIGN KEY (user_id) REFERENCES Users ON DELETE CASCADE
);

CREATE TABLE Skills (
    skill_id SERIAL,
    skill VARCHAR UNIQUE NOT NULL,

    PRIMARY KEY (skill_id)
);

CREATE TABLE ProfileSkills (
    profile_skill_id SERIAL,
    user_id INTEGER NOT NULL,
    skill_id INTEGER NOT NULL,

    PRIMARY KEY (profile_skill_id),
    UNIQUE (user_id, skill_id),
    FOREIGN KEY (user_id) REFERENCES Users ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES Skills ON DELETE CASCADE
);

CREATE TABLE Organisations (
    organisation_id SERIAL,
    name VARCHAR NOT NULL,
    type VARCHAR NOT NULL,
    about TEXT,
    website_url VARCHAR,
    handphone VARCHAR,
    email VARCHAR(320),
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    created_on TIMESTAMP NOT NULL DEFAULT NOW(),
    is_deleted TIMESTAMP DEFAULT NULL,

    PRIMARY KEY (organisation_id)
);

CREATE TABLE Memberships (
    membership_id SERIAL,
    organisation_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    is_owner BOOLEAN NOT NULL DEFAULT FALSE,
    joined_on TIMESTAMP NOT NULL DEFAULT NOW(),

    PRIMARY KEY (membership_id),
    UNIQUE (organisation_id, user_id),
    FOREIGN KEY (organisation_id) REFERENCES Organisations ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users ON DELETE CASCADE
);

CREATE TABLE Listings (
    listing_id SERIAL,
    organisation_id INTEGER,
    created_by INTEGER,
    title VARCHAR NOT NULL,
    category VARCHAR NOT NULL,
    about TEXT,
    tagline VARCHAR,
    mission TEXT,
    listing_url VARCHAR,
    pic1 VARCHAR,
    pic2 VARCHAR,
    pic3 VARCHAR,
    pic4 VARCHAR,
    pic5 VARCHAR,
    is_published BOOLEAN NOT NULL DEFAULT FALSE,
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    start_date TIMESTAMP NOT NULL DEFAULT NOW(),
    end_date TIMESTAMP,
    created_on TIMESTAMP NOT NULL DEFAULT NOW(),
    is_deleted TIMESTAMP DEFAULT NULL,

    PRIMARY KEY (listing_id),
    FOREIGN KEY (organisation_id) REFERENCES Organisations ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES Users ON DELETE SET NULL
);

/* Featured listings */
CREATE TABLE Features (
    feature_id SERIAL,
    listing_id INTEGER UNIQUE NOT NULL,

    PRIMARY KEY (feature_id),
    FOREIGN KEY (listing_id) REFERENCES Listings ON DELETE CASCADE
);

CREATE TABLE HashTags (
    hashtag_id SERIAL,
    listing_id INTEGER,
    tag VARCHAR NOT NULL,

    PRIMARY KEY (hashtag_id),
    UNIQUE (listing_id, tag),
    FOREIGN KEY (listing_id) REFERENCES Listings ON DELETE CASCADE
);

CREATE TABLE ListingSkills (
    listing_skill_id SERIAL,
    listing_id INTEGER NOT NULL,
    skill_id INTEGER NOT NULL,

    PRIMARY KEY (listing_skill_id),
    UNIQUE (listing_id, skill_id),
    FOREIGN KEY (listing_id) REFERENCES Listings ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES Skills ON DELETE CASCADE
);

/* Jobs for a particular listing */
CREATE TABLE Jobs (
    job_id SERIAL,
    listing_id INTEGER,
    job_title VARCHAR NOT NULL,
    job_description TEXT,
    is_deleted TIMESTAMP DEFAULT NULL,

    PRIMARY KEY (job_id),
    FOREIGN KEY (listing_id) REFERENCES Listings ON DELETE CASCADE
);

CREATE TABLE FAQs (
    faq_id SERIAL,
    listing_id INTEGER,
    question TEXT NOT NULL,
    answer TEXT,

    PRIMARY KEY (faq_id),
    FOREIGN KEY (listing_id) REFERENCES Listings ON DELETE CASCADE
);

CREATE TABLE Likes (
    like_id SERIAL,
    user_id INTEGER NOT NULL,
    listing_id INTEGER NOT NULL,

    PRIMARY KEY (like_id),
    UNIQUE (user_id, listing_id),
    FOREIGN KEY (user_id) REFERENCES Users ON DELETE CASCADE,
    FOREIGN KEY (listing_id) REFERENCES Listings ON DELETE CASCADE
);

CREATE TABLE ListingAdmins (
    listing_admin_id SERIAL,
    user_id INTEGER NOT NULL,
    listing_id INTEGER NOT NULL,

    PRIMARY KEY (listing_admin_id),
    UNIQUE (user_id, listing_id),
    FOREIGN KEY (user_id) REFERENCES Users ON DELETE CASCADE,
    FOREIGN KEY (listing_id) REFERENCES Listings ON DELETE CASCADE
);

CREATE TABLE Participants (
    participant_id SERIAL,
    listing_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    joined_on TIMESTAMP NOT NULL DEFAULT NOW(),
    end_on TIMESTAMP,

    PRIMARY KEY (participant_id),
    UNIQUE (listing_id, user_id),
    FOREIGN KEY (user_id) REFERENCES Users ON DELETE CASCADE,
    FOREIGN KEY (listing_id) REFERENCES Listings ON DELETE CASCADE
);

CREATE TABLE Subscriptions (
    subscription_id SERIAL,
    user_id INTEGER NOT NULL,
    listing_id INTEGER NOT NULL,

    PRIMARY KEY (subscription_id),
    UNIQUE (user_id, listing_id),
    FOREIGN KEY (user_id) REFERENCES Users ON DELETE CASCADE,
    FOREIGN KEY (listing_id) REFERENCES Listings ON DELETE CASCADE
);

CREATE TABLE Milestones (
    milestone_id SERIAL,
    listing_id INTEGER,
    description TEXT NOT NULL,
    date TIMESTAMP,

    PRIMARY KEY (milestone_id),
    FOREIGN KEY (listing_id) REFERENCES Listings ON DELETE CASCADE
);
