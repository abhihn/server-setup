qd-installations Cookbook
=========================

This cookbook will install update Yum and install the following

1. Wget
2. Logwatch
3. Git
4. gcc
5. make
6. libcurl-devel
7. gcc-c++

Create a cookbook
-----------------

$ knife cookbook create qd-installations

Upload the cookbook to chef server
----------------------------------

$ knife cookbook upload qd-installations

here qd-installations in the cookbook name

Add cookbook to run list of a node
----------------------------------

$ knife node run_list add nov-24 qd-installations

here nov-24 is the node name and qd-installations in the cookbook name


Requirements
------------
TODO: List your cookbook requirements. Be sure to include any requirements this cookbook has on platforms, libraries, other cookbooks, packages, operating systems, etc.

e.g.
#### packages
- `toaster` - qd-installations needs toaster to brown your bagel.

Attributes
----------
TODO: List your cookbook attributes here.

e.g.
#### qd-installations::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['qd-installations']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### qd-installations::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `qd-installations` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[qd-installations]"
  ]
}
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Krishnaprasad Varma (kpvarma)
