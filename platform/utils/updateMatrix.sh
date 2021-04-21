#!/bin/bash
while : 
do
	now=`date`
	echo "Connectivity matrix last pulled at $now"
	sudo docker cp MATRIX:/home/matrix.html /var/www/conmatrix.com/html/matrix.html 
	sleep 1000 
done

