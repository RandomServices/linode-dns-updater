require 'linode'

class LinodeTool
  def config
    @config ||= YAML::load(File.read('config.yml'))
  end

  def api_key
    config['api_key']
  end

  def linode
    @linode ||= Linode.new(api_key: api_key)
  end
end
