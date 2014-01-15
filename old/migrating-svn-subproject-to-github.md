---
layout: default
parent-url: /
parent: owlwood
title: Migrating SVN subproject to GitHub
---
Suppose you have SVN repo that consists of a number of subprojects. And you want to extract one of them and convert it into a valid Git repo in order to load it to GitHub.

Given:  

* SVN repo at path `/path/to/svn` and subproject `subproject`.
* Each SVN subproject has following structure: `trunk/ tags/ branches/`.
* svn and git tools installed.
* Also you will need [svn2git](https://github.com/nirvdrum/svn2git#installation) tool. It depends on git, git-svn and ruby, so make sure you've got them before installing svn2git.

Extracting subproject
=========

First, we will need to do whole dump of svnrepo:

```
$ svnadmin dump /path/to/svn &gt;repo-dumpfile
```

Then, we will filter that dumpfile through `svndumpfilter` in order to exclude all subdirs except for `subproject`.

```
$ svndumpfilter --drop-empty-revs --renumber-revs include subproject &lt;repo-dumpfile &gt;subproject-dumpfile
```

A couple of useful command-line arguments:

* **--drop-empty-revs** - if SVN repo holds several subprojects there will be revisions when no file which belong to current subproject is affected at all, i.e. empty revisions. If you don't want to have them in your extracted repo, this parameter would just skip them during extracting.
* **--renumber-revs** - in case some of revisions was dropped, there will be gaps in revision numbers. This paramter would renumber revisions so there will be no gaps in numbers.

**NOTE**: if this subproject was named otherwise once and than later had been renamed to `subproject`, you must include that one too! Of course, if it had been renamed twice, you will need both old names to include and so on.

Preparing for conversion
=========

Now we have a correct SVN repo dump so we could restore it as an actual SVN repo. Though, it's structure is a bit complicated:

```
subprojectrepo
`- subproject
	|- branches
	|- tags
	`- trunk
```

That is, there is a dir named `subproject` in the repo's root. In order to successfully convert it to Git repo with tags and branches converted from file (as in SVN) to actual tags and branches (as in Git), you might want to change repo structure to following one:

```
subprojectrepo
|- branches
|- tags
`- trunk
```

To make it look like above, you need manually edit subproject dump file and change each `Node-path` and `Node-copyfrom-path` be removing all heading "subproject" components. Also, you might want to remove the actual "subproject" dir creation (usually it can be found in the very first revision).


Restoring SVN repo
=========

As simple as it is:

```
$ svnadmin create subproject # Check that dir with the same name does not already exists.
$ svnadmin load subproject &lt;subproject-dumpfile
```

You can now ensure that repository was restored correct by listing it's content:

```
$ svn list file:///path/to/subproject/repo
```

Converting to Git repo
=========

svn2git utility makes a Git repo in current working directory, so create some empty dir and cd to it:

```
$ mkdir subproject-git
$ cd subproject-git
$ svn2git file:///path/to/subproject/repo
```

`svn2git` by default will look for tags, branches and trunk dirs, converting them to the actual tags, branches and master branch respectively, so make sure that SVN repo has them on it's top level.

If you want to change authors' names, create conversion file for them somewhere with content like:

```
svnauthor = Git Author &lt;gitauthor@example.com&gt;
...
```

And then pass this file to svn2git:

```
$ svn2git file:///path/to/subproject/repo --authors /path/to/authors.txt
```

Pushing repo to GitHub
=========

* Create a repo on GitHub.
* Add a remote for the repo:
```
$ git remote add origin git@github.com:GITHUB_USERNAME/REPO_NAME.git
```
* Push.
```
$ git push origin master --tags
```

References:
=========

* http://svnbook.red-bean.com/en/1.7/svn.reposadmin.maint.html#svn.reposadmin.maint.filtering
* https://github.com/nirvdrum/svn2git#installation
* https://help.github.com/articles/importing-from-subversion
