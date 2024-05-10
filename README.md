# POP Engine

API wrapper rubygem for the SMG's [POP Engine™ API](https://pop.selfmgmt.com/docs/partner_api/pop-api-internal-partner-documentation.html) v1.0.

Learn more about [POP Engine™](https://pop.selfmgmt.com/about.html?page=pop-engine) and [SMG](https://www.selfmgmt.com/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pop_engine'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pop_engine

## Usage

To access the API, you'll need to create a `PopEngine::Client` and pass in your credentials.

```ruby
client = PopEngine::Client.new(username: ENV['POP_ENGINE_USERNAME'],
                               password: ENV['POP_ENGINE_PASSWORD'])
```

### Client Options

The gem is using Faraday as the HTTP client. You can pass in a different Faraday adapter if you'd like. The default is `net_http`.
You can also pass a different default language for assessments. The default is `eng` (English).

```ruby
client = PopEngine::Client.new(username: ENV['POP_ENGINE_USERNAME'],
                               password: ENV['POP_ENGINE_PASSWORD'],
                               adapter: :httpclient, language_id: 'fra')
```

The client gives you access to each of the resources.

## Resources

The gem tries to map closely to the POP Engine™ API so you can easily convert API examples to gem code. The gem also offers some
more friendly aliases for certain attributes.

Responses are created as objects like `PopEngine::Assessment`. Having types like `PopEngine::Question` is handy for 
understanding what type of object you're working with. They're built using OpenStruct so you can easily access data in a
Ruby-ish way.

All calls to the API already include the mandatory `command` and `partner_api` parameters. No need to include them in your calls.

#### Pagination

`list` endpoints return pages of results. The result object `PopEngine::Collection` will have a `data` key to access the
results, `count` with the number of results on the page, as well as `next_cursor` with metadata for retrieving next pages.
You may specify the page size with the `max_count` parameter (or its alias `page_size`).

To retrieve the next page, pass the parameters stored in `next_cursor` hash to the subsequent call to the `list` method.

```ruby
page1 = client.assessments.list(per_page: 10)
#=> PopEngine::Collection

page1.count
#=> 10

page1.data
#=> [#<PopEngine::Assessment>, #<PopEngine::Assessment>, ...]

page1.next_cursor
#=> {:assessment_id=>"989", :account_id=>"391", :date=>"2024-05-01"}
# These are friendly aliases.
# Will be converted to the correct API param names when passed to the next call.

page2 = client.assessments.list(per_page: 10, **page1.next_cursor) if page1.next_cursor
#=> PopEngine::Collection
```

### Assessments

```ruby
client.assessments.retrieve('id')
client.assessments.links('id')
client.assessments.scores('id')
client.assessments.list
client.assessments.create(position_id: 'id',
                          fields: { email: 'email', app_full_name: 'name' })

# If giving only the required 'fields' (email and app_full_name),
# you can drop the 'fields' hash.
client.assessments.create(position_id: 'id', email: 'email', app_full_name: 'name')

# This works as well
client.assessments.create(position_id: 'id', email: 'email', app_full_name: 'name',
                          fields: { job_application_id: 'ja_id' })

client.assessments.create(position_id: 'id',
                          fields: { email: 'email', app_full_name: 'name', job_id: 'jid' })

# Or use gem's attrib names aliases (which are perhaps more clear/readable)
client.assessments.create(assessment_type_id: 'id',
                          candidate_email: 'email', candidate_name: 'name')

client.assessments.create(assessment_type_id: 'id',
                          candidate_email: 'email', candidate_name: 'name',
                          fields: { job_id: 'jid' })
```

### Assessment Types
    
```ruby
client.assessment_types.list
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/talentnest/pop-engine/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

When adding methods, add to the list of definitions in lib/pop_engine.rb. Additionally, write a spec and add the new method to the list in the README.

Bug reports and pull requests are welcome on GitHub at https://github.com/talentnest/pop_engine.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
