package Misc;
use strict;
require CGI;
require Display;

my $q = new CGI;
my $disobj = new Display;

sub Mainpage{
	my  @main_index = (
	"Post news:The form for submitting news",
	"Settings:Change profiles and other preferences.",
	"Builder:Update contents on web",
	"Modify news:Modify contents of news");
	
	$disobj->hdr("Welcome to the front page $::user");
	
	
	
	
	if (-e "setup.cgi") {print "<center><font color=red>WARNING</font>: <b>Setup file still on server. Remove it immediately!</b></center>"}
	make_index(@main_index);
	
		
	$disobj->ftr;


}

##############################################





sub Settingspage{
	my @settings_index = (
	"General settings:Main settings menu",
	"Change news form:Change the news form",
	"Edit date profiles:Change the date format",
	"Edit styles:Output display properties",
	"Edit profiles:Modify settings for each category",
	"Edit categories:Add/remove posting categories",
	"Edit users:Edit user accounts");
	
	$disobj->hdr("Settings");
	make_index(@settings_index);
	$disobj->ftr;


}

##############################################


sub Logout{
	my $cookie = $q->cookie(-name => 'userpass', -value => '', -expires => 'Thu, 25-Apr-1999 00:40:33 GMT');
	print $q->header(-cookie => "$cookie");
	print qq~<a href="$::settings{'full'}/apexnews.cgi">CLICK HERE TO LOGIN</a>~;

}


#############################################


sub verify{
	if ($q->param()){																#Check if something has been sent to the script, if not, go to login form.
		my $input_name = $q->param('Username');
		my $input_pass = $q->param('Password');
		require Fnc;
		Fnc::stripper($input_name);
		Fnc::stripper($input_pass);
	   	unless ( $input_name =~ /\w/ ) {die ("Not logged in! (Click <a href=\"$::settings{'full'}/apexnews.cgi\">here</a>)")};
	    	unless ( $input_pass =~ /\w/ ) {die ("Invalid password!")};
	   	$input_pass = crypt($input_pass,"kea");
	   	
    		my ($password,$rank) = split(":",$::settings{$input_name});
      	
      		
      	
    	if ($password eq $input_pass){										#Check if password is correct. If so, make a cookie.
    		my $final_cookie = $q->cookie(-name => 'userpass', -value => "$password:$input_name", -expires => '+1M');
        	print $q->header(-cookie => "$final_cookie");
        	print qq~<meta http-equiv="refresh" content="0"; url=apexnews.cgi?Main%20Page">~;
      }
    	else {die "Wrong user name or password!" };
	}
	else {&Misc::loginform};
}


##############################################

sub make_index{																			#Sorts hashes, used for main page and settings index and more?
	my @href	 = @_;
	for (@href){
		my ($link,$desc) = split (':',$_);
		print qq~<tr>
					<td><font class="main"><a href="apexnews.cgi?action=$link">
					<b>$link:</b></a> $desc</font>
					</td>
				</tr>
		~;
	}
}

	
	

sub loginform{
	$disobj->hdr("Welcome");
	require Form;
	my $form = new Form;
	print $form->form("POST");
		
	
	print $form->text("Username","Please enter your username");
		
	print $form->password("Password");
	
	print $form->submit("Submit");
	print $form->endform;
   $disobj->ftr;
   
  
}

1;