package Extras;
use strict;

use Display;
use Form;

my $disobj = new Display;
my $form = new Form;

sub show{
	$disobj->hdr("Extras");
	
	print $form->info("In future betas of ApexNews you will be able to use extras such as a comment system, mailing list and lots more");
	
	
	$disobj->ftr;
	



}

1;