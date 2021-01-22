package Dateformat;
use strict;
require Fnc;
require CGI;
require Display;
my $fnc = new Fnc;
my $q = new CGI;
my $disobj = new Display;

sub new{
	my $invocant = shift;
	my $class = ref($invocant) || $invocant;
	my $dateformat = shift || die "No dateformat name specified";
	
	
	
	my $self	= {	name 	=> $dateformat,
				settings 	=> $::settings{"DSET_$dateformat"},
				string	=> $::settings{"DSTR_$dateformat"}
			 };
	
	
		
	bless($self, $class);
	return $self;
}

sub save{
	my $self = shift;
	$::settings{"DSET_".$self->{name}} = $self->{settings};
	$::settings{"DSTR_".$self->{name}} = $self->{string};
	
}

sub output{
	my $self = shift;
		
	my $to_convert = shift || time;
	my $string = $self->{string};
	my @time_settings = split(" ",$self->{settings});
	my ($offset,$twelve_hour,$add_0_h,$add_0_d,$add_0_m,$endings,$use_shortm,$use_shortw,$use_shorty) = @time_settings;	
	 
	my ($am_pm,$rest);
	
	my ($sec,$min,$hour,$day,$mon,$year,$wday,$yday,$isdst) = localtime($to_convert);
	my $month = ("January","February","March","April","May","June","July","August","September","October","November","December")[$mon];
	my $weekd = ("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")[$wday];
	
	$hour += $offset;
	$year += 1900;
	
	if ($use_shortm){
		$month = ("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")[$mon];
	}
	
	if ($use_shortw){
		$weekd = ("Sun","Mon","Tue","Wed","Thur","Fri","Sat")[$wday];
	}
	
	if ($hour >= 24) { $hour -= 24 }
	if ($hour <  0) { $hour += 24 }
	if ($min  < 10) { $min  = "0$min"  }
	if ($sec  < 10) { $sec  = "0$sec"  }
	
	$mon++;
	
	if ($endings){
		if (($day >3) && ($day < 21)) {$day .= "th"}
		else{
			$rest = $day % 10;
			if ($rest eq 1) {$day .= "st"}
			elsif ($rest eq 2) {$day .= "nd"}
			elsif ($rest eq 3) {$day .= "rd"}
		 	else {$day .= "th"}
		}
	}
	
	
	if ($twelve_hour){
		if ($hour > 12){
			$am_pm = "pm";
			$hour -= 12
		}
		else {$am_pm = "am"}
	}
	
	if ($use_shorty){ $year = substr($year,2,4)}	
	if (($add_0_h eq 1) && ($hour < 10)) { $hour = "0$hour" }
	if (($add_0_d eq 1) && ($day < 10))  { $day  = "0$day"  }
	if (($add_0_m eq 1) && ($mon < 10))  { $mon  = "0$mon"  }
	
	
	$string =~ s/sec/$sec/;
	$string =~ s/min/$min/;
	$string =~ s/hour/$hour/;
	$string =~ s/day/$day/;
	$string =~ s/month/$month/;
	$string =~ s/mon/$mon/;
	$string =~ s/year/$year/;
	$string =~ s/weekd/$weekd/;
	$string =~ s/am_pm/$am_pm/;
	
	return $string;	

}



1;

