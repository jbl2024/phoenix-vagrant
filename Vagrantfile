require 'json'
require File.expand_path(File.dirname(__FILE__) + '/scripts/vador.rb')

confDir = $confDir ||= File.expand_path(File.dirname(__FILE__))
settingsPath = confDir + "/settings.yml"

projectsDir = $projectsDir ||= File.expand_path(File.dirname(__FILE__))
projectsSettingsPath = projectsDir + "/projects.yml"


Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-19.04"

  settings = YAML::load(File.read(settingsPath))
  config.vm.provision "shell", path: "scripts/install-deps.sh", privileged: true
  Vador.configure(config, settings)
  config.vm.provision "shell", path: "scripts/cd.sh", privileged: false
end
