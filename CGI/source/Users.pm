package Users;
use strict;

require CGI;
require Display;
require Form;
my $form = new Form;
my $disobj = new Display;
my $q = new CGI;

sub edit{

	$disobj->hdr("Edit Users");
	print $form->form('post');
	print $form->hidden('action','Create user');
	print $form->top("Add user");
	print $form->text("Username","Create a new user account. NOTE: In this version of ApexNews you can only create admin accounts so only give access to people you trust!! Admin accounts cannot be deleted");
	#print $form->text("Full name","Full name of new user (optional)");
	print $form->text("Password","Select password for the new user.");
	#print $form->list("User rank","1 is administrator, 2 is regular user (can only post news and edit own posts and user profile). Only give people you trust fully admin status because they have the same power as you and <b>can't be deleted</b> with ordinary methods!",'',(1,2));
	print $form->submit("Add user");
	print $form->endform;
	
	#my ($pass,$rank,$fullname,$email,$pi) = split (':',$::settings{$::user});
	
	#print $form->form('get');
	#print $form->hidden("action","Apply user info");
	#print $form->top('Edit your profile');
	#print $form->text('Full name','Your full name',99,$fullname);
	#print $form->text("Email","Your e-mail address",99,$email);
	#print $form->smallarea("Personal info","If there's any information you want to ",$pi);
	#print $form->submit("Submit new settings");
	#print $form->endform;
	
	print $form->info("Member managing will be much more advanced in the next beta");
	$disobj->ftr;

}

sub apply {
	my $invocant = shift;
	
	my ($fullname,$email,$pi) = ($q->param('Full name'),$q->param('Email'),$q->param('Personal info'));
	
	my ($pass,@junk) = split(':',$::settings{$::user}); 
	
	$::settings{$::user} = join(':',$pass,$::rank,$fullname,$email,$pi);
	
	$disobj->hdr("Done");
	
	$disobj->ftr;
	
}

sub create {
	my $invocant = shift;
	
	my ($username,$password) = ($q->param('Username'),$q->param('Password'));
	
	my $fullname = '';
	#my ($username,$fullname,$password) = ($q->param('Username'),$q->param('Full name'),$q->param('Password'));
	
	die "User already exists" if (defined $::settings{$username});
	
	$password = crypt $password, 'kea';
	
	$::settings{$username} = join(':',$password,1,$fullname,'','');
	
	$disobj->hdr("Done");
	
	$disobj->ftr;
	
}




1;