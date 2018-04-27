require 'logger'

RSpec.describe SidekiqMiddlewares::ErrorLogger do
  subject(:middleware) { described_class.new logger }
  let(:logger) { instance_double(Logger) }

  describe '#call' do
    it 'yields to the next call in the chain' do
      called = false
      subject.call { called = true }
      expect(called).to be_truthy
    end

    context 'when the call chain raises an error' do
      let(:custom_error) { StandardError.new 'test error' }

      it 'logs the error' do
        expect { subject.call { raise custom_error } }.to log_with(logger, :error, custom_error)
      end

      it 'raises the error' do
        logger.as_null_object
        expect { subject.call { raise custom_error } }.to raise_error custom_error
      end
    end
  end
end
