FROM alpine:3.8

ADD assets/ /opt/resource/
ADD itest/ /opt/itest/

# Install uuidgen
RUN apk add --no-cache ca-certificates curl bash jq util-linux
#Install grunt
RUN apk --update add openssh-client git nodejs  npm && rm -rf /var/cache/apk/* && \
    npm install -g grunt-cli

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


# Add CF Community Plugin Repo
RUN cf add-plugin-repo CF-Community https://plugins.cloudfoundry.org

# CF MultiApps Plugin
RUN cf install-plugin -f multiapps


# NPM Install of SAP Cloud MTA Build Required for our setup
RUN npm install -g mbt
