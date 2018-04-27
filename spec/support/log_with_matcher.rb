RSpec::Matchers.define :log_with do |logger, level, message|
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
