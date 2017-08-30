payload=$(mktemp $TMPDIR/bosh-deployment-event-resource-request.XXXXXX)

cat > ${payload} <&0
BOSH_ENVIRONMENT="$(jq -r '.source.target // ""' < ${payload})"
BOSH_CLIENT="$(jq -r '.source.client // ""' < ${payload})"
BOSH_CLIENT_SECRET="$(jq -r '.source.client_secret // ""' < ${payload})"
BOSH_CA_CERT="$(jq -r '.source.ca_cert // ""' < ${payload})"
export BOSH_ENVIRONMENT
export BOSH_CLIENT
export BOSH_CLIENT_SECRET
export BOSH_CA_CERT

if [[ -z "${BOSH_ENVIRONMENT}" || -z "${BOSH_CLIENT}" || -z "${BOSH_CLIENT_SECRET}" || -z "${BOSH_CA_CERT}" ]]; then
  echo >&2 "must specify target, client, client_secret and ca_cert"
  exit 1
fi

excluded_deployments=$(jq -r '.source.excluded_deployments // "[]"' < ${payload})
export excluded_deployments

current_version=$(jq -r '.version.last_event // "0"' < ${payload})
previous_backup=$(jq -r '.version.previous_backup // "0"' < ${payload})
