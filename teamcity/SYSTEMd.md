# Install TC agent as systemd service
Select *tcagent*, *tcagent-tethered*, *tcagent-bdc*, or *tcagent-tethered-bdc* service.

Use tcagent by default in San Diego.

Use tcagent-bdc by default in BDC.

Use tcagent-tethered or tcagent-tethered-bdc if build agent will interact with USB tethered devices.

## tcagent instructions

### install/enable/start systemd service

    cat tcagent.service| sudo tee /etc/systemd/system/tcagent.service 1>/dev/null
    sudo systemctl daemon-reload
    sudo systemctl enable tcagent.service
    sudo systemctl start tcagent.service

## tcagent-tethered instructions
### install/enable/start systemd service

    cat tcagent-tethered.service| sudo tee /etc/systemd/system/tcagent.service 1>/dev/null
    sudo systemctl daemon-reload
    sudo systemctl enable tcagent.service
    sudo systemctl start tcagent.service

## tcagent-bdc and tcagent-tethered-bdc instructions
### ensure /prj/omnilin and /prj/xrresearch mounts are available

    sudo mkdir -p /mnt/{xrresearch,omnilin}
    # add the following to your /etc/fstab
    zarkon.qualcomm.com:/prj/xrresearch /mnt/xrresearch nfs defaults 0 0
    megalon.qualcomm.com:/prj/omnilin /mnt/omnilin nfs defaults 0 0
    
    sudo mount /mnt/xrresearch
    sudo mount /mnt/omnilin

### install/enable/start systemd service

    cat tcagent-bdc.service| sudo tee /etc/systemd/system/tcagent.service 1>/dev/null
    sudo systemctl daemon-reload
    sudo systemctl enable tcagent.service
    sudo systemctl start tcagent.service

### install/enable/start tethered systemd service

    cat tcagent-tethered-bdc.service| sudo tee /etc/systemd/system/tcagent.service 1>/dev/null
    sudo systemctl daemon-reload
    sudo systemctl enable tcagent.service
    sudo systemctl start tcagent.service
