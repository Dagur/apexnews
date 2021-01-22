package Display;
use strict;
use CGI;
use Benchmark;

my $q = new CGI;

sub new{
	my $invocant = shift;
	my $class		= ref($invocant) || $invocant;
	my $self			= {};
	bless($self, $class);
	return $self;
}


sub hdr{
	my ($class,$heading) = @_;

	my $output = qq~Content-type:text/html\n\n 
	<html>
	<head>
	<title>ApexNews :: AdminCP</title>

	<meta name="MSSmartTagsPreventParsing" content="TRUE">
	<meta name="Title" content="ApexNews :: AdminCP">
	<meta name="Description" content="description">
	<meta name="Keywords" content="keywords">
	<meta name="Author" content="author details">

	<style type="text/css">
	<!--

	a:link,a:visited,a:active {text-decoration: underline; color:#333; font-weight:bold; background-color:transparent;}
	a:hover                   {text-decoration: none; color:#333;      font-weight:bold; background-color:transparent;}

	font.small   {FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 8.5pt;  color: #333;                   background-color:transparent;}
	font.main    {FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10pt;   color: #333;                   background-color:transparent;}
	font.semi    {FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 12.5pt; color: #333; font-weight:bold; background-color:transparent;}
	font.large   {FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 15pt;   color: #333; font-weight:bold; background-color:transparent;}
	font.desc   {FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 8.5pt;  color: #DDDDDD;                   background-color:transparent;}

	font.secthead  {FONT-FAMILY: Verdana; FONT-SIZE: 15pt; color:#33cc33; font-weight:bold; background-color:transparent;}

	font.copy    {font-family: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 7.75pt; color: #333; background-color:transparent;}
	a:link.copy,a:visited.copy,a:active.copy {text-decoration: none;      color:#333; font-weight:bold; background-color:transparent;}
	a:hover.copy                             {text-decoration: underline; color:#333; font-weight:bold; background-color:transparent;}

	table.main {border:0;               width:100%; background-color:#339933;}
	td.td1     {border:0; height:100px; width:100%; background-color:#333333;}
	td.td2     {border:0; height:32px;  width:100%; background-color:#33CC33;}
	td.td3     {border:0; height:100%;  width:100%; background-color:#339933;}

	  table.tmnu {border:0; height:100%; width:100%;   background-color:#33CC33;}
	  td.tmsp    {border:0; height:100%; width:2%;     background-color:#33CC33;}
	  td.tmlk    {border:0; height:100%; width:120px;  background-color:#33CC33;}

	  table.mnbd {border:0;             width:100%; background-color:#339933;}
	  td.mbs1    {border:0; height:3%;  width:100%; background-color:#339933;}
	  td.mbmn    {border:0; height:90%; width:100%; background-color:#339933;}
	  td.mbs2    {border:0; height:7%;  width:100%; background-color:#339933;}

	    table.sect {border:0; height:100%; width:60%; background-color:#33cc33;}
	    td.schd    {border:0; height:50px; width:60%; background-color:#333333;}
	    td.scmn    {border:0; height:90%;  width:60%; background-color:#33cc33;}

	body  {background-color:#339933; margin-top:0px; margin-bottom:0px; margin-right:0px; margin-left:0px;}


	-->
	</style>

	</head>

	<body>

	<table class="main" cellspacing="0" cellpadding="0">

	<tr>
	<td class="td1" align="center" valign="middle">
	<img src="$::settings{'img'}//logogfx.gif" height="80" width="400" border="0" alt="ApexNews :: AdminCP">
	
	</td>
	</tr>

	<tr>
	<td class="td2" align="center" valign="middle">
	<!-- start top menu -->

	<table class="tmnu" cellspacing="0" cellpadding="0">
	<tr>

	<td class="tmsp" align="center" valign="middle">
	&nbsp;
	</td>

	<td class="tmlk" align="center" valign="middle">
	<a href="$::settings{full}/apexnews.cgi?action=Main page">
	<img src="$::settings{'img'}//main.gif"  border="0" alt="Main Page">
	</a>
	</td>

	<td class="tmlk" align="center" valign="middle">
	<a href="$::settings{full}/apexnews.cgi?action=Post news">
	<img src="$::settings{'img'}//post.gif"  border="0" alt="Post News">
	</a>
	</td>

	<td class="tmlk" align="center" valign="middle">
	<a href="$::settings{full}/apexnews.cgi?action=Builder">
	<img src="$::settings{'img'}//build.gif"  border="0" alt="Builder">
	</a>
	</td>

	<td class="tmlk" align="center" valign="middle">
	<a href="$::settings{full}/apexnews.cgi?action=Modify news">
	<img src="$::settings{'img'}//modify.gif"  border="0" alt="Modify News">
	</a>
	</td>

	<td class="tmlk" align="center" valign="middle">
	<a href="$::settings{full}/apexnews.cgi?action=Settings">
	<img src="$::settings{'img'}//settings.gif" border="0" alt="Settings">
	</a>
	</td>
	
	<td class="tmlk" align="center" valign="middle">
	<a href="$::settings{full}/apexnews.cgi?action=Extras">
	<img src="$::settings{'img'}//extras.gif"  border="0" alt="Extras">
	</a>
	</td>
	
	<td class="tmlk" align="center" valign="middle">
	<a href="$::settings{mysite}">
	<img src="$::settings{'img'}//mysite.gif"  border="0" alt="Back to site!">
	</a>
	</td>

	<td class="tmlk" align="center" valign="middle">
	<a href="$::settings{full}/apexnews.cgi?action=Log out">
	<img src="$::settings{'img'}//logout.gif" border="0" alt="Logout">
	</a>
	</td>

	<td class="tmsp" align="center" valign="middle">
	&nbsp;
	</td>

	</tr>
	</table>

	<!-- end top menu -->
	</td>
	</tr>

	<tr>
	<td class="td3" align="center" valign="top">
	<!-- start main body -->

	<table class="mnbd" cellspacing="0" cellpadding="0">

	<tr>
	<td class="mbs1" align="center" valign="middle">
	&nbsp;
	</td>
	</tr>

	<tr>
	<td class="mbmn" align="center" valign="middle"><table class="sect" cellspacing="0" cellpadding="5">

	<tr>
	<td class="schd" align="left" valign="middle">
	<font class="secthead">:: $heading</font>
	</td>
	</tr>

	<tr>
	<td class="scmn" align="left" valign="middle">~;
		   print $output;

}

sub ftr{																							#Footer
	my $t1 = new Benchmark; 
	my $bench = "Processing Time : " . timestr(timediff($t1,$::t0));
	my $output = qq~
	<!-- end section table -->
	</td>
	</tr>

	<tr>
	<td class="mbs2" align="center" valign="middle">
	<br>
	<font class="copy"><a href="http://www.apexnews.net/" target="hndc" class="copy">ApexNews</a> v$::version &copy; 2001</font>
	<br>
	<font class="copy">AdminCP Template by <a href="http://www.halogen-net.com" target="hndc" class="copy">Jordan Gadd</a></font>
	<br><br>
	<font class="copy">$bench</font>
	<br><br>
	</td>
	</tr>

	</table>

	<!-- end main body -->
	</td>
	</tr>

	</table>

	</body>

	</html>~;

		print $output;
}

sub error{
		my ($message1,$message2) = split " at ",$_[1];
		print qq~<b>Error:</b>
			 <br><center><font face="verdana" color="yellow" size="3">$message1</font>
			 <br></center><b>At:</b>
			 <br><center><font face="arial" color="green" size="2">$message2</font></center>
			 <br><b>Extra:</b>
			 <br><center><font face="arial" color="green" size="2">$!
			 <p>&nbsp;</center> ~;
		ftr;
		exit;	


}



1;