# sidekiq_middlewares
[![Build Status](https://travis-ci.org/emartech/sidekiq_middlewares.svg?branch=master)](https://travis-ci.org/emartech/sidekiq_middlewares)

Ruby Sidekiq Middlewares For common uses

### Benchmarker

#### Optiosn
* logger
  * required
  * this will be the object that must respond to :info method
* formatter
  * optional
  * this proc will receive one argument, a message object which is a Hash type
  * If the logger can handle Hash messages, such as TwP's [logging](https://github.com/TwP/logging) libary, than you don't need this

first you need a logger that respond to :info method, and format the message object into an expected format.

For simplicity, in the example this will be json.
```ruby
require 'json'
require 'logger'
json_logger = Logger.new(STDOUT)
json_logger.formatter = proc do |severity, datetime, progname, msg|
  JSON.dump(msg) + "\n"
end
```

Than you can use it with the Benchmarker middleware like this:

```ruby
Sidekiq.configure_server do |config|
  config.redis = sidekiq_redis_config

  config.server_middleware do |chain|
    chain.add SidekiqMiddlewares::Benchmarker, logger: json_logger
  end
end
```

Or if you don't want to provide logger who also know about how to format, you can give an optional formatter to the middleware.

```ruby
Sidekiq.configure_server do |config|
  config.redis = sidekiq_redis_config

  config.server_middleware do |chain|
    chain.add SidekiqMiddlewares::Benchmarker, logger: Logger.new(STDOUT), formatter: proc { |m| JSON.dump(m) + "\n" }
  end
end
```
