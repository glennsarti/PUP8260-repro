Puppet::Type.type(:single_namevar_child).provide(:prov_single_namevar_child) do
  def exists?
    ['parent\unmanaged1', 'parent\unmanaged2', 'parent\managed1', 'parent\managed2'].include?(path_value)
  end

  def path_value
    resource.parameter(:path).value
  end

  def create
    puts "single_namevar_child CREATING #{path_value}"
  end

  def destroy
    puts "single_namevar_child DESTROYING #{path_value}"
  end

  def flush
    puts "single_namevar_child FLUSHING #{path_value}"
  end
end
