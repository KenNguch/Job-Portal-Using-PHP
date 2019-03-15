<div class="footerWrap">
  <div class="container">
    <div class="col-md-3">
      <img src="<?php echo base_url('public/images/logo.png');?>" alt="Kenya jobs website" />
      <br><br>
      <p>Where jobs are not only dreams</p>

      <!--Social-->

        <div class="social">
        <a href="http://www.twitter.com" target="_blank"><i class="fa fa-twitter-square" aria-hidden="true"></i></a>
        <a href="http://www.plus.google.com" target="_blank"><i class="fa fa-google-plus-square" aria-hidden="true"></i></a>
        <a href="http://www.facebook.com" target="_blank"> <i class="fa fa-facebook-square" aria-hidden="true"></i></a>
        <a href="https://www.pinterest.com" target="_blank"><i class="fa fa-pinterest-square" aria-hidden="true"></i></a>
        <a href="https://www.youtube.com" target="_blank"><i class="fa fa-youtube-square" aria-hidden="true"></i></a>
        <a href="https://www.linkedin.com" target="_blank"><i class="fa fa-linkedin-square" aria-hidden="true"></i></a>
        </div>


    </div>
    <div class="col-md-2">
      <h5>Quick Links</h5>
      <ul class="quicklinks">
        <li><a href="<?php echo base_url('about-us.html');?>" title="About Us">About Us</a></li>
        <li><a href="<?php echo base_url('how-to-get-job.html');?>" title="How to get Job">How to get Job</a></li>
        <li><a href="<?php echo base_url('search-jobs');?>" title="New Job Openings">New Job Openings</a></li>
        <li><a href="<?php echo base_url('search-resume');?>" title="New Job Openings">Resume Search</a></li>
        <li><a href="<?php echo base_url('contact-us');?>" title="Contact Us">Contact Us</a></li>
      </ul>
    </div>

    <div class="col-md-3">
      <h5>Popular Industries</h5>
      <ul class="quicklinks">
        <?php
			$res_inds = $this->industries_model->get_top_industries();
			if($res_inds):
				foreach($res_inds as $row_inds):
		?>
        <li><a href="<?php echo base_url('industry/'.$row_inds->slug);?>" title="<?php echo $row_inds->industry_name;?> Jobs"><?php echo $row_inds->industry_name;?> Jobs</a></li>
        <?php

		  		endforeach;

		  	endif;

		  ?>
      </ul>
    </div>
    <div class="col-md-4">
      <h5>Popular Cities</h5>
      <ul class="citiesList">
        <li><a href="<?php echo base_url('search/nairobi');?>" title="Jobs in Nairobi">Nairobi </a></li>
        <li><a href="<?php echo base_url('search/limuru');?>" title="Jobs in Limuru">Limuru</a></li>
        <li><a href="<?php echo base_url('search/mombasa');?>" title="Jobs in Mombasa">Mombasa</a></li>
        <li><a href="<?php echo base_url('search/kiambu');?>" title="Jobs in Kiambu">Kiambu</a></li>
        <li><a href="<?php echo base_url('search/kisumu');?>" title="Jobs in Kisumu">Kisumu</a></li>
        <li><a href="<?php echo base_url('search/migori');?>" title="Jobs in Migori">Migori</a></li>
        <li><a href="<?php echo base_url('search/nakuru');?>" title="Jobs in Nakuru">Nakuru</a></li>
      <div class="clear"></div>
    </div>

    <div class="clear"></div>
    <div class="copyright">

      <div class="bttxt">Copyright <?php echo date('Y');?> </div>

    <div class="bttxt">Develop & Design by : Manaal Ventures</div>

    </div>
  </div>
</div>
</div>
