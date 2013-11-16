#!/bin/sh
# filename:     tmux.sh
# author:       Graham Inggs <graham@nerve.org.za>
# date:         2013-05-24 ; Initial Release
# date:         2013-08-23 ; Fetch files from packages-9.1-release
# purpose:      Install tmux on NAS4Free (embedded version).
# Note:         Check the end of the page.
#
#----------------------- Set variables ------------------------------------------------------------------
DIR=`dirname $0`;
PLATFORM=`uname -m`
RELEASE=`uname -r | cut -d- -f1`
URL="ftp://ftp.freebsd.org/pub/FreeBSD/ports/${PLATFORM}/packages-9.1-release/All"
TMUXFILE="tmux-1.7_1.tbz"
LIBEVENTFILE="libevent-1.4.14b_2.tbz"
#----------------------- Set Errors ---------------------------------------------------------------------
_msg() { case $@ in
  0) echo "The script will exit now."; exit 0 ;;
  1) echo "No route to server, or file do not exist on server"; _msg 0 ;;
  2) echo "Can't find ${FILE} on ${DIR}"; _msg 0 ;;
  3) echo "tmux installed and ready! (ONLY USE DURING A SSH SESSION)"; exit 0 ;;
  4) echo "Always run this script using the full path: /mnt/.../directory/tmux.sh"; _msg 0 ;;
esac ; exit 0; }
#----------------------- Check for full path ------------------------------------------------------------
if [ ! `echo $0 |cut -c1-5` = "/mnt/" ]; then _msg 4 ; fi
cd $DIR;
#----------------------- Download and decompress mc files if don't exist --------------------------------
FILE=${TMUXFILE}
if [ ! -d ${DIR}/bin ]; then
  if [ ! -e ${DIR}/${FILE} ]; then fetch ${URL}/${FILE} || _msg 1; fi
  if [ -f ${DIR}/${FILE} ]; then tar xzf ${DIR}/${FILE} || _msg 2; rm ${DIR}/+*; rm -R ${DIR}/man; fi
  if [ ! -d ${DIR}/bin ]; then _msg 4; fi
fi
#----------------------- Download and decompress libslang files if don't exist --------------------------
FILE=${LIBEVENTFILE}
if [ ! -d ${DIR}/lib ]; then
  if [ ! -e ${DIR}/${FILE} ]; then fetch ${URL}/${FILE} || _msg 1; fi
  if [ -f ${DIR}/${FILE} ]; then tar xzf ${DIR}/${FILE} || _msg 2};
    rm ${DIR}/+*; rm -R ${DIR}/man; rm -R ${DIR}/include; rm ${DIR}/lib/*.a; rm ${DIR}/lib/*.la;
    rm ${DIR}/bin/event_rpcgen.py; fi
  if [ ! -d ${DIR}/lib ]; then _msg 4; fi
fi
#----------------------- Create symlinks ----------------------------------------------------------------
for i in `ls $DIR/bin/`
  do if [ ! -e /usr/local/bin/${i} ]; then ln -s ${DIR}/bin/$i /usr/local/bin; fi; done
for i in `ls $DIR/lib`
  do if [ ! -e /usr/local/lib/${i} ]; then ln -s $DIR/lib/$i /usr/local/lib; fi; done
_msg 3 ; exit 0;
#----------------------- End of Script ------------------------------------------------------------------
# 1. Keep this script in his own directory.
# 2. chmod the script u+x,
# 3. Always run this script using the full path: /mnt/share/directory/tmux
# 4. You can add this script to WebGUI: Advanced: Commands as Post command (see 3).
# 5. To run tmux from shell type 'tmux'.
