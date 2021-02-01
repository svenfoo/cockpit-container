FROM registry.fedoraproject.org/fedora:33
LABEL maintainer="cockpit-devel@lists.fedorahosted.org"
LABEL VERSION=242

ARG VERSION=242

ADD . /container

# Again see above ... we do our branching in shell script
RUN /container/install-package.sh && /container/prep-container.sh

LABEL INSTALL="/usr/bin/docker run --rm --privileged -v /:/host IMAGE /container/atomic-install IMAGE"
LABEL UNINSTALL="/usr/bin/docker run --rm --privileged -v /:/host IMAGE /container/atomic-uninstall"
LABEL RUN="/usr/bin/docker run -d --name NAME --privileged --pid=host -v /:/host IMAGE /container/atomic-run --local-ssh"

# Look ma, no EXPOSE

CMD ["/container/atomic-run"]
