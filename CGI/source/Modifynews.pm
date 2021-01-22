package Modifynews;
use strict;
use Database;
use Fcntl qw(:flock :DEFAULT);
require Display;
require CGI;
require Dateformat;

my $dft = new Dateformat('default');
my $q = new CGI;
my $disobj	= new Display;

sub display{																		#"Post" form
	my $invocant	= shift;
	my @cats = split(",",$::settings{categories});
	my $current_category;
	my $startpos = $q->param('page') || 0;
	
	if ($q->param('category')){$current_category = $q->param('category') }
	else { $current_category = "default" }
	
	
	
	die "Incorrect usage of Modifynews' display method." if @_ || $current_category eq '';
	tie my %hash, "Database", "data/$current_category", O_RDWR | O_CREAT , LOCK_EX or die "Can't connect to $_.db";
	
	$disobj->hdr("Modify news");
	
	print qq~
	
		<script>function gogo(){
		var valuestring=document.FORMNAME.SELECTBOXNAME.options[document.FORMNAME.SELECTBOXNAME.selectedIndex].value;
 		location.href=valuestring;}
		</script>
		<form action="apexnews.cgi" method="post">
		<input type="hidden" name="action" value="Change news">
		<center>
		<select onchange="top.location=this.options[this.selectedIndex].value">
		<option >Select a category here!</option>
	
	~;
	for (@cats){
		print qq~
			<option value='$::settings{full}/apexnews.cgi?action=Modify news;category=$_'>$_</option>
		~;
	}
				
	print qq~	
		</center>	
		<br><table bgcolor="black" width="98%" cellpadding="0" cellspacing="0" align="center"><tr><td>
	      <table width="100%" bgcolor="black" cellspacing="2" cellpadding="0" align="center" border="0">
	      <tr>
	      <td bgcolor="black" width="10">&nbsp</td>
	      <td bgcolor="black" width="50%"  >
	      <font color="white" face="verdana">Subject:</font>
	      </td><td bgcolor="black" width="50%" nowrap align="center">
	      <font color="white" face="verdana">Date:</font>
	      </td>
	      </tr>
	      <form action="admin.cgi" method="post">
	~;
	
	my $counter;          
	my $key;
	
	for $key (sort {$b <=> $a} keys %hash){		
		$counter++;
		if (($counter > $startpos ) && ($counter <= $startpos + 10)){
			my ($color1,$color2);
			if (($counter % 2) == 0) { 
				 $color1 = "#33cc33";  
				 $color2 = "#00ff00" ;
			}
			else { 
				$color1 = "#339933"; 
				$color2 = "black" ;
			}
			my $post = $hash{$key};
			my $date = $dft->output($key);
			my $teaser = $post->{'Subject'};
			
			if (length($teaser) > 38) { 
				$teaser = substr($teaser,0,38);
				$teaser .= "...";
			}
			print qq~
				<tr>
		         	<td bgcolor="$color1" align="left">
		         	<input type="radio" name="utvarp" value="$key-$current_category" align="middle">
		         	<td bgcolor="$color1">
	           		<font color="black" face="verdana"><b>$teaser</b>
	           		</td><td align="center" bgcolor="$color1" nowrap>
	           		<font color="white" face="verdana" >$date</td>
	           		</tr>
	           	~;       	
	   	}
	}
		
		 print qq~ 
		 	</table></td></tr></table><center>
            		<input type="submit" name="change" value="Delete">
            		<input type="submit" name="change" value="Modify">
            		</form>
            	~;
         
	my $pages;     
	if ($counter % 10 == 0){ $pages =  $counter / 10}
	else { $pages = $counter / 10 +1}
  
	unless ($pages  < 2 ){
		print "<br>Pages:";
		for (1..$pages){ 
   			my $startpos = ($_ - 1) * 10 ;
   			print qq~
   			<a href="$::settings{'full'}/apexnews.cgi?action=Modify news;category=$current_category;page=$startpos">$_</a> ~ 
   		}
   	}	
   		
   $disobj->ftr;
   untie %hash;
  
}


1;