module Server :
  sig

    val cmd_usage : string -> unit -> unit

    val all_usage :  unit -> unit

    val dispatch : string list -> unit -> unit

  end

