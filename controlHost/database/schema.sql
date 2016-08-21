  create table guests(
    guest_id integer primary key,
    guest_name text,
		owner text,
    guest_size integer,
    guest_status text,
    host_id integer
	);
		
  create table hosts(
    host_id integer primary key,
    host_name text,
    guest_count integer,
    host_amount_size integer
	);

  create table keys(
    guest_id integer, 
    guest_keyinfo text
	);

  create table ip_nic_relations(
    guest_id integer, 
    guest_ipaddr text,
    guest_macaddr text
	);
	
  create table clients(
    customer_id integer primary key,
    owner text
	);
