PROTOCOL=https
KEYCLOAK_DOMAIN=keycloak.domain.tld
KEYCLOAK_ADMIN_PASSWORD=admin
NAME="user"
ACCOUNTS=30 # THE AMOUNT OF ACCOUNTS YOU WISH TO CREATE

# Get access token
KEYCLOAK_TOKEN=$(curl -s --insecure --location --request POST "$PROTOCOL://$KEYCLOAK_DOMAIN/auth/realms/master/protocol/openid-connect/token" \
--header "Content-Type: application/x-www-form-urlencoded" \
--data-urlencode "username=admin" \
--data-urlencode "password=$KEYCLOAK_ADMIN_PASSWORD" \
--data-urlencode "grant_type=password" \
--data-urlencode "client_id=admin-cli" | jq -r .access_token)

echo $KEYCLOAK_TOKEN

for i in $(eval echo {1..$ACCOUNTS})
do
    NEW_USER_USERNAME=$NAME$(($i))
    NEW_USER_FIRSTNAME=$NEW_USER_USERNAME
    NEW_USER_LASTNAME=$NEW_USER_USERNAME
    NEW_USER_EMAIL="$NEW_USER_USERNAME@mail.com"
    NEW_USER_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 8 ; echo '')
    NEW_USER_ATTRIBUTE_ROLE=essim
    ROLE_NAME=Editor

    echo $NEW_USER_USERNAME
    echo $NEW_USER_PASSWORD

    # Create new user
    curl -s --insecure --location --request POST "$PROTOCOL://$KEYCLOAK_DOMAIN/auth/admin/realms/esdl-mapeditor/users" \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer $KEYCLOAK_TOKEN" \
    --data-raw "{\"firstName\":\"$NEW_USER_FIRSTNAME\",\"lastName\":\"$NEW_USER_LASTNAME\",\"email\":\"$NEW_USER_EMAIL\",\"enabled\":true,\"username\":\"$NEW_USER_USERNAME\",\"emailVerified\":true}"

    # Get new user's ID
    USER_ID=$(curl -s --insecure --location --request GET "$PROTOCOL://$KEYCLOAK_DOMAIN/auth/admin/realms/esdl-mapeditor/users?username=$NEW_USER_USERNAME" \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer $KEYCLOAK_TOKEN" | jq -r .[0].id)

    # Set new user password
    curl -s --insecure --location --request PUT "$PROTOCOL://$KEYCLOAK_DOMAIN/auth/admin/realms/esdl-mapeditor/users/$USER_ID/reset-password" \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer $KEYCLOAK_TOKEN" \
    --data-raw "{\"type\":\"password\",\"value\":\"$NEW_USER_PASSWORD\",\"temporary\":false}"

    # Add attribute to new user
    curl -s --insecure --location --request PUT "$PROTOCOL://$KEYCLOAK_DOMAIN/auth/admin/realms/esdl-mapeditor/users/$USER_ID" \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer $KEYCLOAK_TOKEN" \
    --data-raw "{\"attributes\":{\"role\":\"$NEW_USER_ATTRIBUTE_ROLE\"}}"

    # Get client ID
    CLIENT_ID=$(curl -s --insecure --location --request GET "$PROTOCOL://$KEYCLOAK_DOMAIN/auth/admin/realms/esdl-mapeditor/clients?clientId=essim-dashboard" \
    --header "Authorization: Bearer $KEYCLOAK_TOKEN" | jq -r '.[0].id')

    # Get role ID
    ROLE_ID=$(curl -s --insecure --location --request GET "$PROTOCOL://$KEYCLOAK_DOMAIN/auth/admin/realms/esdl-mapeditor/clients/$CLIENT_ID/roles" \
    --header "Authorization: Bearer $KEYCLOAK_TOKEN" | jq -r --arg role "$ROLE_NAME" '.[] | select(.name == $role) | .id')

    # Assign role to user
    curl -s --insecure --location --request POST "$PROTOCOL://$KEYCLOAK_DOMAIN/auth/admin/realms/esdl-mapeditor/users/$USER_ID/role-mappings/clients/$CLIENT_ID" \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer $KEYCLOAK_TOKEN" \
    --data-raw "[{\"id\":\"$ROLE_ID\",\"name\":\"$ROLE_NAME\",\"composite\":false}]"
done