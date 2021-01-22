package Admins;
use strict;

require Display;
require Form;
my $form = new Form;
my $disobj = new Display;


sub edit{
	$disobj->hdr("Edit Admins");
	print $form->form('get');
	print $form->top("Add admin");
	print $form->text("Add admin","Create a new admin account.");
	print $form->submit("Add admin");
	print $form->endform;
	
	print $form->form('get');
	print $form->top('Edit your profile');
	print $form->text("Email","Your e-mail address");
	print $form->smallarea("Personal info","If there's any information you want to ");
	print $form->submit("Submit new settings");
	print $form->endform;
	
	print $form->info("Member managing will be much more advanced in future versions of ApexNews.");
	
	
	
	$disobj->ftr;



}

1;