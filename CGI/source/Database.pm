package Database;
use strict;
use AnyDBM_File;
use Fcntl qw(:DEFAULT :flock);

sub TIEHASH{
	my $self = shift;
	my $file = shift;
	my $options = shift;
	my $locking = shift;
	
	die "Incorrect usage of Database.pm" if @_;
	
	
	my $lock_file;
    	for ('','.db','.pag') {
    		if ( (-e "$::settings{abs}/$file". $_) and !(-d "$::settings{abs}/$file". $_) ) {
    			$lock_file = $file.$_;
         		last;
        	}
    	}
    
    die "Could determine a lock file using $::settings{abs}/$file" unless ($lock_file);  
    
    	sysopen(DBLOCK, "$::settings{abs}/$lock_file", $options) or die "Here: can't open $lock_file: ";
	flock(DBLOCK, $locking) or die "Can't lock $file: ";
	
	tie (my %hash, "AnyDBM_File", $file,$options,0755) || die "could not tie to $file";
	my $ree = \%hash;
	
	return bless $ree, $self;
}
sub FETCH{
	my $self = shift;
	my $entry = shift;
	
	my $value = $self->{$entry};
		my $fields = {};
		my @data = split("`",$value);					#data from one post is put into an array called @data
		$fields->{author} = shift @data;
		for (@data){
			my ($datakey,$datavalue) = split("°",$_);
			$fields->{$datakey} = $datavalue;
		}
		
	return bless $fields, $self;
}
sub STORE{
	my $self = shift;
	my $key = shift;
	my $all_posts = shift;
	
	my $post = "$::user`";
	
	for( keys %$all_posts ){
		$post .= join("°",$_,$all_posts->{$_});							#Post put into $post variable, seperated by "`"
   		$post .= "`";												#@line[1] is the name of the field it came from
	}
	
	$self->{$key} = $post;
	untie $self;
}

sub FIRSTKEY { my $a = scalar keys %{$_[0]}; each %{$_[0]} }
sub NEXTKEY  { each %{$_[0]} }
sub EXISTS   { exists $_[0]->{$_[1]} }
sub DELETE   { delete $_[0]->{$_[1]} }
sub CLEAR    { %{$_[0]} = () }
1;