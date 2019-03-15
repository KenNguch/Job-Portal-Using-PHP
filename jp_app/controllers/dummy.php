<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
class Dummy extends CI_Controller {
	public function index()
	{
		
		//Jobs by company
		$result_posted_jobs = $this->posted_jobs_model->get_all_posted_jobs(4000, 0);
		
		foreach($result_posted_jobs as $row){
			/*$job_url = $row->company_slug.'-jobs-in-';
			
			$final_job_url ='';
			$job_title = trim($row->job_title);
			$string1 = preg_replace('/[^a-zA-Z0-9 ]/s', '', $job_title);
			$job_title_slug = strtolower(preg_replace('/\s+/', '-', $string1));
  
			$job_url_postfix = strtolower($row->city).'-'.$job_title_slug.'-'.$row->ID;
			$final_job_url = $job_url.$job_url_postfix;
			
			$this->posted_jobs_model->update_posted_job($row->ID, array('job_slug' => $final_job_url));			*/
		}
		
		
	}
}
