# Netdata::Client

`netdatacli` is a command line client intended to be run as a cron/launchd job.  It will check your servers every 2 minutes and give you a desktop notification if certain conditions exist.

This is very early stage software, it's just a proof of concept for now.  Features I'm hoping to add include:

* Data aggregation between each report point (every 2 minutes).  So you don't just get a notification about what is happening right now, but also what happened since the last check in (if anything).
* More datapoints.  Currently it only supports system.cpu.
* Better architecture.

Installation:

    $ gem install netdata-client

## Usage

If you're using OSX > 10.4:

1. Rename `com.netdata.monitor.plist.dist` to `com.netdata.monitor.plist` and update the ProgramArguments value to point to where the gem lives (i.e. `/Library/Ruby/Gems/2.0.0`).
2. `cp com.netdata.monitor.plist /Library/LaunchDaemons`.
3. `launchtl load -w /Library/LaunchDaemons/com.netdata.monitor.plist`

If using *nix:
1. Configure a cron job.
2. Profit.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/netdata-client.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

