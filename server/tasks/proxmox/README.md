# Create cloud-init template

To create new cloud-init VM template in Proxmox:

- use `inventory.yaml` and update it with your proxmox host
- modify `vars` section in [create-vm-template-improved.yaml](create-vm-template-improved.yaml) as needed to fit your needs
- run the playbook

```shell
# the -K argument allows you to pass the sudo password
ansible-playbook -i inventory/inventory.yaml server/tasks/proxmox/create-vm-template.yaml -K
```
