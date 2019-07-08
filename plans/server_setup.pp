plan puppet_ciamohe::server_setup(
) {
  # get pe-server from inventory file? eg https://puppet.com/docs/bolt/latest/writing_plans.html#collect-facts-from-the-targets
  $server = get_targets('*').filter |$n| { $n.vars['role'] == 'pe' }
  # install pe server
  run_task('puppet_ciamohe::install_pe', $server)

  # install modules
  run_command('puppet module install puppetlabs-motd', $server)
  # update site on server
  $manifest = "include motd"
 # run_task('puppet_ciamohe::update_site_pp', $server, manifest => $manifest)
  # set the ui password
  run_command('puppet infra console_password --password=litmus', $server)
}
