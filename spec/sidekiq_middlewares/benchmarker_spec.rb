require 'logger'
require 'yaml'

RSpec.describe SidekiqMiddlewares::Benchmarker do
  subject(:middleware) { described_class.new(opts) }
  let(:opts) { { logger: logger } }
  let(:logger) { instance_double(Logger) }

  define :log_with do |logger, level, message|
    supports_block_expectations

    match do |actual|
      expect(logger).to receive(level).with(message)
      execute_with_error_handling(&actual)
      true
    end

    def execute_with_error_handling
      yield
    rescue
      nil
    end
  end

  before { allow(::Process).to receive(:clock_gettime).with(Process::CLOCK_MONOTONIC).and_return(1.5, 3.5) }

  describe '#call' do
    subject(:call_result) { middleware.call(worker, job, queue, &next_middleware_call) }
    let(:worker) { double(:TestWorker, bid: nil, jid: '709d26b3199e1d730e6a96e1') }
    let(:job) do
      {
        'class' => 'SpikeWorker',
        'args' => [1_492_689_350, 0],
        'retry' => true,
        'queue' => queue,
        'backtrace' => true,
        'jid' => '709d26b3199e1d730e6a96e1',
        'created_at' => 1_492_689_350,
        'enqueued_at' => 1_492_689_350
      }
    end
    let(:queue) { 'BenchmarkQueue' }
    let(:next_middleware_call) { proc {} }

    let(:expected_log_message) do
      {
        'jid' => '709d26b3199e1d730e6a96e1',
        'queue' => queue,
        'worker_class' => 'SpikeWorker',
        'created_at' => 1_492_689_350,
        'enqueued_at' => 1_492_689_350,
        'execution_time_sec' => 2.0
      }
    end

    it { expect { subject }.to log_with(logger, :info, expected_log_message) }

    context 'when formatter given as init option' do
      before { opts[:formatter] = proc { |msg| YAML.dump(msg) } }

      it { expect { subject }.to log_with(logger, :info, YAML.dump(expected_log_message)) }
    end

    context 'when the call chain raises an error' do
      let(:next_middleware_call) { proc { raise StandardError } }
      it 'logs the message with 0 execution time' do
        expect { subject }.to log_with(logger, :info, expected_log_message)
      end
    end
  end
end
