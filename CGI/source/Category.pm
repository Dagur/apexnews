package Category;
use strict;
use AnyDBM_File;
use Fcntl;
require CGI;
require Fnc;
require Display;
require Profiles;
my $disobj = new Display;
my $q = new CGI;
my $fnc = new Fnc;

sub add{
	my $invocant = shift;
	my $name = $fnc->stripper($q->param('Name'));
	
	
	unless( ($name !~ /^[\w\d]+$/) || ($::settings{'categories'} =~ /(?:^|,)$name(?:,|$)/)) {
		 $::settings{'categories'} = join(",",$::settings{'categories'},$name);
		 tie (my %temphash, 'AnyDBM_File', "data/$name", O_CREAT | O_RDWR, 0755)	#tie a hash to the DBM file
   	        or die "Error creating new database."; 

   	
   	untie %temphash;
		}
	else {die "Category name already exisist or illegal category name!"}
	
	join(",",$::settings{'categories'},$name);
	
	add Profiles ($name,$name,'default','Date','30','default','Newest first',0);
	
	
	$disobj->hdr('Done');
	
	$disobj->ftr;
	
	
}

sub del{
	my $invocant = shift;
	my $selection = $q->param('Select category');
	if ($selection eq '-'){die "No category selected"}
	if ($selection eq 'default'){ die "Cannot delete default category"}
	
	
	$::settings{categories} =~ s/(^|,)$selection(,|$)/$2/; #Preserve the trailing comma
	$::settings{profiles}   =~ s/(^|,)$selection(,|$)/$2/; #Preserve the trailing comma
	
	delete $::settings{$selection."_profiles"};
	
	
	
	$disobj->hdr('done');
	
	$disobj->ftr;

}

###############################################


sub form{
	require Form;
	my $form = new Form;
	
	$disobj->hdr('Edit categories');
	
	print $form->form("get");
	print $form->hidden("action","Add category");
	print $form->top("Add category");
	print $form->text("Name","Choose a name for the new category.",20);
	print $form->submit("Create category");
	print $form->endform;
	
	print $form->form("get");
	print $form->hidden("action","Delete category");
	print $form->top("Delete category");
	my @categories = split(",",$::settings{'categories'});
	print $form->list("Select category","This will <b>not</b> delete the database files, they need to be deleted manually. They can be found in the 'data' directory",'',('-',@categories));
	
	
	print $form->submit("Delete category");
	print $form->endform;
	     
	$disobj->ftr;

}

1;