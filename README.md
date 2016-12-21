# alfieri
## Description
Highly configurable, multi-staged, (almost fully-) automated installer for 
ArchLinux.
Its name is almost an acronym: ArchLinux Fantastic Installer. The other letters 
were chosen in order to make an Italian word.

This software, hopefully, will relieve you from the burden of (re)installing 
ArchLinux systems. With this tool you will be able to install the same system 
(potentially with the same configuration) on multiple machines, or reinstall
your system with ease.

### Multi-staged process
The task of *installing ArchLinux* has been, conceptually, in multiple stages.
Each stage is numerated with a 3-digits code.
The stages will be executed in numeric order from 000 to 999.
It is not required for all stages to be present, i.e. you can have stages 540,
547, 600 without the intermediate stages.
Alfieri performs some mandatory stages on his own (i.e. without any external
configuration). After them, it runs externally configured stages (Custom stages).
These custom stages are placed in a configurable directory. Each stage is named
`xyy.stage` which essentially are ZSH scripts. 
The stage number is composed by Major stage (the `x` in `xyy.stage`) and Minor 
stage (the `yy` in `xyy.stage`). The Major stage is essentially used for grouping
purposes.

### Major stages
Alfieri defines three built-in Major stages. They are:

1. **(0yy) Pre-installation phase.**  
    Stages which are performed before actual installation.
    They might alter the installation medium system.
2. **(1yy) Installation phase (before chroot).**  
    Stages which are performed during installation, before chrooting inside the 
    new system.
3. **(2yy) Installation phase (inside chroot).**  
    Stages which are performed inside the chroot.
4. **(3yy) Installation phase (after chroot).**  
    Stages which are performed after exiting the chroot, but before rebooting.
5. **(4yy) Post installation phase.**  
    Stages which are executed after rebooting into the newly installed system.

Major stages after 5yy are not defined by `alfieri`. The user can use them as
they wish (if they want) - they are simply executed sequentially.

## Configuration files
There are some configuration files that you **are required** to edit before
attempting installation. They are:
* `alfieri.cfg`  
    Here are defined some variables that specify alfieri's behaviour.
* `locale.gen`  
    **This will be /etc/locale.gen on your target system!!**
* `2xx.pacman` and `3xx.pacman`__ see below.

### About 2xx.pacman and 3xx.pacman
These files contain a list of packages that will be installed during Major stages
2 and 3.
Conceptually, you would put essential packages in `2xx.pacman` so that, after 
reboot, they could be used. For example, packages needed for network, file systems
and the like. All other packages should be put in `3xx.pacman` although this is
not required - i.e. you could put all packages in `2xx.pacman` but that's not
recommended.

## Using
1. Edit the configuration files: (see above)
2. Prepare the hard disk (partition, format, mount inside /mnt)
3. On the installation medium run `alfieri 000`
4. After reboot you should see a minimal ArchLinux system. From there you may
want to run `alfieri 400` which will prepare your final system

## Licensing
The software is covered by the MIT license. For more information, see the `LICENSE` file.

## Additional information
The software is still in development. As such many bugs could be present. You are
encouraged to test and report bugs!
