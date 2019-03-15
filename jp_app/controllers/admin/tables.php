<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
class Tables extends CI_Controller {
	public function index(){
		
		$data['title'] = SITE_NAME.': Tables';
		$data['msg'] = '';
		$this->load->view('admin/tables_view', $data);
	}	
		
}
