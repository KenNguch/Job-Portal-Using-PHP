-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Mar 09, 2019 at 01:26 PM
-- Server version: 10.1.37-MariaDB
-- PHP Version: 5.6.40

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jobportal`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `count_active_opened_jobs` ()  BEGIN
	#Routine body goes here...
	SELECT COUNT(ID) as total
	FROM `pp_post_jobs` AS pj
	WHERE pj.sts='active' AND CURRENT_DATE < pj.last_date;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_active_opened_jobs_by_company_id` (IN `comp_id` INT(11))  BEGIN
	#Routine body goes here...
	SELECT COUNT(ID) as total
	FROM `pp_post_jobs` AS pj
	WHERE pj.company_ID=comp_id AND pj.sts='active';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_active_records_by_city_front_end` (IN `city` VARCHAR(40))  BEGIN
	#Routine body goes here...
	SELECT COUNT(pj.ID) AS total
	FROM `pp_post_jobs` AS pj
	INNER JOIN pp_companies AS pc ON pj.company_ID=pc.ID
	WHERE pj.city=city AND pj.sts='active' AND pc.sts = 'active';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_active_records_by_industry_front_end` (IN `industry_id` INT(11))  BEGIN
	SELECT COUNT(pj.ID) AS total
	FROM `pp_post_jobs` AS pj
	INNER JOIN pp_companies AS pc ON pj.company_ID=pc.ID
	INNER JOIN pp_job_industries AS ji ON pj.industry_ID=ji.ID
	WHERE pj.industry_ID=industry_id AND pj.sts='active' AND pc.sts = 'active';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_all_posted_jobs_by_company_id_frontend` (IN `comp_id` INT(11))  BEGIN
	#Routine body goes here...
	SELECT COUNT(pj.ID) AS total
	FROM `pp_post_jobs` AS pj
	INNER JOIN pp_companies AS pc ON pj.company_ID=pc.ID
	WHERE pj.company_ID=comp_id AND pj.sts='active' AND pc.sts = 'active';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_applied_jobs_by_employer_id` (IN `employer_id` INT(11))  BEGIN
	SELECT COUNT(pp_seeker_applied_for_job.ID) AS total
	FROM `pp_seeker_applied_for_job`
	INNER JOIN pp_post_jobs ON pp_post_jobs.ID=pp_seeker_applied_for_job.job_ID
	INNER JOIN pp_job_seekers ON pp_job_seekers.ID=pp_seeker_applied_for_job.seeker_ID
	WHERE pp_post_jobs.employer_ID=employer_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_applied_jobs_by_jobseeker_id` (IN `jobseeker_id` INT(11))  BEGIN
	SELECT COUNT(pp_seeker_applied_for_job.ID) AS total
	FROM `pp_seeker_applied_for_job`
	WHERE pp_seeker_applied_for_job.seeker_ID=jobseeker_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_ft_job_search_filter_3` (IN `param_city` VARCHAR(255), `param_company_slug` VARCHAR(255), `param_title` VARCHAR(255))  BEGIN
	SELECT COUNT(pj.ID) as total
	FROM pp_post_jobs pj
	INNER JOIN pp_companies pc ON pc.ID = pj.company_ID
	WHERE (pj.job_title like CONCAT("%",param,"%") OR pj.job_description like CONCAT("%",param,"%") OR pj.required_skills like CONCAT("%",param,"%"))
AND pc.company_slug = param_company_slug AND pj.city = param_city AND pj.sts = 'active' AND pc.sts = 'active';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_ft_search_job` (IN `param` VARCHAR(255), `param2` VARCHAR(255))  BEGIN
	SELECT COUNT(pc.ID) as total
	FROM `pp_post_jobs` pj
	INNER JOIN pp_companies AS pc ON pj.company_ID=pc.ID
	WHERE pj.sts = 'active' AND pc.sts = 'active'
AND (pj.job_title like CONCAT("%",param,"%") OR pj.job_description like CONCAT("%",param,"%") OR pj.required_skills like CONCAT("%",param,"%"))
AND pj.city like CONCAT("%",param2,"%");
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_ft_search_resume` (IN `param` VARCHAR(255))  BEGIN
	SELECT COUNT(DISTINCT ss.ID) as total
	FROM `pp_job_seekers` js
	INNER JOIN pp_seeker_skills AS ss ON js.ID=ss.seeker_ID
	WHERE js.sts = 'active'
