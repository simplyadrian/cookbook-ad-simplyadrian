actions :create, :delete
default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :domain_user, :kind_of => String
attribute :domain_pass, :kind_of => String
attribute :type, :kind_of => String, :default => "replica"
attribute :site_name, :kind_of => String
attribute :safe_mode_pass, :kind_of => String
attribute :options, :kind_of => Hash, :default => {}
attribute :local_pass, :kind_of => String
