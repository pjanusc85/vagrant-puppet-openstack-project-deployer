# Vagrant Project Deployer Skeleton

##The Big Idea
The idea isto have all project deployment configuration managed by the VCS and provide easy tools for auto-deployment. 

We have 2 providers: AWS and OpenStack. In future we could have multiple like Google Compute Engine.

Provisioning can be done in multiple ways, puppet is used here. But we should be agnostic and if we like ansible/chef/CFEngine, we should be able to use that.

##Tools Used
* [vagrant](http://www.vagrantup.com/)
* [vagrant-openstack](https://github.com/cloudbau/vagrant-openstack-plugin)
* [vagrant-aws](https://github.com/mitchellh/vagrant-aws)
* [puppet](https://docs.puppetlabs.com/puppet/3.7/reference/lang_summary.html)


##Usage
A typical usage of this project will constitute the following steps:
1. Clone this project
2. Add war files into the deploy/{env} folder
3. Update manifests/site.pp to add to the war deployment instructions
4. Create a jenkins project, and add promotions that can provision, destroy and create a new node fore you.

##Limitations
1. The present aws plugin only supports elb, so if you have dns resolved to an elastic-ip, make sure you assign the machine to the ealstic-ip in AWS console.
