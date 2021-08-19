let path = ref ""

let spec = [
  ("-p", Arg.String (fun p -> path := p), "Pass a path for rendering");
]
