<?php
class Scam_Model extends CI_Model {
	
	private $table_name = 'pp_scam';
	
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
	
	public function update($id, $data){
		$this->db->where('ID', $id);
		$return=$this->db->update($this->table_name, $data);
		return $return;
	}
	
	public function delete($id){
		$this->db->where('ID', $id);
		$this->db->delete($this->table_name);
	}
	
	public function get_record_by_id($id) {
        $this->db->select('*');
        $this->db->from($this->table_name);
		$this->db->where('ID', $id);
        $Q = $this->db->get();
        if ($Q->num_rows > 0) {
            $return = $Q->row_array();
        } else {
            $return = 0;
        }
        $Q->free_result();
        return $return;
    }
	
	public function get_all_records() {
        $this->db->select('*');
        $this->db->from($this->table_name);
		$this->db->order_by("ID", "DESC");
        $Q = $this->db->get();
        if ($Q->num_rows > 0) {
            $return = $Q->result();
        } else {
            $return = 0;
        }
        $Q->free_result();
        return $return;
    }
	
	public function get_scam_records() {
        $this->db->select('pp_scam.reason, pp_scam.job_ID, pp_job_seekers.first_name, pp_job_seekers.email');
        $this->db->from($this->table_name);
		$this->db->join('pp_job_seekers', 'pp_job_seekers.ID = pp_scam.user_ID', 'inner');
        $Q = $this->db->get();
        if ($Q->num_rows > 0) {
            $return = $Q->result();
        } else {
            $return = 0;
        }
        $Q->free_result();
        return $return;
    }
	
	public function record_count($tablename, $where=''){
	
		if($where!='')
			$this->db->where($where);
		$this->db->from($tablename);
		return $this->db->count_all_results();
	}
	
}
?>
