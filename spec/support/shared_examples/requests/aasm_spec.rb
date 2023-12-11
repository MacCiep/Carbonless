shared_examples 'allows for transition to' do |state|
  it { expect(record).to allow_transition_to(state) }
end

shared_examples 'does not allow for transition to' do |state|
  it { expect(record).not_to allow_transition_to(state) }
end

shared_context 'with respond to event' do |event, new_state|
  it "transitions to #{new_state}" do
    expect(record.respond_to?(event)).to eq(true)
  end
end