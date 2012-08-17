Use [Dropbox](http://www.dropbox.com) as the storage backend for your [Redmine](http://www.redmine.org) installation

#### Installation

To install the plugin, execute the following commands from the root of your redmine directory:
    
    cd plugins
    git clone git://github.com/alexbevi/redmine_dropbox_attachments.git
    bundle install

More information on installing Redmine plugins can be found at [redmine.org](http://www.redmine.org/wiki/redmine/Plugins.)

After the plugin is installed you will need to restart Redmine for the plugin to be available.

#### Configuration

The plugin must be configured from `Administration --> Plugins --> Dropbox Attachment Storage --> Configure`

![Screenshot](https://github.com/alexbevi/redmine_dropbox_attachments/blob/master/screenshot01.png)

##### Authorization

Before Redmine can store files on a shared Dropbox folder, it must be authorized. This is done by clicking _Authorize Redmine with Dropbox_, then selecting _Allow_ from Dropbox's authorization page.

##### Specifying a Base Directory

`TODO`

#### Acknowledgement

This plugin is heavily based on the [Redmine S3](https://github.com/tigrish/redmine_s3) plugin. Thanks to all the contributors there who've made this such an easy plugin to build ;)

I also used the [Redmine DropBox](https://github.com/zuinqstudio/redmine_drop_box) plugin to find some quick answers to interacting with dropbox.

#### About

Copyright (c) 2012 Alex Bevilacqua

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.