package Changestyle;
use strict;
require CGI;
require Styles;
require Display;


my $disobj = new Display;
my $style = new Styles;
my $q = new CGI;

sub then{
	my $invocant = shift;
	my $changes = $q->param('Change style');
	my $stylename = $q->param('Style name');
	$disobj->hdr('done');
	$style->save($stylename,$changes);
		
	$disobj->ftr;	

}

sub addstyle{
	my $invocant = shift;
	my $newstylename = $q->param('Name');
	
	$style->newstyle($newstylename);
	
	$disobj->hdr('done');
	
	$disobj->ftr;

}

sub del{
	my $invocant = shift;
	my $deleteme= $q->param('Style');
	
	$style->del($deleteme);
	
	$disobj->hdr('done');
	
	$disobj->ftr;

}

sub display{
	require Form;
	my $form = new Form;
	my $value = '';
	my $stylename = $q->param('Style');
	my @display_html = $style->openstyle($stylename);
	my @fields = split(",",$::settings{form_fields});
	
	my $desc = qq~For input data to appear you must use special tags in the style settings. It's simply the name of the
		textfield/textarea in brackets. In addition you can write <b>[Date]</b> to display the date according to your settings,
		<b>[Author]</b> to put the authors name in the post and <b>[Id]</b> to put the post id into the post (mainly used for 
		headlines linking). Finally you can write <b>[Teaser|Fieldname:length]</b> to display a shorter version of your news. Example:
		<b>[Teaser|Main:30]</b> displays the first 30 charachters from the 'Main' field.
		The following are available (by your settings):<br><center>~;
		
	for my $field (@fields){
		$field =~ s/.*:(.*):.*/\<b>[$1]<b> /ig;
		$desc .= $field;
	}
	
	for(@display_html){ $value .= $_;}
		
	$disobj->hdr('Edit style');
	print $form->form("post");
	print $form->hidden("action","Change style");
	print $form->hidden("Style name","$stylename");
	print $form->area("Change style",$desc,$value);
	print $form->submit("Submit new settings");
	print $form->endform;
	
	$disobj->ftr;


}

sub options{
	require Form;
	my $form = new Form;
	my @styles = split(",",$::settings{'styles'});
	
	$disobj->hdr('Edit styles');
	print $form->form("get");
	print $form->top("Edit style");
	print $form->hidden("action","Edit style");
	print $form->list("Style","Choose which style to edit",'',@styles);
	print $form->submit("Edit style");
	print $form->endform;
	
	print $form->form("get");
	print $form->top("Create new style");
	print $form->hidden("action","Create style");
	print $form->text("Name","Choose a name for the new style");
	print $form->submit("Create style");
	print $form->endform;
	
	print $form->form("get");
	print $form->top("Delete style");
	print $form->hidden("action","Delete style");
	print $form->list("Style","Warning: this will delete the style permanently",'',('-',,@styles));
	print $form->submit("Delete style");
	print $form->endform;
	
	
	$disobj->ftr;


	
}





1;