AND ss.skill_name like CONCAT('%',param,'%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_search_posted_jobs` (IN `where_condition` VARCHAR(255))  BEGIN
	#Routine body goes here...
SET @query = "SELECT COUNT(pj.ID) as total
	FROM `pp_post_jobs` pj
	LEFT JOIN pp_companies AS pc ON pj.company_ID=pc.ID
	WHERE
";

SET @where_clause = CONCAT(where_condition);
SET @query = CONCAT(@query, @where_clause);

PREPARE stmt FROM @query;
EXECUTE stmt;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ft_job_search_filter_3` (IN `param_city` VARCHAR(255), `param_company_slug` VARCHAR(255), `param_title` VARCHAR(255), `from_limit` INT(5), `to_limit` INT(5))  BEGIN
	SELECT pj.ID, pj.job_title, pj.job_slug, pj.employer_ID, pj.company_ID, pj.job_description, pj.city, pj.dated, pj.last_date, pj.is_featured, pj.sts, pc.company_name, pc.company_logo, pc.company_slug, MATCH(pj.job_title, pj.job_description) AGAINST( param_title ) AS score
	FROM pp_post_jobs pj
	INNER JOIN pp_companies pc ON pc.ID = pj.company_ID
	WHERE (pj.job_title like CONCAT("%",param_title,"%") OR pj.job_description like CONCAT("%",param_title,"%") OR pj.required_skills like CONCAT("%",param_title,"%"))
AND pc.company_slug = param_company_slug AND pj.city = param_city AND pj.sts = 'active' AND pc.sts = 'active'

ORDER BY score DESC
	LIMIT from_limit, to_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ft_search_job` (IN `param` VARCHAR(255), `param2` VARCHAR(255), `from_limit` INT(5), `to_limit` INT(5))  BEGIN

	SELECT pj.ID, pj.job_title, pj.job_slug, pj.employer_ID, pj.company_ID, pj.job_description, pj.city, pj.dated, pj.last_date, pj.is_featured, pj.sts, pc.company_name, pc.company_logo, pc.company_slug, MATCH(pj.job_title, pj.job_description) AGAINST(param) AS score
	FROM `pp_post_jobs` pj
	INNER JOIN pp_companies AS pc ON pj.company_ID=pc.ID
	WHERE pj.sts = 'active' AND pc.sts = 'active'
	AND (
			pj.job_title like CONCAT("%",param,"%")
			OR pj.job_description like CONCAT("%",param,"%")
			OR pj.required_skills like CONCAT("%",param,"%")
			OR pj.pay like CONCAT("%",REPLACE(param,' ','-'),"%")
			OR pj.city like CONCAT("%",param,"%")
		)
		AND (pj.city) like CONCAT("%",param2,"%")
ORDER BY pj.ID DESC
	LIMIT from_limit, to_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ft_search_jobs_group_by_city` (IN `param` VARCHAR(255))  BEGIN
	SELECT city, COUNT(city) as score
	FROM `pp_post_jobs` pj
	WHERE pj.sts = 'active'
AND (
			pj.job_title like CONCAT("%",param,"%")
			OR pj.job_description like CONCAT("%",param,"%")
			OR pj.required_skills like CONCAT("%",param,"%")
			OR pj.pay like CONCAT("%",REPLACE(param,' ','-'),"%")
			OR pj.city like CONCAT("%",param,"%")
		)
	GROUP BY city
	ORDER BY score DESC
	LIMIT 0,5;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ft_search_jobs_group_by_company` (IN `param` VARCHAR(255))  BEGIN
	SELECT  pc.company_name,pc.company_slug, COUNT(pc.company_name) as score
	FROM `pp_post_jobs` pj
	INNER JOIN pp_companies AS pc ON pj.company_ID=pc.ID
	WHERE pj.sts = 'active' AND pc.sts = 'active'
AND (
			pj.job_title like CONCAT("%",param,"%")
			OR pj.job_description like CONCAT("%",param,"%")
			OR pj.required_skills like CONCAT("%",param,"%")
			OR pj.pay like CONCAT("%",REPLACE(param,' ','-'),"%")
			OR pj.city like CONCAT("%",param,"%")
		)
	GROUP BY pc.company_name
	ORDER BY score DESC
	LIMIT 0,5;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ft_search_jobs_group_by_salary_range` (IN `param` VARCHAR(255))  BEGIN
	SELECT pay, COUNT(pay) as score
	FROM `pp_post_jobs` pj
	WHERE pj.sts = 'active'
AND (
			pj.job_title like CONCAT("%",param,"%")
			OR pj.job_description like CONCAT("%",param,"%")
			OR pj.required_skills like CONCAT("%",param,"%")
			OR pj.pay like CONCAT("%",REPLACE(param,' ','-'),"%")
			OR pj.city like CONCAT("%",param,"%")
		)
	GROUP BY pay
	ORDER BY score DESC
	LIMIT 0,5;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ft_search_jobs_group_by_title` (IN `param` VARCHAR(255))  BEGIN
	SELECT job_title, COUNT(job_title) as score
	FROM `pp_post_jobs` pj
	WHERE pj.sts = 'active'
AND (
			pj.job_title like CONCAT("%",param,"%")
			OR pj.job_description like CONCAT("%",param,"%")
			OR pj.required_skills like CONCAT("%",param,"%")
			OR pj.pay like CONCAT("%",REPLACE(param,' ','-'),"%")
			OR pj.city like CONCAT("%",param,"%")
		)

	GROUP BY job_title
	ORDER BY score DESC
	LIMIT 0,5;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ft_search_resume` (IN `param` VARCHAR(255), `from_limit` INT(5), `to_limit` INT(5))  BEGIN
  SELECT js.ID, js.first_name, js.gender, js.dob, js.city, js.photo
	FROM pp_job_seekers AS js
	INNER JOIN pp_seeker_skills AS ss ON js.ID=ss.seeker_ID
	WHERE js.sts = 'active' AND ss.skill_name like CONCAT("%",param,"%")
  GROUP BY ss.seeker_ID
	ORDER BY js.ID DESC
	LIMIT from_limit, to_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_active_deactive_posted_job_by_company_id` (IN `comp_id` INT(11), `from_limit` INT(4), `to_limit` INT(4))  BEGIN
	#Routine body goes here...
	SELECT pj.ID, pj.job_title, pj.job_slug, pj.job_description, pj.employer_ID, pj.last_date, pj.dated, pj.city, pj.is_featured, pj.sts, pc.company_name, pc.company_logo
	FROM `pp_post_jobs` AS pj
	INNER JOIN pp_companies AS pc ON pj.company_ID=pc.ID
	WHERE pj.company_ID=comp_id AND pj.sts IN ('active', 'inactive', 'pending') AND pc.sts = 'active'
	ORDER BY ID DESC
	LIMIT from_limit, to_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_active_featured_job` (IN `from_limit` INT(5), `to_limit` INT(5))  BEGIN
	SELECT pj.ID, pj.job_title, pj.job_slug, pj.employer_ID, pj.company_ID, pj.city, pj.dated, pj.last_date, pj.is_featured, pj.sts, pc.company_name, pc.company_logo, pc.company_slug
	FROM `pp_post_jobs` pj
	LEFT JOIN pp_companies AS pc ON pj.company_ID=pc.ID
	WHERE pj.is_featured='yes' AND pj.sts='active' AND pc.sts = 'active'
	ORDER BY ID DESC
	LIMIT from_limit, to_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_active_posted_job_by_company_id` (IN `comp_id` INT(11), `from_limit` INT(4), `to_limit` INT(4))  BEGIN
	#Routine body goes here...
	SELECT pj.ID, pj.job_title, pj.job_slug, pj.job_description, pj.employer_ID, pj.last_date, pj.dated, pj.city, pj.is_featured, pj.sts, pc.company_name, pc.company_logo
	FROM `pp_post_jobs` AS pj
	INNER JOIN pp_companies AS pc ON pj.company_ID=pc.ID
	WHERE pj.company_ID=comp_id AND pj.sts='active' AND pc.sts = 'active'
	ORDER BY ID DESC
	LIMIT from_limit, to_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_active_posted_job_by_id` (IN `job_id` INT(11))  BEGIN
	SELECT pp_post_jobs.*, pc.ID AS CID, emp.first_name, emp.email AS employer_email, pp_job_industries.industry_name, pc.company_name, pc.company_email, pc.company_ceo, pc.company_description, pc.company_logo, pc.company_phone, pc.company_website, pc.company_fax,pc.no_of_offices, pc.no_of_employees, pc.established_in, pc.industry_ID AS cat_ID, pc.company_location, pc.company_slug
,emp.city as emp_city, emp.country as emp_country
FROM `pp_post_jobs`
	INNER JOIN pp_companies AS pc ON pp_post_jobs.company_ID=pc.ID
	INNER JOIN pp_employers AS emp ON pc.ID=emp.company_ID
	INNER JOIN pp_job_industries ON pp_post_jobs.industry_ID=pp_job_industries.ID
	WHERE pp_post_jobs.ID=job_id AND pp_post_jobs.sts='active' AND pc.sts = 'active';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_active_employers` (IN `from_limit` INT(5), `to_limit` INT(5))  BEGIN
	SELECT pc.ID AS CID, pc.company_name, pc.company_logo, pc.company_slug
	FROM `pp_employers` emp
	INNER JOIN pp_companies AS pc ON emp.company_ID=pc.ID
	WHERE emp.sts = 'active'
	ORDER BY emp.ID DESC
	LIMIT from_limit, to_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_active_top_employers` (IN `from_limit` INT(5), `to_limit` INT(5))  BEGIN
	SELECT pc.ID AS CID, pc.company_name, pc.company_logo, pc.company_slug
	FROM `pp_employers` emp
	INNER JOIN pp_companies AS pc ON emp.company_ID=pc.ID
	WHERE emp.sts = 'active' AND emp.top_employer = 'yes'
	ORDER BY emp.ID DESC
	LIMIT from_limit, to_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_opened_jobs` (IN `from_limit` INT(5), `to_limit` INT(5))  BEGIN
	SELECT pj.ID, pj.job_title, pj.job_slug, pj.employer_ID, pj.company_ID, pj.job_description, pj.city, pj.dated, pj.last_date, pj.is_featured, pj.sts, pc.company_name, pc.company_logo, pc.company_slug, ji.industry_name
	FROM `pp_post_jobs` pj
	INNER JOIN pp_companies AS pc ON pj.company_ID=pc.ID
	INNER JOIN pp_job_industries AS ji ON pj.industry_ID=ji.ID
	WHERE pj.sts = 'active' AND pc.sts='active'
	ORDER BY pj.ID DESC
	LIMIT from_limit, to_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_posted_jobs` (IN `from_limit` INT(5), `to_limit` INT(5))  BEGIN
	#Routine body goes here...
	SELECT pj.ID, pj.job_title, pj.job_slug, pj.employer_ID, pj.company_ID, pj.job_description, pj.city, pj.dated, pj.last_date, pj.is_featured, pj.sts, pc.company_name, pc.company_logo, pc.company_slug, pj.ip_address
	FROM `pp_post_jobs` pj
	INNER JOIN pp_companies AS pc ON pj.company_ID=pc.ID
	ORDER BY ID DESC
	LIMIT from_limit, to_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_posted_jobs_by_company_id_frontend` (IN `comp_id` INT(11), `from_limit` INT(4), `to_limit` INT(4))  BEGIN
	#Routine body goes here...
	SELECT pj.ID, pj.job_title, pj.job_slug, pj.job_description, pj.employer_ID, pj.last_date, pj.dated, pj.city, pj.is_featured, pj.sts, pc.company_name, pc.company_logo
	FROM `pp_post_jobs` AS pj
	INNER JOIN pp_companies AS pc ON pj.company_ID=pc.ID
	WHERE pj.company_ID=comp_id AND pj.sts='active' AND pc.sts = 'active'
	ORDER BY ID DESC
	LIMIT from_limit, to_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_posted_jobs_by_status` (IN `job_status` VARCHAR(10), `from_limit` INT(5), `to_limit` INT(5))  BEGIN
	#Routine body goes here...
	SELECT pj.ID, pj.job_title, pj.job_slug, pj.employer_ID, pj.company_ID, pj.job_description, pj.city, pj.dated, pj.last_date, pj.is_featured, pj.sts, pc.company_name, pc.company_logo, pc.company_slug
	FROM `pp_post_jobs` pj
	INNER JOIN pp_companies AS pc ON pj.company_ID=pc.ID
	WHERE pj.sts = job_status
	ORDER BY ID DESC
	LIMIT from_limit, to_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_applied_jobs_by_employer_id` (IN `employer_id` INT(11), `from_limit` INT(5), `to_limit` INT(5))  BEGIN
	SELECT pp_seeker_applied_for_job.dated AS applied_date, pp_post_jobs.ID, pp_post_jobs.job_title, pp_job_seekers.ID AS job_seeker_ID, pp_post_jobs.job_slug, pp_job_seekers.first_name, pp_job_seekers.last_name, pp_job_seekers.slug
	FROM `pp_seeker_applied_for_job`
	INNER JOIN pp_post_jobs ON pp_post_jobs.ID=pp_seeker_applied_for_job.job_ID
	INNER JOIN pp_job_seekers ON pp_job_seekers.ID=pp_seeker_applied_for_job.seeker_ID
	WHERE pp_post_jobs.employer_ID=employer_id
	ORDER BY pp_seeker_applied_for_job.ID DESC
	LIMIT from_limit, to_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_applied_jobs_by_jobseeker_id` (IN `jobseeker_id` INT(11), `from_limit` INT(5), `to_limit` INT(5))  BEGIN
	SELECT pp_seeker_applied_for_job.ID as applied_id, pp_seeker_applied_for_job.dated AS applied_date, pp_post_jobs.ID, pp_post_jobs.job_title, pp_post_jobs.job_slug, pp_companies.company_name, pp_companies.company_slug, pp_companies.company_logo
	FROM `pp_seeker_applied_for_job`
	INNER JOIN pp_post_jobs ON pp_post_jobs.ID=pp_seeker_applied_for_job.job_ID
	INNER JOIN pp_employers ON pp_employers.ID=pp_post_jobs.employer_ID
	INNER JOIN pp_companies ON pp_companies.ID=pp_employers.company_ID
	WHERE pp_seeker_applied_for_job.seeker_ID=jobseeker_id
	ORDER BY pp_seeker_applied_for_job.ID DESC
	LIMIT from_limit, to_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_applied_jobs_by_seeker_id` (IN `applicant_id` INT(11), `from_limit` INT(5), `to_limit` INT(5))  BEGIN
	#Routine body goes here...
	SELECT aj.*, pp_post_jobs.ID AS posted_job_id, pp_post_jobs.employer_ID, pp_post_jobs.job_title, pp_post_jobs.job_slug, pp_post_jobs.city, pp_post_jobs.is_featured, pp_post_jobs.sts, pp_companies.company_name, pp_companies.company_logo, pp_job_seekers.first_name, pp_job_seekers.last_name, pp_job_seekers.photo
	FROM `pp_seeker_applied_for_job` aj
	INNER JOIN pp_job_seekers ON aj.seeker_ID=pp_job_seekers.ID
	INNER JOIN pp_post_jobs ON aj.job_ID=pp_post_jobs.ID
	INNER JOIN pp_companies ON pp_post_jobs.company_ID=pp_companies.ID
	WHERE aj.seeker_ID=applicant_id
	ORDER BY ID DESC
	LIMIT from_limit, to_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_company_by_slug` (IN `slug` VARCHAR(70))  BEGIN
	SELECT emp.ID AS empID, pc.ID, emp.country, emp.city, pc.company_name, pc.company_description, pc.company_location, pc.company_website, pc.no_of_employees, pc.established_in, pc.company_logo, pc.company_slug
	FROM `pp_employers` AS emp
	INNER JOIN pp_companies AS pc ON emp.company_ID=pc.ID
	WHERE pc.company_slug=slug AND emp.sts='active';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_experience_by_jobseeker_id` (IN `jobseeker_id` INT(11))  BEGIN
	SELECT pp_seeker_experience.*
	FROM `pp_seeker_experience`
	WHERE pp_seeker_experience.seeker_ID=jobseeker_id
	ORDER BY pp_seeker_experience.start_date DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_featured_job` (IN `from_limit` INT(5), `to_limit` INT(5))  BEGIN
	#Routine body goes here...
	SELECT pj.ID, pj.job_title, pj.job_slug, pj.employer_ID, pj.company_ID, pj.city, pj.dated, pj.last_date, pj.is_featured, pj.sts, pc.company_name, pc.company_logo, pc.company_slug
	FROM `pp_post_jobs` pj
	LEFT JOIN pp_companies AS pc ON pj.company_ID=pc.ID
	WHERE pj.is_featured='yes'
	ORDER BY ID DESC
	LIMIT from_limit, to_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_latest_posted_job_by_employer_ID` (IN `emp_id` INT(11), `from_limit` INT(4), `to_limit` INT(4))  BEGIN
	#Routine body goes here...
	SELECT pp_post_jobs.ID, pp_post_jobs.job_title, pp_post_jobs.job_slug, pp_post_jobs.employer_ID, pp_post_jobs.last_date, pp_post_jobs.dated, pp_post_jobs.city, pp_post_jobs.is_featured, pp_post_jobs.sts, pp_job_industries.industry_name, pc.company_name, pc.company_logo
	FROM `pp_post_jobs`
	INNER JOIN pp_companies AS pc ON pp_post_jobs.company_ID=pc.ID
	INNER JOIN pp_employers AS emp ON pp_post_jobs.employer_ID=emp.ID
	INNER JOIN pp_job_industries ON pp_post_jobs.industry_ID=pp_job_industries.ID
	WHERE pp_post_jobs.employer_ID=emp_id
	ORDER BY ID DESC
	LIMIT from_limit, to_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_opened_jobs_home_page` (IN `from_limit` INT(5), `to_limit` INT(5))  BEGIN
set @prev := 0, @rownum := '';
SELECT ID, job_title, job_slug, employer_ID, company_ID, job_description, city, dated, last_date, is_featured, sts, company_name, company_logo, company_slug, industry_name
FROM (
  SELECT ID, job_title, job_slug, employer_ID, company_ID, job_description, city, dated, last_date, is_featured, sts, company_name, company_logo, company_slug, industry_name,
         IF( @prev <> company_ID,
             @rownum := 1,
             @rownum := @rownum+1
         ) AS rank,
         @prev := company_ID,
         @rownum
			FROM (
					SELECT pj.ID, pj.job_title, pj.job_slug, pj.employer_ID, pj.company_ID, pj.job_description, pj.city, pj.dated, pj.last_date, pj.is_featured, pj.sts, company_name, company_logo, company_slug, industry_name
					FROM pp_post_jobs AS pj
					INNER JOIN pp_companies AS pc ON pj.company_ID=pc.ID
					INNER JOIN pp_job_industries AS ji ON pj.industry_ID=ji.ID
					WHERE pj.sts = 'active' AND pc.sts='active'
					ORDER BY company_ID DESC, ID DESC
			) pj
) jobs_ranked
WHERE jobs_ranked.rank <= 2
ORDER BY jobs_ranked.ID DESC
LIMIT from_limit,to_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_posted_job_by_company_id` (IN `comp_id` INT(11), `from_limit` INT(4), `to_limit` INT(4))  BEGIN
	#Routine body goes here...
	SELECT pp_post_jobs.ID, pp_post_jobs.job_title, pp_post_jobs.job_slug, pp_post_jobs.employer_ID, pp_post_jobs.last_date, pp_post_jobs.dated, pp_post_jobs.city, pp_post_jobs.job_description, pp_post_jobs.is_featured, pp_post_jobs.sts, pp_job_industries.industry_name, pc.company_name, pc.company_logo
	FROM `pp_post_jobs`
	INNER JOIN pp_companies AS pc ON pp_post_jobs.company_ID=pc.ID
	INNER JOIN pp_job_industries ON pp_post_jobs.industry_ID=pp_job_industries.ID
	WHERE pp_post_jobs.company_ID=comp_id
	ORDER BY ID DESC
	LIMIT from_limit, to_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_posted_job_by_employer_id` (IN `emp_id` INT(11), `from_limit` INT(4), `to_limit` INT(4))  BEGIN
	#Routine body goes here...
	SELECT pp_post_jobs.ID, pp_post_jobs.job_title, pp_post_jobs.job_slug, pp_post_jobs.job_description, pp_post_jobs.contact_person, pp_post_jobs.contact_email, pp_post_jobs.contact_phone, pp_post_jobs.employer_ID, pp_post_jobs.last_date, pp_post_jobs.dated, pp_post_jobs.city, pp_post_jobs.is_featured, pp_post_jobs.sts, pp_job_industries.industry_name, pc.company_name, pc.company_logo
	FROM `pp_post_jobs`
	INNER JOIN pp_companies AS pc ON pp_post_jobs.company_ID=pc.ID
	INNER JOIN pp_employers AS emp ON pp_post_jobs.employer_ID=emp.ID
	INNER JOIN pp_job_industries ON pp_post_jobs.industry_ID=pp_job_industries.ID
	WHERE pp_post_jobs.employer_ID=emp_id
	ORDER BY ID DESC
	LIMIT from_limit, to_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_posted_job_by_id` (IN `job_id` INT(11))  BEGIN
	#Routine body goes here...
	SELECT pp_post_jobs.*, pc.ID AS CID, pp_job_industries.industry_name, pc.company_name, pc.company_email, pc.company_ceo, pc.company_description, pc.company_logo, pc.company_phone, pc.company_website, pc.company_fax,pc.no_of_offices, pc.no_of_employees, pc.established_in, pc.industry_ID AS cat_ID, pc.company_location, pc.company_slug
,em.city as emp_city, em.country as emp_country
	FROM `pp_post_jobs`
	INNER JOIN pp_companies AS pc ON pp_post_jobs.company_ID=pc.ID
  INNER JOIN pp_employers AS em ON pc.ID=em.company_ID
	INNER JOIN pp_job_industries ON pp_post_jobs.industry_ID=pp_job_industries.ID
	WHERE pp_post_jobs.ID=job_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_posted_job_by_id_employer_id` (IN `job_id` INT(11), `emp_id` INT(11))  BEGIN
	SELECT pp_post_jobs.*, pc.ID AS CID, pp_job_industries.industry_name, pc.company_name, pc.company_email, pc.company_ceo, pc.company_description, pc.company_logo, pc.company_phone, pc.company_website, pc.company_fax,pc.no_of_offices, pc.no_of_employees, pc.established_in, pc.industry_ID AS cat_ID, pc.company_location, pc.company_slug
	FROM `pp_post_jobs`
	INNER JOIN pp_companies AS pc ON pp_post_jobs.company_ID=pc.ID
	INNER JOIN pp_employers AS emp ON pp_post_jobs.employer_ID=emp.ID
	INNER JOIN pp_job_industries ON pp_post_jobs.industry_ID=pp_job_industries.ID
	WHERE pp_post_jobs.ID=job_id AND pp_post_jobs.employer_ID=emp_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_qualification_by_jobseeker_id` (IN `jobseeker_id` INT(11))  BEGIN
	SELECT pp_seeker_academic.*
	FROM `pp_seeker_academic`
	WHERE pp_seeker_academic.seeker_ID=jobseeker_id
	ORDER BY pp_seeker_academic.completion_year DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `job_search_by_city` (IN `param_city` VARCHAR(255), `from_limit` INT(5), `to_limit` INT(5))  BEGIN
	SELECT pj.ID, pj.job_title, pj.job_slug, pj.employer_ID, pj.company_ID, pj.job_description, pj.city, pj.dated, pj.last_date, pj.is_featured, pj.sts, pc.company_name, pc.company_logo, pc.company_slug
	FROM pp_post_jobs pj
	INNER JOIN pp_companies pc ON pc.ID = pj.company_ID
	WHERE pj.city = param_city AND pj.sts = 'active' AND pc.sts = 'active'
	ORDER BY pj.dated DESC
	LIMIT from_limit, to_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `job_search_by_industry` (IN `param` VARCHAR(255), `from_limit` INT(5), `to_limit` INT(5))  BEGIN
	SELECT pj.ID, pj.job_title, pj.job_slug, pj.employer_ID, pj.company_ID, pj.job_description, pj.city, pj.dated, pj.last_date, pj.is_featured, pj.sts, pc.company_name, pc.company_logo, pc.company_slug
	FROM pp_post_jobs pj
	INNER JOIN pp_companies pc ON pc.ID = pj.company_ID
	WHERE pj.industry_ID = param AND pj.sts = 'active' AND pc.sts = 'active'
	ORDER BY pj.dated DESC
	LIMIT from_limit, to_limit;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `search_posted_jobs` (IN `where_condition` VARCHAR(255), `from_limit` INT(11), `to_limit` INT(11))  BEGIN
	#Routine body goes here...
SET @query = "SELECT pj.ID, pj.job_title,  pj.job_slug, pj.employer_ID, pj.company_ID, pj.city, pj.dated, pj.last_date, pj.is_featured, pj.sts, pc.company_name, pc.company_logo
	FROM `pp_post_jobs` pj
	LEFT JOIN pp_companies AS pc ON pj.company_ID=pc.ID
	WHERE
";

SET @where_clause = CONCAT(where_condition);
SET @after_where_clause = CONCAT("ORDER BY ID DESC LIMIT ",from_limit,", ",to_limit,"");
SET @full_search_clause = CONCAT(@where_clause, @after_where_clause);
SET @query = CONCAT(@query, @full_search_clause);

PREPARE stmt FROM @query;
EXECUTE stmt;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `pp_admin`
--

CREATE TABLE `pp_admin` (
  `id` int(8) NOT NULL,
  `admin_username` varchar(80) DEFAULT NULL,
  `admin_password` varchar(100) DEFAULT NULL,
  `type` tinyint(1) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_admin`
--

INSERT INTO `pp_admin` (`id`, `admin_username`, `admin_password`, `type`) VALUES
(1, 'admin', 'admin', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pp_ad_codes`
--

CREATE TABLE `pp_ad_codes` (
  `ID` int(4) NOT NULL,
  `bottom` text,
  `right_side_1` text,
  `right_side_2` text,
  `google_analytics` text
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_ad_codes`
--

INSERT INTO `pp_ad_codes` (`ID`, `bottom`, `right_side_1`, `right_side_2`, `google_analytics`) VALUES
(1, '', '', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `pp_cities`
--

CREATE TABLE `pp_cities` (
  `ID` int(11) NOT NULL,
  `show` tinyint(1) NOT NULL DEFAULT '1',
  `city_slug` varchar(150) NOT NULL,
  `city_name` varchar(150) DEFAULT NULL,
  `sort_order` int(3) NOT NULL DEFAULT '998',
  `country_ID` int(11) NOT NULL,
  `is_popular` enum('yes','no') NOT NULL DEFAULT 'no'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_cities`
--

INSERT INTO `pp_cities` (`ID`, `show`, `city_slug`, `city_name`, `sort_order`, `country_ID`, `is_popular`) VALUES
(1, 1, '', 'Nairobi', 998, 0, ''),
(2, 1, '', 'Nakuru', 998, 0, ''),
(3, 1, '', 'Kisumu', 998, 0, ''),
(4, 1, '', 'Limuru', 998, 0, ''),
(5, 1, '', 'Garissa', 998, 0, ''),
(8, 1, '', 'Nyandarua', 998, 0, ''),
(9, 1, '', 'Tharaka Nithi', 998, 0, ''),
(10, 1, '', 'Nyeri', 998, 0, ''),
(11, 1, '', 'Nyamira', 998, 0, ''),
(12, 1, '', 'Migori', 998, 0, ''),
(13, 1, '', 'Kirinyaga', 998, 0, ''),
(15, 1, '', 'Mombasa', 998, 0, ''),
(16, 1, '', 'Naivasha', 998, 0, ''),
(18, 1, '', 'Narok', 998, 0, ''),
(19, 1, '', 'Kiambu', 998, 0, '');

-- --------------------------------------------------------

--
-- Table structure for table `pp_cms`
--

CREATE TABLE `pp_cms` (
  `pageID` int(11) NOT NULL,
  `pageTitle` varchar(100) DEFAULT NULL,
  `pageSlug` varchar(100) DEFAULT NULL,
  `pageContent` text,
  `pageImage` varchar(100) DEFAULT NULL,
  `pageParentPageID` int(11) DEFAULT '0',
  `dated` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `pageStatus` enum('Inactive','Published') DEFAULT 'Inactive',
  `seoMetaTitle` varchar(100) DEFAULT NULL,
  `seoMetaKeyword` varchar(255) DEFAULT NULL,
  `seoMetaDescription` varchar(255) DEFAULT NULL,
  `seoAllowCrawler` tinyint(1) DEFAULT '1',
  `pageCss` text,
  `pageScript` text,
  `menuTop` tinyint(4) DEFAULT '0',
  `menuBottom` tinyint(4) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_cms`
--

INSERT INTO `pp_cms` (`pageID`, `pageTitle`, `pageSlug`, `pageContent`, `pageImage`, `pageParentPageID`, `dated`, `pageStatus`, `seoMetaTitle`, `seoMetaKeyword`, `seoMetaDescription`, `seoAllowCrawler`, `pageCss`, `pageScript`, `menuTop`, `menuBottom`) VALUES
(7, 'About Us', 'about-us.html', 'Technology has changed the way job seekers search for jobs and employers find qualified employees. While employers still advertise job openings through traditional advertising mediums, such as local newspapers and magazines, today employers and job seekers turn to online job portals to find employment matches. Job seekers can advertise their skills and search for available positions, and employers can announce employment openings through job portals such as Monster, Career Builders and Kenya Jobs, for federal government positions.\r\n\r\nJob Seekers\r\nThe majority of job portals allow job seekers to sign up for a free account, which allows them to search job openings posted by employers and post their resumes for employers to review. Portals offer resume posting services, allowing job seekers to copy and paste resume information from a word processing document or build a new resume with online tools. Job portals often offer the option of submitting a completed resume, created from a word processing program such as Microsoft Word. Job seekers can browse through job openings posted by employers and apply for positions through the job portal.\r\n\r\nEmployers\r\nJob portals provide a centralized location for employers to post information about job openings. The majority of employment portals require a fee for employers to post job openings and respond to resumes, with varying terms depending on the job portal. Employers can browse through job seekers\' resumes to find potential matches for job openings. Job portals offer worldwide access for job seekers to view advertisements, providing employers with a wider variety of applicants and a broader candidate pool. Employers can utilize job portal matching technology, allowing the system to find potential matches for employment openings. Sites can also feature partnerships with daily and weekly newspapers, providing print and online job advertising for employers. Individual job portals often maintain partnerships with other, industry-specific employment websites, offering advertising throughout a network of partners.', 'about-company1.jpg', 0, '2019-03-09 11:54:37', 'Inactive', 'About Us', 'About Job Portal, Jobs, IT', 'The leading online job portal', 1, NULL, NULL, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `pp_cms_previous`
--

CREATE TABLE `pp_cms_previous` (
  `ID` int(11) NOT NULL,
  `page` varchar(60) DEFAULT NULL,
  `heading` varchar(155) DEFAULT NULL,
  `content` text,
  `page_slug` varchar(100) DEFAULT NULL,
  `sts` enum('blocked','active') DEFAULT 'active',
  `dated` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_cms_previous`
--

INSERT INTO `pp_cms_previous` (`ID`, `page`, `heading`, `content`, `page_slug`, `sts`, `dated`) VALUES
(4, NULL, 'About Us', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi a velit sed risus pulvinar faucibus. Nulla facilisi. Nullam vehicula nec ligula eu vulputate. Nunc id ultrices mi, ac tristique lectus. Suspendisse porta ultrices ultricies. Sed quis nisi vel magna maximus aliquam a vel nisl. Cras non rutrum diam. Nulla sed ipsum a felis posuere pharetra ut sit amet augue. Sed id nisl sodales, vulputate mi eu, viverra neque. Fusce fermentum, est ut accumsan accumsan, risus ante varius diam, non venenatis eros ligula fermentum leo. Etiam consectetur imperdiet volutpat. Donec ut pharetra nisi, eget pellentesque tortor. Integer eleifend dolor eu ex lobortis, ac gravida augue tristique. Proin placerat consectetur tincidunt. Nullam sollicitudin, neque eget iaculis ultricies, est justo pulvinar turpis, vulputate convallis leo orci at sapien.\n<br /><br />\nQuisque ac scelerisque libero, nec blandit neque. Nullam felis nisl, elementum eu sapien ut, convallis interdum felis. In turpis odio, fermentum non pulvinar gravida, posuere quis magna. Ut mollis eget neque at euismod. Interdum et malesuada fames ac ante ipsum primis in faucibus. Integer faucibus orci a pulvinar malesuada. Aenean at felis vitae lorem venenatis consequat. Nam non nunc euismod, consequat ligula non, tristique odio. Ut leo sapien, aliquet sed ultricies et, scelerisque quis nulla. Aenean non sapien maximus, convallis eros vitae, iaculis massa. In fringilla hendrerit nisi, eu pellentesque massa faucibus molestie. Etiam laoreet eros quis faucibus rutrum. Quisque eleifend purus justo, eget tempus quam interdum non.\n<br /><br />\nNullam enim ex, vulputate at ultricies bibendum, interdum sit amet tortor. Fusce semper augue ac ipsum ultricies interdum. Cras maximus faucibus sapien, et lacinia leo efficitur id. Nullam laoreet pulvinar nibh et ullamcorper. Etiam a lorem rhoncus, rutrum felis sed, blandit orci. Nulla vel tellus gravida, pretium neque a, fringilla lectus. Morbi et leo mi. Aliquam interdum ex ipsum. Vivamus eu ultrices ante, eget volutpat massa. Nulla nisi purus, sollicitudin euismod eleifend pulvinar, dictum rutrum lacus. Nam hendrerit sed arcu a pellentesque. Vestibulum maximus ligula tellus, a euismod dui feugiat et. Aliquam viverra blandit est nec ultricies.\n<br /><br />\nNullam et sem a dui accumsan ornare. Praesent faucibus ultricies orci. Maecenas hendrerit tincidunt rutrum. Phasellus eget libero eget ante interdum venenatis. Cras sodales finibus vulputate. Aenean aliquet velit eget felis pellentesque, et blandit ex facilisis. Vivamus sit amet euismod diam, at rhoncus ex. Nullam consectetur, erat ut maximus dignissim, ex eros pellentesque ex, at dictum odio dui in urna. Nulla rutrum nisi eget risus accumsan, sit amet iaculis risus interdum. Curabitur accumsan eu purus nec condimentum. Fusce pulvinar ex id sagittis sodales. Donec hendrerit scelerisque est, in viverra nibh lobortis et.\n<br /><br />\n<ul>\n<li>Quisque facilisis purus vel sem laoreet posuere.</li>\n<li>Proin eleifend velit ut elit sollicitudin scelerisque.</li>\n<li>Nulla aliquet urna in magna congue, ac hendrerit velit lacinia.</li>\n<li>Aliquam id urna ut lorem porta vulputate.</li>\n<li>Sed ultrices sem quis risus tincidunt, ut lacinia nunc aliquet.</li>\n<li>Phasellus in est suscipit, feugiat tortor ac, iaculis enim.</li>\n</ul>', 'about_us.html', 'active', '2014-05-16 13:47:11'),
(12, NULL, 'First Day of New Job', '<strong>Lorem Ipsum</strong> is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry&#39;s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.<br />\r\n<br />\r\n<strong>Lorem Ipsum</strong> is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry&#39;s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.<br />\r\n<br />\r\n<strong>Lorem Ipsum</strong> is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry&#39;s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.<br />\r\n&nbsp;', 'first_day_job.html', 'active', '2014-05-16 14:46:14'),
(13, NULL, 'Privacy Policy', '<strong>Lorem Ipsum</strong>&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry&#39;s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.<br />\n<br />\n<strong>Lorem Ipsum</strong>&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry&#39;s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.<br />\n<br />\n<strong>Lorem Ipsum</strong>&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry&#39;s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', 'privacy-policy.html', 'active', '2015-05-20 23:38:56'),
(15, NULL, 'Why Job', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi a velit sed risus pulvinar faucibus. Nulla facilisi. Nullam vehicula nec ligula eu vulputate. Nunc id ultrices mi, ac tristique lectus. Suspendisse porta ultrices ultricies. Sed quis nisi vel magna maximus aliquam a vel nisl. Cras non rutrum diam. Nulla sed ipsum a felis posuere pharetra ut sit amet augue. Sed id nisl sodales, vulputate mi eu, viverra neque. Fusce fermentum, est ut accumsan accumsan, risus ante varius diam, non venenatis eros ligula fermentum leo. Etiam consectetur imperdiet volutpat. Donec ut pharetra nisi, eget pellentesque tortor. Integer eleifend dolor eu ex lobortis, ac gravida augue tristique. Proin placerat consectetur tincidunt. Nullam sollicitudin, neque eget iaculis ultricies, est justo pulvinar turpis, vulputate convallis leo orci at sapien.<br />\n<br />\nQuisque ac scelerisque libero, nec blandit neque. Nullam felis nisl, elementum eu sapien ut, convallis interdum felis. In turpis odio, fermentum non pulvinar gravida, posuere quis magna. Ut mollis eget neque at euismod. Interdum et malesuada fames ac ante ipsum primis in faucibus. Integer faucibus orci a pulvinar malesuada. Aenean at felis vitae lorem venenatis consequat. Nam non nunc euismod, consequat ligula non, tristique odio. Ut leo sapien, aliquet sed ultricies et, scelerisque quis nulla. Aenean non sapien maximus, convallis eros vitae, iaculis massa. In fringilla hendrerit nisi, eu pellentesque massa faucibus molestie. Etiam laoreet eros quis faucibus rutrum. Quisque eleifend purus justo, eget tempus quam interdum non.<br />\n<br />\nNullam enim ex, vulputate at ultricies bibendum, interdum sit amet tortor. Fusce semper augue ac ipsum ultricies interdum. Cras maximus faucibus sapien, et lacinia leo efficitur id. Nullam laoreet pulvinar nibh et ullamcorper. Etiam a lorem rhoncus, rutrum felis sed, blandit orci. Nulla vel tellus gravida, pretium neque a, fringilla lectus. Morbi et leo mi. Aliquam interdum ex ipsum. Vivamus eu ultrices ante, eget volutpat massa. Nulla nisi purus, sollicitudin euismod eleifend pulvinar, dictum rutrum lacus. Nam hendrerit sed arcu a pellentesque. Vestibulum maximus ligula tellus, a euismod dui feugiat et. Aliquam viverra blandit est nec ultricies.<br />\n<br />\nNullam et sem a dui accumsan ornare. Praesent faucibus ultricies orci. Maecenas hendrerit tincidunt rutrum. Phasellus eget libero eget ante interdum venenatis. Cras sodales finibus vulputate. Aenean aliquet velit eget felis pellentesque, et blandit ex facilisis. Vivamus sit amet euismod diam, at rhoncus ex. Nullam consectetur, erat ut maximus dignissim, ex eros pellentesque ex, at dictum odio dui in urna. Nulla rutrum nisi eget risus accumsan, sit amet iaculis risus interdum. Curabitur accumsan eu purus nec condimentum. Fusce pulvinar ex id sagittis sodales. Donec hendrerit scelerisque est, in viverra nibh lobortis et.', 'why_job.html', 'active', '2016-03-12 16:12:11'),
(16, NULL, 'Preparing for Interview', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi a velit sed risus pulvinar faucibus. Nulla facilisi. Nullam vehicula nec ligula eu vulputate. Nunc id ultrices mi, ac tristique lectus. Suspendisse porta ultrices ultricies. Sed quis nisi vel magna maximus aliquam a vel nisl. Cras non rutrum diam. Nulla sed ipsum a felis posuere pharetra ut sit amet augue. Sed id nisl sodales, vulputate mi eu, viverra neque. Fusce fermentum, est ut accumsan accumsan, risus ante varius diam, non venenatis eros ligula fermentum leo. Etiam consectetur imperdiet volutpat. Donec ut pharetra nisi, eget pellentesque tortor. Integer eleifend dolor eu ex lobortis, ac gravida augue tristique. Proin placerat consectetur tincidunt. Nullam sollicitudin, neque eget iaculis ultricies, est justo pulvinar turpis, vulputate convallis leo orci at sapien.\n<br /><br />\nQuisque ac scelerisque libero, nec blandit neque. Nullam felis nisl, elementum eu sapien ut, convallis interdum felis. In turpis odio, fermentum non pulvinar gravida, posuere quis magna. Ut mollis eget neque at euismod. Interdum et malesuada fames ac ante ipsum primis in faucibus. Integer faucibus orci a pulvinar malesuada. Aenean at felis vitae lorem venenatis consequat. Nam non nunc euismod, consequat ligula non, tristique odio. Ut leo sapien, aliquet sed ultricies et, scelerisque quis nulla. Aenean non sapien maximus, convallis eros vitae, iaculis massa. In fringilla hendrerit nisi, eu pellentesque massa faucibus molestie. Etiam laoreet eros quis faucibus rutrum. Quisque eleifend purus justo, eget tempus quam interdum non.\n<br /><br />\nNullam enim ex, vulputate at ultricies bibendum, interdum sit amet tortor. Fusce semper augue ac ipsum ultricies interdum. Cras maximus faucibus sapien, et lacinia leo efficitur id. Nullam laoreet pulvinar nibh et ullamcorper. Etiam a lorem rhoncus, rutrum felis sed, blandit orci. Nulla vel tellus gravida, pretium neque a, fringilla lectus. Morbi et leo mi. Aliquam interdum ex ipsum. Vivamus eu ultrices ante, eget volutpat massa. Nulla nisi purus, sollicitudin euismod eleifend pulvinar, dictum rutrum lacus. Nam hendrerit sed arcu a pellentesque. Vestibulum maximus ligula tellus, a euismod dui feugiat et. Aliquam viverra blandit est nec ultricies.\n<br /><br />\nNullam et sem a dui accumsan ornare. Praesent faucibus ultricies orci. Maecenas hendrerit tincidunt rutrum. Phasellus eget libero eget ante interdum venenatis. Cras sodales finibus vulputate. Aenean aliquet velit eget felis pellentesque, et blandit ex facilisis. Vivamus sit amet euismod diam, at rhoncus ex. Nullam consectetur, erat ut maximus dignissim, ex eros pellentesque ex, at dictum odio dui in urna. Nulla rutrum nisi eget risus accumsan, sit amet iaculis risus interdum. Curabitur accumsan eu purus nec condimentum. Fusce pulvinar ex id sagittis sodales. Donec hendrerit scelerisque est, in viverra nibh lobortis et.\n<br /><br />\n<ul>\n<li>Quisque facilisis purus vel sem laoreet posuere.</li>\n<li>Proin eleifend velit ut elit sollicitudin scelerisque.</li>\n<li>Nulla aliquet urna in magna congue, ac hendrerit velit lacinia.</li>\n<li>Aliquam id urna ut lorem porta vulputate.</li>\n<li>Sed ultrices sem quis risus tincidunt, ut lacinia nunc aliquet.</li>\n<li>Phasellus in est suscipit, feugiat tortor ac, iaculis enim.</li>\n</ul>', 'interview.html', 'active', '2016-03-12 16:17:56'),
(17, NULL, 'CV Writing Tips', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi a velit sed risus pulvinar faucibus. Nulla facilisi. Nullam vehicula nec ligula eu vulputate. Nunc id ultrices mi, ac tristique lectus. Suspendisse porta ultrices ultricies. Sed quis nisi vel magna maximus aliquam a vel nisl. Cras non rutrum diam. Nulla sed ipsum a felis posuere pharetra ut sit amet augue. Sed id nisl sodales, vulputate mi eu, viverra neque. Fusce fermentum, est ut accumsan accumsan, risus ante varius diam, non venenatis eros ligula fermentum leo. Etiam consectetur imperdiet volutpat. Donec ut pharetra nisi, eget pellentesque tortor. Integer eleifend dolor eu ex lobortis, ac gravida augue tristique. Proin placerat consectetur tincidunt. Nullam sollicitudin, neque eget iaculis ultricies, est justo pulvinar turpis, vulputate convallis leo orci at sapien.\n<br /><br />\nQuisque ac scelerisque libero, nec blandit neque. Nullam felis nisl, elementum eu sapien ut, convallis interdum felis. In turpis odio, fermentum non pulvinar gravida, posuere quis magna. Ut mollis eget neque at euismod. Interdum et malesuada fames ac ante ipsum primis in faucibus. Integer faucibus orci a pulvinar malesuada. Aenean at felis vitae lorem venenatis consequat. Nam non nunc euismod, consequat ligula non, tristique odio. Ut leo sapien, aliquet sed ultricies et, scelerisque quis nulla. Aenean non sapien maximus, convallis eros vitae, iaculis massa. In fringilla hendrerit nisi, eu pellentesque massa faucibus molestie. Etiam laoreet eros quis faucibus rutrum. Quisque eleifend purus justo, eget tempus quam interdum non.\n<br /><br />\nNullam enim ex, vulputate at ultricies bibendum, interdum sit amet tortor. Fusce semper augue ac ipsum ultricies interdum. Cras maximus faucibus sapien, et lacinia leo efficitur id. Nullam laoreet pulvinar nibh et ullamcorper. Etiam a lorem rhoncus, rutrum felis sed, blandit orci. Nulla vel tellus gravida, pretium neque a, fringilla lectus. Morbi et leo mi. Aliquam interdum ex ipsum. Vivamus eu ultrices ante, eget volutpat massa. Nulla nisi purus, sollicitudin euismod eleifend pulvinar, dictum rutrum lacus. Nam hendrerit sed arcu a pellentesque. Vestibulum maximus ligula tellus, a euismod dui feugiat et. Aliquam viverra blandit est nec ultricies.\n<br /><br />\nNullam et sem a dui accumsan ornare. Praesent faucibus ultricies orci. Maecenas hendrerit tincidunt rutrum. Phasellus eget libero eget ante interdum venenatis. Cras sodales finibus vulputate. Aenean aliquet velit eget felis pellentesque, et blandit ex facilisis. Vivamus sit amet euismod diam, at rhoncus ex. Nullam consectetur, erat ut maximus dignissim, ex eros pellentesque ex, at dictum odio dui in urna. Nulla rutrum nisi eget risus accumsan, sit amet iaculis risus interdum. Curabitur accumsan eu purus nec condimentum. Fusce pulvinar ex id sagittis sodales. Donec hendrerit scelerisque est, in viverra nibh lobortis et.\n<br /><br />\n<ul>\n<li>Quisque facilisis purus vel sem laoreet posuere.</li>\n<li>Proin eleifend velit ut elit sollicitudin scelerisque.</li>\n<li>Nulla aliquet urna in magna congue, ac hendrerit velit lacinia.</li>\n<li>Aliquam id urna ut lorem porta vulputate.</li>\n<li>Sed ultrices sem quis risus tincidunt, ut lacinia nunc aliquet.</li>\n<li>Phasellus in est suscipit, feugiat tortor ac, iaculis enim.</li>\n</ul>', 'cv_tips.html', 'active', '2016-03-12 16:19:17'),
(18, NULL, 'How to get Job', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi a velit sed risus pulvinar faucibus. Nulla facilisi. Nullam vehicula nec ligula eu vulputate. Nunc id ultrices mi, ac tristique lectus. Suspendisse porta ultrices ultricies. Sed quis nisi vel magna maximus aliquam a vel nisl. Cras non rutrum diam. Nulla sed ipsum a felis posuere pharetra ut sit amet augue. Sed id nisl sodales, vulputate mi eu, viverra neque. Fusce fermentum, est ut accumsan accumsan, risus ante varius diam, non venenatis eros ligula fermentum leo. Etiam consectetur imperdiet volutpat. Donec ut pharetra nisi, eget pellentesque tortor. Integer eleifend dolor eu ex lobortis, ac gravida augue tristique. Proin placerat consectetur tincidunt. Nullam sollicitudin, neque eget iaculis ultricies, est justo pulvinar turpis, vulputate convallis leo orci at sapien.<br />\n<br />\nQuisque ac scelerisque libero, nec blandit neque. Nullam felis nisl, elementum eu sapien ut, convallis interdum felis. In turpis odio, fermentum non pulvinar gravida, posuere quis magna. Ut mollis eget neque at euismod. Interdum et malesuada fames ac ante ipsum primis in faucibus. Integer faucibus orci a pulvinar malesuada. Aenean at felis vitae lorem venenatis consequat. Nam non nunc euismod, consequat ligula non, tristique odio. Ut leo sapien, aliquet sed ultricies et, scelerisque quis nulla. Aenean non sapien maximus, convallis eros vitae, iaculis massa. In fringilla hendrerit nisi, eu pellentesque massa faucibus molestie. Etiam laoreet eros quis faucibus rutrum. Quisque eleifend purus justo, eget tempus quam interdum non.<br />\n<br />\nNullam enim ex, vulputate at ultricies bibendum, interdum sit amet tortor. Fusce semper augue ac ipsum ultricies interdum. Cras maximus faucibus sapien, et lacinia leo efficitur id. Nullam laoreet pulvinar nibh et ullamcorper. Etiam a lorem rhoncus, rutrum felis sed, blandit orci. Nulla vel tellus gravida, pretium neque a, fringilla lectus. Morbi et leo mi. Aliquam interdum ex ipsum. Vivamus eu ultrices ante, eget volutpat massa. Nulla nisi purus, sollicitudin euismod eleifend pulvinar, dictum rutrum lacus. Nam hendrerit sed arcu a pellentesque. Vestibulum maximus ligula tellus, a euismod dui feugiat et. Aliquam viverra blandit est nec ultricies.<br />\n<br />\nNullam et sem a dui accumsan ornare. Praesent faucibus ultricies orci. Maecenas hendrerit tincidunt rutrum. Phasellus eget libero eget ante interdum venenatis. Cras sodales finibus vulputate. Aenean aliquet velit eget felis pellentesque, et blandit ex facilisis. Vivamus sit amet euismod diam, at rhoncus ex. Nullam consectetur, erat ut maximus dignissim, ex eros pellentesque ex, at dictum odio dui in urna. Nulla rutrum nisi eget risus accumsan, sit amet iaculis risus interdum. Curabitur accumsan eu purus nec condimentum. Fusce pulvinar ex id sagittis sodales. Donec hendrerit scelerisque est, in viverra nibh lobortis et.<br />\n<br />\nQuisque facilisis purus vel sem laoreet posuere.<br />\nProin eleifend velit ut elit sollicitudin scelerisque.<br />\nNulla aliquet urna in magna congue, ac hendrerit velit lacinia.<br />\nAliquam id urna ut lorem porta vulputate.<br />\nSed ultrices sem quis risus tincidunt, ut lacinia nunc aliquet.<br />\nPhasellus in est suscipit, feugiat tortor ac, iaculis enim.', 'how_to_get_job.html', 'active', '2016-03-12 16:21:26');

-- --------------------------------------------------------

--
-- Table structure for table `pp_companies`
--

CREATE TABLE `pp_companies` (
  `ID` int(11) NOT NULL,
  `company_name` varchar(155) DEFAULT NULL,
  `company_email` varchar(100) DEFAULT NULL,
  `company_ceo` varchar(60) DEFAULT NULL,
  `industry_ID` int(5) DEFAULT NULL,
  `ownership_type` enum('NGO','Private','Public') DEFAULT 'Private',
  `company_description` text,
  `company_location` varchar(155) DEFAULT NULL,
  `no_of_offices` int(11) DEFAULT NULL,
  `company_website` varchar(155) DEFAULT NULL,
  `no_of_employees` varchar(15) DEFAULT NULL,
  `established_in` varchar(12) DEFAULT NULL,
  `company_type` varchar(60) DEFAULT NULL,
  `company_fax` varchar(30) DEFAULT NULL,
  `company_phone` varchar(30) DEFAULT NULL,
  `company_logo` varchar(155) DEFAULT NULL,
  `company_folder` varchar(155) DEFAULT NULL,
  `company_country` varchar(80) DEFAULT NULL,
  `sts` enum('blocked','pending','active') DEFAULT 'active',
  `company_city` varchar(80) DEFAULT NULL,
  `company_slug` varchar(155) DEFAULT NULL,
  `old_company_id` int(11) DEFAULT NULL,
  `old_employerlogin` varchar(100) DEFAULT NULL,
  `flag` varchar(5) DEFAULT NULL,
  `ownership_type` varchar(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_companies`
--

INSERT INTO `pp_companies` (`ID`, `company_name`, `company_email`, `company_ceo`, `industry_ID`, `ownership_type`, `company_description`, `company_location`, `no_of_offices`, `company_website`, `no_of_employees`, `established_in`, `company_type`, `company_fax`, `company_phone`, `company_logo`, `company_folder`, `company_country`, `sts`, `company_city`, `company_slug`, `old_company_id`, `old_employerlogin`, `flag`, `ownership_type`) VALUES
(1, 'NICK Technologies', NULL, NULL, 22, 'Private', 'An IT company', '101 Limuru', NULL, 'www.companyurl.com', '1-10', NULL, NULL, NULL, '313313137', 'JOBPORTAL-1457690431.jpg', NULL, NULL, 'active', NULL, 'nick-technologies', NULL, NULL, NULL, 'Private'),
(2, 'It Pixels', NULL, NULL, 22, 'Private', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce venenatis arcu est. Phasellus vel dignissim tellus. Aenean fermentum fermentum convallis. Maecenas vitae ipsum sed risus viverra volutpat non ac sapien. Donec viverra massa at dolor imperdiet hendrerit. Nullam quis est vitae dui placerat posuere. Phasellus eget erat sit amet lacus semper consectetur. Sed a nisi nisi. Pellentesque hendrerit est id quam facilisis auctor a ut ante. Etiam metus arcu, sagittis vitae massa ac, faucibus tempus dolor. Sed et tempus ex. Aliquam interdum erat vel convallis tristique. Phasellus lectus eros, interdum ac sollicitudin vestibulum, scelerisque vitae ligula. Cras aliquam est id velit laoreet, et mattis massa ultrices. Ut aliquam mi nunc, et tempor neque malesuada in. Nulla at viverra metus, id porttitor nulla. In et arcu id felis eleifend auctor vitae a justo. Nullam eleifend, purus id hendrerit tempus, massa elit vehicula metus, pharetra elementum lectus elit ac felis. Sed fermentum luctus aliquet. Vestibulum pulvinar ornare ipsum, gravida condimentum nulla luctus sit amet. Sed tempor eros a tempor faucibus. Proin orci tortor, placerat sit amet elementum sit amet, ornare vel urna.', 'Lorem ipsum dolor sit amet', NULL, 'www.companyurl.com', '1-10', NULL, NULL, NULL, '5335434534', 'JOBPORTAL-1457690733.jpg', NULL, NULL, 'active', NULL, 'it-pixels', NULL, NULL, NULL, 'Private'),
(3, 'Info Technologies', NULL, NULL, 22, 'Private', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce venenatis arcu est. Phasellus vel dignissim tellus. Aenean fermentum fermentum convallis. Maecenas vitae ipsum sed risus viverra volutpat non ac sapien. Donec viverra massa at dolor imperdiet hendrerit. Nullam quis est vitae dui placerat posuere. Phasellus eget erat sit amet lacus semper consectetur. Sed a nisi nisi. Pellentesque hendrerit est id quam facilisis auctor a ut ante. Etiam metus arcu, sagittis vitae massa ac, faucibus tempus dolor. Sed et tempus ex. Aliquam interdum erat vel convallis tristique. Phasellus lectus eros, interdum ac sollicitudin vestibulum, scelerisque vitae ligula. Cras aliquam est id velit laoreet, et mattis massa ultrices. Ut aliquam mi nunc, et tempor neque malesuada in.', 'Lorem ipsum dolor sit amet, consectetur', NULL, 'www.companyurl.com', '101-300', NULL, NULL, NULL, '123456789', 'JOBPORTAL-1457691226.jpg', NULL, NULL, 'active', NULL, 'info-technologies', NULL, NULL, NULL, 'Private'),
(4, 'Some IT company', NULL, NULL, 22, 'Private', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce venenatis arcu est. Phasellus vel dignissim tellus. Aenean fermentum fermentum convallis. Maecenas vitae ipsum sed risus viverra volutpat non ac sapien. Donec viverra massa at dolor imperdiet hendrerit. Nullam quis est vitae dui placerat posuere. Phasellus eget erat sit amet lacus semper consectetur. Sed a nisi nisi. Pellentesque hendrerit est id quam facilisis auctor a ut ante. Etiam metus arcu, sagittis vitae massa ac, faucibus tempus dolor. Sed et tempus ex. Aliquam interdum erat vel convallis tristique. Phasellus lectus eros, interdum ac sollicitudin vestibulum, scelerisque vitae ligula. Cras aliquam est id velit laoreet, et mattis massa ultrices. Ut aliquam mi nunc, et tempor neque malesuada in.', 'Lorem ipsum dolor sit amet, consectetur', NULL, 'www.companyurl.com', '1-10', NULL, NULL, NULL, '123456789', 'JOBPORTAL-1457693358.jpg', NULL, NULL, 'active', NULL, 'some-it-company', NULL, NULL, NULL, 'Private'),
(5, 'Abc IT Tech', NULL, NULL, 22, 'Private', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce venenatis arcu est. Phasellus vel dignissim tellus. Aenean fermentum fermentum convallis. Maecenas vitae ipsum sed risus viverra volutpat non ac sapien. Donec viverra massa at dolor imperdiet hendrerit. Nullam quis est vitae dui placerat posuere. Phasellus eget erat sit amet lacus semper consectetur. Sed a nisi nisi. Pellentesque hendrerit est id quam facilisis auctor a ut ante. Etiam metus arcu, sagittis vitae massa ac, faucibus tempus dolor. Sed et tempus ex. Aliquam interdum erat vel convallis tristique. Phasellus lectus eros, interdum ac sollicitudin vestibulum, scelerisque vitae ligula. Cras aliquam est id velit laoreet, et mattis massa ultrices. Ut aliquam mi nunc, et tempor neque malesuada in.', 'Lorem ipsum dolor sit amet', NULL, 'www.companyurl.com', '1-10', NULL, NULL, NULL, '123456789', 'JOBPORTAL-1457711170.jpg', NULL, NULL, 'active', NULL, 'abc-it-tech', NULL, NULL, NULL, 'Private'),
(6, 'Def It Company', NULL, NULL, 40, 'Private', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce venenatis arcu est. Phasellus vel dignissim tellus. Aenean fermentum fermentum convallis. Maecenas vitae ipsum sed risus viverra volutpat non ac sapien. Donec viverra massa at dolor imperdiet hendrerit. Nullam quis est vitae dui placerat posuere. Phasellus eget erat sit amet lacus semper consectetur. Sed a nisi nisi. Pellentesque hendrerit est id quam facilisis auctor a ut ante. Etiam metus arcu, sagittis vitae massa ac, faucibus tempus dolor. Sed et tempus ex. Aliquam interdum erat vel convallis tristique. Phasellus lectus eros, interdum ac sollicitudin vestibulum, scelerisque vitae ligula. Cras aliquam est id velit laoreet, et mattis massa ultrices. Ut aliquam mi nunc, et tempor neque malesuada in.', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', NULL, 'www.companyurl.com', '1-10', NULL, NULL, NULL, '123456789', 'JOBPORTAL-1457711477.jpg', NULL, NULL, 'active', NULL, 'def-it-company', NULL, NULL, NULL, 'Private'),
(7, 'Ghi Company', NULL, NULL, 10, 'Private', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce venenatis arcu est. Phasellus vel dignissim tellus. Aenean fermentum fermentum convallis. Maecenas vitae ipsum sed risus viverra volutpat non ac sapien. Donec viverra massa at dolor imperdiet hendrerit. Nullam quis est vitae dui placerat posuere. Phasellus eget erat sit amet lacus semper consectetur. Sed a nisi nisi. Pellentesque hendrerit est id quam facilisis auctor a ut ante. Etiam metus arcu, sagittis vitae massa ac, faucibus tempus dolor. Sed et tempus ex. Aliquam interdum erat vel convallis tristique. Phasellus lectus eros, interdum ac sollicitudin vestibulum, scelerisque vitae ligula. Cras aliquam est id velit laoreet, et mattis massa ultrices. Ut aliquam mi nunc, et tempor neque malesuada in.', 'Lorem ipsum dolor sit amet, consectetur', NULL, 'www.companyurl.com', '1-10', NULL, NULL, NULL, '123456789', 'JOBPORTAL-1457711897.jpg', NULL, NULL, 'active', NULL, 'ghi-company', NULL, NULL, NULL, 'Private'),
(8, 'Jkl Company', NULL, NULL, 7, 'Private', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce venenatis arcu est. Phasellus vel dignissim tellus. Aenean fermentum fermentum convallis. Maecenas vitae ipsum sed risus viverra volutpat non ac sapien. Donec viverra massa at dolor imperdiet hendrerit. Nullam quis est vitae dui placerat posuere. Phasellus eget erat sit amet lacus semper consectetur. Sed a nisi nisi. Pellentesque hendrerit est id quam facilisis auctor a ut ante. Etiam metus arcu, sagittis vitae massa ac, faucibus tempus dolor. Sed et tempus ex. Aliquam interdum erat vel convallis tristique. Phasellus lectus eros, interdum ac sollicitudin vestibulum, scelerisque vitae ligula. Cras aliquam est id velit laoreet, et mattis massa ultrices. Ut aliquam mi nunc, et tempor neque malesuada in.', 'Lorem ipsum dolor sit amet', NULL, 'www.companyurl.com', '1-10', NULL, NULL, NULL, '123456789', 'JOBPORTAL-1457712255.jpg', NULL, NULL, 'active', NULL, 'jkl-company', NULL, NULL, NULL, 'Private'),
(9, 'Mno Company', NULL, NULL, 22, 'Private', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce venenatis arcu est. Phasellus vel dignissim tellus. Aenean fermentum fermentum convallis. Maecenas vitae ipsum sed risus viverra volutpat non ac sapien. Donec viverra massa at dolor imperdiet hendrerit. Nullam quis est vitae dui placerat posuere. Phasellus eget erat sit amet lacus semper consectetur. Sed a nisi nisi. Pellentesque hendrerit est id quam facilisis auctor a ut ante. Etiam metus arcu, sagittis vitae massa ac, faucibus tempus dolor. Sed et tempus ex. Aliquam interdum erat vel convallis tristique. Phasellus lectus eros, interdum ac sollicitudin vestibulum, scelerisque vitae ligula. Cras aliquam est id velit laoreet, et mattis massa ultrices. Ut aliquam mi nunc, et tempor neque malesuada in.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce venenatis arcu est. Phasellus vel dignissim tellus. Aenean fermentum fermentum convallis. Maecenas vitae ipsum sed risus viverra volutpat non ac sapien. Donec viverra massa at dolor imperdiet hendrerit. Nullam quis est vitae dui placerat posuere. Phasellus eget erat sit amet lacus semper consectetur. Sed a nisi nisi. Pellentesque hendrerit est id quam facilisis auctor a ut ante. Etiam metus arcu, sagittis vitae massa ac, faucibus tempus dolor. Sed et tempus ex. Aliquam interdum erat vel convallis tristique. Phasellus lectus eros, interdum ac sollicitudin vestibulum, scelerisque vitae ligula. Cras aliquam est id velit laoreet, et mattis massa ultrices. Ut aliquam mi nunc, et tempor neque malesuada in.', 'Lorem ipsum dolor sit amet', NULL, 'www.companyurl.com', '1-10', NULL, NULL, NULL, '12345679', 'JOBPORTAL-1457713172.jpg', NULL, NULL, 'active', NULL, 'mno-company', NULL, NULL, NULL, 'Private'),
(10, 'MNT Comapny', NULL, NULL, 22, 'Private', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce venenatis arcu est. Phasellus vel dignissim tellus. Aenean fermentum fermentum convallis. Maecenas vitae ipsum sed risus viverra volutpat non ac sapien. Donec viverra massa at dolor imperdiet hendrerit. Nullam quis est vitae dui placerat posuere. Phasellus eget erat sit amet lacus semper consectetur. Sed a nisi nisi. Pellentesque hendrerit est id quam facilisis auctor a ut ante. Etiam metus arcu, sagittis vitae massa ac, faucibus tempus dolor. Sed et tempus ex. Aliquam interdum erat vel convallis tristique. Phasellus lectus eros, interdum ac sollicitudin vestibulum, scelerisque vitae ligula. Cras aliquam est id velit laoreet, et mattis massa ultrices. Ut aliquam mi nunc, et tempor neque malesuada in.', 'Aenean fermentum fermentum convallis', NULL, 'www.companyurl.com', '101-300', NULL, NULL, NULL, '123456789', 'JOBPORTAL-1457713426.jpg', NULL, NULL, 'active', NULL, 'mnt-comapny', NULL, NULL, NULL, 'Private'),
(11, 'MNF Comapny', NULL, NULL, 16, 'Private', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce venenatis arcu est. Phasellus vel dignissim tellus. Aenean fermentum fermentum convallis. Maecenas vitae ipsum sed risus viverra volutpat non ac sapien. Donec viverra massa at dolor imperdiet hendrerit. Nullam quis est vitae dui placerat posuere. Phasellus eget erat sit amet lacus semper consectetur. Sed a nisi nisi. Pellentesque hendrerit est id quam facilisis auctor a ut ante. Etiam metus arcu, sagittis vitae massa ac, faucibus tempus dolor. Sed et tempus ex. Aliquam interdum erat vel convallis tristique. Phasellus lectus eros, interdum ac sollicitudin vestibulum, scelerisque vitae ligula. Cras aliquam est id velit laoreet, et mattis massa ultrices. Ut aliquam mi nunc, et tempor neque malesuada in.', 'Pellentesque hendrerit est id quam facilisis', NULL, 'www.companyurl.com', '51-100', NULL, NULL, NULL, '123456789', 'JOBPORTAL-1457713999.jpg', NULL, NULL, 'active', NULL, 'mnf-comapny', NULL, NULL, NULL, 'Private'),
(12, 'QWE Company', NULL, NULL, 18, 'Private', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi a velit sed risus pulvinar faucibus. Nulla facilisi. Nullam vehicula nec ligula eu vulputate. Nunc id ultrices mi, ac tristique lectus. Suspendisse porta ultrices ultricies. Sed quis nisi vel magna maximus aliquam a vel nisl. Cras non rutrum diam. Nulla sed ipsum a felis posuere pharetra ut sit amet augue. Sed id nisl sodales, vulputate mi eu, viverra neque. Fusce fermentum, est ut accumsan accumsan, risus ante varius diam, non venenatis eros ligula fermentum leo. Etiam consectetur imperdiet volutpat. Donec ut pharetra nisi, eget pellentesque tortor. Integer eleifend dolor eu ex lobortis, ac gravida augue tristique. Proin placerat consectetur tincidunt. Nullam sollicitudin, neque eget iaculis ultricies, est justo pulvinar turpis, vulputate convallis leo orci at sapien.\n\nQuisque ac scelerisque libero, nec blandit neque. Nullam felis nisl, elementum eu sapien ut, convallis interdum felis. In turpis odio, fermentum non pulvinar gravida, posuere quis magna. Ut mollis eget neque at euismod. Interdum et malesuada fames ac ante ipsum primis in faucibus. Integer faucibus orci a pulvinar malesuada. Aenean at felis vitae lorem venenatis consequat. Nam non nunc euismod, consequat ligula non, tristique odio. Ut leo sapien, aliquet sed ultricies et, scelerisque quis nulla. Aenean non sapien maximus, convallis eros vitae, iaculis massa. In fringilla hendrerit nisi, eu pellentesque massa faucibus molestie. Etiam laoreet eros quis faucibus rutrum. Quisque eleifend purus justo, eget tempus quam interdum non.', 'Quisque ac scelerisque libero, nec blandit neque', NULL, 'www.companyurl.com', '1-10', NULL, NULL, NULL, '123456789', 'JOBPORTAL-1457768561.jpg', NULL, NULL, 'active', NULL, 'qwe-company', NULL, NULL, NULL, 'Private'),
(13, 'ASD Company', NULL, NULL, 10, 'Private', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi a velit sed risus pulvinar faucibus. Nulla facilisi. Nullam vehicula nec ligula eu vulputate. Nunc id ultrices mi, ac tristique lectus. Suspendisse porta ultrices ultricies. Sed quis nisi vel magna maximus aliquam a vel nisl. Cras non rutrum diam. Nulla sed ipsum a felis posuere pharetra ut sit amet augue. Sed id nisl sodales, vulputate mi eu, viverra neque. Fusce fermentum, est ut accumsan accumsan, risus ante varius diam, non venenatis eros ligula fermentum leo. Etiam consectetur imperdiet volutpat. Donec ut pharetra nisi, eget pellentesque tortor. Integer eleifend dolor eu ex lobortis, ac gravida augue tristique. Proin placerat consectetur tincidunt. Nullam sollicitudin, neque eget iaculis ultricies, est justo pulvinar turpis, vulputate convallis leo orci at sapien.', 'Quisque ac scelerisque libero, nec blandit neque', NULL, 'www.companyurl.com', '1-10', NULL, NULL, NULL, '123456789', 'JOBPORTAL-1457768887.jpg', NULL, NULL, 'active', NULL, 'asd-company', NULL, NULL, NULL, 'Private'),
(14, 'XCV Company', NULL, NULL, 18, 'Private', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi a velit sed risus pulvinar faucibus. Nulla facilisi. Nullam vehicula nec ligula eu vulputate. Nunc id ultrices mi, ac tristique lectus. Suspendisse porta ultrices ultricies. Sed quis nisi vel magna maximus aliquam a vel nisl. Cras non rutrum diam. Nulla sed ipsum a felis posuere pharetra ut sit amet augue. Sed id nisl sodales, vulputate mi eu, viverra neque. Fusce fermentum, est ut accumsan accumsan, risus ante varius diam, non venenatis eros ligula fermentum leo. Etiam consectetur imperdiet volutpat. Donec ut pharetra nisi, eget pellentesque tortor. Integer eleifend dolor eu ex lobortis, ac gravida augue tristique. Proin placerat consectetur tincidunt. Nullam sollicitudin, neque eget iaculis ultricies, est justo pulvinar turpis, vulputate convallis leo orci at sapien.\n\nQuisque ac scelerisque libero, nec blandit neque. Nullam felis nisl, elementum eu sapien ut, convallis interdum felis. In turpis odio, fermentum non pulvinar gravida, posuere quis magna. Ut mollis eget neque at euismod. Interdum et malesuada fames ac ante ipsum primis in faucibus. Integer faucibus orci a pulvinar malesuada. Aenean at felis vitae lorem venenatis consequat. Nam non nunc euismod, consequat ligula non, tristique odio. Ut leo sapien, aliquet sed ultricies et, scelerisque quis nulla. Aenean non sapien maximus, convallis eros vitae, iaculis massa. In fringilla hendrerit nisi, eu pellentesque massa faucibus molestie. Etiam laoreet eros quis faucibus rutrum. Quisque eleifend purus justo, eget tempus quam interdum non.', 'Nullam enim ex, vulputate at ultricies bibendum', NULL, 'www.companyurl.com', '1-10', NULL, NULL, NULL, '123456789', 'JOBPORTAL-1457769102.jpg', NULL, NULL, 'active', NULL, 'xcv-company', NULL, NULL, NULL, 'Private'),
(15, 'Unique Solutions', NULL, NULL, 40, 'Private', 'asdlfjasdfj', 'Narvekar Galli', NULL, 'asdfsd', '1-10', NULL, NULL, NULL, '88888888888', 'JOBPORTAL-1459152055.jpg', NULL, NULL, 'active', NULL, 'unique-solutions', NULL, NULL, NULL, 'Private'),
(16, 'Kacykos', NULL, NULL, 5, 'Private', '234tgfdgh hd hd h dh dvh', 'ssssssssssssaaaaa', NULL, '423523525252', '11-50', NULL, NULL, NULL, '234242525', 'JOBPORTAL-1459158292.jpg', NULL, NULL, 'active', NULL, 'kacykos', NULL, NULL, NULL, 'Public'),
(23, 'Softrait Technologies', NULL, NULL, 22, 'Private', 'rfrfrf', 'frfrf', NULL, 'efrf', '1-10', NULL, NULL, NULL, 'rfrf', 'JOBPORTAL-1459449801.jpg', NULL, NULL, 'active', NULL, 'softrait-technologies', NULL, NULL, NULL, 'Private'),
(18, 'WM Informática', NULL, NULL, 40, 'Private', 'Esta aplicação web é concebida na sua forma actual como um sítio exigindo dinâmicas atualizações constantes tanto dos requerentes, bem como as empresas. No seu conjunto o objetivo do projeto é permitir que os candidatos a emprego a colocar os seus currículos e as empresas a publicar suas vagas.', 'Av. José Bezerra Sobrinho', NULL, 'www.wminfor.com', '11-50', NULL, NULL, NULL, '(81) 3676-1104', 'JOBPORTAL-1459191669.jpg', NULL, NULL, 'active', NULL, 'wm-informtica', NULL, NULL, NULL, 'Public'),
(22, 'dsfsdf', NULL, NULL, 22, 'Private', 'dgdfgd fgdfgdfgdfg dfgdfgdfg dfg dfg dfg dfg dfg', 'sdfsdf sdfsdf sdf sd fsdf fsdf sd fsd f', NULL, 'www.sdfsdf.com', '11-50', NULL, NULL, NULL, '654456456456', 'JOBPORTAL-1459333898.jpg', NULL, NULL, 'active', NULL, 'dsfsdf', NULL, NULL, NULL, 'Semi-Government'),
(20, 'lkinotech', NULL, NULL, 22, 'Private', 'no description', 'panipat', NULL, 'www.lkitech.com', '1-10', NULL, NULL, NULL, '1804020101', 'JOBPORTAL-1459235594.png', NULL, NULL, 'active', NULL, 'lkinotech', NULL, NULL, NULL, 'Private'),
(21, 'dfgsdfg', NULL, NULL, 5, 'Private', 'dfsd erfgerfer erferf', '3434 erfgerge', NULL, 'ass.com', '1-10', NULL, NULL, NULL, '5555555555', 'JOBPORTAL-1459241338.png', NULL, NULL, 'active', NULL, 'dfgsdfg', NULL, NULL, NULL, 'Public'),
(24, 'fdfdf', NULL, NULL, 5, 'Private', 'fdfdfdfdfdf', 'dfdf', NULL, 'dfdf', '51-100', NULL, NULL, NULL, 'fdfdfd', 'JOBPORTAL-1459502829.jpg', NULL, NULL, 'active', NULL, 'fdfdf', NULL, NULL, NULL, 'Private'),
(25, 'Master Tech', NULL, NULL, 10, 'Private', 'mmmmm', 'dha', NULL, 'www.mastertech.com.bd', '1-10', NULL, NULL, NULL, '878755', 'JOBPORTAL-1459553924.png', NULL, NULL, 'active', NULL, 'master-tech', NULL, NULL, NULL, 'Private'),
(26, 'TechHub', NULL, NULL, 3, 'Private', 'TechHub.com', 'Test Address', NULL, 'TechHub.com', '11-50', NULL, NULL, NULL, '001988734344', 'JOBPORTAL-1459583469.jpg', NULL, NULL, 'active', NULL, 'techhub', NULL, NULL, NULL, 'Public'),
(27, 'PEOPLES WEB INNOVATIONS', NULL, NULL, 22, 'Private', 'nothing just for test', 'india', NULL, 'www.wallofindia.com', '1-10', NULL, NULL, NULL, '677775888578', 'JOBPORTAL-1459593780.jpg', NULL, NULL, 'active', NULL, 'peoples-web-innovations', NULL, NULL, NULL, 'Private'),
(28, 'ksksk', NULL, NULL, 10, 'Private', 'jdjdjdj iziziz sjsjsj', 'dkdkdkdkdk', NULL, 'https://mail.google.com/mail/u/0/#inbox', '301-600', NULL, NULL, NULL, '2°2020202020', 'JOBPORTAL-1459634581.jpg', NULL, NULL, 'active', NULL, 'ksksk', NULL, NULL, NULL, 'Public'),
(29, 'sdfsafd', NULL, NULL, 3, 'Private', 'safasfd', 'sdfsdfas', NULL, 'dsffsafas', '51-100', NULL, NULL, NULL, '4343', 'JOBPORTAL-1459679795.jpg', NULL, NULL, 'active', NULL, 'sdfsafd', NULL, NULL, NULL, 'Public'),
(30, 'Motto', NULL, NULL, 40, 'Private', 'sjdfksjdfksjd nfksjdfnd', 'sdf sdf sdf s', NULL, 'http://mottoiletisim.com', '51-100', NULL, NULL, NULL, '5342029597', 'JOBPORTAL-1459784884.jpg', NULL, NULL, 'active', NULL, 'motto', NULL, NULL, NULL, 'Private'),
(31, 'Art Zeus', NULL, NULL, 16, 'Private', 'Teste', 'Teste', NULL, '21996265039', '11-50', NULL, NULL, NULL, 'Álan', 'JOBPORTAL-1459879029.jpg', NULL, NULL, 'active', NULL, 'art-zeus', NULL, NULL, NULL, 'Public'),
(32, 'smartdev', NULL, NULL, 5, 'Private', 'rsearas', 'rsaras', NULL, 'resar.ge', '1501-2000', NULL, NULL, NULL, 'r2313', 'JOBPORTAL-1459948962.png', NULL, NULL, 'active', NULL, 'smartdev', NULL, NULL, NULL, 'Public'),
(33, 'koko jk', NULL, NULL, 5, 'Private', 'ok', 'BP 253', NULL, 'ok', '1-10', NULL, NULL, NULL, '21548854', 'JOBPORTAL-1460013565.png', NULL, NULL, 'active', NULL, 'koko-jk', NULL, NULL, NULL, 'Private'),
(34, 'sdggsd', NULL, NULL, 5, 'Private', 'gsddgs dsggdsgdsd', 'sdgsdg', NULL, 'fsdsdsggds.pl', '1-10', NULL, NULL, NULL, '22424', 'JOBPORTAL-1460071669.png', NULL, NULL, 'active', NULL, 'sdggsd', NULL, NULL, NULL, 'Public'),
(35, 'dsfsfds', NULL, NULL, 10, 'Private', 'fdgdfgd', 'efvaesfesfwef', NULL, 'fdg.com', '1-10', NULL, NULL, NULL, '23424232', 'JOBPORTAL-1460132506.jpg', NULL, NULL, 'active', NULL, 'dsfsfds', NULL, NULL, NULL, 'Private'),
(36, 'Azienda Alpha', NULL, NULL, 22, 'Private', 'test', 'VIa Zurigo, Lugano', NULL, 'www.test.com', '1-10', NULL, NULL, NULL, '111', 'JOBPORTAL-1460229473.jpg', NULL, NULL, 'active', NULL, 'azienda-alpha', NULL, NULL, NULL, 'Private'),
(37, 'asdasdasd', NULL, NULL, 3, 'Private', 'asdasdasdasd', 'sdfsdfsdf', NULL, 'wfsdsdf.com', '1-10', NULL, NULL, NULL, '345345', 'JOBPORTAL-1460425365.png', NULL, NULL, 'active', NULL, 'asdasdasd', NULL, NULL, NULL, 'Private'),
(38, 'uptech', NULL, NULL, 40, 'Private', 'dasdasd', 'asdasdasd', NULL, 'http://asd.asd', '1-10', NULL, NULL, NULL, '4324234234', 'JOBPORTAL-1460530406.png', NULL, NULL, 'active', NULL, 'uptech', NULL, NULL, NULL, 'Private'),
(39, 'BILMA', NULL, NULL, 3, 'Private', 'qdqfd', 'Abdulnasir', NULL, 'hiiraan.com', '51-100', NULL, NULL, NULL, '02525', 'JOBPORTAL-1460625717.jpg', NULL, NULL, 'active', NULL, 'bilma', NULL, NULL, NULL, 'Public'),
(40, 'xyz', NULL, NULL, 22, 'Private', 'rrreytryy', 'dsdfsdf', NULL, 'www.xyz.com', '51-100', NULL, NULL, NULL, '543444', 'JOBPORTAL-1460700378.jpg', NULL, NULL, 'active', NULL, 'xyz', NULL, NULL, NULL, 'Private'),
(41, 'sparx', NULL, NULL, 22, 'Private', 'hello', 'delhi', NULL, 'spar', '1-10', NULL, NULL, NULL, '9874561230', 'JOBPORTAL-1460721976.jpeg', NULL, NULL, 'active', NULL, 'sparx', NULL, NULL, NULL, 'Public'),
(42, 'Gri Telekom', NULL, NULL, 3, 'Private', 'deneme', 'istanbul', NULL, 'http://www.gritelekom.com', '1-10', NULL, NULL, NULL, '905055050505', 'JOBPORTAL-1460804749.jpg', NULL, NULL, 'active', NULL, 'gri-telekom', NULL, NULL, NULL, 'Private'),
(43, 'Paxten', NULL, NULL, 22, 'Private', 'asadasdsd', 'asdasdas', NULL, 'www.paxten.in', '1-10', NULL, NULL, NULL, '99999999999', 'JOBPORTAL-1460975531.jpg', NULL, NULL, 'active', NULL, 'paxten', NULL, NULL, NULL, 'Private'),
(44, 'start designs', NULL, NULL, 16, 'Private', 'test', '8/344 vidhyadhar nagar', NULL, 'www.webismyworld789@gmail.com', '1-10', NULL, NULL, NULL, '08003366789', 'JOBPORTAL-1461332142.jpg', NULL, NULL, 'active', NULL, 'start-designs', NULL, NULL, NULL, 'Public'),
(45, 'tar? bili?im hizmetleri', NULL, NULL, 7, 'Private', 'Job portal is developed for creating an interactive job vacancy for candidates. This web application is to be conceived in its current form as a dynamic site-requiring constant updates both from the seekers as well as the companies. On the whole the objective of the project is to enable jobseekers to place their resumes and companies to publish their vacancies. It enables jobseekers to post their resume, search for jobs, view personal job listings. It will provide various companies to place their vacancy profile on the site and also have an option to search candidate resumes. Apart from this there will be an admin module for the customer to make changes to the database content. It consists of 4 modules:', '5714 37 göztepe', NULL, 'www.deneme.com', '301-600', NULL, NULL, NULL, '0212530152365', 'JOBPORTAL-1461495364.png', NULL, NULL, 'active', NULL, 'tar-biliim-hizmetleri', NULL, NULL, NULL, 'Private'),
(46, 'ewwfwe', NULL, NULL, 40, 'Private', 'sfddssda', 'wweewcs evrve', NULL, 'scdc.scs', '1-10', NULL, NULL, NULL, '561656810596', 'JOBPORTAL-1461611130.png', NULL, NULL, 'active', NULL, 'ewwfwe', NULL, NULL, NULL, 'Public'),
(47, 'fonseca', NULL, NULL, 3, 'Private', 'afafff', 'av joao', NULL, 'fonseca.com.br', '11-50', NULL, NULL, NULL, '21999754478', 'JOBPORTAL-1461764354.jpg', NULL, NULL, 'active', NULL, 'fonseca', NULL, NULL, NULL, 'Public'),
(48, 'avrupa reklam', NULL, NULL, 7, 'Private', 'asdfdsfa', 'Beyazevler', NULL, 'www.avrupareklam.com.tr', '1-10', NULL, NULL, NULL, '5325858854', 'JOBPORTAL-1461950231.jpg', NULL, NULL, 'active', NULL, 'avrupa-reklam', NULL, NULL, NULL, 'Private'),
(49, 'Handhome', NULL, NULL, 35, 'Private', 'Handhome.net là m?t n?n t?ng chia s? thông tin ki?n trúc, n?i th?t t?i Vi?t Nam', '52 Nguyen Thai H?c, Ph??ng ?i?n Biên, Qu?n Ba ?ình, Hà N?i', NULL, 'http://handhome.net', '1-10', NULL, NULL, NULL, '12345678', 'JOBPORTAL-1462009695.png', NULL, NULL, 'active', NULL, 'handhome', NULL, NULL, NULL, 'Public'),
(50, 'GBBS-IT', NULL, NULL, 5, 'Private', 'bonjour', 'lotissement El Salem 3 N° 4 Tahar bouchet Birkhadem Alger', NULL, 'www.gbbs-it.com', '1-10', NULL, NULL, NULL, '+213550193126', 'JOBPORTAL-1462047950.png', NULL, NULL, 'active', NULL, 'gbbsit', NULL, NULL, NULL, 'Private'),
(51, 'AMAM', NULL, NULL, 5, 'Private', 'khjg', 'Villa 42 pins maritime', NULL, 'GBBS-IT', '11-50', NULL, NULL, NULL, '+213550193126', 'JOBPORTAL-1462048253.png', NULL, NULL, 'active', NULL, 'amam', NULL, NULL, NULL, 'Private'),
(52, 'Confédération Algérienne du Patronat', NULL, NULL, 16, 'Private', 'test', 'Hôtel El Aurassi Niveau C Bureau n°7', NULL, 'www.marwendzc.com', '1-10', NULL, NULL, NULL, '670119423', 'JOBPORTAL-1462049084.png', NULL, NULL, 'active', NULL, 'confdration-algrienne-du-patronat', NULL, NULL, NULL, 'Public'),
(53, 'netzen', NULL, NULL, 7, 'Private', 'sadasdsd', 'içerenköy', NULL, 'www.company.com', '1-10', NULL, NULL, NULL, '5324475202', 'JOBPORTAL-1462141216.jpg', NULL, NULL, 'active', NULL, 'netzen', NULL, NULL, NULL, 'Private'),
(54, 'the testing company', NULL, NULL, 5, 'Private', 'adas askd jaskd askd jaks nfasdm,fsad fsdma fname fjsadb fsdfa basdf', 'dfgdfg', NULL, 'www.testincompany.com', '11-50', NULL, NULL, NULL, '564123231', 'JOBPORTAL-1462172312.png', NULL, NULL, 'active', NULL, 'the-testing-company', NULL, NULL, NULL, 'Public'),
(55, 'hkyhjgjgjhgkjh', NULL, NULL, 3, 'Private', 'gszdfszdfsdf', 'kjghkj,hkhjk', NULL, 'www.lhjkkjh.com', '1-10', NULL, NULL, NULL, '78768767567', 'JOBPORTAL-1462474003.jpg', NULL, NULL, 'active', NULL, 'hkyhjgjgjhgkjh', NULL, NULL, NULL, 'Private'),
(56, 'whitehouse dental practice', NULL, NULL, 3, 'Private', 'sdasdasdasdasd', '18 thirlmere drive', NULL, 'asdadad', '11-50', NULL, NULL, NULL, '7495996849', 'JOBPORTAL-1462541062.jpg', NULL, NULL, 'active', NULL, 'whitehouse-dental-practice', NULL, NULL, NULL, 'Private'),
(57, 'bobbbbbbbbbb', NULL, NULL, 3, 'Private', 'zzzzzzzzzzzzzzzzzzzzzzzz', 'zzzzzzzzzzzzzzzzzzzzzzzzzzzz', NULL, 'http://rtrtr.cc', '1-10', NULL, NULL, NULL, '11111111111111111111', 'JOBPORTAL-1462549881.jpg', NULL, NULL, 'active', NULL, 'bobbbbbbbbbb', NULL, NULL, NULL, 'Private'),
(58, 'teste test', NULL, NULL, 3, 'Private', 'teste test', 'teste test', NULL, 'teste.com', '11-50', NULL, NULL, NULL, '3456798789', 'JOBPORTAL-1462712382.png', NULL, NULL, 'active', NULL, 'teste-test', NULL, NULL, NULL, 'Private'),
(59, 'Test', NULL, NULL, 22, 'Private', 'IT', 'NY', NULL, 'codeareena.com', '1-10', NULL, NULL, NULL, '313444', 'JOBPORTAL-1462948682.png', NULL, NULL, 'active', NULL, 'test', NULL, NULL, NULL, 'Private'),
(60, 'In', NULL, NULL, 22, 'Private', 'dadwedew', 'India', NULL, 'ddsdwfefde', '1-10', NULL, NULL, NULL, '2222222222', 'JOBPORTAL-1463032113.jpg', NULL, NULL, 'active', NULL, 'in', NULL, NULL, NULL, 'Private'),
(61, 'cinestation', NULL, NULL, 22, 'Private', 'it sowftware', 'hyderabad', NULL, 'cinestation.in', '1-10', NULL, NULL, NULL, '8187030758', 'JOBPORTAL-1463114643.jpg', NULL, NULL, 'active', NULL, 'cinestation', NULL, NULL, NULL, 'Private'),
(62, 'Softgators Tech Pvt Ltd', NULL, NULL, 22, 'Private', 'asdasddasd', 'D4/26 Vashisth Park', NULL, 'softgators.com', '1-10', NULL, NULL, NULL, '9015845820', 'JOBPORTAL-1463156147.jpg', NULL, NULL, 'active', NULL, 'softgators-tech-pvt-ltd', NULL, NULL, NULL, 'Private'),
(63, 'TEST', NULL, NULL, 35, 'Private', 'SFSDFSDF SD FSD FSDF S', '3', NULL, 'www.testincompany.com', '11-50', NULL, NULL, NULL, '1118675198', 'JOBPORTAL-1463165183.jpg', NULL, NULL, 'active', NULL, 'test-1463165183', NULL, NULL, NULL, 'Private'),
(64, 'nib technology company', NULL, NULL, 3, 'Private', 'our company is our company is our company is our company is our company is our company is our company is our company is our company is our company is our company is our company is our company is our company is our company is our company is', 'addis ababa', NULL, 'www.websiste.com', '1-10', NULL, NULL, NULL, '+251911996922', 'JOBPORTAL-1463401978.png', NULL, NULL, 'active', NULL, 'nib-technology-company', NULL, NULL, NULL, 'Public'),
(65, 'sadasdsad', NULL, NULL, 3, 'Private', 'gfdgfdgdfg', 'sad', NULL, 'fdgfdgfd', '1-10', NULL, NULL, NULL, 'asdsad', 'JOBPORTAL-1463524284.jpg', NULL, NULL, 'active', NULL, 'sadasdsad', NULL, NULL, NULL, 'Public'),
(66, 'Temp Corp', NULL, NULL, 5, 'Private', 'Temporary company', 'Temporary Street, 1234', NULL, 'www.www.www', '1-10', NULL, NULL, NULL, '111111111', 'JOBPORTAL-1463599153.png', NULL, NULL, 'active', NULL, 'temp-corp', NULL, NULL, NULL, 'Private'),
(67, 'sksks', NULL, NULL, 5, 'Private', 'ksskskskks', 'kdkdkd', NULL, 'http://codeareena.com/jobportal/employer-signup', '1-10', NULL, NULL, NULL, 'ododod', 'JOBPORTAL-1463842511.jpg', NULL, NULL, 'active', NULL, 'sksks', NULL, NULL, NULL, 'Private'),
(68, 'Pakajs', NULL, NULL, 7, 'Private', 'Dsss', 'Snsnhssh', NULL, 'Web', '1-10', NULL, NULL, NULL, '01029883355', 'JOBPORTAL-1464008445.png', NULL, NULL, 'active', NULL, 'pakajs', NULL, NULL, NULL, 'Semi-Government'),
(69, 'ver', NULL, NULL, 35, 'Private', 'dfsdf sdfsdfas', 'ERZ?NCAN AÇIK CEZA EV?', NULL, 'www.sairyazar.com', '11-50', NULL, NULL, NULL, '5443333292', 'JOBPORTAL-1464183007.jpg', NULL, NULL, 'active', NULL, 'ver', NULL, NULL, NULL, 'Public'),
(70, 'ddddd', NULL, NULL, 22, 'Private', 'cxxcxcxcxxcxcx', 'fgfgfgf', NULL, 'www.vvv.com', '11-50', NULL, NULL, NULL, '123456789', 'JOBPORTAL-1464204378.jpg', NULL, NULL, 'active', NULL, 'ddddd', NULL, NULL, NULL, 'Private'),
(71, 'rkparmar', NULL, NULL, 3, 'Private', '2342', 'tresr', NULL, 'gjkhi', '1-10', NULL, NULL, NULL, '556969', 'JOBPORTAL-1464259083.jpg', NULL, NULL, 'active', NULL, 'rkparmar', NULL, NULL, NULL, 'Public'),
(72, 'ivaluelabs', NULL, NULL, 3, 'Private', 'fwqerfdsfasdfasdfasdfasdfasdfasdf', 'turrialba costa rica', NULL, 'www.leo.com', '1-10', NULL, NULL, NULL, '234523452345', 'JOBPORTAL-1464315440.png', NULL, NULL, 'active', NULL, 'ivaluelabs', NULL, NULL, NULL, 'Public'),
(73, 'ugjntechnoly', NULL, NULL, 22, 'Private', 'sasA', 'sasa', NULL, 'ugjntechnology.com', '51-100', NULL, NULL, NULL, '9971562879', 'JOBPORTAL-1464347546.png', NULL, NULL, 'active', NULL, 'ugjntechnoly', NULL, NULL, NULL, 'Public'),
(74, 'Onion Smart Solutions', NULL, NULL, 22, 'Private', 'Software Development Company', '369-00100 Nairobi', NULL, 'www.onion.co.ke', '101-300', NULL, NULL, NULL, '0718199017', 'JOBPORTAL-1464458862.png', NULL, NULL, 'active', NULL, 'onion-smart-solutions', NULL, NULL, NULL, 'Private'),
(75, 'fddsfsdf', NULL, NULL, 7, 'Private', 'dsfsdfsdf', 'dsfsdf', NULL, 'sdfsdf', '11-50', NULL, NULL, NULL, '066666666666', 'JOBPORTAL-1464470540.gif', NULL, NULL, 'active', NULL, 'fddsfsdf', NULL, NULL, NULL, 'Government'),
(76, 'rrrr', NULL, NULL, 5, 'Private', 'effsdfdsdgdfg', 'wedsafadsf', NULL, 'neuronswork.com/', '1-10', NULL, NULL, NULL, 'dfdfdf', 'JOBPORTAL-1464734965.jpg', NULL, NULL, 'active', NULL, 'rrrr', NULL, NULL, NULL, 'Government'),
(77, 'Patel', NULL, NULL, 18, 'Private', 'dsfsd', 'dsfsdf', NULL, 'www.google.com', '1-10', NULL, NULL, NULL, '4353453', 'JOBPORTAL-1464966601.png', NULL, NULL, 'active', NULL, 'patel', NULL, NULL, NULL, 'Private'),
(78, 'aaj mid', NULL, NULL, 16, 'Private', '05000', 'dubai', NULL, '05000', '11-50', NULL, NULL, NULL, '05000', 'JOBPORTAL-1465349326.jpg', NULL, NULL, 'active', NULL, 'aaj-mid', NULL, NULL, NULL, 'Public'),
(79, 'the koko', NULL, NULL, 16, 'Private', 'deals with web design of any sort and develpo apps for companies', '4B shopping mall', NULL, 'thekoko.com', '1-10', NULL, NULL, NULL, '01678905', 'JOBPORTAL-1465479729.jpg', NULL, NULL, 'active', NULL, 'the-koko', NULL, NULL, NULL, 'Private'),
(80, 'test', NULL, NULL, 35, 'Private', 'test', 'test', NULL, 'test.nl', '1-10', NULL, NULL, NULL, 'test', 'JOBPORTAL-1465913974.jpg', NULL, NULL, 'active', NULL, 'test-1465913974', NULL, NULL, NULL, 'Private');

-- --------------------------------------------------------

--
-- Table structure for table `pp_countries`
--

CREATE TABLE `pp_countries` (
  `ID` int(11) NOT NULL,
  `country_name` varchar(150) NOT NULL DEFAULT '',
  `country_citizen` varchar(150) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_countries`
--

INSERT INTO `pp_countries` (`ID`, `country_name`, `country_citizen`) VALUES
(1, 'Kenya', 'Kenyan');

-- --------------------------------------------------------

--
-- Table structure for table `pp_email_content`
--

CREATE TABLE `pp_email_content` (
  `ID` int(11) NOT NULL,
  `email_name` varchar(155) DEFAULT NULL,
  `from_name` varchar(155) DEFAULT NULL,
  `content` text,
  `from_email` varchar(90) DEFAULT NULL,
  `subject` varchar(155) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_email_content`
--

INSERT INTO `pp_email_content` (`ID`, `email_name`, `from_name`, `content`, `from_email`, `subject`) VALUES
(1, 'Forgot Password', 'MNO Jobs', '<style type=\"text/css\">\n				.txt {\n						font-family: Arial, Helvetica, sans-serif;\n						font-size: 13px; color:#000000;\n					}\n				</style>\n<p class=\"txt\">Thank you  for contacting Member Support. Your account information is listed below: </p>\n<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"600\" class=\"txt\">\n  <tr>\n    <td width=\"17\" height=\"19\"><p>&nbsp;</p></td>\n    <td width=\"159\" height=\"25\" align=\"right\"><strong>Login Page:&nbsp;&nbsp;</strong></td>\n    <td width=\"424\" align=\"left\"><a href=\"{SITE_URL}/login\">{SITE_URL}/login</a></td>\n  </tr>\n  <tr>\n    <td height=\"19\">&nbsp;</td>\n    <td height=\"25\" align=\"right\"><strong>Your Username:&nbsp;&nbsp;</strong></td>\n    <td align=\"left\">{USERNAME}</td>\n  </tr>\n  <tr>\n    <td height=\"19\"><p>&nbsp;</p></td>\n    <td height=\"25\" align=\"right\"><strong>Your Password:&nbsp;&nbsp;</strong></td>\n    <td align=\"left\">{PASSWORD}</td>\n  </tr>\n</table>\n\n<p class=\"txt\">Thank you,</p>', 'service@jobportalbeta.com', 'Password Recovery'),
(2, 'Jobseeker Signup', 'Jobseeker Signup Successful', '<style type=\"text/css\">p {font-family: Arial, Helvetica, sans-serif; font-size: 13px; color:#000000;}</style>\n\n  <p>{JOBSEEKER_NAME}:</p>\n  <p>Thank you for joining us. Please note your profile details for future record.</p>\n  <p>Username: {USERNAME}<br>\n    Password: {PASSWORD}</p>\n  \n  <p>Regards</p>', 'service@jobportalbeta.com', 'Jobs website'),
(3, 'Employer signs up', 'Employer Signup Successful', '<style type=\"text/css\">p {font-family: Arial, Helvetica, sans-serif; font-size: 13px; color:#000000;}</style>\n\n  <p>{EMPLOYER_NAME}</p>\n  <p>Thank you for joining us. Please note your profile details for future record.</p>\n  <p>Username: {USERNAME}<br>\n    Password: {PASSWORD}</p>\n  <p>Regards</p>', 'service@jobportalbeta.com', 'Jobs website'),
(4, 'New job is posted by Employer', 'New Job Posted', '<style type=\"text/css\">p {font-family: Arial, Helvetica, sans-serif; font-size: 13px; color:#000000;}</style>\n\n  <p>{JOBSEEKER_NAME},</p>\n  <p>We would like to inform  that a new job has been posted on our website that may be of your interest.</p>\n  <p>Please visit the  following link to review and apply:</p>\n <p>{JOB_LINK}</p>\n  <p>Regards,</p>', 'service@jobportalbeta.com', 'New {JOB_CATEGORY}'),
(5, 'Apply Job', 'Job Application', '<style type=\"text/css\">p {font-family: Arial, Helvetica, sans-serif; font-size: 13px; color:#000000;}</style>\n  <p>{EMPLOYER_NAME}:</p>\n  <p>A new candidate has applied for the post of {JOB_TITLE}.</p>\n  <p>Please visit the following link to review the applicant profile.<br>\n    {CANDIDATE_PROFILE_LINK}</p>\n  <p>Regards,</p>', 'service@jobportalbeta.com', 'New Job CV {JOB_TITLE}'),
(6, 'Job Activation Email', 'Job Activated', '<style type=\"text/css\">p {font-family: Arial, Helvetica, sans-serif; font-size: 13px; color:#000000;}</style>\n  <p>{EMPLOYER_NAME}:</p>\n  <p>You had recently posted a job: {JOB_TITLE} on our website.</p>\n  <p>Your recent job has been approved and should be displaying on our website.</p>\n  <p>Thank you for using our website.</p>\n  <p>Regards,</p>', 'service@jobportalbeta.com', '{JOB_TITLE}  is now active'),
(7, 'Send Message To Candidate', '{EMPLOYER_NAME}', '<style type=\"text/css\">p {font-family: Arial, Helvetica, sans-serif; font-size: 13px; color:#000000;}</style>\r\n  <p>Hi {JOBSEEKER_NAME}:</p>\r\n  <p>A new message has been posted for you by :  {COMPANY_NAME}.</p>\r\n  <p>Message:</p>\r\n  <p>{MESSAGE}</p>\r\n  <p>You may review this company by going to: {COMPANY_PROFILE_LINK} to company profile.</p>\r\n  \r\n  <p>Regards,</p>', '{EMPLOYER_EMAIL}', 'New message for you'),
(8, 'Scam Alert', '{JOBSEEKER_NAME}', 'This is a scam', '{JOBSEEKER_EMAIL}', 'Company reported');

-- --------------------------------------------------------

--
-- Table structure for table `pp_employers`
--

CREATE TABLE `pp_employers` (
  `ID` int(11) NOT NULL,
  `company_ID` int(6) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `pass_code` varchar(100) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `mobile_phone` varchar(30) NOT NULL DEFAULT '',
  `gender` enum('female','male') DEFAULT NULL,
  `dated` date NOT NULL,
  `sts` enum('blocked','pending','active') NOT NULL DEFAULT 'active',
  `dob` date DEFAULT NULL,
  `home_phone` varchar(30) DEFAULT NULL,
  `verification_code` varchar(155) DEFAULT NULL,
  `first_login_date` datetime DEFAULT NULL,
  `last_login_date` datetime DEFAULT NULL,
  `ip_address` varchar(40) DEFAULT NULL,
  `old_emp_id` int(11) DEFAULT NULL,
  `flag` varchar(10) DEFAULT NULL,
  `present_address` varchar(155) DEFAULT NULL,
  `top_employer` enum('no','yes') DEFAULT 'no'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_employers`
--

INSERT INTO `pp_employers` (`ID`, `company_ID`, `email`, `pass_code`, `first_name`, `last_name`, `country`, `city`, `mobile_phone`, `gender`, `dated`, `sts`, `dob`, `home_phone`, `verification_code`, `first_login_date`, `last_login_date`, `ip_address`, `old_emp_id`, `flag`, `present_address`, `top_employer`) VALUES
(1, 1, 'bsclmr4914@spu.ac.ke', 'wesbrown1', 'Nicholas Wakaba', NULL, 'Kenya', 'Nairobi', '135646456', NULL, '0000-00-00', 'active', NULL, '0', NULL, '2016-03-11 14:54:55', '2016-04-11 23:45:57', '115.186.165.234', NULL, NULL, NULL, 'yes');

-- --------------------------------------------------------

--
-- Table structure for table `pp_favourite_candidates`
--

CREATE TABLE `pp_favourite_candidates` (
  `employer_id` int(11) NOT NULL,
  `seekerid` int(11) DEFAULT NULL,
  `employerlogin` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `pp_favourite_companies`
--

CREATE TABLE `pp_favourite_companies` (
  `seekerid` int(11) NOT NULL,
  `companyid` int(11) DEFAULT NULL,
  `seekerlogin` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `pp_institute`
--

CREATE TABLE `pp_institute` (
  `ID` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `sts` enum('blocked','active') DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_institute`
--

INSERT INTO `pp_institute` (`ID`, `name`, `sts`) VALUES
(1, 'St Pauls University', NULL),
(2, 'University Of Nairobi', NULL),
(3, 'Kenyatta University', NULL),
(4, 'Kenya Medical Training College', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pp_job_alert`
--

CREATE TABLE `pp_job_alert` (
  `ID` int(11) NOT NULL,
  `job_ID` int(11) DEFAULT NULL,
  `dated` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `pp_job_alert_queue`
--

CREATE TABLE `pp_job_alert_queue` (
  `ID` int(11) NOT NULL,
  `seeker_ID` int(11) DEFAULT NULL,
  `job_ID` int(11) DEFAULT NULL,
  `dated` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `pp_job_functional_areas`
--

CREATE TABLE `pp_job_functional_areas` (
  `ID` int(7) NOT NULL,
  `industry_ID` int(7) DEFAULT NULL,
  `functional_area` varchar(155) DEFAULT NULL,
  `sts` enum('suspended','active') DEFAULT 'active'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 PACK_KEYS=0;

-- --------------------------------------------------------

--
-- Table structure for table `pp_job_industries`
--

CREATE TABLE `pp_job_industries` (
  `ID` int(11) NOT NULL,
  `industry_name` varchar(155) DEFAULT NULL,
  `slug` varchar(155) DEFAULT NULL,
  `sts` enum('suspended','active') DEFAULT 'active',
  `top_category` enum('no','yes') DEFAULT 'no'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 PACK_KEYS=0;

--
-- Dumping data for table `pp_job_industries`
--

INSERT INTO `pp_job_industries` (`ID`, `industry_name`, `slug`, `sts`, `top_category`) VALUES
(3, 'Accounts', 'accounts', 'active', 'yes'),
(5, 'Advertising', 'advertising', 'active', 'yes'),
(7, 'Banking', 'banking', 'active', 'yes'),
(10, 'Customer Service', 'customer-service', 'active', 'yes'),
(16, 'Graphic / Web Design', 'graphic-web-design', 'active', 'yes'),
(18, 'HR / Industrial Relations', 'hr-industrial-relations', 'active', 'yes'),
(22, 'IT - Software', 'it-software', 'active', 'yes'),
(35, 'Teaching / Education', 'teaching-education', 'active', 'yes'),
(40, 'IT - Hardware', 'it-hardware', 'active', 'yes');

-- --------------------------------------------------------

--
-- Table structure for table `pp_job_seekers`
--

CREATE TABLE `pp_job_seekers` (
  `ID` int(11) NOT NULL,
  `first_name` varchar(30) DEFAULT NULL,
  `last_name` varchar(30) DEFAULT NULL,
  `email` varchar(155) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `present_address` varchar(255) DEFAULT NULL,
  `permanent_address` varchar(255) DEFAULT NULL,
  `dated` datetime NOT NULL,
  `country` varchar(50) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `gender` enum('female','male') DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `photo` varchar(100) DEFAULT NULL,
  `default_cv_id` int(11) NOT NULL,
  `mobile` varchar(30) DEFAULT NULL,
  `home_phone` varchar(25) DEFAULT NULL,
  `cnic` varchar(255) DEFAULT NULL,
  `nationality` varchar(50) DEFAULT NULL,
  `career_objective` text,
  `sts` enum('active','blocked','pending') NOT NULL DEFAULT 'active',
  `verification_code` varchar(155) DEFAULT NULL,
  `first_login_date` datetime DEFAULT NULL,
  `last_login_date` datetime DEFAULT NULL,
  `slug` varchar(155) DEFAULT NULL,
  `ip_address` varchar(40) DEFAULT NULL,
  `old_id` int(11) DEFAULT NULL,
  `flag` varchar(10) DEFAULT NULL,
  `queue_email_sts` tinyint(1) DEFAULT NULL,
  `send_job_alert` enum('no','yes') DEFAULT 'yes'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_job_seekers`
--

INSERT INTO `pp_job_seekers` (`ID`, `first_name`, `last_name`, `email`, `password`, `present_address`, `permanent_address`, `dated`, `country`, `city`, `gender`, `dob`, `phone`, `photo`, `default_cv_id`, `mobile`, `home_phone`, `cnic`, `nationality`, `career_objective`, `sts`, `verification_code`, `first_login_date`, `last_login_date`, `slug`, `ip_address`, `old_id`, `flag`, `queue_email_sts`, `send_job_alert`) VALUES
(8, 'Kennedy Ngure', '', 'kennguch3@gmail.com', 'ngure1998', '101 Limuru', '', '2016-03-12 01:44:43', 'Kenya', 'Nairobi', 'male', '2001-03-09', '0703976320', 'no-image.jpg', 0, '0703976320', '123123123', NULL, '1', NULL, 'active', NULL, '2016-05-14 15:39:15', '2016-05-14 15:39:15', NULL, '2.50.150.100', NULL, NULL, NULL, 'yes'),
(143, 'Rebeccah Ndungi', '', 'bobitnrb860418@spu.ac.ke', 'bobitnrb', '00200', '', '2019-03-02 17:13:43', 'Kenya', 'Nairobi', 'female', '1990-02-14', NULL, NULL, 0, '0724412804', '', NULL, 'Kenyan', NULL, 'active', NULL, '2019-03-02 17:21:52', '2019-03-02 17:21:52', NULL, '::1', NULL, NULL, NULL, 'yes');

-- --------------------------------------------------------

--
-- Table structure for table `pp_job_titles`
--

CREATE TABLE `pp_job_titles` (
  `ID` int(11) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `text` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_job_titles`
--

INSERT INTO `pp_job_titles` (`ID`, `value`, `text`) VALUES
(1, 'Web Designer', 'Web Designer'),
(2, 'Web Developer', 'Web Developer'),
(3, 'Graphic Designer', 'Graphic Designer'),
(4, 'Project Manager', 'Project Manager'),
(5, 'Network Administrator', 'Network Administrator'),
(6, 'Network Engineer', 'Network Engineer'),
(7, 'Software Engineer', 'Software Engineer'),
(8, 'System Administrator', 'System Administrator'),
(9, 'System Analyst', 'System Analyst');

-- --------------------------------------------------------

--
-- Table structure for table `pp_newsletter`
--

CREATE TABLE `pp_newsletter` (
  `ID` int(11) NOT NULL,
  `email_name` varchar(50) DEFAULT NULL,
  `from_name` varchar(60) DEFAULT NULL,
  `from_email` varchar(120) DEFAULT NULL,
  `email_subject` varchar(100) DEFAULT NULL,
  `email_body` text,
  `email_interval` int(4) DEFAULT NULL,
  `status` enum('inactive','active') DEFAULT 'active',
  `dated` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `pp_post_jobs`
--

CREATE TABLE `pp_post_jobs` (
  `ID` int(11) NOT NULL,
  `employer_ID` int(11) NOT NULL,
  `job_title` varchar(255) NOT NULL,
  `company_ID` int(11) NOT NULL,
  `industry_ID` int(11) NOT NULL,
  `pay` varchar(60) NOT NULL,
  `dated` date NOT NULL,
  `sts` enum('inactive','pending','blocked','active') NOT NULL DEFAULT 'pending',
  `is_featured` enum('no','yes') NOT NULL DEFAULT 'no',
  `country` varchar(100) NOT NULL,
  `last_date` date NOT NULL,
  `age_required` varchar(50) NOT NULL,
  `qualification` varchar(60) NOT NULL,
  `experience` varchar(50) NOT NULL,
  `city` varchar(100) NOT NULL,
  `job_mode` enum('Home Based','Part Time','Full Time') NOT NULL DEFAULT 'Full Time',
  `vacancies` int(3) NOT NULL,
  `job_description` longtext NOT NULL,
  `contact_person` varchar(100) NOT NULL,
  `contact_email` varchar(100) NOT NULL,
  `contact_phone` varchar(30) NOT NULL,
  `viewer_count` int(11) NOT NULL DEFAULT '0',
  `job_slug` varchar(255) DEFAULT NULL,
  `ip_address` varchar(40) DEFAULT NULL,
  `flag` varchar(10) DEFAULT NULL,
  `old_id` int(11) DEFAULT NULL,
  `required_skills` varchar(255) DEFAULT NULL,
  `email_queued` tinyint(1) DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_post_jobs`
--

INSERT INTO `pp_post_jobs` (`ID`, `employer_ID`, `job_title`, `company_ID`, `industry_ID`, `pay`, `dated`, `sts`, `is_featured`, `country`, `last_date`, `age_required`, `qualification`, `experience`, `city`, `job_mode`, `vacancies`, `job_description`, `contact_person`, `contact_email`, `contact_phone`, `viewer_count`, `job_slug`, `ip_address`, `flag`, `old_id`, `required_skills`, `email_queued`) VALUES
(53, 1, 'Senior Accountant', 1, 3, 'Intern', '2019-03-02', 'active', 'no', 'Kenya', '2019-07-02', '', 'Any Skill', 'Fresh', 'Nairobi', 'Full Time', 1, 'Requires a new accountant', '', '', '', 0, 'nick-technologies-jobs-in-nairobi-senior-accountant-53', '::1', NULL, NULL, 'cpa', 0),
(52, 1, 'Senior Developer', 1, 22, 'Trainee Stipend', '2019-03-02', 'active', 'no', 'Kenya', '2019-07-02', '', 'Any Skill', 'Less than 1', 'Nairobi', 'Full Time', 12, 'senior', '', '', '', 0, 'nick-technologies-jobs-in-nairobi-senior-developer-52', '::1', NULL, NULL, 'java', 0);

-- --------------------------------------------------------

--
-- Table structure for table `pp_prohibited_keywords`
--

CREATE TABLE `pp_prohibited_keywords` (
  `ID` int(11) NOT NULL,
  `keyword` varchar(150) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_prohibited_keywords`
--

INSERT INTO `pp_prohibited_keywords` (`ID`, `keyword`) VALUES
(8, 'idiot'),
(9, 'fuck'),
(10, 'bitch');

-- --------------------------------------------------------

--
-- Table structure for table `pp_qualifications`
--

CREATE TABLE `pp_qualifications` (
  `ID` int(5) NOT NULL,
  `val` varchar(25) DEFAULT NULL,
  `text` varchar(25) DEFAULT NULL,
  `display_order` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_qualifications`
--

INSERT INTO `pp_qualifications` (`ID`, `val`, `text`, `display_order`) VALUES
(1, 'BA', 'BA', NULL),
(2, 'BE', 'BE', NULL),
(3, 'BS', 'BS', NULL),
(4, 'CA', 'CA', NULL),
(5, 'Certification', 'Certification', NULL),
(6, 'Diploma', 'Diploma', NULL),
(7, 'HSSC', 'HSSC', NULL),
(8, 'MA', 'MA', NULL),
(9, 'MBA', 'MBA', NULL),
(10, 'MS', 'MS', NULL),
(11, 'PhD', 'PhD', NULL),
(12, 'SSC', 'SSC', NULL),
(13, 'ACMA', 'ACMA', NULL),
(14, 'MCS', 'MCS', NULL),
(15, 'Any Skill', 'Any Skill', NULL),
(16, 'Degree', 'BSC', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pp_salaries`
--

CREATE TABLE `pp_salaries` (
  `ID` int(5) NOT NULL,
  `val` varchar(40) DEFAULT NULL,
  `text` varchar(40) DEFAULT NULL,
  `display_order` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_salaries`
--

INSERT INTO `pp_salaries` (`ID`, `val`, `text`, `display_order`) VALUES
(1, 'Intern / Industrial Attachment', 'Internship', 0),
(2, '5000-10000', '5-10', NULL),
(3, '11000-15000', '11-15', NULL),
(4, '16000-20000', '16-20', NULL),
(5, '21000-25000', '21-25', NULL),
(6, '26000-30000', '26-30', NULL),
(7, '31000-35000', '31-35', NULL),
(8, '36000-40000', '36-40', NULL),
(9, '41000-50000', '41-50', NULL),
(10, '51000-60000', '51-60', NULL),
(11, '61000-70000', '61-70', NULL),
(12, '71000-80000', '71-80', NULL),
(13, '81000-100000', '81-100', NULL),
(14, '100000-120000', '101-120', NULL),
(15, '120000-140000', '121-140', NULL),
(16, '140000-160000', '141-160', NULL),
(17, '160000-200000', '161-200', NULL),
(18, '200000-240000', '201-240', NULL),
(19, '240000-280000', '241-280', NULL),
(20, '281000-350000', '281-350', NULL),
(21, '350000-450000', '351-450', NULL),
(22, '450000 or above', '450 or above', NULL),
(23, 'Discuss', 'Discuss', NULL),
(24, 'Depends', 'Depends', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pp_scam`
--

CREATE TABLE `pp_scam` (
  `ID` int(11) NOT NULL,
  `user_ID` int(11) DEFAULT NULL,
  `job_ID` int(11) DEFAULT NULL,
  `reason` text,
  `dated` datetime DEFAULT NULL,
  `ip_address` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `pp_seeker_academic`
--

CREATE TABLE `pp_seeker_academic` (
  `ID` int(11) NOT NULL,
  `seeker_ID` int(11) DEFAULT NULL,
  `degree_level` varchar(30) DEFAULT NULL,
  `degree_title` varchar(100) DEFAULT NULL,
  `major` varchar(155) DEFAULT NULL,
  `institude` varchar(155) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `completion_year` int(5) DEFAULT NULL,
  `dated` datetime DEFAULT NULL,
  `flag` varchar(10) DEFAULT NULL,
  `old_id` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_seeker_academic`
--

INSERT INTO `pp_seeker_academic` (`ID`, `seeker_ID`, `degree_level`, `degree_title`, `major`, `institude`, `country`, `city`, `completion_year`, `dated`, `flag`, `old_id`) VALUES
(1, 10, NULL, 'BA', 'test', 'teste e ere', 'Kenya States of America', 'Nairobi', 2012, '2016-03-12 13:05:55', NULL, NULL),
(2, 18, NULL, 'BS', 'axaxsxsxsxsxs', 'xsxsxsxsxsxsxsxsx', 'Peru', 'Lima', 2015, '2016-03-28 20:03:39', NULL, NULL),
(3, 18, NULL, 'Certification', 'cscscdscdsdc', 'cdscdsdcscdsdcscsdcdcsd', 'Pakistan', 'sdcsdcsdcsd', 2020, '2016-03-28 20:05:34', NULL, NULL),
(4, 18, NULL, 'Diploma', 'csdcsdcsdcsdscsdcscdsdcsdc', 'cdscsdcsdcsdcsdcsdcsdcsdcsdc', 'Pakistan', 'csdcsdcscsdcsd', 2018, '2016-03-28 20:06:28', NULL, NULL),
(5, 15, NULL, 'Certification', '3º Ano Completo', 'EREM Tamandaré', 'Brazil', 'Tamandaré', 2014, '2016-03-28 22:24:18', NULL, NULL),
(6, 25, NULL, 'BS', 'ghj', 'fghjfgh', 'Kenya States of America', 'fortson', 2007, '2016-03-29 13:43:47', NULL, NULL),
(7, 32, NULL, 'MBA', 'ded', 'eded', 'India', 'arabbia', 2020, '2016-03-31 23:38:10', NULL, NULL),
(8, 36, NULL, 'MBA', 'MKT', 'WUB', 'Bangladesh', 'dhaka', 2013, '2016-04-02 03:23:29', NULL, NULL),
(9, 59, NULL, 'MBA', 'computer application', 'add', 'India', 'mana', 2010, '2016-04-08 16:06:52', NULL, NULL),
(10, 74, NULL, 'BA', 'php', 'abc', 'India', 'mangalore', 2014, '2016-04-15 11:42:43', NULL, NULL),
(11, 75, NULL, 'BS', 'Computer', 'SV University', 'India', 'Bangalore', 2002, '2016-04-15 15:27:09', NULL, NULL),
(12, 95, NULL, 'PhD', 'test', 'test', 'Tahiti', 'test', 2021, '2016-05-04 18:51:07', NULL, NULL),
(13, 109, NULL, 'BA', '12', '21', 'Pakistan', '12', 2021, '2016-05-13 20:35:24', NULL, NULL),
(14, 132, NULL, 'Certification', 'sdas', 'asdsad', 'Peru', 'sadsad', 2000, '2016-06-01 03:45:47', NULL, NULL),
(15, 133, NULL, 'BS', 'ddd', 'sffs', 'Pakistan', 'Tgcvga', 2020, '2016-06-02 12:53:52', NULL, NULL),
(16, 137, NULL, 'BA', 'fdsa', 'fdas', 'Pakistan', 'fdsa', 2008, '2016-06-09 23:56:55', NULL, NULL),
(18, 139, NULL, 'CA', 'fdsa', 'fdsa', 'Norway', 'fdsa', 2006, '2016-06-11 22:02:33', NULL, NULL),
(19, 123, NULL, 'BA', 'Science', 'anc', 'Nigeria', 'adg', 2012, '2016-06-17 02:41:10', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pp_seeker_additional_info`
--

CREATE TABLE `pp_seeker_additional_info` (
  `ID` int(11) NOT NULL,
  `seeker_ID` int(11) DEFAULT NULL,
  `languages` varchar(255) DEFAULT NULL COMMENT 'JSON data',
  `interest` varchar(155) DEFAULT NULL,
  `awards` varchar(100) DEFAULT NULL,
  `additional_qualities` varchar(155) DEFAULT NULL,
  `convicted_crime` enum('no','yes') DEFAULT 'no',
  `crime_details` text,
  `summary` text,
  `bad_habits` varchar(255) DEFAULT NULL,
  `salary` varchar(50) DEFAULT NULL,
  `keywords` varchar(255) DEFAULT NULL,
  `description` text
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_seeker_additional_info`
--

INSERT INTO `pp_seeker_additional_info` (`ID`, `seeker_ID`, `languages`, `interest`, `awards`, `additional_qualities`, `convicted_crime`, `crime_details`, `summary`, `bad_habits`, `salary`, `keywords`, `description`) VALUES
(1, 8, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(2, 9, NULL, NULL, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur massa nisl, porttitor id urna sag', NULL, 'no', NULL, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur massa nisl, porttitor id urna sagittis, mollis tristique diam. Donec augue nulla, tempus id egestas finibus, sodales a ligula. Suspendisse lacinia malesuada sapien nec pretium. Curabitur sed augue sed neque vulputate congue at pellentesque ante. Aliquam facilisis cursus eros, in laoreet risus luctus non. Aliquam tincidunt purus in urna molestie, eget aliquet lectus sollicitudin. Proin pretium tellus maximus dolor dapibus aliquet. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam sed bibendum nulla. Nulla ac magna placerat, tristique nisl a, consectetur lectus. Pellentesque quis enim semper, placerat augue vel, faucibus urna. Nullam ut odio volutpat, scelerisque mi ac, ornare libero.', NULL, NULL, NULL, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur massa nisl, porttitor id urna sagittis, mollis tristique diam. Donec augue nulla, tempus id egestas finibus, sodales a ligula. Suspendisse lacinia malesuada sapien nec pretium. Curabitur sed augue sed neque vulputate congue at pellentesque ante. Aliquam facilisis cursus eros, in laoreet risus luctus non. Aliquam tincidunt purus in urna molestie, eget aliquet lectus sollicitudin. Proin pretium tellus maximus dolor dapibus aliquet. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam sed bibendum nulla. Nulla ac magna placerat, tristique nisl a, consectetur lectus. Pellentesque quis enim semper, placerat augue vel, faucibus urna. Nullam ut odio volutpat, scelerisque mi ac, ornare libero.'),
(3, 10, NULL, NULL, 'Quisque ac scelerisque libero, nec blandit neque. Nullam felis nisl, elementum eu sapien ut, convall', NULL, 'no', NULL, 'Quisque ac scelerisque libero, nec blandit neque. Nullam felis nisl, elementum eu sapien ut, convallis interdum felis. In turpis odio, fermentum non pulvinar gravida, posuere quis magna. Ut mollis eget neque at euismod. Interdum et malesuada fames ac ante ipsum primis in faucibus. Integer faucibus orci a pulvinar malesuada. Aenean at felis vitae lorem venenatis consequat. Nam non nunc euismod, consequat ligula non, tristique odio. Ut leo sapien, aliquet sed ultricies et, scelerisque quis nulla. Aenean non sapien maximus, convallis eros vitae, iaculis massa. In fringilla hendrerit nisi, eu pellentesque massa faucibus molestie. Etiam laoreet eros quis faucibus rutrum. Quisque eleifend purus justo, eget tempus quam interdum non.', NULL, NULL, NULL, 'Quisque ac scelerisque libero, nec blandit neque. Nullam felis nisl, elementum eu sapien ut, convallis interdum felis. In turpis odio, fermentum non pulvinar gravida, posuere quis magna. Ut mollis eget neque at euismod. Interdum et malesuada fames ac ante ipsum primis in faucibus. Integer faucibus orci a pulvinar malesuada. Aenean at felis vitae lorem venenatis consequat. Nam non nunc euismod, consequat ligula non, tristique odio. Ut leo sapien, aliquet sed ultricies et, scelerisque quis nulla. Aenean non sapien maximus, convallis eros vitae, iaculis massa. In fringilla hendrerit nisi, eu pellentesque massa faucibus molestie. Etiam laoreet eros quis faucibus rutrum. Quisque eleifend purus justo, eget tempus quam interdum non.'),
(4, 11, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(5, 12, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(6, 13, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(7, 14, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(8, 15, NULL, NULL, 'Qualquer coisa que vim que seja bem vindo.', NULL, 'no', NULL, 'Eu geralmente trabalhei com computação e fotografias. O meu objetivo é dar o meu melhor a empresa, pois quando eu tento dar o meu melhor eu consigo, e pra conquistar as pessoas eu sou de mais.', NULL, NULL, NULL, 'Serviços Gerais'),
(9, 16, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(10, 17, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(11, 18, NULL, NULL, 'demo demo demo demo demo demo demo demode mdo', NULL, 'no', NULL, 'dededededed edededededededed dede', NULL, NULL, NULL, 'de demo demo demo demo demo demo dem'),
(12, 19, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(13, 20, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(14, 21, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(15, 22, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(16, 23, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(17, 24, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(18, 25, NULL, NULL, 'rthrthrt', NULL, 'no', NULL, 'df df df gd fg dfgdfgsdfrg', NULL, NULL, NULL, 'sfrtghdr'),
(19, 26, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(20, 27, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(21, 28, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(22, 29, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(23, 30, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(24, 32, NULL, NULL, NULL, NULL, 'no', NULL, 'adfsdfsdfsdfsdf', NULL, NULL, NULL, NULL),
(25, 33, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(26, 35, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(27, 36, NULL, NULL, NULL, NULL, 'no', NULL, 'My Name is Saiful', NULL, NULL, NULL, NULL),
(28, 37, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(29, 38, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(30, 41, NULL, NULL, NULL, NULL, 'no', NULL, 'kdkdkd kdkdkd ksksks zkzkzkz sksksksksks kdkdkd kdkdkd ksksks zkzkzkz sksksksksks kdkdkd kdkdkd ksksks zkzkzkz sksksksksks kdkdkd kdkdkd ksksks zkzkzkz sksksksksks vkdkdkd kdkdkd ksksks zkzkzkz sksksksksks kdkdkd kdkdkd ksksks zkzkzkz sksksksksks kdkdkd kdkdkd ksksks zkzkzkz sksksksksks kdkdkd kdkdkd ksksks zkzkzkz sksksksksks kdkdkd kdkdkd ksksks zkzkzkz sksksksksks vkdkdkd kdkdkd ksksks zkzkzkz sksksksksks kdkdkd kdkdkd ksksks zkzkzkz sksksksksks kdkdkd kdkdkd ksksks zkzkzkz sksksksksks kdkdkd kdkdkd ksksks zkzkzkz sksksksksks kdkdkd kdkdkd ksksks zkzkzkz sksksksksks vkdkdkd kdkdkd ksksks zkzkzkz sksksksksks', NULL, NULL, NULL, NULL),
(31, 42, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(32, 47, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(33, 48, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(34, 49, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(35, 50, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(36, 51, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(37, 52, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(38, 53, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(39, 54, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(40, 55, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(41, 56, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(42, 57, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(43, 58, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(44, 59, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(45, 60, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(46, 61, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(47, 65, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(48, 66, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(49, 67, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(50, 68, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(51, 69, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(52, 70, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(53, 71, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(54, 74, NULL, NULL, 'ghgfhg', NULL, 'no', NULL, 'fgfdfd', NULL, NULL, NULL, 'hghg'),
(55, 75, NULL, NULL, 'Best Employee of the Year', NULL, 'no', NULL, '1	Around 6+ Years of Experience in Manual testing (Printer Domain).\n2	Expertise in Software testing process.\n3	Proficient with Software Development Life cycle.\n4	Black Box testing, Integration Testing, System testing, Boundary testing and Regression testing process of a given software application for different software releases and builds.\n5	Development of test procedure, test cases and test reporting documents.\n6	Review Test Cases on Fixed Defects by Onsite Team on different freezes and different Products.', NULL, NULL, NULL, 'To be a part of an Organization which provides a high quality of work life through challenging opportunities, a meaningful career growth and professional development'),
(56, 76, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(57, 78, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(58, 79, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(59, 80, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(60, 81, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(61, 82, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(62, 83, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(63, 84, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(64, 85, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(65, 86, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(66, 87, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(67, 88, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(68, 89, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(69, 90, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(70, 91, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(71, 92, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(72, 93, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(73, 94, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(74, 95, NULL, NULL, NULL, NULL, 'no', NULL, 'test at test.com and testing test from test date to test updat and original test update.', NULL, NULL, NULL, NULL),
(75, 97, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(76, 98, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(77, 99, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(78, 100, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(79, 102, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(80, 103, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(81, 105, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(82, 106, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(83, 107, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(84, 108, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(85, 109, NULL, NULL, NULL, NULL, 'no', NULL, 'hello pro', NULL, NULL, NULL, NULL),
(86, 110, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(87, 111, NULL, NULL, NULL, NULL, 'no', NULL, 'You\'ve ventured too far out into the desert! Time to head back.\n\nWe couldn\'t find any results for your search. Use more generic words or double check your spelling.You\'ve ventured too far out into the desert! Time to head back.\n\nWe couldn\'t find any results for your search. Use more generic words or double check your spelling.You\'ve ventured too far out into the desert! Time to head back.\n\nWe couldn\'t find any results for your search. Use more generic words or double check your spelling.', NULL, NULL, NULL, NULL),
(88, 113, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(89, 114, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(90, 115, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(91, 116, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(92, 117, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(93, 118, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(94, 119, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(95, 121, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(96, 122, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(97, 123, NULL, NULL, NULL, NULL, 'no', NULL, 'sfsdfds fsd fsdf sdfsdfsdfsdfsdf', NULL, NULL, NULL, NULL),
(98, 124, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(99, 125, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(100, 126, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(101, 127, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(102, 128, NULL, NULL, 'vcvc', NULL, 'no', NULL, 'vbvbvbv', NULL, NULL, NULL, 'vcvc'),
(103, 129, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(104, 130, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(105, 132, NULL, NULL, 'dadasdas', NULL, 'no', NULL, 'sdasdsad', NULL, NULL, NULL, 'sdsadsadad'),
(106, 133, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(107, 134, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(108, 135, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(109, 136, NULL, NULL, 'was class prefect', NULL, 'no', NULL, 'advance welding and inspection pro', NULL, NULL, NULL, 'to help employers succeed'),
(110, 137, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(111, 138, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(112, 139, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(113, 142, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL),
(114, 143, NULL, NULL, NULL, NULL, 'no', NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pp_seeker_applied_for_job`
--

CREATE TABLE `pp_seeker_applied_for_job` (
  `ID` int(11) NOT NULL,
  `seeker_ID` int(11) NOT NULL,
  `job_ID` int(11) NOT NULL,
  `cover_letter` text,
  `expected_salary` varchar(20) DEFAULT NULL,
  `dated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ip_address` varchar(40) DEFAULT NULL,
  `employer_ID` int(11) DEFAULT NULL,
  `flag` varchar(10) DEFAULT NULL,
  `old_id` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_seeker_applied_for_job`
--

INSERT INTO `pp_seeker_applied_for_job` (`ID`, `seeker_ID`, `job_ID`, `cover_letter`, `expected_salary`, `dated`, `ip_address`, `employer_ID`, `flag`, `old_id`) VALUES
(1, 9, 8, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur massa nisl, porttitor id urna sagittis, mollis tristique diam. Donec augue nulla, tempus id egestas finibus, sodales a ligula. Suspendisse lacinia malesuada sapien nec pretium. Curabitur sed augue sed neque vulputate congue at pellentesque ante. Aliquam facilisis cursus eros, in laoreet risus luctus non. Aliquam tincidunt purus in urna molestie, eget aliquet lectus sollicitudin. Proin pretium tellus maximus dolor dapibus aliquet. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam sed bibendum nulla. Nulla ac magna placerat, tristique nisl a, consectetur lectus. Pellentesque quis enim semper, placerat augue vel, faucibus urna. Nullam ut odio volutpat, scelerisque mi ac, ornare libero.', 'Trainee Stipend', '2016-03-12 01:53:57', NULL, 7, NULL, NULL),
(2, 10, 12, 'Quisque ac scelerisque libero, nec blandit neque. Nullam felis nisl, elementum eu sapien ut, convallis interdum felis. In turpis odio, fermentum non pulvinar gravida, posuere quis magna. Ut mollis eget neque at euismod. Interdum et malesuada fames ac ante ipsum primis in faucibus. Integer faucibus orci a pulvinar malesuada. Aenean at felis vitae lorem venenatis consequat. Nam non nunc euismod, consequat ligula non, tristique odio. Ut leo sapien, aliquet sed ultricies et, scelerisque quis nulla. Aenean non sapien maximus, convallis eros vitae, iaculis massa. In fringilla hendrerit nisi, eu pellentesque massa faucibus molestie. Etiam laoreet eros quis faucibus rutrum. Quisque eleifend purus justo, eget tempus quam interdum non.', '21000-25000', '2016-03-12 13:06:43', NULL, 11, NULL, NULL),
(3, 10, 9, 'Quisque ac scelerisque libero, nec blandit neque. Nullam felis nisl, elementum eu sapien ut, convallis interdum felis. In turpis odio, fermentum non pulvinar gravida, posuere quis magna. Ut mollis eget neque at euismod. Interdum et malesuada fames ac ante ipsum primis in faucibus. Integer faucibus orci a pulvinar malesuada. Aenean at felis vitae lorem venenatis consequat. Nam non nunc euismod, consequat ligula non, tristique odio. Ut leo sapien, aliquet sed ultricies et, scelerisque quis nulla. Aenean non sapien maximus, convallis eros vitae, iaculis massa. In fringilla hendrerit nisi, eu pellentesque massa faucibus molestie. Etiam laoreet eros quis faucibus rutrum. Quisque eleifend purus justo, eget tempus quam interdum non.', 'Trainee Stipend', '2016-03-12 13:07:08', NULL, 8, NULL, NULL),
(4, 11, 9, 'Test', '5000-10000', '2016-03-28 14:14:16', NULL, 8, NULL, NULL),
(5, 11, 15, 'Account Officer', 'Trainee Stipend', '2016-03-28 14:14:39', NULL, 14, NULL, NULL),
(6, 11, 7, 'Account Officer', 'Trainee Stipend', '2016-03-28 14:15:03', NULL, 6, NULL, NULL),
(7, 12, 15, 'bcchchv', '5000-10000', '2016-03-28 14:47:58', NULL, 14, NULL, NULL),
(8, 15, 12, '1.500', 'Depends', '2016-03-28 18:51:23', NULL, 11, NULL, NULL),
(9, 17, 15, 'uuuuu', 'Trainee Stipend', '2016-03-28 19:37:26', NULL, 14, NULL, NULL),
(10, 18, 14, 'deed  deededxeddxedde', '16000-20000', '2016-03-28 20:07:46', NULL, 13, NULL, NULL),
(11, 15, 7, 'Designer', '5000-10000', '2016-03-28 23:51:55', NULL, 6, NULL, NULL),
(13, 21, 14, 'aaaaaaaaaaaa', '31000-35000', '2016-03-29 02:58:06', NULL, 13, NULL, NULL),
(14, 23, 10, 'Hello, this is my cover letter.', '5000-10000', '2016-03-29 05:54:46', NULL, 9, NULL, NULL),
(15, 25, 15, 'fgmfhjm', '11000-15000', '2016-03-29 13:44:49', NULL, 14, NULL, NULL),
(16, 26, 15, 'sadfsdfsdfffffffffffffffffffffffs', '5000-10000', '2016-03-29 22:41:52', NULL, 14, NULL, NULL),
(17, 30, 12, '234234234', '5000-10000', '2016-03-31 20:01:56', NULL, 11, NULL, NULL),
(18, 30, 15, '45345345', '281000-350000', '2016-03-31 20:16:28', NULL, 14, NULL, NULL),
(19, 32, 3, 'fsdfsdf', '5000-10000', '2016-03-31 23:39:09', NULL, 2, NULL, NULL),
(20, 36, 12, 'Hello', '5000-10000', '2016-04-02 03:25:01', NULL, 11, NULL, NULL),
(21, 38, 14, 'test', '11000-15000', '2016-04-02 12:12:38', NULL, 13, NULL, NULL),
(22, 41, 13, 'ksksks ksksksks skskks ksksks ksksksks skskks ksksks ksksksks skskks ksksks ksksksks skskks ksksks ksksksks skskks ksksks ksksksks skskksksksks ksksksks skskks ksksks ksksksks skskks ksksks ksksksks skskksksksks ksksksks skskks ksksks ksksksks skskks ksksks ksksksks skskksksksks ksksksks skskks ksksks ksksksks skskks ksksks ksksksks skskksksksks ksksksks skskks ksksks ksksksks skskks ksksks ksksksks skskksksksks ksksksks skskks ksksks ksksksks skskks ksksks ksksksks skskksksksks ksksksks skskks ksksks ksksksks skskks ksksks ksksksks skskks', '11000-15000', '2016-04-03 02:58:44', NULL, 12, NULL, NULL),
(23, 42, 15, 'aaaaa', '21000-25000', '2016-04-03 03:32:39', NULL, 14, NULL, NULL),
(24, 42, 6, 'a', 'Trainee Stipend', '2016-04-03 03:33:06', NULL, 5, NULL, NULL),
(25, 47, 14, 'rrrr', 'Trainee Stipend', '2016-04-03 03:45:58', NULL, 13, NULL, NULL),
(26, 48, 3, 'fsdfsdf', '26000-30000', '2016-04-03 15:33:36', NULL, 2, NULL, NULL),
(27, 36, 15, 'Thanks', '16000-20000', '2016-04-03 17:39:50', NULL, 14, NULL, NULL),
(28, 49, 15, 'benimben44627', '16000-20000', '2016-04-03 20:17:39', NULL, 14, NULL, NULL),
(29, 51, 15, 'Test Letter', '5000-10000', '2016-04-04 21:08:49', NULL, 14, NULL, NULL),
(30, 52, 15, 'fd', '5000-10000', '2016-04-05 13:58:50', NULL, 14, NULL, NULL),
(31, 55, 15, '3123', '11000-15000', '2016-04-06 18:23:31', NULL, 14, NULL, NULL),
(32, 59, 12, 'dhggggggggg', '26000-30000', '2016-04-08 16:07:49', NULL, 11, NULL, NULL),
(33, 58, 15, 'dfghdg', 'Trainee Stipend', '2016-04-08 16:23:41', NULL, 14, NULL, NULL),
(35, 65, 7, 'sfdadsa', '16000-20000', '2016-04-11 17:21:27', NULL, 6, NULL, NULL),
(36, 66, 15, 'SDS', '5000-10000', '2016-04-12 01:34:51', NULL, 14, NULL, NULL),
(37, 67, 12, 'hola', '11000-15000', '2016-04-12 10:35:49', NULL, 11, NULL, NULL),
(38, 69, 12, 'orem ipsum dolor sit amet, consectetur adipiscing elit. Fusce venenatis arcu est. Phasellus vel dignissim tellus. Aenean fermentum fermentum convallis. Maecenas vitae ipsum sed risus viverra volutpat non ac sapien. Donec viverra massa at dolor imperdiet hendrerit. Nullam quis est vitae dui placerat posuere. Phasellus eget erat sit amet lacus semper consectetur. Sed a nisi nisi. Pellentesque hendrerit est id quam facilisis au', '281000-350000', '2016-04-13 18:36:52', NULL, 11, NULL, NULL),
(39, 70, 3, 'Just testing', '71000-80000', '2016-04-13 21:43:07', NULL, 2, NULL, NULL),
(40, 70, 12, 'lol', '5000-10000', '2016-04-13 22:25:07', NULL, 11, NULL, NULL),
(42, 75, 3, 'test', '36000-40000', '2016-04-15 15:29:26', NULL, 2, NULL, NULL),
(43, 76, 12, 'fghfghfghgfh', '5000-10000', '2016-04-15 17:37:18', NULL, 11, NULL, NULL),
(44, 78, 15, 'denemeee', '11000-15000', '2016-04-16 12:06:39', NULL, 14, NULL, NULL),
(45, 80, 4, 'test', '41000-50000', '2016-04-17 23:23:48', NULL, 3, NULL, NULL),
(46, 81, 3, 'ok', 'Trainee Stipend', '2016-04-18 15:36:42', NULL, 2, NULL, NULL),
(47, 81, 13, 'Test', '11000-15000', '2016-04-19 18:55:11', NULL, 12, NULL, NULL),
(48, 83, 13, 'rtytrryty', '31000-35000', '2016-04-20 08:56:47', NULL, 12, NULL, NULL),
(49, 84, 12, 'dfgdfgdfgd', '5000-10000', '2016-04-22 03:43:30', NULL, 11, NULL, NULL),
(51, 95, 14, 'test', '450000 or above', '2016-05-04 18:51:57', NULL, 13, NULL, NULL),
(52, 97, 15, 'as', '26000-30000', '2016-05-05 15:55:09', NULL, 14, NULL, NULL),
(53, 99, 15, 'wdeasdasd', '450000 or above', '2016-05-06 01:03:12', NULL, 14, NULL, NULL),
(54, 92, 12, 'hello', '5000-10000', '2016-05-07 17:30:16', NULL, 11, NULL, NULL),
(56, 105, 7, 'Test cover letter', '5000-10000', '2016-05-10 03:11:06', NULL, 6, NULL, NULL),
(57, 107, 14, 'nada', '11000-15000', '2016-05-12 07:35:53', NULL, 13, NULL, NULL),
(58, 108, 13, 'jhgbhbhj', '51000-60000', '2016-05-12 23:32:26', NULL, 12, NULL, NULL),
(59, 92, 15, 'hhh', '21000-25000', '2016-05-13 13:18:09', NULL, 14, NULL, NULL),
(61, 115, 15, 'testset', '11000-15000', '2016-05-16 17:18:04', NULL, 14, NULL, NULL),
(62, 116, 12, 'As Web designers plan, create and code web pages, using both non-technical and technical skills to produce websites that fit the customer\'s requirements.\nThey are involved in the technical and graphical aspects of pages, producing not just the look of the website, but determining how it works as well. Web designers might also be responsible for the maintenance of an existing site.\nThe term web developer is sometimes used interchangeably with web designer, but this can be confusing. Web developing is a more specialist role, focusing on the back-end development of a website and will incorporate, among other things, the creation of highly complex search functions.\nThe recent growth in touchscreen phones and tablet devices has dictated a new way of designing websites, with the web designer needing to ensure that web pages are responsive no matter what type of device a viewer is using. Therefore the need to test websites at different stages of design, on a variety of different devices, has become an important aspect of the job.', 'Trainee Stipend', '2016-05-16 17:25:54', NULL, 11, NULL, NULL),
(63, 117, 15, 'cascsacs', '5000-10000', '2016-05-16 22:52:56', NULL, 14, NULL, NULL),
(64, 41, 15, 'tes cover letter', 'Trainee Stipend', '2016-05-21 19:30:17', NULL, 14, NULL, NULL),
(65, 123, 14, '\'t\'g(', '5000-10000', '2016-05-22 12:41:41', NULL, 13, NULL, NULL),
(66, 123, 15, '(--g-g', '5000-10000', '2016-05-22 12:42:01', NULL, 14, NULL, NULL),
(68, 125, 15, 'sfsqafa', '5000-10000', '2016-05-24 17:36:38', NULL, 14, NULL, NULL),
(69, 126, 10, 'fff', '61000-70000', '2016-05-25 00:34:56', NULL, 9, NULL, NULL),
(70, 126, 4, 'rwy3', '16000-20000', '2016-05-25 00:37:00', NULL, 3, NULL, NULL),
(71, 41, 14, 'test', '5000-10000', '2016-05-25 15:18:35', NULL, 13, NULL, NULL),
(72, 128, 7, 'gfgfg', '11000-15000', '2016-05-26 00:23:22', NULL, 6, NULL, NULL),
(83, 143, 52, 'bbm,bnx', '5000-10000', '2019-03-02 17:22:13', NULL, 1, NULL, NULL),
(75, 130, 10, 'Hello', '16000-20000', '2016-05-28 23:03:02', NULL, 9, NULL, NULL),
(76, 132, 7, 'ssss', 'Trainee Stipend', '2016-06-01 03:42:04', NULL, 6, NULL, NULL),
(77, 132, 10, 'sadsadasd', '5000-10000', '2016-06-01 03:46:57', NULL, 9, NULL, NULL),
(78, 133, 14, 'gg', '36000-40000', '2016-06-02 13:03:45', NULL, 13, NULL, NULL),
(79, 133, 13, 'ggggggggg', 'Trainee Stipend', '2016-06-02 13:09:53', NULL, 12, NULL, NULL),
(80, 117, 7, 'qdwdwd', 'Trainee Stipend', '2016-06-02 16:07:45', NULL, 6, NULL, NULL),
(81, 92, 7, 'ggg', '11000-15000', '2016-06-03 12:43:32', NULL, 6, NULL, NULL),
(82, 142, 3, 'ufd', 'Trainee Stipend', '2016-06-15 14:13:27', NULL, 2, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pp_seeker_experience`
--

CREATE TABLE `pp_seeker_experience` (
  `ID` int(11) NOT NULL,
  `seeker_ID` int(11) DEFAULT NULL,
  `job_title` varchar(155) DEFAULT NULL,
  `company_name` varchar(155) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `city` varchar(40) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `responsibilities` text,
  `dated` datetime DEFAULT NULL,
  `flag` varchar(10) DEFAULT NULL,
  `old_id` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_seeker_experience`
--

INSERT INTO `pp_seeker_experience` (`ID`, `seeker_ID`, `job_title`, `company_name`, `start_date`, `end_date`, `city`, `country`, `responsibilities`, `dated`, `flag`, `old_id`) VALUES
(23, 1, 'IT specialist', 'Oracle', '2016-06-01', '2016-07-25', 'wari', 'Kenya', NULL, '2016-06-09 19:19:49', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pp_seeker_resumes`
--

CREATE TABLE `pp_seeker_resumes` (
  `ID` int(11) NOT NULL,
  `seeker_ID` int(11) DEFAULT NULL,
  `is_uploaded_resume` enum('no','yes') DEFAULT 'no',
  `file_name` varchar(155) DEFAULT NULL,
  `resume_name` varchar(40) DEFAULT NULL,
  `dated` datetime DEFAULT NULL,
  `is_default_resume` enum('no','yes') DEFAULT 'no'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_seeker_resumes`
--

INSERT INTO `pp_seeker_resumes` (`ID`, `seeker_ID`, `is_uploaded_resume`, `file_name`, `resume_name`, `dated`, `is_default_resume`) VALUES
(1, 8, 'yes', 'test-test-8.docx', NULL, '2016-03-12 01:44:43', 'no'),
(116, 143, 'yes', 'rebeccah-ndungi-143.docx', NULL, '2019-03-02 17:13:43', 'no');

-- --------------------------------------------------------

--
-- Table structure for table `pp_seeker_skills`
--

CREATE TABLE `pp_seeker_skills` (
  `ID` int(11) NOT NULL,
  `seeker_ID` int(11) DEFAULT NULL,
  `skill_name` varchar(155) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_seeker_skills`
--

INSERT INTO `pp_seeker_skills` (`ID`, `seeker_ID`, `skill_name`) VALUES
(1, 8, 'php'),
(313, 143, 'java'),
(312, 143, 'c++'),
(311, 143, 'php'),
(310, 8, 'oracle db'),
(309, 8, 'java');

-- --------------------------------------------------------

--
-- Table structure for table `pp_sessions`
--

CREATE TABLE `pp_sessions` (
  `session_id` varchar(40) NOT NULL DEFAULT '0',
  `ip_address` varchar(45) NOT NULL DEFAULT '0',
  `user_agent` varchar(120) NOT NULL,
  `last_activity` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `user_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_sessions`
--

INSERT INTO `pp_sessions` (`session_id`, `ip_address`, `user_agent`, `last_activity`, `user_data`) VALUES
('f4733ccb0548f0d8f074852333362a73', '::1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/72.0.3626.121 Chrome/72.0.3626.12', 1552134280, 'a:6:{s:8:\"admin_id\";s:1:\"1\";s:4:\"name\";s:5:\"admin\";s:14:\"is_admin_login\";b:1;s:10:\"user_email\";s:24:\"bobitnrb860418@spu.ac.ke\";s:10:\"first_name\";s:15:\"Rebeccah Ndungi\";s:23:\"flash:old:update_action\";b:1;}');

-- --------------------------------------------------------

--
-- Table structure for table `pp_settings`
--

CREATE TABLE `pp_settings` (
  `ID` int(11) NOT NULL,
  `emails_per_hour` int(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_settings`
--

INSERT INTO `pp_settings` (`ID`, `emails_per_hour`) VALUES
(1, 300);

-- --------------------------------------------------------

--
-- Table structure for table `pp_skills`
--

CREATE TABLE `pp_skills` (
  `ID` int(11) NOT NULL,
  `skill_name` varchar(40) DEFAULT NULL,
  `industry_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pp_skills`
--

INSERT INTO `pp_skills` (`ID`, `skill_name`, `industry_ID`) VALUES
(1, 'html', NULL),
(2, 'php', NULL),
(3, 'js', NULL),
(4, '.net', NULL),
(5, 'css', NULL),
(6, 'jquery', NULL),
(7, 'java', NULL),
(8, 'photoshop', NULL),
(9, 'illustrator', NULL),
(10, 'Indesign', NULL),
(11, 'mysql', NULL),
(12, 'Ms Office', NULL),
(13, 'Marketting', NULL),
(14, 'informática', NULL),
(15, 'web', NULL),
(16, 'indesing', NULL),
(17, 'developer', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pp_stories`
--

CREATE TABLE `pp_stories` (
  `ID` int(11) NOT NULL,
  `seeker_ID` int(11) NOT NULL,
  `is_featured` enum('yes','no') DEFAULT 'no',
  `sts` enum('active','inactive') DEFAULT 'inactive',
  `title` varchar(250) DEFAULT NULL,
  `story` text,
  `dated` datetime DEFAULT NULL,
  `ip_address` varchar(40) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_gallery`
--

CREATE TABLE `tbl_gallery` (
  `ID` int(11) NOT NULL,
  `image_caption` varchar(150) DEFAULT NULL,
  `image_name` varchar(155) DEFAULT NULL,
  `dated` datetime DEFAULT NULL,
  `sts` enum('inactive','active') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_gallery`
--

INSERT INTO `tbl_gallery` (`ID`, `image_caption`, `image_name`, `dated`, `sts`) VALUES
(1, 'Test', 'portfolio-2.jpg', '2015-09-05 18:16:41', 'active'),
(2, '', 'portfolio-1.jpg', '2015-09-05 21:17:59', 'active'),
(3, '', 'portfolio-3.jpg', '2015-09-05 21:22:19', 'active'),
(4, '', 'portfolio-6.jpg', '2015-09-05 21:22:29', 'active'),
(5, '', 'portfolio-7.jpg', '2015-09-05 21:22:38', 'active'),
(6, '', 'portfolio-8.jpg', '2015-09-05 21:22:53', 'active'),
(7, '', 'portfolio-9.jpg', '2015-09-05 21:23:05', 'active'),
(8, 'Walk with the Queen... But be careful!', 'portfolio-10.jpg', '2015-09-05 21:23:16', 'inactive'),
(9, 'Bla bla bla Bla bla bla Bla bla bla Bla bla bla Bla bla bla Bla bla bla Bla bla bla Bla bla bla Bla.', 'portfolio-11.jpg', '2015-09-05 21:23:24', 'active'),
(10, 'Beatuiful Bubble', 'portfolio-12.jpg', '2015-09-05 21:23:32', 'active');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `pp_admin`
--
ALTER TABLE `pp_admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pp_ad_codes`
--
ALTER TABLE `pp_ad_codes`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_cities`
--
ALTER TABLE `pp_cities`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_cms`
--
ALTER TABLE `pp_cms`
  ADD PRIMARY KEY (`pageID`);

--
-- Indexes for table `pp_cms_previous`
--
ALTER TABLE `pp_cms_previous`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_companies`
--
ALTER TABLE `pp_companies`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_countries`
--
ALTER TABLE `pp_countries`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_email_content`
--
ALTER TABLE `pp_email_content`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_employers`
--
ALTER TABLE `pp_employers`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_favourite_candidates`
--
ALTER TABLE `pp_favourite_candidates`
  ADD PRIMARY KEY (`employer_id`);

--
-- Indexes for table `pp_favourite_companies`
--
ALTER TABLE `pp_favourite_companies`
  ADD PRIMARY KEY (`seekerid`);

--
-- Indexes for table `pp_institute`
--
ALTER TABLE `pp_institute`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_job_alert`
--
ALTER TABLE `pp_job_alert`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_job_alert_queue`
--
ALTER TABLE `pp_job_alert_queue`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_job_functional_areas`
--
ALTER TABLE `pp_job_functional_areas`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_job_industries`
--
ALTER TABLE `pp_job_industries`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_job_seekers`
--
ALTER TABLE `pp_job_seekers`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_job_titles`
--
ALTER TABLE `pp_job_titles`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_newsletter`
--
ALTER TABLE `pp_newsletter`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_post_jobs`
--
ALTER TABLE `pp_post_jobs`
  ADD PRIMARY KEY (`ID`);
ALTER TABLE `pp_post_jobs` ADD FULLTEXT KEY `job_search` (`job_title`,`job_description`);

--
-- Indexes for table `pp_prohibited_keywords`
--
ALTER TABLE `pp_prohibited_keywords`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_qualifications`
--
ALTER TABLE `pp_qualifications`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_salaries`
--
ALTER TABLE `pp_salaries`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_scam`
--
ALTER TABLE `pp_scam`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_seeker_academic`
--
ALTER TABLE `pp_seeker_academic`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_seeker_additional_info`
--
ALTER TABLE `pp_seeker_additional_info`
  ADD PRIMARY KEY (`ID`);
ALTER TABLE `pp_seeker_additional_info` ADD FULLTEXT KEY `resume_search` (`summary`,`keywords`);

--
-- Indexes for table `pp_seeker_applied_for_job`
--
ALTER TABLE `pp_seeker_applied_for_job`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_seeker_experience`
--
ALTER TABLE `pp_seeker_experience`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_seeker_resumes`
--
ALTER TABLE `pp_seeker_resumes`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_seeker_skills`
--
ALTER TABLE `pp_seeker_skills`
  ADD PRIMARY KEY (`ID`);
ALTER TABLE `pp_seeker_skills` ADD FULLTEXT KEY `js_skill_search` (`skill_name`);

--
-- Indexes for table `pp_sessions`
--
ALTER TABLE `pp_sessions`
  ADD PRIMARY KEY (`session_id`),
  ADD KEY `last_activity_idx` (`last_activity`);

--
-- Indexes for table `pp_settings`
--
ALTER TABLE `pp_settings`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_skills`
--
ALTER TABLE `pp_skills`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `pp_stories`
--
ALTER TABLE `pp_stories`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `tbl_gallery`
--
ALTER TABLE `tbl_gallery`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `pp_admin`
--
ALTER TABLE `pp_admin`
  MODIFY `id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `pp_ad_codes`
--
ALTER TABLE `pp_ad_codes`
  MODIFY `ID` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `pp_cities`
--
ALTER TABLE `pp_cities`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `pp_cms`
--
ALTER TABLE `pp_cms`
  MODIFY `pageID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `pp_cms_previous`
--
ALTER TABLE `pp_cms_previous`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `pp_companies`
--
ALTER TABLE `pp_companies`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=82;

--
-- AUTO_INCREMENT for table `pp_countries`
--
ALTER TABLE `pp_countries`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `pp_email_content`
--
ALTER TABLE `pp_email_content`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `pp_employers`
--
ALTER TABLE `pp_employers`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=82;

--
-- AUTO_INCREMENT for table `pp_favourite_candidates`
--
ALTER TABLE `pp_favourite_candidates`
  MODIFY `employer_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pp_favourite_companies`
--
ALTER TABLE `pp_favourite_companies`
  MODIFY `seekerid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pp_institute`
--
ALTER TABLE `pp_institute`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `pp_job_alert`
--
ALTER TABLE `pp_job_alert`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pp_job_alert_queue`
--
ALTER TABLE `pp_job_alert_queue`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pp_job_functional_areas`
--
ALTER TABLE `pp_job_functional_areas`
  MODIFY `ID` int(7) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pp_job_industries`
--
ALTER TABLE `pp_job_industries`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `pp_job_seekers`
--
ALTER TABLE `pp_job_seekers`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=144;

--
-- AUTO_INCREMENT for table `pp_job_titles`
--
ALTER TABLE `pp_job_titles`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `pp_newsletter`
--
ALTER TABLE `pp_newsletter`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pp_post_jobs`
--
ALTER TABLE `pp_post_jobs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT for table `pp_prohibited_keywords`
--
ALTER TABLE `pp_prohibited_keywords`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `pp_qualifications`
--
ALTER TABLE `pp_qualifications`
  MODIFY `ID` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `pp_salaries`
--
ALTER TABLE `pp_salaries`
  MODIFY `ID` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `pp_scam`
--
ALTER TABLE `pp_scam`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pp_seeker_academic`
--
ALTER TABLE `pp_seeker_academic`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `pp_seeker_additional_info`
--
ALTER TABLE `pp_seeker_additional_info`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=115;

--
-- AUTO_INCREMENT for table `pp_seeker_applied_for_job`
--
ALTER TABLE `pp_seeker_applied_for_job`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;

--
-- AUTO_INCREMENT for table `pp_seeker_experience`
--
ALTER TABLE `pp_seeker_experience`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `pp_seeker_resumes`
--
ALTER TABLE `pp_seeker_resumes`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=117;

--
-- AUTO_INCREMENT for table `pp_seeker_skills`
--
ALTER TABLE `pp_seeker_skills`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=314;

--
-- AUTO_INCREMENT for table `pp_settings`
--
ALTER TABLE `pp_settings`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `pp_skills`
--
ALTER TABLE `pp_skills`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `pp_stories`
--
ALTER TABLE `pp_stories`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_gallery`
--
ALTER TABLE `tbl_gallery`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
