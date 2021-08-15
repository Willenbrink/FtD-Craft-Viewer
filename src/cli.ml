let read_items = ref false
let print_items = ref false
let read_cons = ref false
let print_cons = ref false
let verbose = ref false
let check_invars = ref true

let spec = [
  ("-i", Arg.Set read_items, "Read the items");
  ("-ii", Arg.Set print_items, "Print the items");
  ("-c", Arg.Set read_cons, "Read the constructs");
  ("-cc", Arg.Set print_cons, "Print the constructs");
  ("-v", Arg.Set verbose, "Print detailed information");
  ("--ignore-invars", Arg.Clear check_invars, "Skip the checking of data invariants");
]
