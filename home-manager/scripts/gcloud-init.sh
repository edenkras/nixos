#set -euo pipefail
#gitlab_domain="code.zeekit.co"
#token="g72azTjXxk55Y9fUyY4s"
#
#svc_account_map=$(curl -sS --header "PRIVATE-TOKEN: $token" "https:/$gitlab_domain/api/v4/admin/ci/variables" | jq -rc '.[] | select(.key | contains("svc")) | .key + "=" + (.value | @sh)')
#eval "$svc_account_map"
#
#key_file_base_path="$HOME/walmart/.svc"
#mkdir -p $key_file_base_path
#for var_name in "${!svc_deploy_mgmt_@}"; do
#        declare -n var_value=$var_name
#        key_file_path="$key_file_base_path/$var_name.json"
#        echo "$var_value" >"$key_file_path"
#        env=$(echo ${var_name##*_})
#        project=zeekit-$env
#        gcloud config configurations delete $project --quiet || true
#        gcloud config configurations create $project --no-activate
#        gcloud --configuration $project auth activate-service-account --key-file "$key_file_path"
#        gcloud --configuration $project config set project $project
#done
gcloud config configurations list
