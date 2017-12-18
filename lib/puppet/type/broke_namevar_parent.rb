require 'puppet/type'

Puppet::Type.newtype(:broke_namevar_parent) do
  @doc = <<-EOT
  broke_namevar_parent
  EOT

  ensurable

  def self.title_patterns
    [ [ /^(.*?)\Z/m, [ [ :path, lambda{|x| x} ] ] ] ]
  end

  newparam(:path, :namevar => true) do
    desc "Some param"
  end

  newparam(:purge_values, :boolean => true) do
    desc "Whether to delete any registry value associated with this key that is
    not being managed by puppet."

    newvalues(:true, :false)
    defaultto false

    validate do |value|
      case value
      when true, /^true$/i, :true, false, /^false$/i, :false, :undef, nil
        true
      else
        # We raise an ArgumentError and not a Puppet::Error so we get manifest
        # and line numbers in the error message displayed to the user.
        raise ArgumentError.new("Validation Error: purge_values must be true or false, not #{value}")
      end
    end

    munge do |value|
      case value
      when true, /^true$/i, :true
        true
      else
        false
      end
    end
  end

  def eval_generate
    # This value will be given post-munge so we can assume it will be a ruby true or false object
    return [] unless value(:purge_values)

     # get the "should" names of single_namevar_child associated with this key
    should_values = catalog
                      .relationship_graph
                      .direct_dependents_of(self)
                      .select {|dep| dep.type == :broke_namevar_child }
                      .map { |reg| reg.parameter(:value_name).value.downcase }

    # Static list of pretend values
    is_values = ['unmanaged1', 'unmanaged2', 'managed1', 'managed2']
    resources = []

    is_values.each do |is_value|
      unless should_values.include?(is_value.downcase)
        unique_key = "Generated_#{self[:path]}\\#{is_value}"
        resources << Puppet::Type.type(:broke_namevar_child).new(:title => unique_key, :path => self[:path], :value_name => is_value, :ensure => :absent, :catalog => catalog)
      end
    end

    resources
  end
end
