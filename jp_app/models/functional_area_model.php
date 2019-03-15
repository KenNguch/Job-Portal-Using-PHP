<?php
class Functional_Area_Model extends CI_Model {
    public function __construct() {
	   $this->load->database();
    }
    
	public function add_functional_area($data){
  
            $return = $this->db->insert('pp_job_functional_areas', $data);
            if ((bool) $return === TRUE) {
                return $this->db->insert_id();
            } else {
                return $return;
            }       
	}	
	
	public function update_functional_area($id, $data){
		$this->db->where('ID', $id);
		$return=$this->db->update('pp_job_functional_areas', $data);
		return $return;
	}
	
	public function delete_functional_area($id){
		$this->db->where('ID', $id);
		$this->db->delete('pp_job_functional_areas');
	}
	public function get_all_functional_areas() {
        $this->db->select('industry_name');
        $this->db->from('pp_job_functional_areas');
		$this->db->order_by("functional_area", "ASC");
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
	
	public function get_functional_area_by_id($id) {
        $this->db->select('*');
        $this->db->from('pp_job_functional_areas');
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
	
	public function get_functional_area_by_industry_id($industry_id) {
        $this->db->select('pp_job_functional_areas.*, pp_job_industries.industry_name');
        $this->db->from('pp_job_functional_areas');
		$this->db->join('pp_job_industries', 'pp_job_functional_areas.industry_ID = pp_job_industries.ID', 'inner');
		$this->db->where('ID', $industry_id);
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
