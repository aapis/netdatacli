# Netdata::Client

`netdatacli` is a command line client intended to be run as a cron/launchd job.  It will check your servers every 2 minutes and give you a desktop notification if certain conditions exist.

This is a prototype.  It will be rebuilt as an OSX/iOS app at some point in the future.  Features I'm hoping to add at this stage include:

* Data aggregation between each report point (every 2 minutes).  So you don't just get a notification about what is happening right now, but also what happened since the last check in (if anything).
* More datapoints.  Currently it only supports system.cpu.
* Better architecture.

Installation:

    $ gem install netdata-client

## Usage

First, create `~/.netdatacli.yml`.  Populate it as follows.

```yml
instances:
    http://my.instance.tld:19999
    http://my.otherinstance.tld:19999
```

If you're using OSX > 10.4:

1. Rename `com.netdata.monitor.2mins.plist.dist` to `com.netdata.monitor.2mins.plist` and update the ProgramArguments value to point to where the gem lives (i.e. `/Library/Ruby/Gems/2.0.0`).
2. `cp com.netdata.monitor.plist /Library/LaunchDaemons`
3. `launchtl load -w /Library/LaunchDaemons/com.netdata.monitor.plist`

If using *nix:

1. Configure a cron job.
2. Profit.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aapis/netdata-client.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

