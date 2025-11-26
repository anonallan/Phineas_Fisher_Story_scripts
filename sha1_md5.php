<?php
while ($f = fgets(STDIN)){
	$passwenc = md5(sha1(rtrim($f)));
	echo "$passwenc : $f";
}

?>
