package Builder;
use strict;
use Database;
use Fcntl qw(:DEFAULT :flock);
require Display;
require Dateformat;
require CGI;
require Styles;
require Profiles;

my $q = new CGI;
my $style = new Styles;
my $disobj = new Display;

sub teaser{
	my $contents = shift;
	my $chars = shift;
	
	return substr($contents,0,$chars);
	
}

sub run{
	my @categories;
	if($q->param('categories')){
		@categories = $q->param('categories');
	}
	else{ @categories = @_}
	
	
	for my $category (@categories){
		my @profiles = split(",",$::settings{$category."_profiles"});
		for my $profile (@profiles){
			my $profileobj = new Profiles($profile);
			
			my $display_html;
			my $ready;
			tie (my %hash, 'Database', "data/$category", O_RDONLY, LOCK_SH) 
   			or die "Error connecting to database. data/$category";
	
		
			open(FILE,"styles/$profileobj->{style}.htm") or die "cannot open styles/$profileobj->{style}.htm" ;
			if ($::settings{'flocking'} eq 'On'){flock(FILE, LOCK_SH);}
			while(<FILE>){$display_html .= $_};
			close(FILE);
	
			open(FILE,"+>$profileobj->{file}") or die "cannot open $profileobj->{file}";								#The file to change
			if ($::settings{'flocking'} eq 'On'){flock(FILE, LOCK_EX);}
	
			my $sorting;
			
			if ($profileobj->{order} eq 'Newest first') { 
				if ($profileobj->{sorting} eq 'Quantity') {
					my $counter;
					for my $key (sort {$b <=> $a} keys %hash){
						$counter++;
						if ($counter <= $profileobj->{skip}){next}
						
						if ($counter > ($profileobj->{number} + $profileobj->{skip})){last}
						
						my $href = $hash{$key};
						my $dft = new Dateformat($profileobj->{dateprofile});
						my $date = $dft->output($key);
						my $temp_display_html = $display_html;
					
						for my $field (keys %$href){	
							my $field_value = $href->{$field};
							
							$temp_display_html =~ s/\[$field]/$field_value/g;
							$temp_display_html =~ s/\[Date]/$date/g;
							$temp_display_html =~ s/\[Id]/$key/g;
							$temp_display_html =~ s/\[Author]/$href->{author}/g;
							
							$temp_display_html =~ m/\[Teaser\|$field:(\d+)]/g;
							if ($1) {
								if (length($field_value) >$1){
									$field_value = substr($field_value,0,$1);
									$temp_display_html =~ s/\[Teaser\|$field:(\d+)]/$field_value\.\.\./g;
								}
								else {
									$temp_display_html =~ s/\[Teaser\|$field:(\d+)]/$field_value/g;
								}
							}
						}
						$ready .= qq~<a name="$key"></a>$temp_display_html~;										
					}
				}
				elsif ($profileobj->{sorting} eq 'Date'){
					my $counter;
					for my $key (sort {$b <=> $a} keys %hash){
						$counter++;
						if ($counter <= $profileobj->{skip}){next}
						
						if ($key < ( time - ($profileobj->{number} * 86400 ))){last}
						my $href = $hash{$key};
						my $dft = new Dateformat($profileobj->{dateprofile});
						my $date = $dft->output($key);
						my $temp_display_html = $display_html;
					
						for my $field (keys %$href){	
							my $field_value = $href->{$field};
							
							$temp_display_html =~ s/\[$field]/$field_value/g;
							$temp_display_html =~ s/\[Date]/$date/g;
							$temp_display_html =~ s/\[Id]/$key/g;
							$temp_display_html =~ s/\[Author]/$href->{author}/g;
							
							$temp_display_html =~ m/\[Teaser\|$field:(\d+)]/g;
							if ($1) {
								if (length($field_value) >$1){
									$field_value = substr($field_value,0,$1);
									$temp_display_html =~ s/\[Teaser\|$field:(\d+)]/$field_value\.\.\./g;
								}
								else {
									$temp_display_html =~ s/\[Teaser\|$field:(\d+)]/$field_value/g;
								}
							}
						}
						$ready .= qq~<a name="$key"></a>$temp_display_html~;
					}
				}
				else {die "Error in profile $profileobj->{name}"}
			}		
			elsif ($profileobj->{order} eq 'Oldest first') { 
				if ($profileobj->{sorting} eq 'Quantity') {
					my $counter;
					my $skipcounter;
					for my $key (sort {$a <=> $b} keys %hash){
						
						if ($counter < $profileobj->{number}){
							$skipcounter++;
							if ($skipcounter <= $profileobj->{skip}){next}
							my $href = $hash{$key};
							my $dft = new Dateformat($profileobj->{dateprofile});
							my $date = $dft->output($key);
							my $temp_display_html = $display_html;
					
							for my $field (keys %$href){	
								my $field_value = $href->{$field};
							
								$temp_display_html =~ s/\[$field]/$field_value/g;
								$temp_display_html =~ s/\[Date]/$date/g;
								$temp_display_html =~ s/\[Id]/$key/g;
								$temp_display_html =~ s/\[Author]/$href->{author}/g;
							
								$temp_display_html =~ m/\[Teaser\|$field:(\d+)]/g;
								if ($1) {
									if (length($field_value) >$1){
										$field_value = substr($field_value,0,$1);
										$temp_display_html =~ s/\[Teaser\|$field:(\d+)]/$field_value\.\.\./g;
									}
									else {
										$temp_display_html =~ s/\[Teaser\|$field:(\d+)]/$field_value/g;
									}
								}
							}
							$ready .= qq~<a name="$key"></a>$temp_display_html~;
							$counter++;
						}
					}
				}
				elsif ($profileobj->{sorting} eq 'Date'){ #why anyone would use this is beyond me :-)
					my $counter;
					for my $key (sort {$a <=> $b} keys %hash){
						$counter++;
						if ($counter <= $profileobj->{skip}){next}
						if ($key < ( time - ($profileobj->{number} * 86400 ))){last;}
						my $href = $hash{$key};
						my $dft = new Dateformat($profileobj->{dateprofile});
						my $date = $dft->output($key);
						my $temp_display_html = $display_html;
					
						for my $field (keys %$href){	
							my $field_value = $href->{$field};
							
							$temp_display_html =~ s/\[$field]/$field_value/g;
							$temp_display_html =~ s/\[Date]/$date/g;
							$temp_display_html =~ s/\[Id]/$key/g;
							$temp_display_html =~ s/\[Author]/$href->{author}/g;
							
							$temp_display_html =~ m/\[Teaser\|$field:(\d+)]/g;
							if ($1) {
								if (length($field_value) >$1){
									$field_value = substr($field_value,0,$1);
									$temp_display_html =~ s/\[Teaser\|$field:(\d+)]/$field_value\.\.\./g;
								}
								else {
									$temp_display_html =~ s/\[Teaser\|$field:(\d+)]/$field_value/g;
								}
							}
						}
						$ready .= qq~<a name="$key"></a>$temp_display_html~;
					}
				}
				else {die "Error in profile $profileobj->{name}"}
			}
			else {die "Error in profile $profileobj->{name}"}
			
			#$ready .= qq~<p><a href="http://news.sonicbarrier.net"><font size="2" color="green">Generated by ApexNews</font></a></p>~;
			print FILE $ready;
			undef $ready;
			close(FILE);
			untie %hash;
		
		}
	}
	
	
	$disobj->hdr("done");
	
	$disobj->ftr;
}

