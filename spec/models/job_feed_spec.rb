require 'spec_helper'

describe JobFeed do

  before do 
    @job_feed = JobFeed.new(guid: "Example GUID",
                            published_at: Date.today,
                            url: "Example URL",
                            job_id: 1,
                            feed_id: 11)
  end

  subject { @job_feed }

  it { should respond_to(:guid) }
  it { should respond_to(:published_at) }
  it { should respond_to(:url) }
  it { should respond_to(:job_id) }
  it { should respond_to(:feed_id) }

  it { should be_valid }

  describe "when guid is not unique" do
    before do
      job_feed_with_same_guid = @job_feed.dup
      job_feed_with_same_guid.guid = @job_feed.guid.downcase
      job_feed_with_same_guid.save
    end

    it { should_not be_valid }
  end

  describe "when url is not present" do 
    before { @job_feed.url = " " }
    it { should_not be_valid }
  end

  describe "when guid is not present" do
    before { @job_feed.guid = " " }
    it { should_not be_valid }
  end

  describe "when feed_id is not present" do
    before { @job_feed.feed_id = " " }
    it { should_not be_valid }
  end

  describe "url with mixed case" do
    let(:mixed_case_url) { "htTp://wWw.ExaMPle.Com/" }

    it "should be saved all lower case" do
      @job_feed.url = mixed_case_url
      @job_feed.save
      @job_feed.reload.url.should == UnicodeUtils.downcase(mixed_case_url)
    end
  end

  describe "guid with mixed case" do
    let(:mixed_case_guid) { "5689 at hTtP://WwW.eXaMpLe.CoM" }

    it "should be saved all lower case" do
      @job_feed.guid = mixed_case_guid
      @job_feed.save
      @job_feed.reload.guid.should == UnicodeUtils.downcase(mixed_case_guid)
    end
  end

end
