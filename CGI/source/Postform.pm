package Postform;
use strict;
use Fcntl qw(:DEFAULT :flock);

require Display;
require Form;

my $form = new Form;
my $disobj = new Display;


sub main{																		#"Post" form
	
	my @fields = split(",",$::settings{form_fields});
	my @cats = split(",",$::settings{categories});
	
	$disobj->hdr('New post');
	
	print $form->form("post");
	print $form->hidden("action","Parse");
	
	if (scalar(@cats) > 1){
		if ($::settings{MCP} eq 'Yes'){
			print $form->checkbox("Categories","To which categories do you want to post?",\@cats);
		}
		else{
			print $form->list("Categories","To which category do you want to post?",'',@cats);
			
		}
	}
	else{
		print $form->hidden("Categories","default");
	}
	
	
	for (@fields){
		my ($type,$name,$default) = split(":",$_);
		if ($type eq "Textfield"){print $form->text("$name","The '$name' textfield","99",$default)	}
   		else 	{print $form->area("$name","The '$name' textarea","$default")	}
   	}
   	print $form->list("Convert newlines to HTML","Converts \\n's to &#60;br&#62; instead of erasing them. Recommended.",'',('Yes','No'));
   	print $form->submit("Submit post");
   	print $form->endform;
	$disobj->ftr;
}


sub modify{
	require Database;
	require CGI;
	
	my $q = new CGI;
	my $action = $q->param('change');
	my ($key,$category) = split("-",$q->param('utvarp'));
	
	my @fields = split(",",$::settings{form_fields});
	unless ($category){die "wtf"}
	
	die 'No news item selected' unless $key;
	
	if ($action eq 'Delete'){
		tie (my %hash, 'Database', "data/$category", O_WRONLY, LOCK_EX)	#tie a hash to the DBM file
   		or die "There was an error when connecting to the database.";
		
		delete $hash{$key};
		untie %hash;		
		$disobj->hdr("Done");
		print "$action - $key";
		$disobj->ftr;	
	}
	
	elsif($action eq 'Modify'){	
		tie (my %hash, 'Database', "data/$category", O_RDONLY, LOCK_SH)	#tie a hash to the DBM file
   		or die "There was an error when connecting to the database.";
		
		my $post = $hash{$key};
				
		$disobj->hdr("Modify post");
		print $form->form("post");
		print $form->hidden("action","Parse");
		print $form->hidden("key","$key");
		print $form->hidden("Categories","$category");
		print $form->hidden("author","$post->{author}");
		
		for (@fields){
			my ($type,$name,$default) = split(":",$_);
			my $contents = $post->{$name};
						
			if ($type eq "Textfield"){print $form->text("$name","The '$name' textfield","99",$contents)	}
   			else 	{
   				$contents =~ s/<br>/\n/g;
   				print $form->area("$name","The '$name' textarea",$contents)	
   			}
   		}
   		print $form->submit("Submit post");
   		print $form->endform;
   	
   	
		
	$disobj->ftr;
	untie %hash;
	}
	else{ die('Access the script in the correct manner')}



}

1;