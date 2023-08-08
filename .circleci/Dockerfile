FROM cimg/openjdk:11.0-node
# alternative: FROM cimg/openjdk:11.0.20-node

## install aio-cli https://github.com/adobe/aio-cli
RUN sudo npm install -g @adobe/aio-cli
RUN aio telemetry off # prevent AIO to be interactive and fail with exit code 0! this breaks the build
RUN aio plugins:install @adobe/aio-cli-plugin-cloudmanager
RUN aio plugins:install @adobe/aio-cli-plugin-aem-rde
RUN aio plugins:update


## install the cli for the Adobe internal validations API
RUN curl -L https://github.com/andresbott/aem-guides-wknd/releases/download/poc-eaas/eaas-next-linux-amd64-snapshot-01ecce5164ed  --output eaas && \
  chmod +x ./eaas && \
  sudo mv ./eaas /usr/local/bin/eaas