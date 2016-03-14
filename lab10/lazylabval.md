Write the step-by-step lazy evaluation of each of the following _`lazyCaml`_ expressions; or if the expression does not terminate with a normal form, state why:
```
take 2 (dfs (crazytree 2 "run"))
take 2 (dfs (Node(crazytree (1) ("arun"), crazytree 2 ("buffalorun"))))
take 2 (dfs(crazytree 1 ("arun")) @ dfs (crazytree 2 ("buffalorun")))
take 2 (dfs(Node(crazytree 0 "aarun", crazytree 1 "buffaloarun")) @ dfs (crazytree 2 ("buffalorun")))
take 2 (dfs(crazytree 0 "aarun") @ dfs(crazytree 1 "buffaloarun")) @ dfs (crazytree 2 ("buffalorun"))
take 2 (dfs(Leaf "aarun") @ dfs(crazytree 1 "buffaloarun")) @ dfs (crazytree 2 ("buffalorun"))
take 2 (["aarun"] @ dfs(crazytree 1 "buffaloarun")) @ dfs (crazytree 2 ("buffalorun"))
"aarun"::(take 1 (dfs(crazytree 1 "buffaloarun") @ dfs (crazytree 2 ("buffalorun"))))
"aarun"::(take 1 (dfs(Node(crazytree 0 "abuffaloarun", crazytree 1 "buffalobuffaloarun")) @ dfs (crazytree 2 ("buffalorun"))))
"aarun"::(take 1 ((dfs(crazytree 0 "abuffaloarun") @ dfs(crazytree 1 "buffalobuffaloarun"))@ dfs (crazytree 2 ("buffalorun"))))
"aarun"::(take 1 ((dfs(Leaf "abuffaloarun") @ dfs(crazytree 1 "buffalobuffaloarun")) @ dfs (crazytree 2 ("buffalorun"))))
"aarun"::(take 1 ((["abuffaloarun"] @ dfs(crazytree 1 "buffalobuffaloarun")) @ dfs (crazytree 2 ("buffalorun"))))
"aarun"::("abuffaloarun"::(take 0 (dfs(crazytree 1 "buffalobuffaloarun")) @ dfs (crazytree 2 ("buffalorun"))))
"aarun"::("abuffaloarun"::([]))
["aarun";"abuffaloarun"]

```

```
treefind (crazytree 1 "?") "abuffalo?"
treefind (Node(crazytree 0 "a?", crazytree 1 "buffalo?")) "abuffalo?"
(treefind (crazytree 0 "a?") "abuffalo?") || (treefind (crazytree 1 "buffalo?") "abuffalo?")
(treefind (Leaf "a?") "abuffalo?") || (treefind (crazytree 1 "buffalo?") "abuffalo?")
false || (treefind (crazytree 1 "buffalo?") "abuffalo?")
false || (treefind (Node (crazytree 0 "abuffalo?", crazytree 1 "buffalobuffalo?")) "abuffalo?")
false || ((treefind (crazytree 0 "abuffalo?") "abuffalo?") || (treefind (crazytree 1 "buffalobuffalo?") "abuffalo?"))
false || ((treefind (Leaf "abuffalo?") "abuffalo?") || (treefind (crazytree 1 "buffalobuffalo?") "abuffalo?"))
false || ((true || (treefind (crazytree 1 "buffalobuffalo?") "abuffalo?"))

true
```

```
treefind (crazytree 1 "!") "buffalobuffalo!"
treefind (Node(crazytree 0 "a!", crazytree 1 "buffalo!")) "buffalobuffalo!"
(treefind (crazytree 0 "a!") "buffalobuffalo!") || (treefind (crazytree 1 "buffalo!") "buffalobuffalo!")
(treefind (Leaf "a!") "buffalobuffalo!") || (treefind (crazytree 1 "buffalo!") "buffalobuffalo!")
false || (treefind (crazytree 1 "buffalo!") "buffalobuffalo!")
false || (treefind (Node(crazytree 0 "abuffalo!", crazytree 1 "buffalobuffalo!")) "buffalobuffalo!")
false || ((treefind (crazytree 0 "abuffalo!") "buffalobuffalo!") || (treefind (crazytree 1 "buffalobuffalo!") "buffalobuffalo!")false || ((treefind (Leaf "abuffalo!") "buffalobuffalo!") || (treefind (crazytree 1 "buffalobuffalo!") "buffalobuffalo!")
false || (false || (treefind (Node (crazytree 0 "abuffalobuffalo!, crazytree 1 "buffalobuffalobuffalo!")) "buffalobuffalo!"))
.
.
.

Since crazytree's leaves already have greater length than the string we are trying to compare, thus it will not terminate with a normal form and crazytree will just keep growing.
```
