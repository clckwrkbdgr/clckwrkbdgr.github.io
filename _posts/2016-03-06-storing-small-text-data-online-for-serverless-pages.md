---
layout: default
date: 2016-03-06 17:57:33
title: Storing small text data online for serverless pages
---

I needed some free online database for one of my projects, actually only to store couple of text strings. Basically I had two functions and needed some service to provide theirs implementation:

{% highlight javascript %}
function setCookie(cname, cvalue) {
    ...
}
function getCookie(cname) {
    ...
    return value;
}
{% endhighlight %}

I stumbled across some free database solutions like Amazon SimpleDB and Mongolab, but found them too heavy for my needs and too complex to just create and use. At first I tried to use obvious solution: pastebin.com is good for storing text and has nice API. Of course, it does not allow editing pastes, but paste could be deleted and then recreated. I did even compiled some [solution](https://gist.github.com/umi0451/4865cc5da17f67ae929d) for this case, but one major downside of storing data in pastebin is that it does not allow to create more then one paste in a hour. So I looked up some more and found perfect solution for my problem: [fieldbook](https://fieldbook.com/books).

First I've created a spreadsheet in Fieldbook and added two keys with values. Of course, it could be done from within program, but all I needed is to read/write existing values, so just made solution for this functions only.

Each Fieldbook sheet has its own API url. Also API key is needed and a password for it. They can be generated on API page but **only one time**, so be careful to write them down that very moment. That's all what's needed to access sheet's data.

{% highlight javascript %}
var POST_URL='https://api.fieldbook.com/v1/$FIELBOOK_URL/books';
var KEY='key-1';
var SECRET='$SECRET';
{% endhighlight %}

API calls are really simple, while testing them using Python I was amused how they could be fit in one line each. But in Javascript it takes a little bit more words. _Get_ request is very basic and pretty much copy-pasted from fieldbook own tutorials. What is going on here is AJAX request returning JSON object of rows, each row containing record ID, name and fields:

{% highlight javascript %}
[
    {'id': 1, 'record_url': 'https://fieldbook.com/records/$URL',
        'field_1': 'VALUE1', 'book_name_or_identifier': 'KEY1',
        'field_3': None, 'field_2': None
    },
    {'id': 2, 'record_url': 'https://fieldbook.com/records/$URL',
        'field_1': 'VALUE1', 'book_name_or_identifier': 'KEY1',
        'field_3': None, 'field_2': None
    }
]
{% endhighlight %}

So, after getting sheet content, we're parsing it and extracting only `field_1`, for example - thats where cookie value is stored in our example. When data is parsed, callback function `on_complete` is called to trigger some update on the page.

{% highlight javascript %}
/* asyncronous; calls on_complete({key:value, ...}) after success. */
function getCookies(on_complete) {
    $.ajax({
        url: POST_URL,
        headers: {
            'Accept': 'application/json',
            'Authorization': 'Basic ' + btoa(KEY + ':' + SECRET)
        }
    }).done(function(response) {
        var data = {};
        for(var i = 0; i < response.length; ++i) {
            var record = response[i];
            data[record.book_name_or_identifier] = record.field_1;
        }
        on_complete(data);
    }).fail(function(error) {
        console.log('error', error);
    });
}
{% endhighlight %}

_Set_ requests is not that different. In my case I wanted to read all data but update only one record at a time. When storing data back it's possible to address specific records. For that I'm keeping mapping between cookie names and record integer IDs. Full API url is contructed by adding subpath, for example, `/1` to sheet's API url. Fieldbook is using PATCH requests to update data records, and updates only those field which are supplied in the request content. In our case it's just `field_1`.

{% highlight javascript %}
var cname_to_id = {"KEY1":'1', "KEY2":'2'};
function setCookie(cname, cvalue) {
    $.ajax({
        url: POST_URL + '/' + cname_to_id[cname],
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Basic ' + btoa(KEY + ':' + SECRET)
        },
        type: 'PATCH',
        data : JSON.stringify({"field_1": cvalue})
    }).done(function(response) {
        console.log('done ' + cname + '=' + cvalue);
    }).fail(function(error) {
        console.log('error', error);
    });
}
{% endhighlight %}
