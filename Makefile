setup:
	echo "setting up the environment"	

build_app_image:
	docker build -t shaswatpoc .

push_app_image:
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/XYZ
	docker tag shaswatpoc:latest public.ecr.aws/XYZ/shaswatpoc:2.0.0
	docker push public.ecr.aws/XYZ/shaswatpoc:2.0.0

setup_app_image: build_app_image push_app_image

tf_init:
	export PROV_OPS=plan export SECRET_WORD=TwelveFactor && bash deploy_script.sh

tf_plan:
	echo "Running terraform plan"
	export APP_IMAGE="public.ecr.aws/XYZ/shaswatpoc:2.0.0" export PROV_OPS=plan export SECRET_WORD=TwelveFactor && bash deploy_script.sh

tf_apply:
	echo "Running terraform apply"
	export APP_IMAGE=${APP_IMAGE} export PROV_OPS=create export SECRET_WORD=TwelveFactor && bash deploy_script.sh

tf_destroy:
	export APP_IMAGE="public.ecr.aws/XYZ/shaswatpoc:2.0.0" export PROV_OPS=delete export SECRET_WORD=TwelveFactor && bash deploy_script.sh
