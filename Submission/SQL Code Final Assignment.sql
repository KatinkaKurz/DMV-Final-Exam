-- Create staging table to load data into PostgreSQL, note: this is done by accessing file from local machine in COPY command
CREATE TABLE StagingTable (
    id VARCHAR(255),
	last_scraped DATE,
    host_id VARCHAR(255),
    host_name VARCHAR(255),	
    host_since DATE,	
    host_response_rate FLOAT,
    host_acceptance_rate FLOAT,	
    host_is_superhost VARCHAR(255),	
    host_has_profile_pic VARCHAR(255),
    host_identity_verified VARCHAR(255),	
    latitude FLOAT,	
    longitude FLOAT,	
    room_type VARCHAR(255),
    accommodates FLOAT,	
    bedrooms FLOAT,	
    beds FLOAT,
	amenities TEXT,
    minimum_nights FLOAT,	
    maximum_nights FLOAT,
    availability_30	FLOAT,
    availability_60	FLOAT,
    availability_90	FLOAT,
    availability_365 FLOAT,	
    number_of_reviews FLOAT,
    first_review DATE,
    last_review	DATE,
    review_scores_rating FLOAT,
    review_scores_accuracy FLOAT,
    review_scores_cleanliness FLOAT,
    review_scores_checkin FLOAT,
    review_scores_communication FLOAT,
    review_scores_location FLOAT,
    review_scores_value	FLOAT,
    calculated_host_listings_count FLOAT,
    reviews_per_month FLOAT,
    price_in_dkk FLOAT,
    price_per_person FLOAT,
    price_class	VARCHAR(255),
    danish_name_indicator FLOAT,
    danish_description_indicator FLOAT,
    danish_host_about_indicator FLOAT,
    host_location_category VARCHAR(255),
    host_response_time_int FLOAT,
    host_about_bool	BOOLEAN,
    description_bool BOOLEAN,
    neighbourhood_overview_bool BOOLEAN,
    bathrooms_number FLOAT,
    bathrooms_type VARCHAR(255),
    count_amenities FLOAT,	
    neighbourhood_corrected	VARCHAR(255),
    listing_duration FLOAT,
	availability_90_perc FLOAT,
	host_age_category VARCHAR(255),
	Yearly_host_revenue FLOAT,
	Yearly_airbnb_revenue FLOAT,
	Overall_Category VARCHAR(255)
);

-- Copy data from df_listings_er.csv
COPY StagingTable
FROM '//Users/katinkakurz/Desktop/df_listings_er.csv'
DELIMITER ',' CSV HEADER;

--------Creating dimension tables---------
CREATE TABLE Host (
    host_id VARCHAR(255) PRIMARY KEY,
    host_name VARCHAR(255),
    host_since DATE,
    host_response_time_int FLOAT,
    host_response_rate FLOAT,
    host_acceptance_rate FLOAT,
    host_is_superhost VARCHAR(255),	
    host_has_profile_pic VARCHAR(255),
    host_identity_verified VARCHAR(255),
    danish_host_about_indicator FLOAT,
    host_location_category VARCHAR(255),
    host_about_bool BOOLEAN,
    calculated_host_listings_count FLOAT,
	host_age_category VARCHAR(255)
);

INSERT INTO HOST(
	host_id, 
	host_name, 
	host_since, 
	host_response_rate,
	host_response_time_int, 
	host_acceptance_rate,
    host_is_superhost,
    host_has_profile_pic,
    host_identity_verified,
    danish_host_about_indicator,
    host_location_category,
    host_about_bool,
    calculated_host_listings_count,
	host_age_category
)
SELECT DISTINCT 
	host_id, 
	host_name, 
	host_since, 
	host_response_rate,
	host_response_time_int, 
	host_acceptance_rate,
    host_is_superhost,
    host_has_profile_pic,
    host_identity_verified,
    danish_host_about_indicator,
    host_location_category,
    host_about_bool,
    calculated_host_listings_count,
	host_age_category
FROM StagingTable;


-- Create Dimension Table: Listing
CREATE TABLE Listing (
    id VARCHAR(255) PRIMARY KEY,
	last_scraped DATE,
    danish_name_indicator FLOAT,
    danish_description_indicator FLOAT,
    longitude FLOAT,
    latitude FLOAT,
    room_type VARCHAR(255),
    accommodates INT,
    bedrooms INT,
    beds INT,
    minimum_nights INT,
    maximum_nights INT,
	number_of_reviews FLOAT,
    number_of_reviews_ltm FLOAT,
    number_of_reviews_l30d FLOAT,
    bathrooms_number FLOAT,
    bathrooms_type VARCHAR(255),
    count_amenities INT,
    neighbourhood_corrected VARCHAR(255),
    description_bool BOOLEAN,
    neighbourhood_overview_bool BOOLEAN,
    first_review DATE,
    last_review DATE,
    listing_duration FLOAT,
    review_scores_rating FLOAT,
    review_scores_accuracy FLOAT,
    review_scores_cleanliness FLOAT,
    review_scores_checkin FLOAT,
    review_scores_communication FLOAT,
    review_scores_location FLOAT,
    review_scores_value FLOAT,
	price_class VARCHAR(255),
	overall_category VARCHAR(255)
);


INSERT INTO Listing (
	id,
	last_scraped,
    danish_name_indicator,
    danish_description_indicator,
    longitude,
    latitude,
    room_type,
    accommodates,
    bedrooms,
    beds,
    minimum_nights,
    maximum_nights,
	number_of_reviews,
    bathrooms_number,
    bathrooms_type,
    count_amenities,
    neighbourhood_corrected,
    description_bool,
    neighbourhood_overview_bool,
    first_review,
    last_review,
    listing_duration,
    review_scores_rating,
    review_scores_accuracy,
    review_scores_cleanliness,
    review_scores_checkin,
    review_scores_communication,
    review_scores_location,
    review_scores_value,
	price_class,
	overall_category
)
SELECT DISTINCT
	id,
	last_scraped,
    danish_name_indicator,
    danish_description_indicator,
    longitude,
    latitude,
    room_type,
    accommodates,
    bedrooms,
    beds,
    minimum_nights,
    maximum_nights,
	number_of_reviews,
    bathrooms_number,
    bathrooms_type,
    count_amenities,
    neighbourhood_corrected,
    description_bool,
    neighbourhood_overview_bool,
    first_review,
    last_review,
    listing_duration,
    review_scores_rating,
    review_scores_accuracy,
    review_scores_cleanliness,
    review_scores_checkin,
    review_scores_communication,
    review_scores_location,
    review_scores_value,
	price_class,
	overall_category
FROM StagingTable;

--Create Fact Table: Performance
CREATE TABLE Performance (
    host_id VARCHAR(255),
    id VARCHAR(255),
    availability_90 FLOAT,
    availability_90_perc FLOAT,
	price_in_dkk FLOAT,
	price_per_person FLOAT,
	yearly_host_revenue FLOAT,
	yearly_airbnb_revenue FLOAT,
    PRIMARY KEY (host_id, id),
    FOREIGN KEY (host_id) REFERENCES Host (host_id),
    FOREIGN KEY (id) REFERENCES Listing (id)
);

INSERT INTO Performance (
    host_id, 
	id, 
	availability_90, 
	availability_90_perc, 
	price_in_dkk, 
	price_per_person, 
	yearly_host_revenue, 
	yearly_airbnb_revenue
)
SELECT DISTINCT
    host_id, 
	id, 
	availability_90, 
	availability_90_perc, 
	price_in_dkk, 
	price_per_person, 
	yearly_host_revenue, 
	yearly_airbnb_revenue
FROM StagingTable;