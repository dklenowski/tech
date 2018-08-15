Categories: openstack
Tags: terraform

    #!/bin/bash
    
    user="$1"
    
    export OS_REGION_NAME="<REGION>"
    export OS_AUTH_URL=https://keystone.<REGION>.com/v2.0
    export OS_TENANT_NAME="<TENANT>"
    export OS_PROJECT_NAME="<PROJECT>"
    export OS_USERNAME="$user"
    
    # With Keystone you pass the keystone password.
    echo "Please enter your OpenStack Password for ${user} : "
    read -sr OS_PASSWORD_INPUT
    export OS_PASSWORD=$OS_PASSWORD_INPUT