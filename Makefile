



export AWS_PROFILE=sms
export AWS_REGION=eu-west-1

ENVS = staging prod

check-env-%:
	@if echo $(ENVS) | grep -wq '$*'; \
	then echo "env: $*"; \
	else \
		echo "invalid env: $*"; \
		exit 2; \
	fi

CAPITALIZED_ENV=$(shell echo "$*" | awk '{print toupper(substr($$0, 1, 1)) substr($$0, 2)}')



CODEDEPLOY_ARTIFACT_BUCKET = sms-deploy-artifactbucket7410c9ef-mvbmhlsrh9on


API_DIR = ./

%/api/package: check-env-%
	@cd $(API_DIR); \
	python3 -m venv venv; \
	\
	source venv/bin/activate; \
	\
	pip install -r requirements.txt ; \
	\
	libsPath="`find ./venv -name site-packages`"; \
	\
	mkdir -p ./__$*-build; \
	\
	cp -r \
		 $$libsPath  \
		 ./main.py requirements.txt appspec_hooks.sh appspec.yml \
		 ./__$*-build;

%/api/release: check-env-%
	@cd $(API_DIR); \
	aws deploy push \
            --application-name SMS-AI \
            --description "This is a revision for the application Ai" \
            --s3-location s3://$(CODEDEPLOY_ARTIFACT_BUCKET)/Ai/$*/Ai-$(ver).zip \
            --source ./__$*-build

%/api/deploy: check-env-%
	@cd $(API_DIR); \
	out="`aws deploy create-deployment \
			--application-name SMS-AI \
            --deployment-group-name AiTo$(CAPITALIZED_ENV) \
			 --output json \
            --s3-location bucket=$(CODEDEPLOY_ARTIFACT_BUCKET),key=Ai/$*/Ai-$(ver).zip,bundleType=zip`"; \
	echo "$$out"; \
	aws deploy wait deployment-successful --cli-input-json "$$out"


FRONTEND_DIR = "./front"

%/front/package: check-env-%
	@cd $(FRONTEND_DIR) ; \
	yarn build-$*

%/front/deploy: check-env-%
	@cd $(FRONTEND_DIR) ; \
	aws s3 sync ./dist s3://sms-$*-front-bucket/ai-artifact \
