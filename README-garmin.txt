The Linux kernel detects the Garmin unit when it is
plugged in, but it does not set the permissions properly.
As a result, only the root user can access the device.

To set the permissions correctly, 

* Create a file /etc/udev/rules.d/80-garmin.rules
  ----8<----
  ATTRS{idVendor}=="091e", ATTRS{idProduct}=="0003", MODE="664", GROUP="plugdev"
  ----8<----

* Get udev to recognise the new rule by running
     sudo udevadm control --reload-rules
     
* Ensure that any user that wants to access the device is a 
  member of the group 'plugdev'.
  
* Remove and replug the Garmin device

These steps only need to be done once.

