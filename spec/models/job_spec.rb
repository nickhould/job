# encoding: utf-8

require 'spec_helper'

describe Job do

  before do
    @job = Job.new(business: "example business",
                   published_at: Date.today,
                   title: "example title"
                  )
  end
  
  subject { @job }
  
  it { should respond_to(:business) }
  it { should respond_to(:published_at) }
  it { should respond_to(:title) }

  it { should be_valid }

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

  describe "job builder" do
    before do
      job_entry = double("job_entry", title: "Job title",
                                      business: "Job business",
                                      url: "Job url",
                                      published_at: "Job published_at",
                                      guid: "Job guid",
                                      feed_id: 1)
      @formatted_job_entry = Job.job_builder(job_entry)
    end
    
    subject { @formatted_job_entry }

    it { should be_kind_of(Hash) }
    
  end
end

