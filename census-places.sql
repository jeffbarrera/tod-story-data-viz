SELECT *,
	(job_count_2013 * 1.0) / (housing_units_2013 *1.0) AS jobs_housing_ratio_2013,
	(job_count_2012 * 1.0) / (housing_units_2012 *1.0) AS jobs_housing_ratio_2012,
	(job_count_2011 * 1.0) / (housing_units_2011 *1.0) AS jobs_housing_ratio_2011,
	(job_count_2010 * 1.0) / (housing_units_2010 *1.0) AS jobs_housing_ratio_2010,
	(job_count_2009 * 1.0) / (housing_units_2009 *1.0) AS jobs_housing_ratio_2009
	FROM (
		SELECT 
			job_counts.formatted_place,
			housing_5yr_ests."GEO.id2" AS geoid,
			COALESCE(housing.housing_units_2014_1yr, housing_3yr_ests.HC01_VC03, housing_5yr_ests.HD01_VD01) AS housing_units_2014,
			COALESCE(housing.housing_units_2013_1yr, housing_3yr_ests.HC01_VC03, housing_5yr_ests.HD01_VD01) AS housing_units_2013,
			COALESCE(housing.housing_units_2012_1yr, housing_3yr_ests.HC01_VC03, housing_5yr_ests.HD01_VD01) AS housing_units_2012,
			COALESCE(housing.housing_units_2011_1yr, housing_3yr_ests.HC01_VC03, housing_5yr_ests.HD01_VD01) AS housing_units_2011,
			COALESCE(housing.housing_units_2010_1yr, housing_3yr_ests.HC02_VC03, housing_5yr_ests.HD01_VD01) AS housing_units_2010,
			COALESCE(housing2009.housing_units_2009_1yr, housing_3yr_ests.HC02_VC03, housing_5yr_ests.HD01_VD01) AS housing_units_2009,
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
									REPLACE(housing."GEO.display-label", ', California',""), 
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
			FROM housing
			
		) AS housing
		ON housing.place_1yr = job_counts.formatted_place

		LEFT JOIN (
			SELECT
				LOWER(
					REPLACE(
						REPLACE(
							REPLACE(
								REPLACE(
									REPLACE(housing2009."GEO.display-label", ', California',""), 
								' city',''),
							' town', ''),
						' CDP', ''),
					' ', '_')
				)	AS place_09,  -- reformat place for joins
				HD01_VD01 AS housing_units_2009_1yr
			FROM housing2009
			
		) AS housing2009
		ON housing2009.place_09 = job_counts.formatted_place

		LEFT JOIN (
			SELECT
				LOWER(
					REPLACE(
						REPLACE(
							REPLACE(
								REPLACE(
									REPLACE(housing_3yr_ests."GEO.display-label", ', California',""), 
								' city',''),
							' town', ''),
						' CDP', ''),
					' ', '_')
				)	AS place_3yr,  -- reformat place for joins
				*
			FROM housing_3yr_ests
			
		) AS housing_3yr_ests
		ON housing_3yr_ests.place_3yr = job_counts.formatted_place
		
		LEFT JOIN (
			SELECT
				LOWER(
					REPLACE(
						REPLACE(
							REPLACE(
								REPLACE(
									REPLACE(housing_5yr_ests."GEO.display-label", ', California',''), 
								' city',''),
							' town', ''),
						' CDP', ''),
					' ', '_')
				)	AS place_5yr,  -- reformat place for joins
				*
			FROM housing_5yr_ests
			
		) AS housing_5yr_ests
		ON housing_5yr_ests.place_5yr = job_counts.formatted_place
		
		WHERE
			job_counts.formatted_place NOT LIKE '%county'
	) AS base_data;