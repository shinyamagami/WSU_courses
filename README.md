
# WSU In Person

Welcome to WSU_In_Person gem!

This gem was supposed to collect all the "WEB ARR" classes but all classes
go online so now it lists up all the classes.

ICE tried to force international students to take, at least, one in-person class. Personally, I don't mind it at all, but everyone has different views.

Hope it helps.


All non "WEB ARR" classes are in the csv file.
Please run "ruby main.rb" when you want a newer csv file.
I don't know the definitions of in-person class and WEB ARR classes.
So please don't trust this list.


Currently, this gem does not know how to deal with "301 Moved Permanently".



<!--
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'WSU_In_Person'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install WSU_In_Person

-->

## Usage


Run "ruby main.rb" and it display the list of in-person classes.

Choose a campus and it retreive the latest schedule. They hide schedules in the past but you can see them here in the output folder.



This was before
It only exclude "WEB ARR" classes and I am not sure if it is counted as in-person or not yet. Any classes with "ARR ARR" or a room location will be displayed, I believe.










<!--
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
-->
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/WSU_In_Person.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
