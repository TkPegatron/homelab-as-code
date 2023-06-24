# Raspberry Pi low-power NAS

I have a pretty small homelab rack and a desire to use as little energy as reasonable with my lab, for this I wanted to move away from the old beefy dell I was using (for now anyway, Ill see when I can afford do spec out some 10gbit infra). I figured why not a PI. (*cue copeposting*) Even with encryption, the IOPS speed isn't too far off from 1gbit line speed. The RPi SOC is certainly a bottleneck here but it's not too bad for media streaming and file storage.

This is a bad idea for a variety of reasons but I wanted to work with the hardware i have (No UPS and no 10gbe networking)



`sudo mount -t nfs -o nfsvers=4 172.22.0.3:/srv/media /mnt/client_share -vvv`

Encrypting drives on a raspberry pi running Alma (RHEL9)

```shell
# Creating the LVM across two 6tb drives
pvcreate /dev/sd[c-d]
vgcreate mediacore /dev/sd[c-d]
lvcreate --extents 100%FREE --stripes 2 --name media mediacore
# Encrypt the LVM with LUKS2 using a performant cipher (for the Pi hardware)
### cryptsetup benchmark -c xchacha20,aes-adiantum-plain64
cryptsetup --type luks2 --cipher xchacha20,aes-adiantum-plain64 --hash sha256 --iter-time 5000 --pbkdf argon2i luksFormat /dev/mediacore/media
cryptsetup luksOpen /dev/mediacore/media mediacore
# Format and mount the logical volume
mkfs.xfs /dev/mapper/mediacore
# Optionally, I mount the drive in the /srv/nfs
## This mountpoint follows the FHS standard, the data on the lv is shared with nfs
mkdir /srv/nfs/{media,backup} -pv
mount /dev/mapper/mediacore /srv/nfs/mediacore
```

Because I unlocked the backup disk after boot, udev did not detect the lvm pv under the backup drive's LUKS, this command was helpful in getting the system to recognize it during configuration `lvmdevices --adddev /dev/mapper/backupcore`

Heres the replay for context

```shell
[root@xenia ~]# mount /dev/xenia/media /srv/nfs/backup
mount: /srv/nfs/backup: special device /dev/xenia/media does not exist.
[root@xenia ~]# lvmdevices --adddev /dev/mapper/backupcore 
[root@xenia ~]# pvscan
  PV /dev/sdc                 VG mediacore       lvm2 [<5.46 TiB / 0    free]
  PV /dev/sdd                 VG mediacore       lvm2 [<5.46 TiB / 0    free]
  PV /dev/mapper/backupcore   VG xenia           lvm2 [<3.64 TiB / <1.24 TiB free]
  Total: 3 [14.55 TiB] / in use: 3 [14.55 TiB] / in no VG: 0 [0   ]
[root@xenia ~]# lvscan
  ACTIVE            '/dev/mediacore/media' [<10.92 TiB] inherit
  inactive          '/dev/xenia/media' [2.40 TiB] inherit
[root@xenia ~]# lvchange -ay /dev/xenia/media
[root@xenia ~]# mount /dev/xenia/media /srv/nfs/backup
```

## Benchmarks

In-Memory Adiantum cipher compute test

```none
[root@xenia ~]# cryptsetup benchmark -c xchacha20, 
# Tests are approximate using memory only (no storage IO).
#            Algorithm |       Key |      Encryption |      Decryption
xchacha20,aes-adiantum        256b        59.0 MiB/s        59.3 MiB/s
```

Write from urandom, read from random data image, zeroize image using `dd`

```none
[root@xenia ~]# dd if=/dev/urandom of=/srv/nfs/media/bench.img bs=1M count=500
500+0 records in
500+0 records out
524288000 bytes (524 MB, 500 MiB) copied, 11.5737 s, 45.3 MB/s

[root@xenia ~]# dd if=/srv/nfs/media/bench.img of=/dev/null
1024000+0 records in
1024000+0 records out
524288000 bytes (524 MB, 500 MiB) copied, 11.9793 s, 43.8 MB/s

[root@xenia ~]# dd if=/dev/zero of=/srv/nfs/media/bench.img bs=1M count=500
500+0 records in
500+0 records out
524288000 bytes (524 MB, 500 MiB) copied, 2.70049 s, 194 MB/s
```

Again with sync flag to bypass the buffer

```none
[root@xenia ~]# dd if=/dev/urandom of=/srv/nfs/media/bench.img bs=1M count=500 oflag=sync
500+0 records in
500+0 records out
524288000 bytes (524 MB, 500 MiB) copied, 46.5832 s, 11.3 MB/s

[root@xenia ~]# dd if=/dev/zero of=/srv/nfs/media/bench.img bs=1M count=500 oflag=sync
500+0 records in
500+0 records out
524288000 bytes (524 MB, 500 MiB) copied, 36.9295 s, 14.2 MB/s
```
