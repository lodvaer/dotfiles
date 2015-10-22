journ() {
	vim ~/txt/logs/journal/`date +%F`.mkd
}
bdump() {
	vim ~/txt/logs/braindumps/`date +%F`_`echo -n $@ | tr -c 'a-zA-Z' '_'`.mkd
}
