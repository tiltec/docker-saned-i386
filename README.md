# docker-saned-i386, customized for EPSON Perfection 3170 Photo
Dockerized saned scanner server. Originally based on [sesceu/docker-saned](https://github.com/sesceu/docker-saned), but changed to use [Debian stable](https://debian.org) and [runit](http://smarden.org/runit/) instead.

## Usage
Make sure that the device node e.g. `/dev/usb/00x/` has group id 7 (lp) and group read access.

### Environment variables:
  * SANED_ACL: (***required***) IP ranges or hosts that are allowed access to the daemon.
  * SANED_DLL: (*optional*) Add this dll to /etc/sane.d/dll.conf with these values for faster response

### Ports
This container exposes ports 6566 (saned), 10000 and 10001 (data ports)

### Running

Run as:
```
docker run -v /dev/bus/usb:/dev/bus/usb --privileged -e SANED_ACL="192.168.0.0/24" SANED_DLL=epkowa tiltec/docker-saned-i386
```

### Logging

saned logs are put in `/var/log/saned` using svlog.