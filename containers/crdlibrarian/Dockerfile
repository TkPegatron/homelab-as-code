FROM ghcr.io/tkpegatron/alpine:rolling@sha256:6eb144f3b6059a88dd10fa6826d7c9992d380b5f6007918421b7992cfbb2ba03


RUN apk add --no-cache \
    kubectl nginx

# Install Python Dependancies
RUN pip3 install pyyaml

# Install yannh's OpenAPI2JSONSchema script
RUN curl https://raw.githubusercontent.com/yannh/kubeconform/master/scripts/openapi2jsonschema.py --output /usr/bin/openapi2jsonschema.py 2>/dev/null

COPY ./root/ /

EXPOSE 8080

ENTRYPOINT /usr/bin/entrypoint.sh
