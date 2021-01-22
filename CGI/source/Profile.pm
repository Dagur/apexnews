package Profile;
use strict;
require Display;
require Form;
require CGI;
my $form = new Form;
my $q = new CGI;
	
my $disobj = new Display;


sub change{
	my $invocant = shift;
	my $profile = $q->param('profile');
	require Profiles;
	my $obj = new Profiles ($profile);
	
	die "Cannot associate default profile with another category" if ($obj->{name} eq $q->param('Category'));
	
	$obj->{oldcategory} = $q->param('oldcategory');
	$obj->{style} = $q->param('Style');
	$obj->{category} = $q->param('Category') || $profile;
	$obj->{sorting} = $q->param('Sorting');
	$obj->{number} = $q->param('Days/Number');
	$obj->{dateprofile} = $q->param('Date profile');
	$obj->{order} = $q->param('Order');
	$obj->{skip}	= $q->param('Skip items');
	$obj->save;
	
	$disobj->hdr('Done');
	
	$disobj->ftr;

}

sub edit{
	my $invocant = shift;
	require Profiles;
	
	
	$disobj->hdr('Profile settings');
	my $profilename = $q->param('Profile');
	my $profile = new Profiles($profilename);
	my @categories = split(",",$::settings{categories});
	my @styles = split(",",$::settings{styles});
	my @dateprofiles = split(",",$::settings{dateprofiles});
	
	
	
	print $form->form("get");
	print $form->top("Edit profile $profilename");
	print $form->hidden("action","Change profile");
	print $form->hidden("profile","$profile->{name}");
	print $form->hidden("oldcategory","$profile->{category}");
	
	
	unless ($profile->{category} eq $profile->{name}){
		my $cats = $form->list("Category","Select the category you want $profile->{name} to be associated with","$profile->{category}",@categories);
		$cats =~ s/value="$profile->{category}"/value="$profile->{category}" selected/ig;
		print $cats;
	}
	
	
	my $styles = $form->list("Style","Select the style you want $profile->{name} to use",$profile->{style},@styles);
	$styles =~ s/value="$profile->{style}"/value="$profile->{style}" selected/ig;
	print $styles;
	
	print $form->list("Sorting","Do you want to sort the news by date or by quantity?",$profile->{sorting},('Date','Quantity'));
	print $form->text("Days/Number","If you chose to sort by date, how many days back would you like the news to go? If you chose sorting by date, how many new items do you want to be displayed? Leave blank if you want to show all news!!","","$profile->{number}");
	print $form->list("Date profile","Choose the date format for this profile",$profile->{dateprofile},@dateprofiles);
	print $form->list("Order","Would you like the newest news at the top (reverse chronological order) or the oldest first (chronological order)?",$profile->{order},('Newest first','Oldest first'));
	print $form->text("Skip items","You can select a number of news items to skip before writing to file. Useful if you want to use another profile for the first items","","$profile->{skip}");
	print $form->submit("Apply settings");
	print $form->endform;
	
	$disobj->ftr;
	
}

sub create{
	my $invocant = shift;
	require Profiles;
	
	
	add Profiles ($q->param('Name'),$q->param('Category'),$q->param('Style'),$q->param('Sorting'),$q->param('Number'),$q->param('Dateprofile'),$q->param('Order'),$q->param('Skip items'));
	
	$disobj->hdr('Done');
	
	$disobj->ftr;

}

sub del{
	my $invocant = shift;
	my $profile = $q->param('Profile');
	require Profiles;
	my $profileobj = new Profiles($profile);
	
	$profileobj->del;
	
	$disobj->hdr('Done');
	
	$disobj->ftr;

}



sub choose{
	my @profiles = split(",",$::settings{'profiles'});
	my @categories = split(",",$::settings{'categories'});
	my @styles = split(",",$::settings{'styles'});
	
	$disobj->hdr('Edit profiles');
	print $form->form("get");
	print $form->top("Edit profile");
	print $form->hidden("action","Edit profile");
	print $form->list("Profile","Change a profiles' setings",'',@profiles);
	print $form->submit("Edit profile");
	print $form->endform;
	
	print $form->form("get");
	print $form->top("Create new profile");
	print $form->hidden("action","Create profile");
	print $form->hidden("Order","Newest first");
	print $form->hidden("Number","0");
	print $form->hidden("Sorting","Date");
	print $form->hidden("Dateprofile","default");
	print $form->hidden("Skip items","0");
	print $form->list("Category","Choose the category you want to associate with the new profile",'',@categories);
	print $form->list("Style","Choose the style you want your new profile to use",'',@styles);
	print $form->text("Name","Finally choose a name for the new profile","20");
	print $form->submit("Create profile");
	print $form->endform;
	
	print $form->form("get");
	print $form->top("Delete profile");
	print $form->hidden("action","Delete profile");
	print $form->list("Profile","Warning: this will delete the profile peramanently",'',('-',@profiles));
	print $form->submit("Delete profile");
	print $form->endform;  
   
	$disobj->ftr;



}




1;