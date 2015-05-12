#
# Cookbook Name:: ad-simplyadrian
# Recipe:: installdomaincontroller 
#
# Copyright 2014, simplyadrian
#
# All rights reserved - Do Not Redistribute
#

if node[:os_version] >= "6.2"
  [
    "Microsoft-Windows-GroupPolicy-ServerAdmintools-Update",
    "ServerManager-Core-RSAT",
    "ServerManager-Core-RSAT-Role-Tools",
    "RSAT-AD-Tools-Feature",
    "RSAT-ADDS-Tools-Feature",
    "ActiveDirectory-Powershell",
    "DirectoryServices-DomainController-Tools",
    "DirectoryServices-AdministrativeCenter",
    "DirectoryServices-DomainController"
  ].each do |feature|
    windows_feature feature do
      action :install
    end
  end
else
  [
    "NetFx3",
    "Microsoft-Windows-GroupPolicy-ServerAdminTools-Update",
    "DirectoryServices-DomainController"
  ].each do |feature|
    windows_feature feature do
      action :install
    end
  end
  Chef::Log.error("This version of Windows Server is currently unsupported beyond installing the required roles and features")
end
