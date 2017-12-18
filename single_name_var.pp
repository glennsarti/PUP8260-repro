
# Managed two children
single_namevar_child { 'parent\managed1':
  ensure => present,
}

single_namevar_child { 'parent\managed2':
  ensure => present,
}

# Manage the parent and purge any unmanaged child
# Staticly set to unmanaged1 and unmanaged2
single_namevar_parent { 'parent':
  ensure       => present,
  purge_values => true,
}
