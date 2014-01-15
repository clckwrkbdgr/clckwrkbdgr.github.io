---
layout: default
parent-url: /
parent: owlwood
title: Client-server architecture cheat-sheet
---
There are two types of users in client-server architecture:

* a **server** that awaits requests and serves them;
* and a **client** that sends the requests and waits for a response.

Workflow
--------

Basic server creation and execution workflow:

* Open **socket**. This socket will be used by the server to listen for incoming client requests.
* Created socket is just a structure in memory. One needs to **bind** to to a particular address and port in order to use it. This address is called a _socket address_ and is used by client for sending the request to.
* The next what's needed is to **listen** to the socket for incoming requests.
* Each incoming request will create a _separate socket_ for use with a particular client which sent the request. That is, for 10 client requests there will be 10 sockets created.
* Now that there is a ready dedicated socket, we can speak about real client-server process. Sockets are actually ordinary file descriptors and can be used for both **reading** and **writing**. This is where the reign of the _protocols_ begins.
* After processing the query (or queries) is complete, you can **close** the socket. In this case, the connection is terminated.

Clients are created and used a lot easier:

* Create a **socket** and **connect** it to the server (knowing the exact address of the socket).
* Now you can **read** and **write** data, as in the case with the server.
* After using socket you can **close** it.

Some points on working with client-server
-----------------------------------------

Sockets based on Berkeley sockets can work in two modes: _blocking_ and _nonblocking_.

* **Blocking** sockets, as the name suggests, block the execution flow until they have accomplished their part. When applied to reading/writing this means that the socket may not send or receive all the data passed to it. Blocking calls return the count of sent/received bytes and the application must resubmit unprocessed data.
* **Non-blocking** (asynchronous) calls transfer control of the workflow almost immediately after the call, implementing an event model. To work with such sockets in Berkeley sockets there is a **select** function.

Each side can suddenly terminate a session without correct signal to the opposite side (considering the protocol). For example, the network connection is gone or the computer is being taking away by enemies. In this case, reading/writing to the socket will return an error.

In case of a server, it is usually a good idea to keep _more than one client connection_ simultaneously, for example, for network game players or streaming video viewers. Blocking calls will interfere with the program flow. The most common method in this case is:

* Creating of a separate process/thread to work with a separate socket. For 10 sockets there will be 10 threads or processes.
* Using of non-blocking mode.

Protocols
---------

If possible, one should always use a _text message format_ for the protocol messages. Such protocols are easy to debug because they are human-readable. Text protocols are guaranteed to be portable: text is always text on any platform unlike binary data (consider byte order, size of data types etc). Such protocol could use, for example, XML or JSON as a base. Or it can be simple commands like in SMTP or FTP.

Designing protocols is more an art than a formal methods, but there are some general principles.

* It is advisable to send the message's protocol version and/or application version with the message itself. Message formats of different protocols versions (especially major ones) may be different and this should be taken into account.
* Dedicated messages for the beginning and the ending of the work is preferrably too. For example, HELO and QUIT in SMTP.
* As a rule, the message may have different formats (and different sizes) for different commands. This can be handled either by the command format (fixed size), or by size sent with the message (for example, the first 4 bytes), or by a message terminator (e.g. '}' in JSON), but it should be considered in any case because the socket considers data moved through it as a stream and there is no mechanisms of separation of messages embedded.
