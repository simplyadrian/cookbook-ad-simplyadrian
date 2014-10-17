require 'mixlib/shellout'

action :create do
  if exists?
    new_resource.updated_by_last_action(false)
  else
    if node[:os_version] >= "6.2"
      cmd = create_command
      cmd << " -ADPrepCredential (New-Object System.Management.Automation.PSCredential #{new_resource.domain_user},(convertto-securestring #{new_resource.domain_pass} -asplaintext -force))"
      cmd << " -DnsDelegationCredential (New-Object System.Management.Automation.PSCredential #{new_resource.domain_user},(convertto-securestring #{new_resource.domain_pass} -asplaintext -force))"
      cmd << " -Credential (New-Object System.Management.Automation.PSCredential #{new_resource.domain_user},(convertto-securestring #{new_resource.domain_pass} -asplaintext -force))"
      cmd << " -DomainName #{new_resource.name} -SiteName #{new_resource.site_name}"
      cmd << " -SafeModeAdministratorPassword (convertto-securestring '#{new_resource.safe_mode_pass}' -asplaintext -Force)"
      cmd << " -InstallDns:$true -NoRebootOnCompletion:$false -Force:$true -WhatIf"
    else node[:os_version] <= "6.1"
      cmd = "dcpromo -unattend"
      cmd << " -newDomain:#{new_resource.type}"
      cmd << " -NewDomainDNSName:#{new_resource.name} -SiteName #{new_resource.site_name}"
      cmd << " -RebootOnCompletion:Yes"
      cmd << " -SafeModeAdminPassword:(convertto-securestring '#{new_resource.safe_mode_pass}' -asplaintext -Force)"
      cmd << " -ReplicaOrNewDomain:#{new_resource.replica_type}"
    end
    new_resource.options.each do |option, value|
      if value.nil?
        cmd << " -#{option}"
      else
        cmd << " -#{option} '#{value}'"
      end
    end

    powershell_script "create_domain_#{new_resource.name}" do
      code cmd
    end

    new_resource.updated_by_last_action(true)
  end
end

action :delete do
  if exists?
    cmd = "Uninstall-ADDSDomainController"
    cmd << " -LocalAdministratorPassword (ConverTTo-SecureString '#{new_resource.local_pass}' -AsPlainText -Force)"
    cmd << " -Force:$true"
    cmd << " -ForceRemoval"
    if last_dc?
      cmd << " -DemoteOperationMasterRole"
    end

    new_resource.options.each do |option, value|
      if value.nil?
        cmd << " -#{option}"
      else
        cmd << " -#{option} '#{value}'"
      end
    end

    powershell_script "remove_domain_#{new_resource.name}" do
      code cmd
    end

    new_resource.updated_by_last_action(true)
  else
    new_resource.updated_by_last_action(false)
  end
end

def exists?
  ldap_path = new_resource.name.split(".").map! { |k| "dc=#{k}" }.join(",")
  check = Mixlib::ShellOut.new("powershell.exe -command [adsi]::Exists('LDAP://#{ldap_path}')").run_command
  check.stdout.match("True")
end

def computer_exists?
  comp = Mixlib::ShellOut.new("powershell.exe -command \"get-wmiobject -class win32_computersystem -computername . | select domain\"").run_command
  comp.stdout.include? ("#{new_resource.name}") or comp.stdout.include? ("#{new_resource.name}.upcase")
end

def last_dc?
  dsquery = Mixlib::ShellOut.new("dsquery server -forest").run_command
  dsquery.stdout.split("\n").size == 1
end

def create_command
  if node[:os_version] > '6.2'
    case new_resource.type
      when "forest"
        "Install-ADDSForest"
      when "domain"
        "install-ADDSDomain"
      when "replica"
        "Install-ADDSDomainController"
      when "read-only"
        "Add-ADDSReadOnlyDomainControllerAccount"
  end
  else
    case new_resource.type
      when "forest"
        "forest"
      when "domain"
        "domain"
      when "read-only"
        "domain"
      when "replica"
        "replica"
    end
  end
end

def site_name_by_region
    case aws['region']
      when 'us-east-1'
        new_resouce.site_name = "AWS-VIRGINIA"
      when 'us-west-1'
        new_resource.site_name = "AWS-NCALIFORNIA"
      when 'us-west-2'
        new_resource.site_name = "AWS-OREGON"
    end
end
