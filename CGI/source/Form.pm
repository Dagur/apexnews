package Form;
use strict;

sub new{
	my $invocant = shift;
	my $class		= ref($invocant) || $invocant;
	my $self			= {};
	bless($self, $class);
	return $self;
}

sub form{
	my $self = shift;
	die "Incorrect usage of the form method" unless (scalar @_ == 1);
	my $method = shift;
	
	return qq~<form action="apexnews.cgi" method ="$method">~;
}

sub hidden{
	my $self = shift;
	die "Incorrect usage of the hidden method" unless (scalar @_ == 2);
	my $name = shift;
	my $value = shift;
	
	return qq~<input type="hidden" name="$name" value="$value">~;
}

sub text{
	my $self = shift;
	die "Incorrect usage of the hidden method" unless (scalar @_ >= 2);
	my $name = shift;
	my $description = shift;
	my $length = shift;
	my $value = shift;
	
	if ($length){
		return  qq~ <center><table width="98%" cellpaddin="4" cellspacing="0" align="middle"><tr><td><font class="main"><b>$name:</b></font></td>
		<td align="right"><input type="text" value="$value" size="60" maxlength="$length" name="$name"></td></tr>
		<td colspan="2" bgcolor="darkgreen"><font class="desc">$description</font></td></tr></table></center>~;
	}
	else{
		return  qq~<center> <table width="98%" cellpaddin="4" cellspacing="0" align="middle"><tr><td><font class="main"><b>$name:</b></font></td>
		<td align="right"><input type="text" value="$value" size="60" maxlength="20" name="$name"></td></tr>
		<td colspan="2" bgcolor="darkgreen"><font class="desc">$description</font></td></tr></table></center>~;
	}
}

sub area{
	my ($self,$name,$description,$value) = @_;
		
	return  qq~ <center><table width="98%" cellpaddin="4" cellspacing="0" align="middle"><tr><td>
	<font class="main"><b>$name:</b></font><br>
	<textarea cols="70" rows="15" name="$name">$value</textarea></td></tr>
	<td  bgcolor="darkgreen"><font class="desc">$description<br></font></td></tr></table></center>~;
	
}

sub smallarea{
	my ($self,$name,$description,$value) = @_;
		
		
	return  qq~<center> <table width="98%" cellpaddin="4" cellspacing="0" align="middle"><tr><td valign="top"><font class="main"><b>$name:</b></font></td>
		<td align="right"><textarea cols="45" rows="3" name="$name">$value</textarea></td></tr>
		<td colspan="2" bgcolor="darkgreen"><font class="desc">$description</font></td></tr></table></center>~;
			
}


sub password{
	my $self = shift;
	die "Incorrect usage of the password method" unless (scalar @_ == 1);
	my $name = shift;
	
	return  qq~<center> <table width="98%" cellpaddin="4" cellspacing="0" align="middle"><tr><td><font class="main"><b>$name:</b></font></td>
		<td align="right"><input type="password" size="60" maxlength="20" name="$name"></td></tr>
		<td colspan="2" bgcolor="darkgreen"><font class="desc">Please enter your password.</font></td></tr></table></center>~;
}

sub checkbox{
	my $self = shift;
	my $name = shift;
	my $description = shift;
	require CGI;
	my $q = new CGI;
	
	my @values = shift;
	
	
	my $output = qq~<center> <table width="98%" cellpaddin="4" cellspacing="0" align="middle">
		<tr><td><font class="main"><b>$name:</b></font></td><td align="right">~;
	$output .= $q->checkbox_group(-name=>$name,-values=> @values,-columns=>5, defaults => 'default');
	$output .=qq~</td></tr><td colspan="2" bgcolor="darkgreen"><font class="desc">$description</font></td></tr></table></center>~;
		
	return $output;
}


sub submit{
	my $self = shift;
	die "Incorrect usage of the hidden method" unless (scalar @_ == 1);
	my $value = shift;
	
	return qq~ <br><center><input type="submit" value="$value"></center>
	~;
}

sub top{
	my $self = shift;
	my $header = shift;
	return qq~<font class="large">$header</font>~;
}

sub list{
	my $self = shift;
	my $name = shift;
	my $description = shift;
	my $defaultvalue = shift;

	
	
	
	
	my $output = qq~<center> <table width="98%" cellpaddin="4" cellspacing="0" align="middle">
		<tr><td><font class="main"><b>$name:</b></font></td><td align="right">
		<select name="$name">~;
		
	for(@_){
		unless ($_ eq $defaultvalue) {
			$output .= "<option value=\"$_\"> $_ </option>"
		}
		else {
			$output .= "<option value=\"$_\" selected> $_ </option>"
		}
	}
	
		
	$output .= qq~</select></td></tr><td colspan="2" bgcolor="darkgreen">
		<font class="desc">$description</font></td></tr></table></center>~;
}

sub info{
	my $self = shift;
	my $info = shift;
	
	return qq~<center><font class="main">$info</font></center><br>~;
	
}


sub endform{
	return qq~</form>~;
}

1;