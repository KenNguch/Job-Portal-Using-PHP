<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><?php echo $title;?></title>
<?php $this->load->view('admin/common/meta_tags'); ?>
<?php $this->load->view('admin/common/before_head_close'); ?>
<style type="text/css">
.awesome_style{
	font-size:100px;
}
</style>
</head>
<body class="skin-blue">
<?php $this->load->view('admin/common/after_body_open'); ?>
<?php $this->load->view('admin/common/header'); ?>
<div class="wrapper row-offcanvas row-offcanvas-left"> 
	<?php $this->load->view('admin/common/left_side'); ?>
  <!-- Right side column. Contains the navbar and content of the page -->
  <aside class="right-side"> 
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1> Dashboard</h1></section>
    
    <!-- Main content -->
    <section class="content">
     <table width="100%" border="0" align="left">
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td width="19%" align="center"><a href="<?php echo base_url('admin/employers');?>"><i class="fa awesome_style fa-briefcase"></i><br>
                Employers</a></td>
                <td width="19%" align="center"><a href="<?php echo base_url('admin/job_seekers');?>"><i class="fa awesome_style awesome_style fa-user"></i><br>
                  Jobseeker</a></td>
                <td width="19%" align="center"><a href="<?php echo base_url('admin/posted_jobs');?>"><i class="fa awesome_style fa-upload"></i> <br>
                  Posted Jobs</a></td>
                <td width="19%" align="center"><a href="<?php echo base_url('admin/posted_jobs');?>"><i class="fa fa-clipboard awesome_style"></i><br>
                  Featured Jobs</a></td>
                <td width="19%" align="center"><a href="<?php echo base_url('admin/pages');?>"><i class="fa awesome_style fa-file-text"></i><br>
                  Content Management</a></td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td><a href="<?php echo base_url().'admin/profiles_lists';?>"></a></td>
              </tr>
              <tr>
                <td align="center"><a href="<?php echo base_url('admin/stories');?>"><i class="fa awesome_style fa-thumbs-up"></i><br>
Success Stories</a></td>
                <td align="center"><a href="<?php echo base_url('admin/invite_employer');?>"><i class="fa awesome_style fa-envelope"></i><br>
                  Invite Employer</a></td>
                <td align="center"><a href="<?php echo base_url('admin/invite_jobseeker');?>"><i class="fa awesome_style fa-users"></i> <br>
                  Invite Jobseeker</a></td>
                <td align="center"><a href="<?php echo base_url('admin/email_template');?>"><i class="fa fa-envelope awesome_style"></i><br>
                  Email Templates</a></td>
                <td align="center"><a href="<?php echo base_url('admin/ads');?>"><i class="fa awesome_style fa-bullhorn"></i><br>
Ads</a></td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td align="center"><a href="<?php echo base_url('admin/industries');?>"><i class="fa fa-desktop awesome_style"></i><br>
                  Job Industries</a></td>
                <td align="center"><a href="<?php echo base_url('admin/institute');?>"><i class="fa awesome_style fa-university"></i><br>
                  Institute</a></td>
                <td align="center"><a href="<?php echo base_url('admin/salary');?>"><i class="fa awesome_style fa-money"></i> <br>
                  Salary</a></td>
                <td align="center"><a href="<?php echo base_url('admin/qualification');?>"><i class="fa  awesome_style fa-graduation-cap">&nbsp;</i><br>
               Qualification</a></td>
                <td align="center"><a href="<?php echo base_url('admin/prohibited_keyword');?>"><i class="fa awesome_style fa-tags"></i><br>
Manage Prohibited Keywords</a></td>
              </tr>
              <tr>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
              </tr>
              <tr>
                <td align="center"><a href="<?php echo base_url('admin/skills');?>"><i class="fa awesome_style fa-tags"></i><br>
Manage Skills</a></td>
                <td align="center"><a href="<?php echo base_url('admin/manage_newsletters');?>"><i class="fa fa-envelope awesome_style"></i><br>
                  Manage Newsletters</a></td>
                <td align="center"><a href="<?php echo base_url('admin/job_alert_queue');?>"><i class="fa fa-envelope awesome_style"></i><br>
                  Job Alert Queue</a></td>
                <td align="center"></td>
                <td align="center"></td>
              </tr>
              <tr>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
              </tr>
            </table>
    </section>
    <!-- /.content --> 
  </aside>
  <!-- /.right-side --> 
<?php $this->load->view('admin/common/footer'); ?>