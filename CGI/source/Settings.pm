package Settings;
use strict;
require Display;
require Form;

my $form = new Form;
my $disobj = new Display;

sub general{
	$disobj->hdr("General settings");
	print $form->form("post");
	print $form->hidden("action","Apply settings");
	print $form->list("Allow multiple category posting","With this on you can post new to many categories at once","$::settings{MCP}",('Yes','No'));
	print $form->list("Always build from all categories","Builds news from all categories when 'Builder' is clicked",$::settings{build_all},('Yes','No'));
	
	print $form->submit("Apply new settings");
	print $form->endform;
	$disobj->ftr;

}

sub apply{
	use CGI;
	my $q = new CGI;
	
	$::settings{MCP} = $q->param("Allow multiple category posting");
	$::settings{build_all} = $q->param("Always build from all categories");
	
	$disobj->hdr("Done");
	
	print qq~<center>$::settings{build_all}<a href="$::settings{full}/apexnews.cgi?action=General%20settings">Back to general settings! </a></center>~;
	$disobj->ftr;



}

1;