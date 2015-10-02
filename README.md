# Librato Sync

Minimalistic library that does two things:

* Pull a space from a Librato account, and store JSON data in a local
  directory.
* Push the space to a Librato account, from the JSON data stored locally.

I use this for these purposes:

* Fetch a space, review its definition for inconsistencies, edit it locally,
  and push it back up to Librato.
* Fetch a space from one account, and push a copy of it to another account.
* Copy charts from one space to another, and edit definitions locally.

Uses a config file `.librato.yml` if present. The config file name, and the
data directory can be specified as command line options.

Usage:

```
$ librato pull [account]
$ librato pull [account] --space "Space 1" --space "Space 2" --config librato.yml --dir ./librato
$ librato push [account]
$ librato push [account] --space "Space 1" --space "Space 2" --config librato.yml --dir ./librato
```

Account credentials (user/email and token) can be be included in the config
file, or set as env vars per account:

```
export LIBRATO_USER_ACCOUNT_1=[email]
export LIBRATO_TOKEN_ACCOUNT_1=[token]
```

The Librato API returns charts in an unordered fashion. You can work around
this by specifying a chart order in the config file.

Certain keys and names will be uniq to one account, and need to be changed for
another account.  Account configuration can therefor specify variable names and
values. Variable names will be replaced with the value specific to the account
when pushing a space to an account.

A full config file has this structure. Each bit of configuration is optional,
but the chart order and template vars cannot be specified via command line
options.

```
dir: ./var/librato

spaces:
  -
    name: Space 1
    order:
      - chart_1
      - chart_2
      - chart_3

accounts:
  name_1:
    user: user_1@email.com
    token: token_1
    vars:
      app: app_1
      db_name: foo

  name_2:
    user: user_2@email.com
    token: token_2
    vars:
      app: app_2
      db_name: bar
```
