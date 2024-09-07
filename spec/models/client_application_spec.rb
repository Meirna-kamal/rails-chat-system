require 'rails_helper'

RSpec.describe ClientApplication, type: :model do

  it 'should create a valid application' do
    client_application = ClientApplication.create!(name: 'Test Application')
    expect(client_application).to be_valid
    expect(client_application.name).to eq('Test Application')
    expect(client_application.token).to be_present
  end

  it 'is invalid without a name' do
    client_application = ClientApplication.new(name: nil)
    expect(client_application).to_not be_valid
  end

  it 'generates a token after creation' do
    client_application = ClientApplication.create(name: 'Test App')
    expect(client_application.token).to be_present
  end

end