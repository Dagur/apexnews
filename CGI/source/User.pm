package User;
use strict;

sub new{
	my $invocant = shift;
	my $class = ref($invocant) || $invocant;
	my $self = {};
	bless $self, $class;
	return $self;

}

sub info{
	my $self = shift;
	
	$self->{name} = 'dagur';
	
	return $self;



}

sub blinfo{
	my $invocant = shift;
	my $class = ref($invocant) || $invocant;
	my $self = {name => 'jimb'};
	bless $self, $class;
	return $self;

}


1;