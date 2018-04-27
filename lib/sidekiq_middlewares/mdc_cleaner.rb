module SidekiqMiddlewares
  class MdcCleaner
    def call(*_args)
      Logging.mdc.clear if defined? Logging
      yield
    end
  end
end
