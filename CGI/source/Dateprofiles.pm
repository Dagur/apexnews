package Dateprofiles;
use strict;
require Form;
require CGI;
require Display;

my $form = new Form;
my $disobj = new Display;
my $q = new CGI;

sub edit{
	$disobj->hdr('Edit date profiles');
	my @profiles = split(",",$::settings{'dateprofiles'});
	
	
	print $form->form("get");
	print $form->top("Edit date profile");
	print $form->hidden("action","Date settings");
	print $form->list("Profile","Choose which profile's settings you want to edit",'',@profiles);
	print $form->submit("Edit profile");
	print $form->endform;
	
	print $form->form("get");
	print $form->top("Create new date profile");
	print $form->hidden("action","Create date profile");
	print $form->text("Name","Choose a name for the new date profile",15);
	print $form->submit("Create date profile");
	print $form->endform;
	
	print $form->form("get");
	print $form->top("Delete date profile");
	print $form->hidden("action","Delete date profile");
	print $form->list("Profile","Choose which profile to delete. Data can not be restored.",'',('-',@profiles));
	print $form->submit("Delete profile");
	print $form->endform;
			
	$disobj->ftr;


	
}


sub change{
	my $invocant = shift;
	require Fnc;
	my $fnc = new Fnc;
	
	die "Not an object method" if @_;
	my $dateprofile = $q->param('profilename');
	
	$::settings{"DSTR_$dateprofile"} = $fnc->stripper($q->param('Date profile'));
	
	$::settings{"DSET_$dateprofile"} = 
	join(' ',$q->param('Time offset'),$q->param('twelve_hour'),$q->param('add_0_h'),$q->param('add_0_d'),$q->param('add_0_m'),
			$q->param('endings'),$q->param('use_shortm'),$q->param('use_shortw'),$q->param('use_shorty'));
	
		
	$disobj->hdr('Done');
	
	$disobj->ftr;

}

sub add{
	my $invocant = shift;
	die "Not an object method" if @_;
	my $newdateprofile = $q->param('Name');
	
	unless ( $newdateprofile =~ /\w/ ) {die ("Bad name for date profile!")};
	
	$::settings{dateprofiles} = join (',',$::settings{dateprofiles},$newdateprofile);
	$::settings{"DSET_$newdateprofile"} = $::settings{"DSET_default"};
	$::settings{"DSTR_$newdateprofile"} = $::settings{"DSTR_default"};
	
	$disobj->hdr('Done');
	
	$disobj->ftr;

}

sub del{
	my $invocant = shift;
	
	my $dateprofile = $q->param('Profile');
	
	die "No date profile selected" if ($dateprofile eq "-");
	die "Will not delete default profile" if ($dateprofile eq "default");
	
	undef $::settings{"DSET_".$dateprofile};
	undef $::settings{"DSTR_".$dateprofile};
	
	$::settings{'dateprofiles'} =~ s/,$dateprofile//;
	
	$disobj->hdr('Done');
	
	$disobj->ftr;
}


sub form{
	my $invocant = shift;
	require Dateformat;
	my $dft = new Dateformat($q->param('Profile'));
	
	my @time_settings = split(" ",$dft->{'settings'});
	my $offset = shift(@time_settings);
	my $curset = $dft->output;
	my @s;
	for (@time_settings){
		if ($_ == 0){ push(@s,"0","selected")}
		elsif ($_ == 1){ push(@s,"selected","0")}
		else {die "Something's wrong with the time settings"}
		
	}
	
	
	$disobj->hdr("Edit date profile \"$dft->{name}\"");
	
	print $form->form("post");
	print $form->hidden("action","Change date profile");
	print $form->hidden("profilename","$dft->{name}");
	print $form->list("Time offset"," Server time is (by current settings): $curset","$offset",-12..12);
	
		
	ds("twelve_hour","Twelve hour format","Write 3:00 instead of 15:00 for example. To add 'am/pm' see below.",(shift @s,shift @s));
	ds("add_0_h","Add zero's to hours","Put a zero in front of hours so that there's always 2 digits. Example: write '03' instead of just '3'. ",(shift @s,shift @s));
	ds("add_0_d","Add zero's to days","Put a zero in front of days so that there's always 2 digits. Example: write '03' instead of just '3'. ",(shift @s,shift @s));
	ds("add_0_m","Add zero's to months","Put a zero in front of months so that there's always 2 digits. Example: write '03' instead of just '3'. ",(shift @s,shift @s));
	ds("endings","Add endings to days","Example: write '3rd' or '21st' instead of just '3' or '21' for days",(shift @s,shift @s));
	ds("use_shortm","Use short month names","Writes 'Jan, Feb, Mar....' instead of 'January, February,March....'",(shift @s,shift @s));
	ds("use_shortw","Use short weekday names","Writes 'Mon,Tue,Wed...' instead of 'Monday,Tuesday,Wed'",(shift @s, shift @s));
	ds("use_shorty","Use short year format","Writes '01' instead of '2001'",(shift @s, shift @s));
	
	print $form->text("Date profile",qq~Here you can create the date format you want using special tags for each 
        element of the date. In addition you can use any text and many special 
        characters (like commas and semcolons and much more). Here are the tags 
        you can use (make sure you type them correctly or they wont be converted 
        by the script):<br><center>
        <b>sec min hour day month mon  year weekd am_pm</b></center> ~,"99",$dft->{string});
	
	print $form->submit("Submit");
	print $form->endform;
	$disobj->ftr;


}

sub ds{
	my $param_name = shift;
	my $name = shift;
	my $description = shift;
	my @io = @_;
	
	print qq~<center> <table width="98%" cellpaddin="4" cellspacing="0" align="middle">
		<tr><td><font class="main"><b>$name:</b></font></td><td align="right">
		<select name="$param_name"><option value="1" @io[0]> On </option><option value="0" @io[1]> Off </option>
		</select></td></tr><td colspan="2" bgcolor="darkgreen">
		<font class="desc">$description</font></td></tr></table></center>~;
	
}

1;