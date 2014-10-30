require 'vagrant-openstack-plugin'

Vagrant.configure("2") do |config|
  config.vm.box = "dummy"

  # Make sure the private key from the key pair is provided
  config.ssh.private_key_path = "~/.ssh/id_rsa"

  config.vm.define "aaa" do |aaa|
      aaa.vm.box = "dummy.box"
      aaa.vm.provider :openstack do |os|
        os.username     = "XXXX-user"                                               # e.g. "#{ENV['OS_USERNAME']}"
        os.api_key      = "XXXX-password"                                           # e.g. "#{ENV['OS_PASSWORD']}"
        os.flavor       = /m1.medium/                                               # Regex or String
        os.image        = /precise-ldap-only/                                       # Regex or String
        os.endpoint     = "XXXX-endpoint"                                           # e.g. "#{ENV['OS_AUTH_URL']}/tokens"
        os.keypair_name = "XXXX-keypairname"                                        # as stored in Nova
        os.ssh_username = "ubuntu"                                                  # login for the VM
        os.server_name  = "XXXX-servername"
        os.security_groups    = ['default']                                         # optional
        os.tenant             = "XXXX-tenant"                                       # optional
        os.floating_ip        = "X.X.X.X"                                           # optional (The floating IP to assign for this instance)
      end

      aaa.vm.provision "shell", :inline => <<-SHELL
          apt-get update
          apt-get install -y puppet
      SHELL

      aaa.vm.provision "puppet" do |puppet|
          # puppet.options = "--verbose --debug"
          puppet.manifests_path = "manifests"
          puppet.manifest_file  = "site.pp"
          puppet.module_path = "modules"
      end
  end
end