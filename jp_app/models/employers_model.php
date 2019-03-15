<?php
class Employers_Model extends CI_Model {
    public function __construct() {
	   $this->load->database();
    }
    
	public function add_employer($data){
  
            $return = $this->db->insert('pp_employers', $data);
            if ((bool) $return === TRUE) {
                return $this->db->insert_id();
            } else {
                return $return;
            }       
			
	}	
	
	public function update_employer($id, $data){
		$this->db->where('ID', $id);
		$return=$this->db->update('pp_employers', $data);
		return $return;
	}
	
	public function update($id, $data){
		$this->db->where('ID', $id);
		$return=$this->db->update('pp_employers', $data);
		return $return;
	}
	
	public function delete_employer($id){
		$this->db->where('ID', $id);
		$this->db->delete('pp_employers');
	}
	
	public function authenticate_employer($user_name, $password) {
        $this->db->select('pp_employers.*, pp_companies.company_slug');
        $this->db->from('pp_employers');
		$this->db->join('pp_companies', 'pp_employers.company_ID = pp_companies.ID', 'inner');
        $this->db->where('email', $user_name);
		$this->db->where('pass_code', $password);
		$this->db->limit(1);
        $Q = $this->db->get();
        if ($Q->num_rows > 0) {
            $return = $Q->row();
        } else {
            $return = 0;
        }
        $Q->free_result();
        return $return;
    }
	
	public function authenticate_employer_by_email($user_name) {
        $this->db->select('pp_employers.*');
        $this->db->from('pp_employers');
        $this->db->where('email', $user_name);
		$this->db->limit(1);
        $Q = $this->db->get();
        if ($Q->num_rows > 0) {
            $return = $Q->row();
        } else {
            $return = 0;
        }
        $Q->free_result();
        return $return;
    }
	
	public function authenticate_employer_by_password($ID, $password) {
        $this->db->select('*');
        $this->db->from('pp_employers');
        $this->db->where('ID', $ID);
		$this->db->where('pass_code', $password);
		$this->db->limit(1);
        $Q = $this->db->get();
        if ($Q->num_rows > 0) {
            $return = $Q->row();
        } else {
            $return = 0;
        }
        $Q->free_result();
        return $return;
    }
	
