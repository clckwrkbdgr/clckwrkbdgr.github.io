---
layout: default
parent-url: /
parent: owlwood
title: No sound in ALSA (unable to open slave)
---
After upgrading to Debian Wheezy and deinstalling pulseaudio I encountered problem with ALSA, specifically with mocp:

{% highlight bash %}
$ mocp
Running the server...
Trying JACK...
Trying ALSA...
ALSA lib pcm_dmix.c:1018:(snd_pcm_dmix_open) unable to open slave
Trying OSS...
FATAL_ERROR: No valid sound driver!
FATAL_ERROR: Server exited!
{% endhighlight %}

`aplay` also prints similar messages.

The solution is to create a file named `.asoundrc` in your home folder and paste this in:

{% highlight text %}
pcm.dsp {
	type plug
	slave.pcm "dmix"
}
{% endhighlight %}

Then alsa service should be restarted:

{% highlight bash %}
$ sudo service alsa-utils restart
{% endhighlight %}

Now mocp should work fine.

