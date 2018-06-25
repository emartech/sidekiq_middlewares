module SidekiqMiddlewares
  class Benchmarker

    def initialize(opts = {})
      @logger = opts[:logger] || raise(ArgumentError, 'missing keyword: logger')
      @formatter = opts[:formatter] || proc { |message| message }
    end

    def call(_worker, job, _queue)
      start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      yield
    ensure
      elapsed_time = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time
      @logger.info(@formatter.call(message_to_log(job, elapsed_time)))
    end

    private

    def message_to_log(job, measurement)
      base_by(job).merge(results_by(measurement))
    end

    def base_by(job)
      {
        'jid' => job['jid'],
        'queue' => job['queue'],
        'worker_class' => job['class'],
        'args' => job['args'].inspect,
        'created_at' => job['created_at'],
        'enqueued_at' => job['enqueued_at']
      }
    end

    def results_by(elapsed_time)
      {'execution_time_sec' => elapsed_time}
    end
  end
end
