#!/usr/bin/perl

#####
### ApexNews by Dagur Pall Ammendrup
##
#	COPYRIGHTED
##
### visit http://news.sonicbarrier.net
####

BEGIN {unshift (@INC, "./source")}
use strict;
use AnyDBM_File;
use CGI::Carp 'fatalsToBrowser';
use CGI;
use Fcntl qw(:DEFAULT :flock);
require Display;
my $disobj = new Display;
my $q = new CGI;
use IO::File;

unless ($q->param('action') eq 'install'){ &main }
else {&install}

sub main{
	my $abs = $ENV{'SCRIPT_FILENAME'};
	$abs =~ s/\/setup\.cgi//g;
	
	my $flocksupport = "supported";
	*FH1 = new_tmpfile IO::File or die "Cannot open temporary file: $!\n"; 
  	eval {flock FH1, LOCK_SH};
  	if ($@){$flocksupport = "not supported"}
	
print $q->header;	
print qq~
	<html>
<head>



<title>ApexNews installer</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
<!--
.info {  font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bolder; color: #000000}
.fieldname {  font-family: Arial, Helvetica, sans-serif; font-size: 16px; font-weight: bold; color: #000000; text-decoration: underline}
-->
</style>
</head>

<body bgcolor="#003300" text="#000000">
<table width="75%" border="1" cellspacing="0" cellpadding="4" align="center" bordercolor="#000000">
  <form method="post" action="setup.cgi">
  <input type="hidden" name="action" value="install">
    <tr bgcolor="#000000"> 
      <td>&nbsp;</td>
      <td width="75%"> 
        <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="4" color="#FFFFFF"><b><font face="Georgia, Times New Roman, Times, serif" size="6">ApexNews 
          installer </font></b></font></div>
      </td>
      <td>&nbsp;</td>
    </tr>
    <tr bgcolor="#FFFFFF"> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr bgcolor="#FFFFFF"> 
      <td>&nbsp;</td>
      <td> 
        <p><b><font face="Verdana, Arial, Helvetica, sans-serif" class="info">It 
          is very important that the following information is correct. The default 
          values are <font color=red>not 100% reliable</font>. All paths and URL's should <font color="#FF0000">not</font> 
          be followed by a trailing slash!</font></b><br>
        </p>
        <table width="98%" border="0" cellspacing="0" cellpadding="3">
          <tr> 
            <td class="fieldname" colspan="2" >Absolute path:</td>
          </tr>
          <tr> 
            <td colspan="2"> 
              <div align="center"> 
                <input type="text" name="abs" size="80" value="$abs">
              </div>
            </td>
          </tr>
          <tr> 
            <td class="info" colspan="2">This is not the same as the URL to the 
              folder. It should look something like &quot;/path/to/site&quot;. 
              If you don't know the absolute path, contact your server administrator.</td>
          </tr>
          <tr> 
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr> 
            <td class="fieldname" colspan="2">URL:</td>
          </tr>
          <tr> 
            <td colspan="2"> 
              <div align="center"> 
              
<SCRIPT LANGUAGE="JavaScript">
   
           <!--
           var href = location.href;
           var newstr = href.replace(/.setup\.cgi/,"" );
           document.write('<input type="text" name="full" size="80" value="'+newstr+'">');
          
           // -->
</SCRIPT>
              
              
               
              </div>
            </td>
          </tr>
          <tr> 
            <td class="info" colspan="2">The url to the folder where you are installing 
              ApexNews (and the same folder you are installing from). Should look 
              something like &quot;http://www.mysite.com/cgi-bin/apexnews&quot;. 
              Remeber, no trailing slash.</td>
          </tr>
          <tr> 
            <td class="info" colspan="2">&nbsp;</td>
          </tr>
          <tr> 
            <td class="fieldname" height="24">File locking:</td>
            <td class="fieldname" height="24"> 
              <select name="flocking">~;
              
              if ($flocksupport eq 'not supported'){
              	print qq~
                <option value="On" >On</option>
                <option value="Off" selected>Off</option>~;
            }
            else {
            print qq~
                <option value="On" >On</option>
                <option value="Off">Off</option>~;
            }
            
            
            
print qq~
            </select>
                   
            </td>
          </tr>
          <tr> 
            <td class="info" colspan="2"> 
              <div align="left">File locking is very important for sites with 
                great traffic. It prevents your data from corrupting. If your 
                operating system does not support flocking you must set it to 
                off. Windows 95/98/ME do not support flocking. It appears that 
                on this server flocking is <font color=red>$flocksupport</font>.</div>
            </td>
          </tr>
          <tr> 
            <td class="info" colspan="2">&nbsp;</td>
          </tr>
        </table>
        <p>&nbsp;</p>
      </td>
      <td>&nbsp;</td>
    </tr>
    <tr bgcolor="#FFFFFF"> 
      <td>&nbsp;</td>
      <td> 
      <p><b><font face="Verdana, Arial, Helvetica, sans-serif" class="info">The default URLS in these two fields are only suggestions. You can choose them any way you like.</font></b><br>
        </p>
      
        <table width="98%" border="0" cellspacing="0" cellpadding="3">
          <tr> 
           
             <td class="fieldname">URL to site:</td>
          </tr>
          <tr> 
            <td> 
              <div align="center"> 
                <input type="text" name="mysite" size="80" value="http://$ENV{HTTP_HOST}">
              </div>
            </td>
          </tr>
          <tr> 
            <td class="info">This URL is used to link back to your site from the 
              admin control panel. It's recommended that you link to the page 
              where the news are. </td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td class="fieldname">URLto images:</td>
          </tr>
          <tr> 
            <td> 
              <div align="center"> 
                <input type="text" name="img" size="80" value="http://$ENV{HTTP_HOST}/apeximages">
              </div>
            </td>
          </tr>
          <tr> 
            <td class="info">The url to the folder where the ApexNews images are 
              installed. </td>
          </tr>
        </table>
      </td>
      <td>&nbsp;</td>
    </tr>
    <tr bgcolor="#FFFFFF"> 
      <td>&nbsp;</td>
      <td> 
        <table width="98%" border="0" cellspacing="0" cellpadding="3">
          <tr> 
            <td class="fieldname">Admin username:</td>
          </tr>
          <tr> 
            <td> 
              <div align="center"> 
                <input type="text" name="username" size="80">
              </div>
            </td>
          </tr>
          <tr> 
            <td class="info">Choose a login name for the admin.</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td class="fieldname">Admin password:</td>
          </tr>
          <tr> 
            <td> 
              <div align="center"> 
                <input type="password" name="password" size="80">
              </div>
            </td>
          </tr>
          <tr> 
            <td class="fieldname">Retype password:</td>
          </tr>
          <tr> 
            <td> 
              <div align="center"> 
                <input type="password" name="password2" size="80">
              </div>
            </td>
          </tr>
          <tr> 
            <td class="info">Choose a password for the admin then retype it to 
              prevent typing errors.</td>
          </tr>
          <tr> 
            <td class="info">&nbsp;</td>
          </tr>
          <tr> 
            <td class="info"> 
              <div align="center"> 
                <input type="submit" name="Submit" value="Submit">
              </div>
            </td>
          </tr>
        </table>
      </td>
      <td>&nbsp;</td>
    </tr>
    <tr bgcolor="#FFFFFF">
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
  </form>
</table>
</body>
</html>
~;

}





sub install {
	tie my %hash, "AnyDBM_File","data/default" , O_RDWR | O_CREAT , 0755 or die "could not create default database $!";
	untie %hash;
	tie my %settings, "AnyDBM_File","data/settings" ,  O_RDWR | O_CREAT, 0755 or die "could not create settings file $!";

	die "You left a field empty" unless ($q->param('password') && $q->param('password2') && $q->param('username') && $q->param('abs') && $q->param('full') && $q->param('mysite') && $q->param('img'));
	die "Password field values do not match" unless ($q->param('password') eq $q->param('password2'));
	
	my $usr = $q->param('username');
	
	$settings{$usr} = crypt($q->param('password'),"kea") . ":1";
	$settings{flocking} = $q->param('flocking');
	$settings{dateprofiles} = "default";
	$settings{DSTR_default} = "weekd, day month year at hour:min" ;
	$settings{DSET_default} = "0 0 0 1 1 1 1 1 0" ;
	$settings{profiles} = "default";
	$settings{default_profiles} = "default";
	$settings{profile_default} = "default,default,Quantity,15,default,Newest first";
	$settings{categories} = "default";
	$settings{styles} = "default";
	$settings{form_fields} = "Textfield:Subject:,TextArea:Main:";
	$settings{abs} = $q->param('abs');;
	$settings{full} = $q->param('full');
	$settings{img}  = $q->param('img');
	$settings{mysite} = $q->param('mysite');
	
	
	
	untie %settings;
	print $q->header;
	
	print qq~ <center><h1>All done</h1><br>
			<a href="apexnews.cgi">CLICK TO GO TO YOUR CONTROL PANEL</a>~;
	
	
	

}