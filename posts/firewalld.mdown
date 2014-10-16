Categories: redhat
Tags: firewalld

## Add a rule to allow all traffic from a particular host

		firewall-cmd  --add-rich-rule='rule family="ipv4" source address="124.149.41.241" accept'

		firewall-cmd [--zone=<zone>] --remove-rich-rule='<rule>'

## Allow a service

		firewall-cmd --permanent --zone=public --add-service=http
		firewall-cmd --add-service=http



