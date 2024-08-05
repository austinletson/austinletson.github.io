---
title: "Using Lake's Internal API to Programatically Access the Lake Workspace"
date: "2024-08-03" 
draft: false
tags : [
    "lean",
    "lean4",
    "lake",
]
categories : [
    "lean",
]
---

Sometimes it is useful to programmatically understand the structure of a Lean package or Lake environment.
Lake's internal API is a powerful tool, but isn't always easy to access.
In this post we will explore how to access Lake's API and look at some example use cases.

## Alternatives to consider

Before diving into Lake's internal API, consider the following alternatives:

- manually parsing `lakefile.{lean, toml}`
- manually parsing `lake-manifest.json`.
- running `lake check-test` or `lake check-lint` to identify `test_driver` and `lint_driver` targets.

## Lake's internal API

When manually parsing is too brittle or doesn't give enough details,
Lake's internal API provides a powerful, but somewhat inconvenient alternative.

### Loading the Lake Workspace

From Lake's [Glossary of Terms](https://github.com/leanprover/lean4/tree/master/src/lake#glossary-of-terms):

> A workspace is the broadest organizational unit in Lake. It bundles together a package (termed the root), its transitive dependencies, and Lake's environment. Every package can operate as the root of a workspace and the workspace will derive its configuration from this root.

In our case, the Lake workspace is the key
to accessing useful information about our Lake package and environment.

Here are the steps to load Lake's workspace:

- find the elan, Lake, and Lean installations on your machine
- load the Lake configuration
- load the Lake workspace using the Lake configuration

Lake provides a function for each of these steps,
however accessing these functions from `IO` is kind of annoying
because they are wrapped in Lake's internal monads.

In order to simplify access to the workspace you can wrap all three calls in a function:

```lean4
import Lake.CLI.Main

open Lake

def loadLakeWorkspace : IO Workspace := do 
  let (elanInstall?, leanInstall?, lakeInstall?) ← findInstall?
  let config ← MonadError.runEIO <| mkLoadConfig { elanInstall?, leanInstall?, lakeInstall? }
  let workspace ← MonadError.runEIO <| MainM.runLogIO (loadWorkspace config)
  return workspace
```

### Using Lake's workspace to access information about a Lake package

The Lake documentation contains the spec for the `Workspace` structure ([link](https://leanprover-community.github.io/mathlib4_docs/Lake/Config/Workspace.html)).
Below are a few examples of how to access the workspace

#### Example: `lean_lib`'s in the root package

```lean4
def leanLibs : IO (List Name) := do
  return (← loadLakeWorkspace).root.leanLibs.map (·.name) |>.toList
```

#### Example: root modules of `lean_exe` or `lean_lib` default targets

When running a linter,
you may want to determine all the root Lean modules of your project.
You can leverage the Lake workspace to compile a list of all roots of `lean_exe` or `lean_lib` build targets
You can run your linter on the root modules.

```lean4
/-- Returns the root modules of `lean_exe` or `lean_lib` default targets in the Lake workspace. -/
def resolveDefaultRootModules : IO (Array Name) := do
  -- load the Lake workspace
  let workspace ← loadLakeWorkspace

  -- resolve the default build specs from the Lake workspace (based on `lake build`)
  let defaultBuildSpecs ← match resolveDefaultPackageTarget workspace workspace.root with
    | Except.error e => IO.eprintln s!"Error getting default package target: {e}" *> IO.Process.exit 1
    | Except.ok targets => pure targets

  -- build an array of all root modules of `lean_exe` and `lean_lib` build targets
  let defaultTargetModules := defaultBuildSpecs.concatMap <|
    fun target => match target.info with
      | BuildInfo.libraryFacet lib _ => lib.roots
      | BuildInfo.leanExe exe => #[exe.config.root]
      | _ => #[]

  return defaultTargetModules
```

### Warning about stability

Since Lake is under active development, the API is not guaranteed to be stable,
meaning you may need to update your logic as Lake evolves.

# References

- [Zulip thread on programmatically accessing `lean_lib`](https://leanprover.zulipchat.com/#narrow/stream/270676-lean4/topic/Accessing.20.60lean_lib.60s.20in.20a.20lake.20executable/near/437906939)
- [Lake's docs](https://github.com/leanprover/lean4/tree/master/src/lake#readme)
