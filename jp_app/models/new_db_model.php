<?php
class New_Db_Model extends CI_Model {
	
	private $table_name = 'pp_post_jobs';
	
    public function __construct() {
	   $this->load->database();
    }
    
	public function add($data){
            $return = $this->db->insert($this->table_name, $data);
            if ((bool) $return === TRUE) {
                return $this->db->insert_id();
            } else {
                return $return;
            }       
			
	}	
	
	public function add_company($data){
  
            $return = $this->db->insert('pp_companies', $data);
            if ((bool) $return === TRUE) {
                return $this->db->insert_id();
            } else {
                return $return;
            }       
			
	}
	
	public function update($id, $data){
		$this->db->where('ID', $id);
		$return=$this->db->update($this->table_name, $data);
		return $return;
	}
	
	public function delete($id){
		$this->db->where('ID', $id);
		$this->db->delete($this->table_name);
	}
	
	public function get_all_records() {
        $this->db->select('*');
        $this->db->from($this->table_name);
		$this->db->order_by("ID", "ASC");
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
	
	public function get_records_by_id($id) {
        $this->db->select('*');
        $this->db->from($this->table_name);
		$this->db->where('ID', $id);
        $Q = $this->db->get();
        if ($Q->num_rows > 0) {
            $return = $Q->row();
        } else {
            $return = 0;
        }
        $Q->free_result();
        return $return;
    }
	
	public function get_records_by_company_name($company_name) {
        $this->db->select('ID');
        $this->db->from('pp_companies');
		$this->db->where('company_name', $company_name);
        $Q = $this->db->get();
        if ($Q->num_rows > 0) {
            $return = $Q->row('ID');
        } else {
            $return = 0;
        }
        $Q->free_result();
        return $return;
    }
	
	public function get_records_by_cid($id) {
        $this->db->select('*');
        $this->db->from('pp_companies');
		$this->db->where('ID', $id);
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
        $this->db->select('ID');
        $this->db->from('pp_employers');
		$this->db->where('company_ID', $cid);
        $Q = $this->db->get();
        if ($Q->num_rows > 0) {
            $return = $Q->row('ID');
        } else {
            $return = 0;
        }
        $Q->free_result();
        return $return;
    }
	
	public function get_industry_by_name($name) {
        $this->db->select('ID');
        $this->db->from('pp_job_industries');
		$this->db->where('industry_name', $name);
        $Q = $this->db->get();
        if ($Q->num_rows > 0) {
            $return = $Q->row('ID');
        } else {
            $return = 0;
        }
        $Q->free_result();
        return $return;
    }
	
}