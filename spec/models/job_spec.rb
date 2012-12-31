require 'spec_helper'

describe Job do

  before do
    @job = Job.new(business: "Example business",
                   published_at: Date.today,
                   title: "Example title",
                   url: "http://www.example.com",
                   guid: "5689 at http://www.example.com",
                   feed_id: 1)
  end

  subject { @job }
  
  it { should respond_to(:business) }
  it { should respond_to(:published_at) }
  it { should respond_to(:title) }
  it { should respond_to(:url) }
  it { should respond_to(:guid) }
  it { should respond_to(:feed_id) }

  it "should save information downcase" do

  end
end
