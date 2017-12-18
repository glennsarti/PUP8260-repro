require 'puppet/type'

Puppet::Type.newtype(:single_namevar_child) do
  @doc = <<-EOT
  single_namevar_child
  EOT

  ensurable

  def self.title_patterns
    [ [ /^(.*?)\Z/m, [ [ :path, lambda{|x| x} ] ] ] ]
  end

  autorequire(:single_namevar_parent) do
    ['parent']
  end

  newparam(:path, :namevar => true) do
    desc "Some param"
  end
end
