require 'puppet/type'

Puppet::Type.newtype(:broke_namevar_child) do
  @doc = <<-EOT
  broke_namevar_child
  EOT

  ensurable

  def self.title_patterns
    [ [ /^(.*?)\Z/m, [ [ :path, lambda{|x| x} ] ] ] ]
  end

  # Need to override the normal name method due to PUP-8620
  # https://tickets.puppetlabs.com/browse/PUP-8260
  # The eval_generate method creates child resources, however
  # as this is a compound namevar resource it "breaks" (sends nil) the name which
  # is used the eval_generate method to uniquely identify resources.  Instead we
  # just return the title ourselves
  # def name
  #   self.title
  # end

  autorequire(:broke_namevar_parent) do
    ['parent']
  end

  newparam(:path, :namevar => true) do
    desc "Some param"
  end

  newparam(:value_name, :namevar => true) do
    desc "Some param"
  end
end
