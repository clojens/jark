module Vm :
  sig

    val dispatch : string -> string list -> unit

    val usage : string

  end