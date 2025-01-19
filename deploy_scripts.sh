export CLOUD_PLATFORM=${CLOUD_PLATFORM:-"aws"}
export PROV_OPS=${PROV_OPS:-"create"}
export PROV_COMPONENTID=${PROV_COMPONENTID:-"shaswatpoc-1234"}
export TF_VAR_secret_word=${SECRET_WORD:-"TwelveFactor"}

echo "CLOUD_PLATFORM: $CLOUD_PLATFORM"
echo "PROV_OPS: $PROV_OPS"
echo "PROV_COMPONENTID: $PROV_COMPONENTID"


if [ -z "$APP_IMAGE" ]; then
  echo "Environment variable APP_IMAGE is NOT set or is empty."
  exit 1
else
  echo "APP_IMAGE: $APP_IMAGE"
  echo "Environment variable APP_IMAGE is set to ${APP_IMAGE}."
fi

if [ "$CLOUD_PLATFORM" == "aws" ]
then
    echo "Start AWS config container"
    export AWS_REGION=${AWS_REGION:-"us-east-1"}
    export TF_VAR_region=${AWS_REGION:-"us-east-1"}
    export TF_VAR_cloud_account_id=$(aws sts get-caller-identity --query Account --output text)
    
    export TF_VAR_app_docker_image=${APP_IMAGE}
    export tf_work_dir="./infrastructure/aws"

    #Add your IP which you want to allow to access the instance
    export TF_VAR_public_ip_allowed="49.37.117.223/32"

    export tf_bucket="${tf_bucket:-${TF_VAR_tc_account_id}-shaswatpoc-terraform}"
    echo "Checking S3 Bucket state $tf_bucket ..."
    
    if aws s3api head-bucket --bucket "$tf_bucket" 2>/dev/null; then
        echo "S3 bucket $tf_bucket already exists"
    else
        if [ "$AWS_REGION" == "us-east-1" ]; then
            aws s3api create-bucket --bucket $tf_bucket || true
        else
            aws s3api create-bucket --bucket $tf_bucket --create-bucket-configuration LocationConstraint=$TF_VAR_region || true
        fi
    fi
elif [ "$CLOUD_PLATFORM" == "gcp" ]
then 
    echo "Not yet developed"
    exit 1
else
    echo "Not configure $CLOUD_PLATFORM variable"
    exit 1
fi

generate_certs() {
  echo "Managing certs..."

  SECRET_NAME="shaswatpoc"
  SECRET_KEY_EXISTS=$(aws secretsmanager get-secret-value --secret-id $SECRET_NAME-key --output text  2>/dev/null)
  SECRET_CERT_EXISTS=$(aws secretsmanager get-secret-value --secret-id $SECRET_NAME-cert --output text  2>/dev/null)

  if [[ "$PROV_OPS" == "create" || "$PROV_OPS" == "plan" ]]
  then
      echo "Create certs if not there..."
      if [ -z "$SECRET_KEY_EXISTS" ] && [ -z "$SECRET_CERT_EXISTS" ]; then
          echo "Creating certs..."
          openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -sha256 -days 3650 -nodes -subj "/C=IN/ST=OD/L=BBI/O=KS/OU=POC/CN=shaswatpoc-nodeapp.local"
          aws secretsmanager create-secret --name $SECRET_NAME-key --secret-string file://key.pem
          aws secretsmanager create-secret --name $SECRET_NAME-cert --secret-string file://cert.pem
          rm key.pem cert.pem
      else
          echo "Secret already exists."
      fi

  elif [ "$PROV_OPS" == "delete" ]
  then
      echo "Deleting certs if not there..."
      if [ "$SECRET_KEY_EXISTS" ] && [ "$SECRET_CERT_EXISTS" ]; then
          aws secretsmanager delete-secret --secret-id $SECRET_NAME-key --force-delete-without-recovery
          aws secretsmanager delete-secret --secret-id $SECRET_NAME-cert --force-delete-without-recovery
      else
          echo "Secrets not exists."
      fi
  else
    echo "PROV_OPS is not defined!"
    exit 1
  fi
}

tf_workspace() {
  tf_workspaces=$(terraform -chdir=${tf_work_dir} workspace list)
  if [[ "${tf_workspaces}" == *"${PROV_COMPONENTID}"* ]]; then
    echo "select workspace $PROV_COMPONENTID"
    terraform -chdir=${tf_work_dir} workspace select "${PROV_COMPONENTID}"
  else
    echo "create new workspace $PROV_COMPONENTID"
    terraform -chdir=${tf_work_dir} workspace new "${PROV_COMPONENTID}"
  fi

}

tf_init() {
  if [ "$CLOUD_PLATFORM" == "aws" ]
  then
      terraform -chdir=${tf_work_dir} init -migrate-state -force-copy -backend-config="encrypt=true" -backend-config="bucket=${tf_bucket}"  -backend-config="key=terraform.tfstate"  -backend-config="region=${TF_VAR_region}"
      
      tf_workspace
      if [ "$?" != 0 ];then echo "terraform init failed"; exit 1;fi
  elif [ "$CLOUD_PLATFORM" == "gcp" ]
  then
    echo "Not yet developed"
    exit 1
  fi
}

tf_plan() {
  generate_certs
  env | grep -i TF_VAR
  terraform -chdir=${tf_work_dir} plan -input=false
}


tf_apply() {
  generate_certs
  terraform -chdir=${tf_work_dir} apply -input=false -auto-approve
  if [ "$?" != 0 ];then echo "terraform applied failed"; exit 1;fi
}

tf_destroy() {
  export tf_bucket="${tf_bucket:-${TF_VAR_tc_account_id}-shaswatpoc-terraform}"
  echo "Bucket: $tf_bucket"
  terraform -chdir=${tf_work_dir} destroy -input=false -auto-approve
  if [ "$?" != 0 ];then echo "terraform destroy failed"; exit 1;fi
  if [ "$CLOUD_PLATFORM" == "aws" ]
  then 
    if aws s3api head-bucket --bucket "$tf_bucket" 2>/dev/null; then
      echo "S3 bucket $tf_bucket already exists"
      aws s3api delete-object --bucket $tf_bucket --key terraform.tfstate
      aws s3api delete-bucket --bucket $tf_bucket || true
    fi
  fi
  generate_certs  
}

if [[ "$PROV_OPS" == "create" || "$PROV_OPS" == "upgrade" ]]
then
   echo "Provision  $PROV_COMPONENTID"
   tf_init
   tf_apply

elif [ "$PROV_OPS" == "delete" ]
then
    echo "Deprovision  $PROV_COMPONENTID"
    tf_init
    tf_destroy
elif [ "$PROV_OPS" == "plan" ]
then
    echo "Planning  $PROV_COMPONENTID"
    tf_init
    tf_plan
else
  echo "PROV_OPS is not defined!"
  exit 1
fi
