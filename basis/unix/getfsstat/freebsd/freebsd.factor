! Copyright (C) 2008 Doug Coleman.
! See http://factorcode.org/license.txt for BSD license.
USING: alien.syntax ;
IN: unix.getfsstat.freebsd

CONSTANT: MNT_WAIT        1       ! synchronously wait for I/O to complete
CONSTANT: MNT_NOWAIT      2       ! start all I/O, but do not wait for it 
CONSTANT: MNT_LAZY        3       ! push data not written by filesystem syncer 
CONSTANT: MNT_SUSPEND     4       ! Suspend file system after sync 

FUNCTION: int getfsstat ( statfs* buf, int bufsize, int flags ) ;
