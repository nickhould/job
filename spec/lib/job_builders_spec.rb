# encoding: utf-8

require 'spec_helper'
require "#{Rails.root}/lib/job_builder.rb"

describe JobBuilder do
  context "in Job model" do
    before do
      job_entry = Hash.new 
      job_entry = { title: "Job title",
                    business: "Job business",
                    url: "Job url",
                    published_at: "Job published_at",
                    guid: "Job guid",
                    feed_id: 1 }
      @formatted_job_entry = JobBuilder.build_job(job_entry)
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
end