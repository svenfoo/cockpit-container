FROM fedora:22
MAINTAINER "Stef Walter" <stefw@redhat.com>

# HACK: DNF is unreliable and disconnects from mirrors all the time
RUN dnf install -y yum
RUN yum-deprecated -y update && yum-deprecated install -y sed

ENV VERSION 0.67
ENV RELEASE 1

# Get this specific version of cockpit-ws
RUN yum-deprecated install -y https://kojipkgs.fedoraproject.org/packages/cockpit/$VERSION/$RELEASE.fc22/x86_64/cockpit-ws-$VERSION-$RELEASE.fc22.x86_64.rpm && yum-deprecated clean all

# And the stuff that starts the container
RUN mkdir -p /container && ln -s /host/proc/1 /container/target-namespace
ADD atomic-install /container/atomic-install
ADD atomic-uninstall /container/atomic-uninstall
ADD atomic-run /container/atomic-run
RUN chmod -v +x /container/atomic-install
RUN chmod -v +x /container/atomic-uninstall
RUN chmod -v +x /container/atomic-run

# Make the container think it's the host OS version
RUN rm -f /etc/os-release /usr/lib/os-release && ln -sv /host/etc/os-release /etc/os-release && ln -sv /host/usr/lib/os-release /usr/lib/os-release

LABEL INSTALL /usr/bin/docker run -ti --rm --privileged -v /:/host IMAGE /container/atomic-install
LABEL UNINSTALL /usr/bin/docker run -ti --rm --privileged -v /:/host IMAGE /cockpit/atomic-uninstall
LABEL RUN /usr/bin/docker run -d --privileged --pid=host -v /:/host IMAGE /container/atomic-run --local-ssh

# Look ma, no EXPOSE

CMD ["/container/atomic-run"]
