require "sidekiq_middlewares/version"

module SidekiqMiddlewares
  autoload :Benchmarker, "sidekiq_middlewares/benchmarker"
  autoload :ErrorLogger, "sidekiq_middlewares/error_logger"
  autoload :MdcCleaner, "sidekiq_middlewares/mdc_cleaner"
end
