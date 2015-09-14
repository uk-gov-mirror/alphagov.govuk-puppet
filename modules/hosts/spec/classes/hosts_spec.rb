require_relative '../../../../spec_helper'

describe 'hosts', :type => :class do
  context 'node jumpbox-1 exists in hosts::production' do
    let(:node) { 'jumpbox-1' }
    let(:hiera_data) {{
      "hosts::production::management::hosts" => {
        "jumpbox-1" => {
          "ip" => "10.1.0.100",
        }
      }
    }}

    it 'should purge unmanaged hosts entries' do
      is_expected.to contain_govuk__host('jumpbox-1')
      is_expected.to contain_resources('host').with_purge('true')
    end
  end

  context 'node foo-bar-wibble does NOT exist in hosts::production' do
    let(:node) { 'foo-bar-wibble' }

    it 'should abort catalog so as not to purge hosts entry for self' do
      expect { is_expected.to }.to raise_error(Puppet::Error, /Unable to find Govuk::Host\[foo-bar-wibble\]/)
    end
  end
end
