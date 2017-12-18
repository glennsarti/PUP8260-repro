Puppet::Type.type(:broke_namevar_parent).provide(:prov_broke_namevar_parent) do
  def exists?
    path_value == 'parent'
  end

  def path_value
    resource.parameter(:path).value
  end

  def create
    puts "broke_namevar_parent CREATING #{path_value}"
  end

  def destroy
    puts "broke_namevar_parent DESTROYING #{path_value}"
  end

  def flush
    puts "broke_namevar_parent FLUSHING #{path_value}"
  end
end
