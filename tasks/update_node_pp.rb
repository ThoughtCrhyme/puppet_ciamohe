#!/opt/puppetlabs/puppet/bin/ruby
require 'json'
require 'open3'
require 'puppet'
# see https://github.com/DavidS/dasz-configuration/blob/master/manifests/nodes/backup.dasz.at.pp
# see https://github.com/DavidS/dasz-configuration/blob/master/manifests/site.pp
def update_file(manifest, target_node)
  path = '/etc/puppetlabs/code/environments/production/manifests/nodes'
  stdout, stderr, status = Open3.capture3("mkdir -p #{path}")
  raise Puppet::Error, _("stderr: ' %{stderr}') % { stderr: stderr }") if status != 0
  site_path = File.join(path, "#{target_node}.pp")
  final_manifest = "node '#{target_node}' { #{manifest} } "  
  File.open(site_path, 'w+') { |f| f.write(final_manifest) }
  'site.pp updated'
end

params = JSON.parse(STDIN.read)
manifest = params['manifest']
target_node = params['target_node']

begin
  result = update_file(manifest, target_node)
  puts result.to_json
  exit 0
rescue Puppet::Error => e
  puts({ status: 'failure', error: e.message }.to_json)
  exit 1
end
