
# Managed two children
broke_namevar_child { 'parent-managed1-value':
  ensure     => present,
  path       => 'parent',
  value_name => 'managed1',
}

broke_namevar_child { 'parent-managed2-value':
  ensure     => present,
  path       => 'parent',
  value_name => 'managed2',
}

# Manage the parent and purge any unmanaged child
# Staticly set to unmanaged1 and unmanaged2
broke_namevar_parent { 'parent':
  ensure       => present,
  purge_values => true,
}
