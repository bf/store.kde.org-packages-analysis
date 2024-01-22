#!/usr/bin/env bash
#kpackagetool5 -t Plasma/Applet --uninstall org.example.plasmalistview
#kpackagetool5 -t Plasma/Applet --install plasmoid/
kpackagetool5 -t Plasma/Applet --upgrade plasmoid/

plasmawindowed org.kde.pacman.updatenotifier
