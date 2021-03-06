test_name "Windows Reboot Module - Reboot Immediately Explicit"
extend Puppet::Acceptance::Reboot

reboot_manifest = <<-MANIFEST
notify { 'step_1':
}
~>
reboot { 'now':
  apply => immediately
}
MANIFEST

confine :to, :platform => 'windows'

agents.each do |agent|
  step "Reboot Immediately (Explicit) with Refresh"

  #Apply the manifest.
  on agent, puppet('apply', '--debug'), :stdin => reboot_manifest

  #Verify that a shutdown has been initiated and clear the pending shutdown.
  retry_shutdown_abort(agent)
end
