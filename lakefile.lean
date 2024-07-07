import Lake
open Lake DSL

package «austinletson» where
  -- add package configuration options here

require verso from git "https://github.com/leanprover/verso"

lean_lib «Austinletson» where
  -- add library configuration options here

@[default_target]
lean_exe «austinletson» where
  root := `Main

@[default_target]
lean_exe demosite where
  srcDir := "examples/website"
  root := `DemoSiteMain
  -- Enables the use of the Lean interpreter by the executable (e.g.,
  -- `runFrontend`) at the expense of increased binary size on Linux.
  -- Remove this line if you do not need such functionality.
  supportInterpreter := true
