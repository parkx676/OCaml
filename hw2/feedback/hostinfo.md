# Part 1, `hostinfo.ml`: 
```
## tld
Test with input IP (1,2,3,4) correctly resulted in None.
Test with input DNSName a.b correctly resulted in Some b.
Test with input DNSName a.b.c correctly resulted in Some c.
Test with input DNSName a.b.c.d correctly resulted in Some d.
Test with input DNSName a.b.c.d.e correctly resulted in Some e.
Test with input DNSName aaaaa.b.ccc.dddddd.ee.ffffffff correctly resulted in Some ffffffff.
Test with input DNSName 123.456.789.123.456.789 correctly resulted in Some 789.
Test with input DNSName the.world.is.on.fire.and.you.are.here.to.stay.and.burn.with.me correctly resulted in Some me.
```