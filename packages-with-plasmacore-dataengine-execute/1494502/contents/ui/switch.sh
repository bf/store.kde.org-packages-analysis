#!/bin/bash
to_gpu=$1

kdialog --warningcontinuecancel "$2";

if [ "$?" = 0 ]
then
    pkexec /usr/bin/prime-select $to_gpu
#     kdialog --sorry $to_gpu
    wait
    qdbus org.kde.ksmserver /KSMServer logout 1 1 3
    exit 0;

else
    exit 1;
fi;
