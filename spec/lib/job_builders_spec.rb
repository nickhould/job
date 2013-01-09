# encoding: utf-8

require 'spec_helper'
require "#{Rails.root}/lib/job_builder.rb"

describe JobBuilder do
  before do
    @job_entry = { title: "Job title",
                  business: "Job business",
                  url: "Job url",
                  published_at: "Job published_at",
                  guid: "Job guid",
                  feed_id: 1 }
  end

  describe "build_job" do
    before do
      @formatted_job_entry = JobBuilder.build_job(@job_entry)
    end

    subject { @formatted_job_entry }

    it { should be_kind_of(Hash) }
    it { should have_key(:title) }
    it { should have_key(:business) }
    it { should have_key(:published_at) }
    it { should_not have_key(:guid) }
    it { should_not have_key(:feed_id) }
    it { should_not have_key(:url) }
  end

  describe "build_job_feed" do
    before do 
      @formatted_job_entry = JobBuilder.build_job_feed(@job_entry)
    end

    subject { @formatted_job_entry }

    it { should be_kind_of(Hash) }
    it { should have_key(:published_at) }
    it { should have_key(:guid) }
    it { should have_key(:feed_id) }
    it { should have_key(:url) }
    it { should_not have_key(:title) }
    it { should_not have_key(:business) }
  end
end