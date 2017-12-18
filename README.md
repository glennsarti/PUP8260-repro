This puppet module is used to reproduce the issue PUP-8260 (https://tickets.puppetlabs.com/browse/PUP-8260)

There are three tests cases, and in each case:

* A single "parent" resource exists which will purge any unmanaged children

* Two "child" resources exist (called `managed1` and `managed2`) which will autorequire the "parent"

* There will appear to be four children that exist for the parent (called `managed1`, `managed2`, `unmanaged1`, and `unmanaged2`) thus it should try to purge the unmanaged entries (called `unmanaged1` and `unmanaged2`)

* The providers for both the "child" and "parent" are just stubs which write to STDOUT for its various actions e.g. Create, Destroy and Flush

# single_name_var

This has a parent with single namevar and a child with a single name var.

Running puppet gives output similar to:

``` text
Info: Applying configuration version '1513585575'
Debug: /Stage[main]/Main/Single_namevar_child[parent\managed1]: Adding autorequire relationship with Single_namevar_parent[parent]
Debug: /Stage[main]/Main/Single_namevar_child[parent\managed2]: Adding autorequire relationship with Single_namevar_parent[parent]
single_namevar_child DESTROYING parent\unmanaged1
Notice: /Stage[main]/Main/Single_namevar_child[parent\unmanaged1]/ensure: removed
single_namevar_child FLUSHING parent\unmanaged1
Debug: /Stage[main]/Main/Single_namevar_child[parent\unmanaged1]: The container parent will propagate my refresh event
single_namevar_child DESTROYING parent\unmanaged2
Notice: /Stage[main]/Main/Single_namevar_child[parent\unmanaged2]/ensure: removed
single_namevar_child FLUSHING parent\unmanaged2
Debug: /Stage[main]/Main/Single_namevar_child[parent\unmanaged2]: The container parent will propagate my refresh event
Debug: parent: The container Class[Main] will propagate my refresh event
Debug: Class[Main]: The container Stage[main] will propagate my refresh event
Debug: Finishing transaction 72014260
Debug: Storing state
```

Note that `parent\unmanaged1` and `parent\unmanaged2` are purged

# broke_name_var

This has a parent with single namevar and a child with a compound name var.

This is the broken test case showing the issue with compound namevars, and no name parameter

``` text
Info: Applying configuration version '1513587037'
Debug: /Stage[main]/Main/Broke_namevar_child[parent-managed1-value]: Adding autorequire relationship with Broke_namevar_parent[parent]
Debug: /Stage[main]/Main/Broke_namevar_child[parent-managed2-value]: Adding autorequire relationship with Broke_namevar_parent[parent]
Debug: Finishing transaction 61821180
Debug: Storing state
```

Note that nothing is purged

# fixed_name_var

This has a parent with single namevar and a child with a compound name var.

This is exactly the same code from the broken example above except with a name change (broke -> fixed) and a quick fix in the type of the child:
``` ruby
  def name
    self.title
  end
```

Running puppet gives output similar to:

``` text
Info: Applying configuration version '1513586763'
Debug: /Stage[main]/Main/Fixed_namevar_child[parent-managed1-value]: Adding autorequire relationship with Fixed_namevar_parent[parent]
Debug: /Stage[main]/Main/Fixed_namevar_child[parent-managed2-value]: Adding autorequire relationship with Fixed_namevar_parent[parent]
fixed_namevar_child DESTROYING Generated_parent\unmanaged1
Notice: /Stage[main]/Main/Fixed_namevar_child[Generated_parent\unmanaged1]/ensure: removed
fixed_namevar_child FLUSHING Generated_parent\unmanaged1
Debug: /Stage[main]/Main/Fixed_namevar_child[Generated_parent\unmanaged1]: The container parent will propagate my refresh event
fixed_namevar_child DESTROYING Generated_parent\unmanaged2
Notice: /Stage[main]/Main/Fixed_namevar_child[Generated_parent\unmanaged2]/ensure: removed
fixed_namevar_child FLUSHING Generated_parent\unmanaged2
Debug: /Stage[main]/Main/Fixed_namevar_child[Generated_parent\unmanaged2]: The container parent will propagate my refresh event
Debug: parent: The container Class[Main] will propagate my refresh event
Debug: Class[Main]: The container Stage[main] will propagate my refresh event
Debug: Finishing transaction 41576960
Debug: Storing state
```

Note that `Generated_arent\unmanaged1` and `Generated_parent\unmanaged2` are purged.  The `Generated_` prefix comes from eval_generate
