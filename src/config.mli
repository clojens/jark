module Config :
  sig
    
    val set_env : unit -> Datatypes.env
    
    val get_env : unit -> Datatypes.env

    val cp_boot : unit -> string

    val getc : unit -> unit -> 'a list

    val cljr : string

    val cljr_lib : string

    val setup_cljr : unit -> unit

    val standalone : bool

    val install_components : unit -> unit
        
    val install_standalone : unit -> unit

    val jar_standalone : string

    val opts : (string, string) Hashtbl.t ref

    val get_port : unit -> int
     
    val get_host : unit -> string

    val get_jvm_opts : unit -> string

    val get_log_path : unit -> string

    val remove_config : unit -> unit

  end
