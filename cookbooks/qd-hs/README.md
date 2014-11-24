qd-hs Cookbook
================

This cookbook hardens the server by installing / configuring
1. SELINUX
2. NTP
3. Malware Detectors
4. Aide
5. CHKROOTKIT
6. POSTFIX

Create a cookbook
-----------------

$ knife cookbook create qd-hs

Upload the cookbook to chef server
----------------------------------

$ knife cookbook upload qd-hs

here qd-hs in the cookbook name

Add cookbook to run list of a node
----------------------------------

$ knife node run_list add nov-24 qd-hs

here nov-24 is the node name and qd-hs-1 in the cookbook name

Run the Cookbook in Server
--------------------------

$ knife bootstrap uvo1cijip4m89dvl7kx.vm.cld.sr --sudo -x root -P Sh5C8Zk57R -N nov-24  --run-list qd-hs-1

Requirements
------------
TODO: List your cookbook requirements. Be sure to include any requirements this cookbook has on platforms, libraries, other cookbooks, packages, operating systems, etc.

e.g.
#### packages
- `toaster` - qd-hs-1 needs toaster to brown your bagel.

Attributes
----------
TODO: List your cookbook attributes here.

e.g.
#### qd-hs-1::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['qd-hs-1']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### qd-hs-1::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `qd-hs-1` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[qd-hs-1]"
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
