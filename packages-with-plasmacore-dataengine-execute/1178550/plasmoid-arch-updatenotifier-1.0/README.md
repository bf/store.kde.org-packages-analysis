# plasmoid-arch-updatenotifier
Arch Update Notifier Plasmoid

## Overview ##
This plasmoid is an attempt to notify the user of packages that are pending to install without locking the repository database. Other full package managers like octopi will leverage ALPM to fully integrate with pacman. This plasmoid is *NOT* meant to leverage ALPM. Instead, it leverages tools that are part of pacman like checkupdates. It can also integrate with AUR package managers like pacaur to update your system.

When updating, it will launch a konsole session and allow you to perform the updates as if you were running it from a terminal session.
