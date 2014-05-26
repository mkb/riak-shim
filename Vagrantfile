
ENV["VAGRANT_DEFAULT_PROVIDER"] = "docker"

Vagrant.configure("2") do |config|
  config.vm.define "riak" do |app|
    app.vm.provider "docker" do |d|
      d.image = "lapax/riak"
      d.name = "riak"
      d.ports << "8087:8087"
      d.ports << "8098:8098"
      d.ports << "8069:8069"
    end
  end
end
