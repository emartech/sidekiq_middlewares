module SidekiqMiddlewares
  class ErrorLogger
    def initialize(logger)
      @logger = logger
    end

    def call(*_args)
      begin
        yield
      rescue => ex
        @logger.error ex
        raise
      end
    end
  end
end
