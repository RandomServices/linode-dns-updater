require './lib/environment'
require './lib/linode_tool'

class UpdateSlaves < LinodeTool
  def run
    domains_that_already_exist.each do |domain|
      puts "Updating #{domain}"
      update_domain current_domains_by_name[domain][:domainid]
    end

    missing_domains.each do |domain|
      puts "Creating #{domain}"
      create_domain domain
    end

    extra_domains.each do |domain|
      domain_data = current_domains_by_name[domain]
      if domain_data[:type] == 'slave'
        puts "Deleting #{domain}"
        delete_domain current_domains_by_name[domain][:domainid]
      else
        puts "Not deleting #{domain} because it's not a slave"
      end
    end
  end

  private

  def missing_domains
    config['slaves'] - current_domains_by_name.keys
  end

  def extra_domains
    current_domains_by_name.keys - config['slaves']
  end

  def domains_that_already_exist
    config['slaves'] & current_domains_by_name.keys
  end

  def current_domains
    @current_domains ||= linode.domain.list
  end

  def current_domains_by_name
    Hash[current_domains.map { |r| [r[:domain].to_s, r] }]
  end

  def create_domain(domain)
    linode.domain.create({ domain: domain }.merge(domain_settings))
  end

  def update_domain(domain_id)
    linode.domain.update({ domainid: domain_id }.merge(domain_settings))
  end

  def delete_domain(domain_id)
    linode.domain.delete domainid: domain_id
  end

  def master_ips
    config['master_ips'].join(";") + ";"
  end

  def domain_settings
    {
      master_ips: master_ips,
      type: "slave",
    }
  end
end

UpdateSlaves.new.run
