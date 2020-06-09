FROM ubuntu:20.04
#Changed from 18.04 to 20.04
ARG DEBIAN_FRONTEND=noninteractive 
ADD assets/ /opt/resource/
ADD itest/ /opt/itest/

# Install uuidgen
RUN apt-get update
RUN apt-get install -y ca-certificates curl bash jq util-linux
#Install grunt
RUN apt-get install -y git nodejs npm node-grunt-cli


# Install Cloud Foundry cli
ADD "https://packages.cloudfoundry.org/stable?release=linux64-binary&source=github" /tmp/cf-cli.tgz
RUN mkdir -p /usr/local/bin && \
  tar -xzf /tmp/cf-cli.tgz -C /usr/local/bin && \
  cf --version && \
  rm -f /tmp/cf-cli.tgz && \
  rm -f /usr/local/bin/LICENSE && \
  rm -f /usr/local/bin/NOTICE



# Install cf cli Autopilot plugin
ADD https://github.com/contraband/autopilot/releases/download/0.0.8/autopilot-linux /tmp/autopilot-linux
RUN chmod +x /tmp/autopilot-linux && \
  cf install-plugin /tmp/autopilot-linux -f && \
  rm -f /tmp/autopilot-linux

# Install yaml cli
ADD https://github.com/mikefarah/yq/releases/download/2.3.0/yq_linux_amd64 /tmp/yq_linux_amd64
RUN install /tmp/yq_linux_amd64 /usr/local/bin/yq && \
  yq --version && \
  rm -f /tmp/yq_linux_amd64


#Download and Install MultiApp plugin
ADD https://github.com/cloudfoundry-incubator/multiapps-cli-plugin/releases/download/v2.4.1/mta_plugin_linux_amd64 /tmp/mta_plugin_linux_amd64
RUN chmod +x /tmp/mta_plugin_linux_amd64 && \
   cf install-plugin /tmp/mta_plugin_linux_amd64 -f && \
   rm -f /tmp/mta_plugin_linux_amd64

RUN cf install-plugin -r CF-Community html5-plugin -f

# NPM Install of SAP Cloud MTA Build Required for our setup
RUN npm config set @sap:registry https://npm.sap.com
RUN npm install -g mbt --unsafe-perm=true --allow-root
RUN npm install -g @ui5/cli --unsafe-perm=true --allow-root
