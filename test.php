<?php
	global $AUSADMIN_HOME;

	$AUSADMIN_HOME = '/home/ausadmin';

	require_once('subs.inc');

	# Get the newsgroup name
	$x = apache_lookup_uri($REQUEST_URI);
	$y = $x->path_info;

	# $y ... "/newsgroup_name/something"

	$args = explode('/', $y);

	$ng = $args[1];

	$parent = get_ng_prefix($ng);

	$array = files_in_dir("$AUSADMIN_HOME/data/Newsgroups");

	$len = strlen($parent);
	$siblings = array();

	foreach ($array as $fn) {
		if (strncmp($fn, $parent, $len) || $ng == $fn) {
			continue;
		}
		$siblings[] = $fn;
	}

	$ngline = get_ngline($ng);

	$charter = get_charter($ng);

	if ($charter == false) {
		# Substitute ...
		$charter = "No charter is available for this group, sorry!<br>\n";
	}

	# Now find out any votes related to this newsgroup

	$array = files_in_dir("$AUSADMIN_HOME/vote");
	$len = strlen($ng);

	foreach ($array as $fn) {
		if (strncmp($fn, $ng, $len)) {
			continue;
		}
		$vote_dirs[] = $fn;
	}

?>

<html>
 <head>
  <title>Newsgroup <?php echo $ng ?> </title>
 </head>
 <body>
  <table border="1" bgcolor="#ffffe0" cellspacing="0" cellpadding="3" width="98%">
   <tr>
    <td width="080" valign="top">
     <font size=-1>
      <?php require("ausadmin_hdr.inc"); ?>
      <?php
      # Were there any votes associated with this newsgroup?
        if ($vote_dirs) {
		echo "<b>Votes:</b><br>\n";
		foreach ($vote_dirs as $v) {
			echo "&nbsp;&nbsp;<a href=\"/cgi-bin/voteinfo.pl?vote=$v\">$v</a><br>\n";
		}
		echo "<br>\n";
	}


      	if ($siblings) {
		echo "<b>See Also:</b><br>\n";
		foreach ($siblings as $g) {
			echo "&nbsp;&nbsp;<a href=\"$SCRIPT_NAME/$g/\">$g</a><br>\n";
		}
	}
	?>

     </font>
    </td>
    <td>
     <center><h1><?php echo $ng ?></h1></center>
     <hr>
     <center><h2><?php echo $ngline ?></h2></center>
     <hr>
     <h3>Charter of <?php echo $ng ?></h3>
      <blockquote>
<?php echo $charter ?>
      </blockquote>
    </td>
   </tr>
  </table>

<hr>
All the debugging stuff goes below...<br>

      <?php 
              echo "Hi, I'm a PHP script!<br>\n"; 
	      echo "Your userid is ", posix_getuid(), "<br>\n";
	      echo "The vars are: REQUEST_METHOD=$REQUEST_METHOD<br>\n";
	      echo "&nbsp; QUERY_STRING=$QUERY_STRING<br>\n";
	      echo "&nbsp; SCRIPT_NAME=$SCRIPT_NAME<br>\n";
	      echo "&nbsp; REQUEST_URI=$REQUEST_URI<br>\n";

	      # var $x;
	      
	      echo "args[0] is $args[0]<br>\n";
	      echo "args[1] is $args[1]<br>\n";
	      echo "args[2] is $args[2]<br>\n";
	      echo "ng is $ng, parent is $parent<br>\n";

	      $x = apache_lookup_uri($REQUEST_URI);

	      echo "&nbsp; X=$x<br>\n";
	      $y = $x->path_info;
	      echo "&nbsp; Y=$y<br>\n";

	      $array = files_in_dir("$AUSADMIN_HOME/data/Newsgroups");

		echo "Here is the file list again:<br>\n";

		# foreach ($array as $fn) {
		# 	echo "Filename $fn<br>\n";
		# }

	      echo "survived to end!<br>\n";

      ?>
 </body>
</html>

