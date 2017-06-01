require 'benchmark'
require 'sidekiq_middlewares'

class SidekiqMiddlewares::Benchmarker

  def initialize(opts = {})
    @logger = opts[:logger] || raise(ArgumentError, 'missing keyword: logger')
    @formatter = opts[:formatter] || proc { |message| message }
  end

  def call(_worker, job, _queue, &next_middleware_call)
    measurement = Benchmark.measure(&next_middleware_call)
    @logger.info(@formatter.call(message_to_log(job, measurement)))
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
      'created_at' => job['created_at'],
      'enqueued_at' => job['enqueued_at']
    }
  end

  def results_by(measurement)
    { 'execution_time_sec' => measurement.real }
  end
end
