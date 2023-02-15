<p align=center><a href="https://yang.srlinux.dev"><img src=https://gitlab.com/rdodin/pics/-/wikis/uploads/606d2520872b04ce5691d22630073bc4/srl-yang-models.svg?sanitize=true/></a></p>

[![Yang Browser](https://img.shields.io/badge/YANG_browser-yang.srlinux.dev-blue?style=flat-square&color=00c9ff&labelColor=bec8d2)](https://yang.srlinux.dev)

---

Nokia SR Linux makes extensive use of structured data models. Each application, whether provided by Nokia or written by a user against the [NDK](https://learn.srlinux.dev/ndk/intro/), has a YANG model that defines its configuration and state.

With this design, the YANG data model is defined first, then the CLI, APIs, and show output formats are derived from it.

## Yang browser

This repository contains only the source YANG files that one can use to build code bindings or explore the way the modules are built. To browse the modules, we recommend using [yang.srlinux.dev](https://yang.srlinux.dev) portal, which provides human-friendly tools to browse and search through the models.

## Repository structure

The main branch of this repository contains only the documentation. To reveal the yang files for a given release, select the tag that matches the SR Linux release version.

For instance, tag `v21.6.2` corresponds to the SR Linux release 21.6.2.

## Download

There are several ways to download the yang files for a specific SR Linux release. The below examples are provided for `v21.6.2` version.

### Clone with git

Clone the yang files for a specific release with the following `git` command:

```bash
git clone -b v21.6.2 --depth 1 https://github.com/nokia/srlinux-yang-models
```

### Download archives

To download the proto files for a specific release in the `zip` or `tgz` archive, navigate to the GitHub [`tag`](https://github.com/nokia/srlinux-yang-models/tags) page, which contains the links to the archives.

If needed, the download link can be programmatically derived using the following rule:

**for zip**
`https://github.com/nokia/srlinux-yang-models/archive/tags/` + `$tag` + `.zip`

**for tar.gz**
`https://github.com/nokia/srlinux-yang-models/archive/tags/` + `$tag` + `.tar.gz`

### Extracting all modules

To extract YANG modules of each SR Linux release and put them in a single directory, use the provided `get-all-modules.sh` script:

```bash
# extracts modules in the `$(pwd)/all` directory
./get-all-modules.sh
```
