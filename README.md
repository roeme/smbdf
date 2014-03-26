smbdf
=====

Helper Script intended to be used with samba's "dfree command"
setting. This allows you to have arbitrary, custom sizes reported for your
shares.

This is very useful when dealing with a lot of users, client software and quotas (quotae?),
where multiple shares often reside on a single big partition. Users, and some software
alike, then often errorneously assume there's plenty of space free, while
in fact the quota has already been used up.

It's also a low-friction way to limit usage on a share without having to deal
too much with other subsystems.

In theory, you could also have samba report bigger sizes than the backing
partition of a particular share - and in some situations, for some braindead 
SW this might come in handy (the interwebs do tell tales of this).

To prevent samba reporting a usage larger than the custom maximum size 
(i.e. your artificially set maximum size is lower than the space already
occupied on the filesystem) all of a sudden, this script will check the 
usage of the according path with the help of du and calculate the
artificial free space. This is a potentially time-consuming operation,
hence it is highlighted here. Please report if you're encountering issues
with this.

Usage
=====

The script expects a filesystem path in $1, and optionally a max size in $2. 

Requirements
============

- BASH, as it does some minimal regex-fu with it.
- A du reporting sizes in 1K blocks _or_ supporting the -k switch

Block size note
===============

Samba assumes 1K blocks. This script does take advantage of this fact.
The script also assumes your du reports 1K blocks (if not, hack in the
-k switch for the time being)

Caveat
======

This script calculates the disk usage of the files within the share.
Depending on your environment, this might or might not be a costly operation.
This is why samba lets you choose how long it should cache the output
of this script. Have a look at it.

