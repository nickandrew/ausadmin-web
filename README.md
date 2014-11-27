# aus.news-admin.org main website

This repository contains the ausadmin website, http://aus.news-admin.org/
without generally any of the aus hierarchy specific data used by the
website.

## Technology

This is a Mojolicious perl web framework application, see http://mojolicio.us/

## Operating the website

There's no "build" process. Change directory into _ausadmin_web_
(which contains all the new Mojolicious code and HTML templates)
and run

```
script/ausadmin_web daemon
```

This will listen on 127.0.0.1 port 3000.

To make the website available on the internet, setup nginx and add a
sites-available file, like this:

```
server {
        listen 80;
        server_name aus.news-admin.org;
        location / {
                proxy_pass http://127.0.0.1:3000;
        }
}
```

## TODO

Future changes will involve further separation of aus-specific data
(FAQ and so on) from the site. aus-specific data is published in
https://github.com/nickandrew/ausadmin-aus-data
