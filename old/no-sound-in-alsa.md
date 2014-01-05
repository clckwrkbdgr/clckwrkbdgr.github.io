---
layout: default
title: No sound in ALSA (unable to open slave)
---
After upgrading to Debian Wheezy and deinstalling pulseaudio I encountered problem with ALSA, specifically with mocp:

```
$ mocp
Running the server...
Trying JACK...
Trying ALSA...
ALSA lib pcm_dmix.c:1018:(snd_pcm_dmix_open) unable to open slave
Trying OSS...
FATAL_ERROR: No valid sound driver!
FATAL_ERROR: Server exited!
```

`aplay` also prints similar messages.

The solution is to create a file named `.asoundrc` in your home folder and paste this in:

```
pcm.dsp {
	type plug
	slave.pcm "dmix"
}
```

Then alsa service should be restarted:

```
$ sudo service alsa-utils restart
```

Now mocp should work fine.
