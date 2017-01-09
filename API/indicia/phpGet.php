<?php
	$host='localhost';
	$user='root';
	$password='';
	
	$connection = mysql_connect($host,$user,$password);
	
	if(!$connection){
		die('Connection Failed');
	}
	else{
		$dbconnect = @mysql_select_db('indicia', $connection);
		
		if(!$dbconnect){
			die('Could not connect to Database');
		}
		else{
			$query = 'SELECT * FROM employees ORDER BY id DESC LIMIT 0,1';
			$resultset = mysql_query($query, $connection);
			
			$records = array();
			
			while($r = mysql_fetch_assoc($resultset)){
				$records = $r;
			}
			
			echo json_encode($records);
		}
	}
?>