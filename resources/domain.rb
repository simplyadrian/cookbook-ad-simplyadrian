actions :join, :unjoin
default_action :join

attribute :name, :kind_of => String, :name_attribute => true
attribute :domain_user, :kind_of => String
attribute :domain_pass, :kind_of => String
attribute :oupath, :kind_of => String
attribute :options, :kind_of => Hash, :default => {}
