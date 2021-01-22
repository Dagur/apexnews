#!/usr/bin/perl 

#####
### ApexNews by Dagur Pall Ammendrup
##
#	COPYRIGHTED
##
### visit http://news.sonicbarrier.net
####

use strict;
use Benchmark;

$::t0 =	new Benchmark;
BEGIN {push (@INC, "./source")}

use AnyDBM_File;
use CGI::Carp 'fatalsToBrowser';
use Fcntl qw(:DEFAULT :flock);
use CGI;

	 
$|++;
$::version = "0.01 (alpha)";

$SIG{__DIE__} =	sub { 
	require	Display;
	my $disobj = new Display;
	$disobj->hdr("Fatal error" );
	$disobj->error("$_[0]","$!");
	$disobj->ftr;
};
	


tie (%::settings, 'AnyDBM_File', "data/settings", O_RDWR, 0755)	
	or die "An error ocurred connecting to the settings file.";


eval{&main};
if($@) {die "Unknown error " }


##___________________________________MAIN SUBROUTINE (&main)____________________________________##
sub main{		
	my $q = new CGI;
	my $cookie_userpass = $q->cookie('userpass');
	
	if ($cookie_userpass){
		my ($cookie_password,$cookie_username) = split(":",$cookie_userpass);
		my ($password,$temp_rank) = split(":",$::settings{$cookie_username});
		
		if ($password eq $cookie_password) {	
			$::rank = $temp_rank;
			$::user = $cookie_username;
			
			my $action = $q->param('action')  || 0;

			my %Mode =
			('Parse'				=> ['Post'			,'parse'			]	#Takes posts and puts them  into the database
			,'Builder'				=> ['Builder'			,'options'			]	#Builder options (which categories)
			,'Build',				=> ['Builder'			,'run'			]	#Build news
			,'General settings'		=> ['Settings'			,'general'			]	#Display general settings menu
			,'Apply settings'		=> ['Settings'			,'apply'			]	#Save new general settings
			,'Post news'			=> ['Postform'			,'main'			]	#Show the main post form
			,'Change news'		=> ['Postform'			,'modify'			]	#Show the modify news item post form
			,'Add category'		=> ['Category'			,'add'			]	#Create a new category
			,'Delete category'		=> ['Category'			,'del'				]	#Delete a category
			,'Edit categories'		=> ['Category'			,'form'			]	#Main category options menu
			,'Modify news'			=> ['Modifynews'		,'display'			]	#Show list of news items
			,'Change style'		=> ['Changestyle'		,'then'			]	#Update a style after changes
			,'Create style'			=> ['Changestyle'		,'addstyle'		]	#Create a new style
			,'Delete style'			=> ['Changestyle'		,'del'				]	#Delete style
			,'Edit styles'			=> ['Changestyle'		,'options'			]	#Styles options menu
			,'Edit style'			=> ['Changestyle'		,'display'			]	#Style editing form
			,'Add field'			=> ['Field'			,'add'			]	#Add a field to the postform
			,'Delete field'			=> ['Field'			,'del'				]	#Delete a field in the postform
			,'Change news form'	=> ['Field'			,'form'			]	#Main fields menu
			,'Extras'				=> ['Extras'			,'show'			]	#Extras menu
			,'Date settings'		=> ['Dateprofiles'		,'form'			]	#Change a particular date profile
			,'Change date profile'	=> ['Dateprofiles'		,'change'			]	#Apply changes to date profile
			,'Create date profile'	=> ['Dateprofiles'		,'add'			]	#Create a date profile
			,'Delete date profile'	=> ['Dateprofiles'		,'del'				]	#Delete a date profile
			,'Edit date profiles'		=> ['Dateprofiles'		,'edit'			]	#Main date profiles menu
			,'Edit profiles'			=> ['Profile'			,'choose'			]	#Main profiles menu
			,'Edit profile'			=> ['Profile'			,'edit'			]	#Edit a profile (form)
			,'Create profile'		=> ['Profile'			,'create'			]	#Create a profile
			,'Delete profile'		=> ['Profile'			,'del'				]	#Delete a profile
			,'Change profile'		=> ['Profile'			,'change'			]	#Change a profile
			,'Edit users'			=> ['Users'			,'edit'			]	#Edit user accounts
			,'Apply user info'		=> ['Users'			,'apply'			]	#Apply changes of user info
			,'Create user'			=> ['Users'			,'create'			]	#Create user
			,'Main page'			=> ['Misc'			,'Mainpage'		]	#Show main page
			,'Settings'			=> ['Misc'			,'Settingspage'	]	#Show settings page
			,'Log out'				=> ['Misc'			,'Logout'			]	#Delete cookies
			,'error'				=> ['Misc'			,'Error'			]	#Show error
			,'0'					=> ['Misc'			,'Mainpage'		]	#Show main page
			);
			
			unless (!$Mode{$action}){
				my $code = "use	$Mode{\"$action\"}[0]; $Mode{\"$action\"}[1] $Mode{\"$action\"}[0];";
				eval $code;			
			}
			else {die "Action: \"$action\" does not exist!"}
			
			#Many thanks to Matt Mecham, creator of ikonboard (http://www.ikonboard.com)  for letting me use that trick. 
			#All other code in the script is by me and copyrighted to me so please contact me if you want to use any of it.
			#Please read the license agreement if you haven't already ;)
		}
	else {die "Cookie needs to be deleted"	}		
	}
	else{ 
		use Misc;
		verify Misc;
  	}	
} 