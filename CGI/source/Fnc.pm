package Fnc;
use strict;
use AnyDBM_File;
use Fcntl qw(:DEFAULT :flock);

sub new{
	my $invocant = shift;
	my $class		= ref($invocant) || $invocant;
	my $self			= {};
	bless($self, $class);
	return $self;
}





sub stripper {
	#Thanks to "Dilbert" aka "Steve" from the forums on 
	#http://forums.ikonboard.com for givin me this sub 
	my $invocant = shift;
	my $strip = shift;

	$strip =~ s/\;//g;  
	$strip =~ s/\`//g;
	$strip =~ s/\'//g;
	$strip =~ s/"//g;
	$strip =~ s/\|//g;
	$strip =~ s/\*//g;
	$strip =~ s/\?//g;
	$strip =~ s/<//g;
	$strip =~ s/>//g;
	$strip =~ s/\^//g;
	$strip =~ s/\[//g;
	$strip =~ s/\]//g;
	$strip =~ s/\{//g;
	$strip =~ s/\}//g;
	$strip =~ s/\$//g;
	$strip =~ s/\n//g;
	$strip =~ s/\r//g;

	return $strip; 
} 

sub stripper2 {
	my $invocant = shift;
	my $strip = shift;

	$strip =~ s/\;//g; 
	$strip =~ s/\`//g;
	$strip =~ s/\'/&#39\;/g;
	$strip =~ s/"/&#34;/g;
	$strip =~ s/\|/&#124;/g;
	$strip =~ s/\*//g;
	$strip =~ s/\?//g;
	$strip =~ s/</&#60;/g;
	$strip =~ s/>/&#62;/g;
	$strip =~ s/\^//g;
	$strip =~ s/\[/&#91;/g;
	$strip =~ s/\]/&#93;/g;
	$strip =~ s/\{/&#123;/g;
	$strip =~ s/\}/&#125;/g;
	$strip =~ s/\$/&#36;/g;
	$strip =~ s/\n/<br>/g;
	$strip =~ s/\r//g;

	return $strip; 
} 






1;