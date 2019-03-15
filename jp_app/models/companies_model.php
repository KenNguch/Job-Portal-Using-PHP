<?php
class Companies_Model extends CI_Model {
    public function __construct() {
	   $this->load->database();
    }
    
	public function add_company($data){
  
            $return = $this->db->insert('pp_companies', $data);
            if ((bool) $return === TRUE) {
                return $this->db->insert_id();
            } else {
                return $return;
            }       
			
	}	
	
	public function update_company($id, $data){
		$this->db->where('ID', $id);
		$return=$this->db->update('pp_companies', $data);
		return $return;
	}
	
	public function delete_company($id){
		$this->db->where('ID', $id);
		$this->db->delete('pp_companies');
		return true;
	}
	
	
	
	/*public function get_all_companies($per_page, $page) {
        $this->db->select('pp_companies.*');
        $this->db->from('pp_companies');
		$this->db->order_by("pp_companies.ID", "DESC"); 
		$this->db->limit($per_page, $page);
        $Q = $this->db->get();
        if ($Q->num_rows > 0) {
            $return = $Q->result();
        } else {
            $return = 0;
        }
        $Q->free_result();
        return $return;
    }*/
	
	public function get_all_companies($per_page, $page) {
        $this->db->select('pp_employers.ID, pp_employers.dated, pp_employers.email, pp_employers.first_name, pp_employers.last_name, pp_employers.company_ID, pp_employers.sts, pp_companies.ID AS CID, pp_companies.company_name, pp_companies.company_phone, pp_companies.company_website, pp_companies.industry_ID, pp_companies.company_logo');
        $this->db->from('pp_companies');
		$this->db->join('pp_employers', 'pp_employers.company_ID = pp_companies.ID', 'inner');
		$this->db->order_by("pp_employers.ID", "DESC"); 
		$this->db->limit($per_page, $page);
        $Q = $this->db->get();
        if ($Q->num_rows > 0) {
            $return = $Q->result();
        } else {
            $return = 0;
        }
        $Q->free_result();
        return $return;
    }
	
	public function record_count($table_name) {
		return $this->db->count_all($table_name);
    }
	
	public function get_company_by_id($id) {
        $this->db->select('pp_companies.*');
        $this->db->from('pp_companies');
		$this->db->where('pp_companies.ID', $id);
        $Q = $this->db->get();
        if ($Q->num_rows > 0) {
            $return = $Q->row();
        } else {
            $return = 0;
        }
        $Q->free_result();
        return $return;
    }
	
	public function check_slug($slug) {
		
		$this->db->where('company_slug', $slug);
		$this->db->from('pp_companies');
		return $this->db->count_all_results();
    }
	
	public function check_slug_edit($CID, $slug) {
		
		$this->db->where('company_slug', $slug);
		$this->db->where('ID !=', $CID);
		$this->db->from('pp_companies');
		return $this->db->count_all_results();
    }
	
	
	
	public function get_company_by_old_id($id) {
        $this->db->select('pp_companies.*');
        $this->db->from('pp_companies');
		$this->db->where('pp_companies.old_company_id', $id);
        $Q = $this->db->get();
        if ($Q->num_rows > 0) {
            $return = $Q->row();
        } else {
            $return = 0;
        }
        $Q->free_result();
        return $return;
    }
	
	
}
?>
