<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');
/*
| -------------------------------------------------------------------------
| URI ROUTING
| -------------------------------------------------------------------------
| This file lets you re-map URI requests to specific controller functions.
|
| Typically there is a one-to-one relationship between a URL string
| and its corresponding controller class/method. The segments in a
| URL normally follow this pattern:
|
|	example.com/class/method/id/
|
| In some instances, however, you may want to remap this relationship
| so that a different class/function is called than the one
| corresponding to the URL.
|
| Please see the user guide for complete details:
|
|	http://codeigniter.com/user_guide/general/routing.html
|
| -------------------------------------------------------------------------
| RESERVED ROUTES
| -------------------------------------------------------------------------
|
| There area two reserved routes:
|
|	$route['default_controller'] = 'welcome';
|
| This route indicates which controller class should be loaded if the
| URI contains no data. In the above example, the "welcome" class
| would be loaded.
|
|	$route['404_override'] = 'errors/page_missing';
|
| This route will tell the Router what URI segments to use if those provided
| in the URL cannot be matched to a valid route.
|
*/
$route['default_controller'] = "home";
$route['404_override'] = '';
//Frontend
$route['company/(:any)'] = 'company/index/$1';
$route['jobs/(:any)'] = 'job_details/index/$1';
$route['job_listing/(:any)'] = 'job_listing/index/$1';
$route['(:any).html'] = 'content/index/$1';
$route['login'] = 'user/login/$1';
$route['logout'] = 'user/logout/$1';
$route['forgot'] = 'user/forgot/$1';
$route['search-jobs'] = 'job_search/index/$1';
$route['search-jobs/(:any)'] = 'job_search/index/$1';
$route['search-resume'] = 'resume_search/index/$1';
$route['search-resume/(:any)'] = 'resume_search/index/$1';
$route['search/(:any)'] = 'search/index/$1';
$route['candidate/(:any)'] = 'candidate/index/$1';
$route['industry/(:any)'] = 'industry/index/$1';
$route['employer-signup'] = 'employer_signup';
$route['jobseeker-signup'] = 'jobseeker_signup';
$route['contact-us'] = 'contact_us';
//Employer Section
$route['employer/job_applications/(:any)'] 	= 'employer/job_applications/index/$1';
$route['employer/job_applications/send_message_to_candidate'] 	= 'employer/job_applications/send_message_to_candidate/$1';
$route['employer/my_posted_jobs/(:any)'] 	= 'employer/my_posted_jobs/index/$1';
$route['employer/edit_posted_job/(:num)'] 	= 'employer/edit_posted_job/index/$1';
//Backend
$route['admin/employers/(:num)'] 	= 'admin/employers/index/$1';
$route['admin/job_seekers/(:num)'] = 'admin/job_seekers/index/$1';
$route['admin/posted_jobs/(:num)'] = 'admin/posted_jobs/index/$1';

/* End of file routes.php */
/* Location: ./application/config/routes.php */