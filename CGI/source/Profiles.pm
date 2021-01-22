package Profiles;
use strict;
use Fcntl qw(:flock);
require Fnc;

my $fnc = new Fnc;

sub new{
	my $invocant = shift;
	my $profile = shift;
	
	my $class = ref($invocant) || $invocant;
	$fnc->stripper($profile);
	die "Profile \"$profile\"doesn't exists" unless (defined $::settings{"profile_".$profile});
	my ($category,$style,$sorting,$number,$dateprofile,$order,$skip) = split(',',$::settings{"profile_$profile"});
	
	my $self			= {	name		=>	$profile,
						category		=>	$category,
						style		=>	$style,
						file			=>	"textfiles/$profile.txt",
						sorting		=>	$sorting,
						number		=>	$number,
						dateprofile	=>	$dateprofile,
						order		=>	$order,
						skip			=>	$skip};
	bless($self, $class);
	return $self;
}



sub add{
	my ($self,$newprofile,$category,$style,$sorting,$number,$dateprofile,$order,$skip,$rest) = @_;
	
	die "Wrong usage of the add method" if ($rest);
	for ($self,$newprofile,$category,$style,$sorting,$number,$dateprofile,$order,$skip) { 
		if ($_ eq ''){ die "Too few parameters" }
	}
		
	
	$fnc->stripper($newprofile);
	$fnc->stripper($category);
	$fnc->stripper($style);
	$fnc->stripper($sorting);
	$fnc->stripper($number);
	
	die "Missing parameters" unless ($newprofile and $category and $style);
	die "Order missing :-/" unless ($order =~ /Newest first|Oldest first/);
	die "Illegal profile name" unless ($newprofile =~ /\w/);
	die "Category \"$category\"doesn't exist" unless ($::settings{categories} =~ /$category/);
	die "Style \"$style\" doesn't exist" unless ($::settings{styles} =~ /$style/);
	die "A profile with that name already exists" if ($::settings{profiles} =~ /$newprofile/);
	die "Illegal value in Days/number field. Only use number" if ($number !~ /\d/g );
	
	
	if (defined $::settings{$category."_profiles"}){
		$::settings{$category."_profiles"} = join (',',$::settings{$category."_profiles"},$newprofile);
	}
	else {
		$::settings{$category."_profiles"} = $newprofile
	}
		
	$::settings{profiles} = join (',',$::settings{profiles},$newprofile);
	$::settings{"profile_".$newprofile} = join(',',$category,$style,$sorting,$number,$dateprofile,$order,$skip);
}


sub save{
	my $self = shift;
	die "Style \"$self->{style}\" does not exist" unless ($::settings{styles} =~ /$self->{style}/);
	die "Category \"$self->{category}\" does not exist" unless ($::settings{categories} =~ /$self->{category}/);
	die "Illegal value in Days/number field. Only use number" if ($self->{number} !~ /\d/g );
	
	if ($self->{oldcategory} ne $self->{category}){
		$::settings{$self->{oldcategory}."_profiles"} =~ s/,$self->{name}//;
		$::settings{$self->{category}."_profiles"} = join(',',$::settings{$self->{category}."_profiles"},$self->{name});
	}
	
	$::settings{"profile_".$self->{name}} = join(',',$self->{category},$self->{style},$self->{sorting},$self->{number},$self->{dateprofile},$self->{order},$self->{skip});
	
}

sub del{
	my $self = shift;
	die "Cannot delete default profiles" if ($self->{name} eq $self->{category});
	
	$::settings{profiles} =~ s/,$self->{name}//;
	$::settings{$self->{category}."_profiles"} =~ s/,$self->{name}//;
	
	delete $::settings{"profile_".$self->{name}}

}

1;