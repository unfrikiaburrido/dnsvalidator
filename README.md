# dnsvalidator

This is a simple PowerShell script to validate DNS against a well known IP to see their reliability

Took the idea after I clicked on a link and noticed that parler.com was unavailable for me, but had returned to life couple of weeks ago

So there it is, it's not that I personally have an interest in this network it is just that i hate dumb DNS which don't know how to do their work, or, here comes the worst, neglect doing their work because they think that silently hiding some part of the internet to their users is the best way to protect them.

The way to run this is very very simple, just download the powershell edit the url to check and run it

```powershell
.\check_dns.ps1 >.\check_dns_25_feb.log
# see, it was simple ...
```

Note: i'd recommend to start little by little, i used https://public-dns.info/nameserver/es.txt my country DNS list

This script is so simple you can modify at will
