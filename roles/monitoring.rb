name "monitoring"
description "Nagios server"
run_list(
"recipe[apt]",
"recipe[nagios::default]"
)
default_attributes(
"nagios" => {
"server_auth_method" => "htauth"
}
)
