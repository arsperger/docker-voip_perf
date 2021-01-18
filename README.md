# VoIP_Perf Docker edition

This repo is a fork of [Voip_perf docker](https://github.com/jchavanton/voip_perf) with a small customization.

I found this tool very useful for performing a simple load tests in the scenarios where moving of RTP packets is not necessary.

For example in cases where you need to test anti-flood protection script (eg. Kamailio mod pike + fail2ban) or  performance of your back-end infrastructure (eg. dynamic configuration lookup, processing CDRs, etc).

### clone and build

```
git clone https://github.com/arsperger/docker-voip_perf
cd docker-voip_perf
make build
```

### use it

Send 10 INVITE requests to sip:12345678@123.456.78.99 with rate 5 call per sec.

```
docker run -rm --net=host voip_perf client 12345678 123.456.78.99 10 5
```

Print help to check available scripts
```
docker run -rm --net=host voip_perf help
```