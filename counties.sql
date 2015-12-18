
SELECT *,
	(job_count_2013 * 1.0) / (housing_units_2013 *1.0) AS jobs_housing_ratio_2013,
	(job_count_2012 * 1.0) / (housing_units_2012 *1.0) AS jobs_housing_ratio_2012,
	(job_count_2011 * 1.0) / (housing_units_2011 *1.0) AS jobs_housing_ratio_2011,
	(job_count_2010 * 1.0) / (housing_units_2010 *1.0) AS jobs_housing_ratio_2010,
	(job_count_2009 * 1.0) / (housing_units_2009 *1.0) AS jobs_housing_ratio_2009
	FROM (
		SELECT 
			job_counts.formatted_place,
			counties_1yr_ests.housing_units_2014_1yr AS housing_units_2014,
			counties_1yr_ests.housing_units_2013_1yr AS housing_units_2013,
			counties_1yr_ests.housing_units_2012_1yr AS housing_units_2012,
			counties_1yr_ests.housing_units_2011_1yr AS housing_units_2011,
			counties_1yr_ests.housing_units_2010_1yr AS housing_units_2010,
			counties_2009.housing_units_2009_1yr AS housing_units_2009,
			"2013_job_count" AS job_count_2013,
			"2012_job_count" AS job_count_2012,
			"2011_job_count" AS job_count_2011,
			"2010_job_count" AS job_count_2010,
			"2009_job_count" AS job_count_2009
		FROM (
			SELECT 
				LOWER(place) AS formatted_place,
				*
			FROM job_counts
			) as job_counts
			
		LEFT JOIN (
			SELECT
				LOWER(
					REPLACE(
						REPLACE(
							REPLACE(
								REPLACE(
									REPLACE(counties_1yr_ests."GEO.display-label", ', California',""), 
								' city',''),
							' town', ''),
						' CDP', ''),
					' ', '_')
				)	AS place_1yr,  -- reformat place for joins
				HC01_VC03 AS housing_units_2014_1yr,
				HC02_VC03 AS housing_units_2013_1yr,
				HC04_VC03 AS housing_units_2012_1yr,
				HC06_VC03 AS housing_units_2011_1yr,
				HC08_VC03 AS housing_units_2010_1yr
			FROM counties_1yr_ests
			
		) AS counties_1yr_ests
		ON counties_1yr_ests.place_1yr = job_counts.formatted_place

		LEFT JOIN (
			SELECT
				LOWER(
					REPLACE(
						REPLACE(
							REPLACE(
								REPLACE(
									REPLACE(counties_2009."GEO.display-label", ', California',""), 
								' city',''),
							' town', ''),
						' CDP', ''),
					' ', '_')
				)	AS place_09,  -- reformat place for joins
				HD01_VD01 AS housing_units_2009_1yr
			FROM counties_2009
			
		) AS counties_2009
		ON counties_2009.place_09 = job_counts.formatted_place

		
		WHERE
			job_counts.formatted_place LIKE '%county'
	) AS base_data;