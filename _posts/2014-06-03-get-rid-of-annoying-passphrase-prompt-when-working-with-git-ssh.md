---
layout: default
date: 2014-06-03 11:00:52
title: Get rid of annoying passphrase prompt when working with Git/SSH
---

Every time I push from or pull to GitHub remote repository, SSH client asks:

	Enter passphrase for key /home/<username>/.ssh/id_rsa:

Which is really annoying once you have ~20 project and tweaking them all at one time.

To get rid of this prompt and to keep passphrase permanently, put this line into `~/.ssh/config`:

	IdentityFile ~/.ssh/id_rsa

And then run command in shell:

	git-add ~/.ssh/id_rsa

It will ask passphrase for the last time and link it with identity file permanently.
