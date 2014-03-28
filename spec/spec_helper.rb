require 'chefspec'
require 'chefspec/berkshelf'
require 'chef/application'

at_exit { ChefSpec::Coverage.report! }
