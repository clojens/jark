module Ghash :
  sig

    val assoc_to_hashtbl : ('a * 'b) list -> ('a, 'b) Hashtbl.t

    val print : (string, string) Hashtbl.t -> unit

    val keys : ('a, 'b) Hashtbl.t -> 'a list

    val values : ('a, 'b) Hashtbl.t -> 'b list
        
    val list_to_hashtbl : 'a list -> ('a, 'a) Hashtbl.t

  end
