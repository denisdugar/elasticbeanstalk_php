#!/bin/bash

export db_admin=$(sed -n '1p' /home/ec2-user/creds)
export db_pass=$(sed -n '2p' /home/ec2-user/creds)
export db_endpoint=$(sed -n '3p' /home/ec2-user/creds)

mysql -u $db_admin -h $db_endpoint -p$db_pass -e 
"select id from information_schema.processlist where command = 'Query' and time > 15" | 
while read id;
do
     if [["id" == "$id"]] 
     then 
        continue
    fi
    echo "kill $id";
    mysql -u $db_admin -h $db_endpoint -p$db_pass -e "kill $id";
done

