FROM ghcr.io/tkpegatron/alpine:rolling@sha256:6c67d4c548c4e4c67b512c46b93287c1b749324fe692172c1da97bc3c2fb557d


RUN apk add --no-cache \
    kubectl nginx

# Install Python Dependancies
RUN pip3 install pyyaml

# Install yannh's OpenAPI2JSONSchema script
RUN curl https://raw.githubusercontent.com/yannh/kubeconform/master/scripts/openapi2jsonschema.py --output /usr/bin/openapi2jsonschema.py 2>/dev/null

COPY ./root/ /

EXPOSE 8080

ENTRYPOINT /usr/bin/entrypoint.sh
