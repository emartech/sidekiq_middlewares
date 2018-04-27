RSpec.describe SidekiqMiddlewares::MdcCleaner do
  describe '#call' do
    it 'yields to the next call in the chain' do
      called = false
      subject.call { called = true }
      expect(called).to be_truthy
    end

    context 'when Logging is loaded' do
      before { Logging = double 'Logging gem' }
      after { Object.send(:remove_const, :Logging) }

      it 'clears the Logging.mdc if Logging is loaded' do
        expect(Logging).to receive_message_chain(:mdc, :clear)
        subject.call {}
      end
    end
  end
end
