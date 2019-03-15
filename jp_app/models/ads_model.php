<?php
class Ads_Model extends CI_Model {
    public function __construct() {
	   $this->load->database();
    }
    /*
	public function add($data){
  
            $return = $this->db->insert('pp_ad_codes', $data);
            if ((bool) $return === TRUE) {
                return $this->db->insert_id();
            } else {
                return $return;
            }       
			
	}	
	*/
	public function update_ads($id, $data){
		$this->db->where('ID', $id);
		$return=$this->db->update('pp_ad_codes', $data);
		return $return;
	}
	
	public function update($id, $data){
		$this->db->where('ID', $id);
		$return=$this->db->update('pp_ad_codes', $data);
		return $return;
	}
	/*
	public function delete_ads($id){
		$this->db->where('ID', $id);
		$this->db->delete('pp_ad_codes');
	}
	*/
	public function get_ads() {
        $this->db->select('pp_ad_codes.*');
        $this->db->from('pp_ad_codes');
		$this->db->where('ID', '1');
        $Q = $this->db->get();
        if ($Q->num_rows > 0) {
            $return = $Q->row();
        } else {
            $return = 0;
        }
        $Q->free_result();
        return $return;
    }
	
	public function get_ads_by_id($id) {
        $this->db->select('pp_ad_codes.*');
        $this->db->from('pp_ad_codes');
		$this->db->where('ad_codes.ID', $id);
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
