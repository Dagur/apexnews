package Field;
use strict;
require CGI;
require Display;
my $disobj = new Display;
my $q = new CGI;



sub add{
	unless ($q->param('Field name')  =~ /\w/) { die "Bad field name"  ;}
	unless ($q->param('Field value') =~ /\w*/){ die "Bad field value" ;}
	my $new_field = join ':',$q->param('Field type'),$q->param('Field name'),$q->param('Field value');
	my @field_array = split(",",$::settings{form_fields});
	my $array_length = @field_array;
	my @new_field_array;
  
	for(my $i=0;$i <= $array_length;$i++){
		unless ($i == ($q->param('Field number') - 1)){$new_field_array[$i] = shift @field_array }
		else {$new_field_array[$i] = $new_field}
	}
	$::settings{form_fields} = join ",",@new_field_array;
	
	
	$disobj->hdr("field added");	
	print qq~<center><font face="verdana" size="4">Settings changed!<p></font>
           <a href="$::settings{full}/apexnews.cgi?action=Change%20news%20form">Back</a></center>~;
	$disobj->ftr;

}

################################


sub del{
	my $invocant = shift;
	my $var = $::settings{form_fields};
	die "Subject field cannot be deleted" if ( $q->param('Field name') eq 'Subject');
	
	$::settings{form_fields} = '';
	
	foreach (split(",",$var)){
		my ($type,$name,$default) = split(":",$_);
		if ($name eq $q->param('Field name') ){ next; }
		else { $::settings{form_fields} .= join(":",$type,$name,$default) . ","}
	}
	chop $::settings{form_fields};
	
	$disobj->hdr("Field deleted");
	print qq~<center><font face="verdana" size="4">Settings changed!<p></font>
		<a href="$::settings{full}/apexnews.cgi?action=Change%20news%20form">Back</a></center><br>~;
	$disobj->ftr;


}


sub form{																		#"Post" form
	$disobj->hdr("Change form");
	require Form;
	my $form = new Form;
	
	print $form->top("Add field");
	print $form->form("get");
	print $form->hidden("action","Add field");
	
	my @fields  = split(',',$::settings{form_fields});
	my $counter = scalar @fields + 1;
	
	print $form->list("Field number","Where would you like to place the new form field?",'',1..$counter);
	print $form->list("Field type","Choose a field type. A textfield is for a single line but textarea for multiple lines",'',("Textfield","TextArea"));
	print $form->text("Field name","Choose a name for the new field",10);
	print $form->text("Field value","You can use a default value for your new field. If you prefer not to you can leave it empty");
	print $form->submit("Add field");
	print $form->endform;
	
	print $form->top("Delete field");
	print $form->form("get");
	print $form->hidden("action","Delete field");
	
	my @fieldnames;
	for my $field (@fields){
		$field =~ s/.*:(.*):.*/$1/ig;
		push (@fieldnames,$field);
	}
	print $form->list("Field name","Choose a field to be deleted. It can easily be re-insterted at any time",'',@fieldnames);
	print $form->submit("Delete field");
	print $form->endform;
	
  $disobj->ftr;
}


1;