	public function is_email_already_exists($ID, $email) {
        $this->db->select('ID');
        $this->db->from('pp_employers');
        $this->db->where('ID !=', $ID);
		$this->db->where('email', $email);
		$this->db->limit(1);
        $Q = $this->db->get();
        if ($Q->num_rows > 0) {
            $return = $Q->row('ID');
        } else {
            $return = 0;
        }
        $Q->free_result();
        return $return;
    }
	
	
	public function get_all_employers($per_page, $page) {
        $this->db->select('pp_employers.ID, pp_employers.dated, pp_employers.email, pp_employers.first_name, pp_employers.last_name, pp_employers.company_ID, pp_employers.sts, pp_employers.city, pp_employers.country, pp_employers.top_employer, pp_employers.ip_address, pp_companies.ID AS CID, pp_companies.company_name, pp_companies.company_logo, pp_companies.company_phone, pp_companies.company_location, pp_companies.company_slug');
        $this->db->from('pp_employers');
		$this->db->join('pp_companies', 'pp_employers.company_ID = pp_companies.ID', 'left');
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
	
	public function get_employer_by_id($id) {
        $this->db->select('pp_employers.*, pp_companies.ID AS CID,pp_companies.company_name,pp_companies.company_email,pp_companies.ownership_type,pp_companies.company_ceo,pp_companies.industry_ID,pp_companies.ownership_type,pp_companies.company_description,pp_companies.company_location,pp_companies.no_of_offices,pp_companies.company_website,pp_companies.no_of_employees, pp_companies.established_in, pp_companies.company_logo, pp_companies.company_folder, pp_companies.company_type, pp_companies.company_fax, pp_companies.company_slug, pp_companies.company_phone, pp_job_industries.industry_name');
        $this->db->from('pp_employers');
		$this->db->join('pp_companies', 'pp_employers.company_ID = pp_companies.ID', 'inner');
		$this->db->join('pp_job_industries', 'pp_companies.industry_ID = pp_job_industries.ID', 'left');
		$this->db->where('pp_employers.ID', $id);
        $Q = $this->db->get();
        if ($Q->num_rows > 0) {
            $return = $Q->row();
        } else {
            $return = 0;
        }
        $Q->free_result();
        return $return;
    }
	
	public function get_employer_by_id_simple($id) {
        $this->db->select('pp_employers.*');
        $this->db->from('pp_employers');
		$this->db->where('pp_employers.ID', $id);
        $Q = $this->db->get();
        if ($Q->num_rows > 0) {
            $return = $Q->row();
        } else {
            $return = 0;
        }
        $Q->free_result();
        return $return;
    }
	
	public function get_employer_by_company_id($cid) {
        $this->db->select('pp_employers.*, pp_companies.ID AS CID,pp_companies.company_name,pp_companies.company_email,pp_companies.company_ceo,pp_companies.industry_ID,pp_companies.ownership_type,pp_companies.company_description,pp_companies.company_location,pp_companies.no_of_offices,pp_companies.company_website,pp_companies.no_of_employees, pp_companies.established_in, pp_companies.company_logo, pp_companies.company_folder, pp_companies.company_type, pp_companies.company_fax, pp_companies.company_phone');
        $this->db->from('pp_employers');
		$this->db->join('pp_companies', 'pp_employers.company_ID = pp_companies.ID', 'left');
		$this->db->where('pp_employers.company_ID', $cid);
        $Q = $this->db->get();
        if ($Q->num_rows > 0) {
            $return = $Q->row();
        } else {
            $return = 0;
        }
        $Q->free_result();
        return $return;
    }
	
//====== Searching Employers =======	
	public function search_all_employers($per_page, $page, $search_parameters, $wild_card='') {
		
		$where = ($wild_card=='yes')?'where':'like';
        $this->db->select('pp_employers.ID, pp_employers.dated, pp_employers.email, pp_employers.first_name, pp_employers.last_name, pp_employers.company_ID, pp_employers.sts, pp_employers.top_employer, pp_companies.ID AS CID, pp_companies.company_name, pp_companies.company_logo');
        $this->db->from('pp_employers');
		$this->db->join('pp_companies', 'pp_employers.company_ID = pp_companies.ID', 'inner');
		$this->db->$where($search_parameters);
		$this->db->order_by("pp_employers.ID", "DESC"); 
		$this->db->limit($per_page, $page);
        $Q = $this->db->get();
        if ($Q->num_rows > 0) {
            $return = $Q->result();
        } else {
            $return = 0;
        }
        $Q->free_result();
		//echo $this->db->last_query(); exit;
        return $return;
    }
	
	public function search_record_count($table_name, $search_parameters) {
		//return $this->db->count_all($table_name);
		$this->db->like($search_parameters);
		$this->db->from($table_name);
		$this->db->join('pp_companies', 'pp_employers.company_ID = pp_companies.ID', 'left');
		return $this->db->count_all_results();
		//exit;
    }
//====== Specifically front end methods =======	
	public function get_all_active_employers($per_page, $page) {
        $Q = $this->db->query("CALL get_all_active_employers($page, $per_page)");
        if ($Q->num_rows > 0) {
            $return = $Q->result();
        } else {
            $return = 0;
        }
		$Q->next_result();
        $Q->free_result();
        return $return;
    }	
	
	public function get_all_active_top_employers($per_page, $page) {
        $Q = $this->db->query("CALL get_all_active_top_employers($page, $per_page)");
        if ($Q->num_rows > 0) {
            $return = $Q->result();
        } else {
            $return = 0;
        }
		$Q->next_result();
        $Q->free_result();
        return $return;
    }
	
	
	public function get_company_details_by_slug($slug) {
        $Q = $this->db->query('CALL get_company_by_slug("'.$slug.'")');
        if ($Q->num_rows > 0) {
            $return = $Q->row();
        } else {
            $return = 0;
        }
		$Q->next_result();
        $Q->free_result();
        return $return;
    }	
}
?>
