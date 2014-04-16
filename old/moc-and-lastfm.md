---
layout: default
parent-url: /
parent: owlwood
title: MOC and Last.fm
---
The [moc](http://moc.daper.net/) player itself doesn't support [scrobbling](http://www.last.fm/). But there is an option to execute an external command on each track change:

{% highlight text %}
OnSongChange = "/path/to/external/command %a %t %d %r"
{% endhighlight %}
Arguments are substituted using current song (that is, the song that playing is changed to) info:

* **%a** is replaced by the _artist_ name.
* **%t** is replaced by the song _title_.
* **%r** is replaced by the _album_ title.
* **%d** is the track _duration_.

Each parameter will be properly escaped. Os course, if there no info about some of that parameters, an empty string will be passed.

Perfect script for above task can be found at [http://lukeplant.me.uk/blog/posts/moc-and-last-fm/](http://lukeplant.me.uk/blog/posts/moc-and-last-fm/). Put it anywhere you like and make it executable.

{% highlight bash %}
$ chmod +x moc_submit_lastfm
{% endhighlight %}

Now it can be specified in the MOC confing file:

{% highlight text %}
OnSongChange = "/path/to/moc_submit_lastfm --artist %a --title %t --length %d --album %r"
{% endhighlight %}

Next what will need is a scrobbler itself. The most common one under Linux and the one that is used by script is `lastfmsubmitd`. Upon installation it may ask user to fill some data like Last.fm user name and password, and user group. The latter one by default is called `lastfm`. The only users who can sumbit info to Last.fm. are the ones who are present in group `lastfm`

{% highlight bash %}
$ sudo apt-get install lastfmsubmitd
$ sudo addgroup lastfm
$ sudo adduser $YOUR_USER lastfm # This will add user to the group
{% endhighlight %}

Now mocp should be completely restarted in order to re-read it's config:

{% highlight bash %}
$ mocp -x && mocp
{% endhighlight %}

**N.B.**: Sometimes even if `/etc/lastfmsubmitd.conf` contains valid account info, no scrobbling data is send by `lastfmsubmitd` during being said that `lastfmsubmitd: no account info found; exiting.`. One reason for that is that conf file is not accessible by the deamon, usually due to its permissions: they're 600 (that is, the only reader and writer is `root`) and should be set to 755 (that is, every user can read but only root is allowed to write). Also there might be need to set 777 permissions to pool dir `/var/spool/lastfm`.

