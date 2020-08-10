
# Client-side authentication configuration for nginx

### 1) Create new ca

Run new_ca.sh 'ca_name'


### 2) Create client certificate

Run new_ca.sh 'ca_name' 'client-certifiacate-name' 'mail_to'

If you want to get cert by email you had to install mutt and configurate mta, otherwise just comment last string at script.


### 3) To revoke 

Run revoke.sh 'ca_name' 'client-certifiacate-name'


### 4) Nginx Config

#path to ca

ssl_client_certificate /etc/nginx/ssl/'ca_name'/certs/ca.crt;

#path to revoke crl

ssl_crl /etc/nginx/ssl/'ca_name'/private/ca.crl;

ssl_verify_client optional;

ssl_verify_depth 1;

if ($ssl_client_verify != SUCCESS) {

        return 403;
        
        }
