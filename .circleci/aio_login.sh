#!/bin/bash
# moving login step to a bash script to ease readability of the pipeline code

echo "${SERVICE_ACCOUNT_PRIVATE_KEY_B64}" | base64 -d > private.key

# prevent aio to ask questions
aio telemetry off

aio config:set ims.contexts.aio-cli-plugin-cloudmanager.client_id "${SERVICE_ACCOUNT_CLIENT_ID}"
aio config:set ims.contexts.aio-cli-plugin-cloudmanager.client_secret "${SERVICE_ACCOUNT_CLIENT_SECRET}"
aio config:set ims.contexts.aio-cli-plugin-cloudmanager.technical_account_id "${SERVICE_ACCOUNT_TECH_ACCOUNT_ID}"
aio config:set  --json ims.contexts.aio-cli-plugin-cloudmanager.meta_scopes '["ent_cloudmgr_sdk"]'
aio config:set ims.contexts.aio-cli-plugin-cloudmanager.ims_org_id "${SERVICE_ACCOUNT_ORG_ID}"
aio config:set ims.contexts.aio-cli-plugin-cloudmanager.private_key  private.key --file

aio auth login --ctx=aio-cli-plugin-cloudmanager > login.log

# configure coordinates
aio config:set cloudmanager_orgid  "${SERVICE_ACCOUNT_ORG_ID}"
aio config:set cloudmanager_programid "${PROGRAM_ID}"
aio config:set cloudmanager_environmentid "${ENVIRONMENT_ID}"