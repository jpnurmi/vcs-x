# VCS X

Various version control system extensions for [Git](https://git-scm.com) and
[Repo](https://source.android.com/docs/setup/reference/repo) with auto-completion
for Bash and compact output suitable for large repo trees.

## Installation

```sh
$ git clone --recurse-submodules https://github.com/jpnurmi/vcs-x.git ~/.vcs-x
$ echo 'source ~/.vcs-x/vcs-x.sh' >> ~/.bashrc
```

## Usage

### `git-remote-dup`

Duplicates a Git remote. Commonly used remote names can be specified via the
`x.remotes` Git config variable.

```sh
$ git remote -v
origin	git@github.com:jpnurmi/vcs-x.git (fetch)
origin	git@github.com:jpnurmi/vcs-x.git (push)

$ git config --global x.remotes "foo bar"

$ git-remote-dup origin <TAB><TAB>
bar      foo      -h       --help   --https  --ssh

$ git-remote-dup origin foo
foo	git@github.com:foo/vcs-x.git (fetch)
foo	git@github.com:foo/vcs-x.git (push)
origin	git@github.com:jpnurmi/vcs-x.git (fetch)
origin	git@github.com:jpnurmi/vcs-x.git (push)

$ git-remote-dup --https origin bar
bar	https://github.com/bar/vcs-x.git (fetch)
bar	https://github.com/bar/vcs-x.git (push)
foo	git@github.com:foo/vcs-x.git (fetch)
foo	git@github.com:foo/vcs-x.git (push)
origin	git@github.com:jpnurmi/vcs-x.git (fetch)
origin	git@github.com:jpnurmi/vcs-x.git (push)
```

### `git-remote-https`, `git-remote-ssh`

Changes Git remote URLs to HTTPS or SSH.

```sh
$ git remote -v
origin	git@github.com:jpnurmi/vcs-x.git (fetch)
origin	git@github.com:jpnurmi/vcs-x.git (push)

$ git-remote-https origin
origin	https://github.com/jpnurmi/vcs-x.git (fetch)
origin	https://github.com/jpnurmi/vcs-x.git (push)

$ git-remote-ssh origin
origin	git@github.com:jpnurmi/vcs-x.git (fetch)
origin	git@github.com:jpnurmi/vcs-x.git (push)
```

### `git-remote-tidy`

Batch-deletes matching remote branches and tags.

```sh
$ git-remote-tidy origin f* bar
To github.com:jpnurmi/vcs-x.git
 - [deleted]         foo
 - [deleted]         bar
```

### `repo-branch`

Runs `git branch` in all/specified projects.

```sh
$ repo-branch ark<TAB><TAB>
arkcompiler_ets_frontend     arkcompiler_runtime_core     arkui_ace_engine             arkui_advanced_ui_component  arkui_ui_appearance          
arkcompiler_ets_runtime      arkcompiler_toolchain        arkui_ace_engine_lite        arkui_napi                   arkui_ui_lite

$ repo-branch arkui_ace_engine arkui_napi
arkui_ace_engine master
arkui_napi no branch
```

### `repo-cd`

Changes directory to the project or root.

```sh
$ repo-cd ark<TAB><TAB>
arkcompiler_ets_frontend     arkcompiler_runtime_core     arkui_ace_engine             arkui_advanced_ui_component  arkui_ui_appearance          
arkcompiler_ets_runtime      arkcompiler_toolchain        arkui_ace_engine_lite        arkui_napi                   arkui_ui_lite

$ repo-cd arkui_ace_engine
foundation/arkui/ace_engine$ repo-cd # repo root
```

### `repo-checkout`

Runs `git checkout` in all/listed projects.

```sh
$ repo-checkout master
```

Can be combined with `repo-rev-parse`:
```sh
$ repo-rev-parse > sha1.txt
$ repo-checkout sha1.txt
```

Or with `repo-branch`:
```sh
$ repo-branch > branches.txt
$ repo-checkout branches.txt
```

### `repo-clean`

Runs `git clean` in all projects.

```sh
$ repo-clean -xdf
```

### `repo-diff`

Runs `git diff` in all/specified projects.

```sh
$ repo-diff
```

### `repo-forall`

Same as `repo forall` but with auto-completion:

```sh
$ repo-forall ark<TAB><TAB>
arkcompiler_ets_frontend     arkcompiler_runtime_core     arkui_ace_engine             arkui_advanced_ui_component  arkui_ui_appearance          
arkcompiler_ets_runtime      arkcompiler_toolchain        arkui_ace_engine_lite        arkui_napi                   arkui_ui_lite
```

### `repo-ignore`

Ignores files for `repo-status`.

```sh
$ repo-status
some_project
Not currently on any branch.
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   package-lock.json
$ repo-ignore package-lock.json
$ repo-status
```

### `repo-init`

Same as `repo init` but with auto-completion:

```sh
$ repo-init -<TAB><TAB>
--archive          --clone-filter     --dissociate       --help             --manifest-url     --no-tags          -q                 --repo-url         --verbose          
-b                 --config-name      -g                 -m                 --mirror           -p                 --quiet            --submodules       
-c                 --current-branch   --groups           --manifest-branch  --no-clone-bundle  --partial-clone    --reference        -u                 
--clone-bundle     --depth            -h                 --manifest-name    --no-repo-verify   --platform         --repo-rev         -v
```

### `repo-lfs-fetch`

Runs `git lfs fetch` in all/specified projects.

```sh
$ repo-lfs-fetch -j8
LFS fetch: 100% (487/487) vendor_unionman
```

```sh
$ repo-lfs-fetch ark
arkcompiler_ets_frontend     arkcompiler_runtime_core     arkui_ace_engine             arkui_advanced_ui_component  arkui_ui_appearance          
arkcompiler_ets_runtime      arkcompiler_toolchain        arkui_ace_engine_lite        arkui_napi                   arkui_ui_lite                

$ repo-lfs-fetch -v arkui_ace_engine arkui_napi
LFS fetch: 50% (1/2) arkui_ace_engine
...
LFS fetch: 100% (2/2) arkui_napi
...
```

### `repo-lfs-pull`

Runs `git lfs pull` in all/specified projects.

```sh
$ repo-lfs-pull -j8
LFS pull: 100% (487/487) vendor_unionman
```

```sh
$ repo-lfs-pull ark
arkcompiler_ets_frontend     arkcompiler_runtime_core     arkui_ace_engine             arkui_advanced_ui_component  arkui_ui_appearance          
arkcompiler_ets_runtime      arkcompiler_toolchain        arkui_ace_engine_lite        arkui_napi                   arkui_ui_lite                

$ repo-lfs-pull -v arkui_ace_engine arkui_napi
LFS pull: 50% (1/2) arkui_ace_engine
...
LFS pull: 100% (2/2) arkui_napi
...
```

### `repo-mirror`

Runs `repo-sync` and `repo-lfs-fetch` in `REPO_MIRROR_LOCATION`.

```sh
$ repo-mirror -j8
```

### `repo-reset`

Runs `git reset` in all projects.

```sh
$ repo-reset --hard
```

### `repo-rev-parse`

Runs `git rev-parse` for `HEAD`/ref in all projects.

```sh
$ repo-rev-parse > sha1.txt
$ repo-checkout sha1.txt
```

### `repo-status`

Runs `git status` in all/specified projects.

```sh
$ repo-status ark<TAB><TAB>
arkcompiler_ets_frontend     arkcompiler_runtime_core     arkui_ace_engine             arkui_advanced_ui_component  arkui_ui_appearance          
arkcompiler_ets_runtime      arkcompiler_toolchain        arkui_ace_engine_lite        arkui_napi                   arkui_ui_lite

$ repo-status arkui_ace_engine arkui_napi
arkui_ace_engine nothing to commit, working tree clean
arkui_napi nothing to commit, working tree clean
```

### `repo-sync`

`repo sync` with auto-completion.

```sh
$ repo-sync -<TAB><TAB>
-c                          --fail-fast                 --help                      --manifest-name             --no-clone-bundle           --prune                     --smart-sync
--clone-bundle              --fetch-submodules          -j                          --manifest-server-password  --no-manifest-update        -q                          --smart-tag
--current-branch            --force-broken              --jobs                      --manifest-server-username  --no-repo-verify            --quiet                     -t
-d                          --force-remove-dirty        -l                          -n                          --no-tags                   --retry-fetches             -u
--detach                    --force-sync                --local-only                --network-only              --optimized-fetch           -s                          -v
-f                          -h                          -m                          --nmu                       -p                          --skip-hook                 --verbose
```

### `repo-unignore`

Unignores files for `repo-status`.

```sh
$ repo-status
$ repo-unignore package-lock.json
$ repo-status
some_project
Not currently on any branch.
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   package-lock.json
```
