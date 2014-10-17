actions :rename
default_action :rename

attribute :name, :kind_of => String, :name_attribute => true
attribute :hostname, :kind_of => String
attribute :domain_user, :kind_of => String
attribute :domain_pass, :kind_of => String
