# encoding: utf-8

require 'spec_helper'

describe Job do

  before do
    @job = Job.new(business: "example business",
                   published_at: Date.today,
                   title: "example title",
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

  it { should be_valid }

  describe "when guid is not unique" do
    before do
      job_with_same_guid = @job.dup
      job_with_same_guid.guid = @job.guid.upcase
      job_with_same_guid.save
    end

    it { should_not be_valid }
  end

  describe "when business is not present" do
    before { @job.business = " " }
    it { should_not be_valid }
  end

  describe "when published_at is not present" do
    before { @job.published_at = " " }
    it { should_not be_valid }
  end

  describe "when title is not present" do
    before { @job.title = " " }
    it { should_not be_valid }
  end

  describe "when url is not present" do 
    before { @job.url = " " }
    it { should_not be_valid }
  end

  describe "when guid is not present" do
    before { @job.guid = " " }
    it { should_not be_valid }
  end

  describe "when feed_id is not present" do
    before { @job.feed_id = " " }
    it { should_not be_valid }
  end

  describe "business with mixed case" do
    let(:mixed_case_business) { "ExAmPlE bUSiNesS" }

    it "should be saved all lower case" do
      @job.business = mixed_case_business
      @job.save
      @job.reload.business.should == UnicodeUtils.downcase(mixed_case_business)
    end
  end

  describe "title with mixed case" do
    let(:mixed_case_title) { "ExAmPlE tiTle"}

    it "should be saved all lower case" do
      @job.title = mixed_case_title
      @job.save
      @job.reload.title.should == UnicodeUtils.downcase(mixed_case_title)
    end
  end

  describe "title with international accents" do
    let(:international_title) { "ÉÀÂËÏÖÈ" }

    it "should be saved all lower case" do
      @job.title = international_title
      @job.save
      @job.reload.title.should == UnicodeUtils.downcase(international_title)
    end
  end

  describe "business with international accents" do
    let(:international_business) { "ÉÀÂËÏÖÈ" }

    it "should be saved all lower case" do 
      @job.business = international_business
      @job.save
      @job.reload.business.should == UnicodeUtils.downcase(international_business)
    end
  end

  describe "url with mixed case" do
    let(:mixed_case_url) { "htTp://wWw.ExaMPle.Com/" }

    it "should be saved all lower case" do
      @job.url = mixed_case_url
      @job.save
      @job.reload.url.should == UnicodeUtils.downcase(mixed_case_url)
    end
  end

  describe "guid with mixed case" do
    let(:mixed_case_guid) { "5689 at hTtP://WwW.eXaMpLe.CoM" }

    it "should be saved all lower case" do
      @job.guid = mixed_case_guid
      @job.save
      @job.reload.guid.should == UnicodeUtils.downcase(mixed_case_guid)
    end
  end

  describe "feed adapter" do
    it "should map an Espresso job to the correct adapter" do
      entry = double("entry", title:     "Entry title",
                              author:    "Entry author",
                              id:        "Entry ID",
                              published: "Entry published",
                              id:        "Entry ID")
      feed = double("feed", name: "Espresso Jobs",
                            id:   1 )
      Job.should_receive(:new_job_from_espresso).with(entry, feed)
      Job.feed_adapter(entry, feed)
    end

    it "should map an Infopresse job to the correct adapter" do
      entry = double("entry", title:     "Entry title",
                              url:       "Entry url",
                              id:        "Entry ID",
                              published: "Entry published",
                              summary:   "Entry summary")
      feed = double("feed", name: "Infopresse Jobs",
                            id: 2 )
      Job.should_receive(:new_job_from_infopresse).with(entry, feed)
      Job.feed_adapter(entry, feed)
    end

    it "should map an Isarta job to the correct adapter" do
      entry = double("entry", title:     "Entry title",
                              url:       "Entry url",
                              id:        "Entry ID",
                              summary:   "Entry summary")
      feed = double("feed", name: "Isarta",
                            id: 3 )
      Job.should_receive(:new_job_from_isarta).with(entry, feed)
      Job.feed_adapter(entry, feed)    
    end
  end
end