sub options{																		#"Post" form
	my @cats = split(",",$::settings{categories});
	if (scalar(@cats) == 1){run('default'); exit}
	if ($::settings{build_all} eq 'Yes') { run(split(',',$::settings{categories}));exit}
	
	$disobj->hdr('New post');
	
	print qq~ <script language="JAVASCRIPT">
	function set(n) 
	{
               temp = document.main.elements.length  ;
                 
               for (i=0; i < temp; i++)
	{   document.main.elements[i].checked=n;
	   }
	} 

	function Invers(){

	temp = document.main.elements.length ;
                 
	for (i=0; i < temp; i++){

          if(document.main.elements[i].checked == 1){document.main.elements[i].checked = 0;}
                else {document.main.elements[i].checked = 1}
               
              }

	}
	</script> ~;

	
	
	
	
	my @cats = split(",",$::settings{categories});
	
	require Form;
	my $form = new Form;
	print qq~<form action="apexnews.cgi" method="post" name="main">~;
	print $form->hidden("action","Build");
	print $form->checkbox("categories","Select the categories you want to build from. Each profile associated with that category will be used.",\@cats);
  	print qq~<br><center><INPUT name=button onclick=set(1) type=button value="Select All"> 
		<INPUT name=button onclick=Invers() type=button value=" Invert "> 
		<INPUT name=button onclick=set(0) type=button value=" Reset "> <br>
		<INPUT name="submit" value="Submit" type=submit>
		</form></center><br>~;
	
	$disobj->ftr;
  
}

1;