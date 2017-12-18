
# Managed two children
fixed_namevar_child { 'parent-managed1-value':
  ensure     => present,
  path       => 'parent',
  value_name => 'managed1',
}

fixed_namevar_child { 'parent-managed2-value':
  ensure     => present,
  path       => 'parent',
  value_name => 'managed2',
}

# Manage the parent and purge any unmanaged child
# Staticly set to unmanaged1 and unmanaged2
fixed_namevar_parent { 'parent':
  ensure       => present,
  purge_values => true,
}
