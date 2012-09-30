module Ghash =
  struct

    open Unix
    open Printf

    let list_to_assoc xs =
      let l1 = drop_nth xs 2 in
      let l2 = drop 1 (drop_nth xs 3) in 
      zip l1 l2

    let keys h = Hashtbl.fold (fun key _ l -> key :: l) h []

    let values h = Hashtbl.fold (fun _ value l -> value :: l) h []

    let print h =
      List.iter
        (fun key ->
          printf "%s => %s\n" key (Hashtbl.find h key))
        (keys h)

    let assoc_to_hashtbl assoc_xs = 
      let h = Hashtbl.create 0 in
      List.iter (fun (k,v) -> Hashtbl.replace h k v) assoc_xs ;
      h

    let list_to_hashtbl xs =
      let assoc_xs = list_to_assoc xs in
      assoc_to_hashtbl assoc_xs

  end 
