
class Vador
  def self.configure(config, settings)
    self.configure_guest(config, settings)
    self.configure_port_forwarding(config, settings)
    self.configure_internal_links(config, settings)
    #self.configure_proxy(config, settings)
    self.configure_projects(config)
  end

  def self.configure_guest(config, settings)
    config.vm.provider 'virtualbox' do |vb|
      vb.customize ['modifyvm', :id, '--memory', settings['memory'] ||= '2048']
      vb.customize ['modifyvm', :id, '--cpus', settings['cpus'] ||= '1']
      vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
  end

  def self.configure_port_forwarding(config, settings)
    ports = settings['ports'] || []
    ports.each do |port|
      config.vm.network 'forwarded_port', guest: port['guest'], host: port['host']
    end
  end

  def self.configure_internal_links(config, settings)
    internal_links = settings['internal_links'] || []
    internal_links.each do |mount_point, guest_point|

      script = <<-SHELL
        echo "mounting #{mount_point} to #{guest_point}"
        mkdir -p #{mount_point}
        mkdir -p #{guest_point}
        chown vagrant:vagrant #{mount_point}
        chown vagrant:vagrant #{guest_point}
        mount --bind #{mount_point} #{guest_point}
      SHELL
      config.vm.provision "shell", run: "always", inline: script
    end    
  end

  def self.configure_proxy(config, settings)
    if settings['http_proxy']
        puts "==> http_proxy: #{settings['http_proxy']}"
        config.proxy.http = settings['http_proxy']
    end
    if settings['https_proxy']
        puts "==> https_proxy: #{settings['https_proxy']}"
        config.proxy.https = settings['https_proxy']
    end
    if settings['no_proxy']
        puts "==> no_proxy: #{settings['no_proxy']}"
        config.proxy.no_proxy = settings['no_proxy']
    end
  end

  def self.configure_projects(config)
    baseFolder = File.expand_path(File.dirname(__FILE__) + "/..")
    projects = Dir.glob("#{baseFolder}/**/vador.yml")
    projects.each do |project|
      puts "==> Loading project settings for #{project}"
      project_data = YAML::load(File.read(project))
      self.configure_port_forwarding(config, project_data)
      self.configure_internal_links(config, project_data)
    end
  end

end