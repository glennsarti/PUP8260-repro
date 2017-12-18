Puppet::Type.type(:fixed_namevar_child).provide(:prov_fixed_namevar_child) do
  def exists?
    return false unless path_value == 'parent'
    ['unmanaged1', 'unmanaged2', 'managed1', 'managed2'].include?(value_name_value)
  end

  def path_value
    resource.parameter(:path).value
  end

  def value_name_value
    resource.parameter(:value_name).value
  end

  def create
    puts "fixed_namevar_child CREATING #{@resource.title}"
  end

  def destroy
    puts "fixed_namevar_child DESTROYING #{@resource.title}"
  end

  def flush
    puts "fixed_namevar_child FLUSHING #{@resource.title}"
  end
end
