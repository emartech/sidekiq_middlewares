module SidekiqMiddlewares
  class ErrorLogger
    def initialize(opts = {})
      @logger = opts[:logger] || raise(ArgumentError, 'missing keyword: logger')
      @formatter = opts[:formatter] || proc { |message| message }
    end

    def call(*_args)
      begin
        yield
      rescue => ex
        @logger.error(@formatter.call(ex))
        raise
      end
    end
  end
end
