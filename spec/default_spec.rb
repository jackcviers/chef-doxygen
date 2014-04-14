require_relative 'spec_helper'

describe 'doxygen::default' do

  # before do
  #   stub_command("test -f /var/chef/cache/git-1.8.2.1.tar.gz")
  #   stub_command("git --version | grep 1.8.2.1").and_return(0)
  # end
  
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
    end.converge(described_recipe)
  end

  it 'should include_recipe[git::default] recipe' do
    expect(chef_run).to include_recipe "git::default"
  end

  it 'should include_recipe[build-essential::default]' do
    expect(chef_run).to include_recipe "build-essential::default"
  end
  
  it 'should sync_git["/home/vagrant/doxygen"]' do
    expect(chef_run).to sync_git("/home/vagrant/doxygen").with("checkout_branch" => "Release_#{chef_run.node['doxygen']['version'].gsub(/\.{1}/, '_')}")
  end

  it 'should bash[install_doxygen]' do
    expect(chef_run).to run_bash 'install_doxygen'
  end

end

