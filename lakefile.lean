import Lake

open Lake DSL

package vopm where

require mathlib from git
  "https://github.com/leanprover-community/mathlib4" @ "9c3101a274bcc37e8aa14424129a1f541e09cbc6"

@[default_target]
lean_lib VOPM where
