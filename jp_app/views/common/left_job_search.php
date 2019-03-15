<div class="col-md-3"> 
<div class="secondary">
    <!--Widget-->
    <div class="widget">
      <h4 class="widget-title">Job Title</h4>
      <ul class="nav nav-pills nav-stacked">
        <?php
		
		foreach($left_side_title as $row_titles):?>
        <li> <a href="<?php echo base_url('search-jobs/'.make_friendly_url($row_titles->job_title));?>"><span class="badge pull-right"><?php echo $row_titles->score;?></span><?php echo character_limiter($row_titles->job_title, 10);?></a> </li>
        <?php endforeach;?>
      </ul>
    </div>
    
    <!--Widget-->
    <div class="widget">
      <h4 class="widget-title"> City </h4>
      <ul class="nav nav-pills nav-stacked">
      <?php foreach($left_side_city as $row_city):?>
        <li> <a href="<?php echo base_url('search-jobs/'.str_replace(' ','-',trim($param)).'/'.make_friendly_url($row_city->city));?>"><span class="badge pull-right"><?php echo $row_city->score;?></span><?php echo character_limiter($row_city->city, 14);?></a> </li>
      <?php endforeach;?>
      </ul>
    </div>
    
    <!--Widget-->
    <div class="widget">
      <h4 class="widget-title">Top Companies</h4>
      <ul class="nav nav-pills nav-stacked">
      <?php foreach($left_side_company as $row_company):?>
        <li> <a href="<?php echo base_url('company/'.$row_company->company_slug);?>"><span class="badge pull-right"><?php echo $row_company->score;?></span><?php echo character_limiter($row_company->company_name, 14);?></a> </li>
      <?php endforeach;?>
      </ul>
    </div>
    
    <!--Widget-->
    <div class="widget">
      <h4 class="widget-title"> Salary Range </h4>
      <ul class="nav nav-pills nav-stacked">     
        <?php foreach($left_side_salary_range as $row_range): ?>
        <li> <a href="<?php echo base_url('search-jobs/'.$row_range->pay);?>"><span class="badge pull-right"><?php echo $row_range->score;?></span><?php echo character_limiter($row_range->pay, 14);?></a> </li>
      <?php endforeach;?>      
      </ul>
    </div>
    
</div>
</div>