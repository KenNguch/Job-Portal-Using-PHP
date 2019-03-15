<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
class Cms extends CI_Controller {
	public function index(){
		$data['title'] = SITE_NAME.': Content Management';
		$data['msg'] = '';
		
		//Pagination starts
		$total_rows = $this->cms_model->record_count('pp_cms');
		$config = pagination_configuration(base_url("admin/cms"), $total_rows, 50, 3, 5, true);
		
		$this->pagination->initialize($config);
        $page = ($this->uri->segment(2)) ? $this->uri->segment(3) : 0;
		$page_num = $page-1;
		$page_num = ($page_num<0)?'0':$page_num;
		$page = $page_num*$config["per_page"];
		$data["links"] = $this->pagination->create_links();
		//Pagination ends
		
		$obj_result = $this->cms_model->get_all_records($config["per_page"], $page);
		$data['result'] = $obj_result;
		$this->load->view('admin/cms_view', $data);
		return;
	}
	
	public function get_cms_by_id($id=''){
		if($id!=''){
			$row = $this->cms_model->get_cms_by_id($id);
			$json_data = json_encode($row);
			echo $json_data;
			exit;
		}
		return;
	}
	public function add(){
		$data['title'] = SITE_NAME.': Content Management';
		$data['msg'] = '';
		
		$this->form_validation->set_rules('heading', 'Heading', 'trim|required');
		$this->form_validation->set_rules('page_slug', 'Page Slug', 'trim|required');	
		$this->form_validation->set_rules('editor1', 'Page Content', 'trim|required');
		$this->form_validation->set_error_delimiters('<span class="err" style="padding-left:2px;">', '</span>');
		
		if ($this->form_validation->run() === FALSE) {
			$this->index();
			return;
		}
		
		$cms_array = array(
							'heading' => $this->input->post('heading'),
							'page_slug' => $this->input->post('page_slug'),
							'content' => $this->input->post('editor1'),
							'dated' => date("Y-m-d H:i:s")
		);
		$this->cms_model->add($cms_array);
		$this->session->set_flashdata('added_action', true);
		redirect(base_url('admin/cms'));
	}
		
	public function update(){
		
		$id = $this->input->post('cms_id');
		if($id==''){
			redirect(base_url().'admin/cms','');
			exit;
		}
		
		$data['title'] = SITE_NAME.': Edit Page';
		$data['msg'] = '';
		
		$this->form_validation->set_rules('edit_heading', 'Heading', 'trim|required');
		$this->form_validation->set_rules('edit_page_slug', 'Page Slug', 'trim|required');	
		$this->form_validation->set_rules('edit_editor1', 'Page Content', 'trim|required');
		$this->form_validation->set_error_delimiters('<span class="err" style="padding-left:2px;">', '</span>');
		
		if ($this->form_validation->run() === FALSE) {
			$this->index();
			return;
		}
		
		$cms_array = array(
							'heading' => $this->input->post('edit_heading'),
							'page_slug' => $this->input->post('edit_page_slug'),
							'content' => $this->input->post('edit_editor1')
		);
		$this->cms_model->update($id, $cms_array);
		$this->session->set_flashdata('update_action', true);
		redirect(base_url('admin/cms'));
		return;
	}
	
	public function status($id='', $current_staus=''){
		
		if($id==''){
			echo 'error';
			exit;
		}
		if($current_staus==''){
			echo 'invalid current status provided.';
			exit;
		}
		
		if($current_staus=='active')
			$new_status= 'blocked';
		else
			$new_status= 'active';
		
		$data = array (
						'sts' => $new_status
		);
		
		$this->cms_model->update($id, $data);
		echo $new_status;
		exit;
	}	
	
	public function delete($id=''){
		
		if($id==''){
			echo 'error';
			exit;
		}
		
		$obj_row = $this->cms_model->delete($id);
		echo 'done';
		exit;
	}
}