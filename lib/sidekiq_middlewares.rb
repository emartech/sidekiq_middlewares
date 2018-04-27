require "sidekiq_middlewares/version"

module SidekiqMiddlewares
  autoload :Benchmarker, "sidekiq_middlewares/benchmarker"
  autoload :MdcCleaner, "sidekiq_middlewares/mdc_cleaner"
end
