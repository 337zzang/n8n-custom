# n8n Custom Dockerfile for Business Automation
# Version: 2.0.0-enterprise

FROM n8nio/n8n:2.0.0

# 환경변수 설정
ENV NODE_FUNCTION_ALLOW_BUILTIN=*
ENV NODE_FUNCTION_ALLOW_EXTERNAL=axios,lodash,moment,dayjs,cheerio,node-fetch,uuid,crypto-js,xml2js,fast-xml-parser,papaparse,xlsx,pdf-lib,handlebars,jsonwebtoken,archiver,jszip,dotenv,qs,form-data,date-fns,validator,marked,qrcode
ENV N8N_DIAGNOSTICS_ENABLED=false
ENV EXECUTIONS_DATA_PRUNE=true
ENV EXECUTIONS_DATA_MAX_AGE=168
ENV GENERIC_TIMEZONE=Asia/Seoul

USER root

# npm 패키지 설치
WORKDIR /usr/local/lib/node_modules/n8n

RUN npm install --save --legacy-peer-deps \
    axios@1.6.0 \
    node-fetch@2.7.0 \
    form-data@4.0.0 \
    qs@6.11.2 \
    lodash@4.17.21 \
    moment@2.30.1 \
    moment-timezone@0.5.45 \
    dayjs@1.11.10 \
    date-fns@3.3.1 \
    validator@13.11.0 \
    uuid@9.0.1 \
    cheerio@1.0.0-rc.12 \
    fast-xml-parser@4.3.4 \
    xml2js@0.6.2 \
    papaparse@5.4.1 \
    xlsx@0.18.5 \
    pdf-lib@1.17.1 \
    archiver@6.0.1 \
    jszip@3.10.1 \
    crypto-js@4.2.0 \
    jsonwebtoken@9.0.2 \
    handlebars@4.7.8 \
    marked@11.2.0 \
    dotenv@16.4.1 \
    qrcode@1.5.3

USER node
WORKDIR /home/node

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:5678/healthz || exit 1

EXPOSE 5678
