include_recipe "build-essential"
include_recipe "git::default"

doxygen_options = node.to_hash['doxygen'].to_hash['options'].sort.find_all do |key, val|
  !val.nil? || val != false
end.map do |key, val|
  if val == true
    "--key"
  else
    "--key" + key + "=" + val
  end
end.join " "

git "/home/vagrant/doxygen" do
  repository "git://github.com/doxygen/doxygen.git"
  checkout_branch "Release_#{node['doxygen']['version'].gsub(/\.{1}/, '_')}"
  action :sync
end

bash "config_doxygen" do
  cwd "/home/vagrant/doxygen"
  flags "-lx"
  code <<-EOH
    git checkout master
    ./configure
    make
    make distclean
    git pull
    ./configure
    ./configure #{doxygen_options}
    make
  EOH
  action :run
end

bash "install_doxygen" do
  cwd "/home/vagrant/doxygen"
  flags "-lx"
  code <<-EOH
    make install
  EOH
  action :run
end
