let read_items = ref false
let print_items = ref false
let read_cons = ref false
let print_cons = ref false
let verbose = ref 0
let check_invars = ref true
let path = ref ""

let spec = [
  ("-i", Arg.Set read_items, "Read the items");
  ("-ii", Arg.Set print_items, "Print the items");
  ("-c", Arg.Set read_cons, "Read the constructs");
  ("-cc", Arg.Set print_cons, "Print the constructs");
  ("-v", Arg.Int (fun i -> verbose := i), "Print detailed information. Higher number means more information.");
  ("--ignore-invars", Arg.Clear check_invars, "Skip the checking of data invariants");
  ("-p", Arg.String (fun p -> path := p), "Pass a path for rendering");
]
