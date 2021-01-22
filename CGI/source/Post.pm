package Post;
use strict;
use Database;
require CGI;
use Fcntl qw(:DEFAULT :flock);
my $q = new CGI;


sub parse{
	my @categories = $q->param('Categories');
	my @temp = split(",",$::settings{form_fields});													#Get form fields from global variable
	my $time;
	my $all_posts = {};
   
	unless ($q->param('key')){$time = time }
	else{$time = $q->param('key') }
   
   	for (@categories){
   		for my $field (@temp){
   			$field =~ s/.*:(.*):.*/$1/;
   			my $post = $q->param("$field");
   			
   			if ($q->param('Convert newlines to HTML') eq 'No'){$post =~ s/\n//g }
   			else {$post =~ s/\n/<br>/g}
   			   			
   			$all_posts->{$field} = $post;
   			
   		}
  		tie (my %hash, "Database", "data/$_", O_RDWR | O_CREAT, LOCK_EX) or die "Can't connect to $_.db";
   		$hash{"$time"} = $all_posts;
      		untie %hash;
   	}
   
   use Builder;
   Builder::run(@categories);
   
	


}



1;