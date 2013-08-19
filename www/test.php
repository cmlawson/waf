<?php
// Create connection
$con = mysql_connect('server47.web-hosting.compact:21098','whiccleu_colin','Spotistic8')
  or die('could not connect to db' . mysql_error() );

echo 'connected successfully!';

mysql_select_db('whiccleu_main') or die('Could not select db' . mysql_error());

$sql       = 'INSERT INTO pet'.
             '(name, birth, sex) '.
             'VALUES ("karl", "1975-01-01", "m" )';

// $retval = mysql_query( $sql, $con );
// if (! $retval )
// {
//   die('could not enter data' . mysql_error());
// }

// echo "Entered data successfully";

mysql_close($con);

?>
