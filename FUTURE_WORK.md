## The future - mkb

Riak-shim will follow [semantic versioning](http://semver.org) as best I can
manage.

My plan is to keep tweaking riak-shim to suit my own needs for two internal
projects I am working on.  The first of those goes into production  shortly,
so I am declaring a 1.0 release.  From here on out, minor version releases
might introduce new functionality, but won't break what is already here.

For the past few weeks riak-shim has been fairly stable and hasn't needed
significant changes.  I am hopeful that we can avoid incompatable updates for
a while.

The area most likely to change is the handling of secondary indexes since I am
unhappy with the current interface.

## TODOS

- Examples directory
- Keep working on docs
- Keep expanding tests
- find less horrible way to deal with index names
- find less horrible way to deal with key accessor
- nice error message when can't connect to db
- nice error ,essage when back end doesn't support 2i
- nice error message when secondary index is missing?

