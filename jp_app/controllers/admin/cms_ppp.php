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
		$data["total_rows"] = $total_rows;
		$this->load->view('admin/cms_view', $data);
		return;
	}
	
	public function add(){
		$data['title'] = SITE_NAME.': Content Management';
		$data['msg'] = '';
		
		$this->form_validation->set_rules('heading', 'Heading', 'trim|required');
		$this->form_validation->set_rules('page_slug', 'Page Slug', 'trim|required');
		$this->form_validation->set_rules('meta_title', 'Meta Title', 'trim|required|max_length[65]');
		$this->form_validation->set_rules('meta_keyword', 'Meta Keywords', 'trim|required');
		$this->form_validation->set_rules('meta_description', 'Meta Description', 'trim|required|max_length[150]');	
		$this->form_validation->set_rules('editor1', 'Page Content', 'trim|required');
		$this->form_validation->set_error_delimiters('<span class="err" style="padding-left:2px;">', '</span>');
		
		if ($this->form_validation->run() === FALSE) {
			//$this->index();
			$this->load->view('admin/cms_add_view',$data);
			return;
		}
		
		
		$page_slug = (stristr($this->input->post('page_slug'),'.html')?$this->input->post('page_slug'):$this->input->post('page_slug').'.html');
		$cms_array = array(
							'heading' => $this->input->post('heading'),
							'page_slug' => $page_slug,
							'meta_title' => $this->input->post('meta_title'),
							'meta_keyword' => $this->input->post('meta_keyword'),
							'meta_description' => $this->input->post('meta_description'),
							'content' => $this->input->post('editor1'),
							'parent_level' => $this->input->post('parent_level'),
							'dated' => date("Y-m-d H:i:s")
		);
		
		
		if (!empty($_FILES['image_file']['name'])){
			$real_path = realpath(APPPATH . '../public/uploads/');
			$config['upload_path'] = $real_path;
			$config['allowed_types'] = 'jpg|jpeg|png|gif';
			$config['overwrite'] = false;
			$config['max_size'] = 12000;
			$this->upload->initialize($config);
			if (!$this->upload->do_upload('image_file')){
				$data['msg'] = strip_tags($this->upload->display_errors());
				$this->load->view('admin/cms_add_view',$data);
				return;
			}
			
			$image = array('upload_data' => $this->upload->data());	
			$image_name = $image['upload_data']['file_name'];
			$thumb_config['image_library'] = 'gd2';
			$thumb_config['source_image']	= $real_path.'/'.$image_name;
			$thumb_config['new_image']	= $real_path.'/'.$image_name;
			$thumb_config['maintain_ratio'] = TRUE;
			$thumb_config['height']	= 200;
			$thumb_config['width']	 = 200;
			
			$this->image_lib->initialize($thumb_config);
			$this->image_lib->resize();
	
			$file_name = $image['upload_data']['file_name'];
			$cms_array['image_file'] = $file_name;
			
		}
		
		
		$this->cms_model->add($cms_array);
		$this->session->set_flashdata('added_action', true);
		redirect(base_url('admin/cms'));
	}
		
	public function update($id=''){
		
		if($id==''){
			redirect(base_url().'admin/cms','');
			exit;
		}
		$row = $this->cms_model->get_cms_by_id($id);
		$data['row']=$row ;
		
		$data['title'] = SITE_NAME.': Edit Page';
		$data['msg'] = '';
		
		$this->form_validation->set_rules('edit_heading', 'Heading', 'trim|required');
		$this->form_validation->set_rules('edit_page_slug', 'Page Slug', 'trim|required');
		$this->form_validation->set_rules('meta_title', 'Meta Title', 'trim|required');
		$this->form_validation->set_rules('meta_keyword', 'Meta Keywords', 'trim|required');
		$this->form_validation->set_rules('meta_description', 'Meta Description', 'trim|required');		
		$this->form_validation->set_rules('editor1', 'Page Content', 'trim|required');
		$this->form_validation->set_error_delimiters('<span class="err" style="padding-left:2px;">', '</span>');
		
		if ($this->form_validation->run() === FALSE) {
			//$this->index();
			$this->load->view('admin/cms_edit_view',$data);
			return;
		}
		
		$page_slug = (stristr($this->input->post('edit_page_slug'),'.html')?$this->input->post('edit_page_slug'):$this->input->post('edit_page_slug').'.html');
		
		$cms_array = array(
							'heading' => $this->input->post('edit_heading'),
							'page_slug' => $page_slug,
							'meta_title' => $this->input->post('meta_title'),
							'meta_keyword' => $this->input->post('meta_keyword'),
							'meta_description' => $this->input->post('meta_description'),
							'parent_level' => $this->input->post('parent_level'),
							'content' => $this->input->post('editor1')
		);
		
		
		if (!empty($_FILES['image_file']['name'])){
			$real_path = realpath(APPPATH . '../public/uploads/');
			$config['upload_path'] = $real_path;
			$config['allowed_types'] = 'jpg|jpeg|png|gif';
			$config['overwrite'] = false;
			$config['max_size'] = 12000;
			$this->upload->initialize($config);
			if (!$this->upload->do_upload('image_file')){
				$data['msg'] = strip_tags($this->upload->display_errors());
				$this->load->view('admin/cms_add_view',$data);
				return;
			}
			
			$image = array('upload_data' => $this->upload->data());	
			$image_name = $image['upload_data']['file_name'];
			$thumb_config['image_library'] = 'gd2';
			$thumb_config['source_image']	= $real_path.'/'.$image_name;
			$thumb_config['new_image']	= $real_path.'/'.$image_name;
			$thumb_config['maintain_ratio'] = TRUE;
			$thumb_config['height']	= 200;
			$thumb_config['width']	 = 200;
			
			$this->image_lib->initialize($thumb_config);
			$this->image_lib->resize();
	
			$file_name = $image['upload_data']['file_name'];
			$cms_array['image_file'] = $file_name;
			
		}
		
		
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