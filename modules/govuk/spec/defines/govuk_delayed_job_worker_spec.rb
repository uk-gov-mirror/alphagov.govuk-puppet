require_relative '../../../../spec_helper'

describe 'govuk::delayed_job::worker', :type => :define do
  let(:title) { 'giraffe' }

  context "in non-development environments" do

    it do
      should contain_file("/etc/init/giraffe-delayed-job-worker.conf").
        without_content(/manual/)
    end

    it { should contain_service("giraffe-delayed-job-worker").with(:ensure => true) }
  end

  context "in development environments" do
    let(:params) { {:enable_service => false} }

    it do
      should contain_file("/etc/init/giraffe-delayed-job-worker.conf").
        with_content(/^manual$/)
    end

    it { should contain_service("giraffe-delayed-job-worker").with(:ensure => false) }
  end
end
