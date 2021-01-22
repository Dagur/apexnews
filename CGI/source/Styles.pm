package Styles;
use strict;
use Fcntl qw(:flock);



sub new{
	my $invocant = shift;
	my $class		= ref($invocant) || $invocant;
	my $self			= {};
	bless($self, $class);
	return $self;
}

sub openstyle{
	my $invocant = shift;
	my $style = shift;
	my @array;
	
	open(FILE,"styles/$style.htm") or die "Could not open styles/$style";
	if ($::settings{flocking} eq "On"){ flock (FILE, LOCK_SH)}
	while(<FILE>){ push @array,  $_}
	
	return @array;
	close(FILE);
	

}

sub save{
	my $invocant = shift;
	my $style = shift;
	my $content = shift;
	
	open(FILE,">styles/$style.htm") or die "Could not open styles/$style.htm";
	if ($::settings{flocking} eq "On"){ flock (FILE, LOCK_EX)}
	print FILE $content;
	close(FILE);

}

sub del{
	my $invocant = shift;
	my $style = shift;
	
	unlink "styles/$style.htm";
	$::settings{'styles'} =~ s/,$style//;

}

sub newstyle{
	my $invocant = shift;
	my $newstyle = shift;
	
	die "Illegal style name" unless ($newstyle =~ /\w/);
	die "Style already exists" unless ($::settings{'styles'}  !~ /$newstyle/);
	
	$::settings{'styles'} = join (',',$::settings{'styles'},$newstyle);
	
	open(FILE,">styles/$newstyle.htm") or die "Could not create styles/$newstyle.htm";
	if ($::settings{flocking} eq "On"){ flock (FILE, LOCK_EX)}
	print FILE "[Subject] - Date: [Date] <br> [Main]";
	close(FILE);
}




1;