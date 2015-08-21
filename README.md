# Cockpit Web Service Container

Some operating systems (like Atomic Host) contain parts of Cockpit
but not the Web Service.

This privileged container is useful to run the Cockpit Web Service
and use Cockpit on the host.

     $ sudo atomic run cockpit/ws

### Development

 * [Cockpit Code](https://github.com/cockpit-project/cockpit)
