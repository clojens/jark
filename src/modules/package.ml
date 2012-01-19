module Package =
  struct

    open Datatypes
    open Glist
    open Gstr
    open Jark
    open Config
    open Gopt
    open Plugin

    let registry = Plugin.create ()
    let register_fn = Plugin.register_fn registry
    let alias_fn = Plugin.alias_fn registry

    let show_usage args = Plugin.show_usage registry "package"

    let install args =
      let package = Gopt.getopt "--package" () in 
      Jark.nfa "jark.package" ~f:"install" ~a:[package] ()

    let versions args =
      let package = Gopt.getopt "--package" () in 
      Jark.nfa "jark.package" ~f:"versions" ~a:[package] ()

    let latest args =
      let package = Gopt.getopt "--package" () in 
      Jark.nfa "jark.package" ~f:"latest-version" ~a:[package] ()

    let search args =
      let package = Gopt.getopt "--package" () in
      Jark.nfa "jark.package" ~f:"search" ~a:[package] ~fmt:ResHash ()

    let deps args =
      Gstr.pe "deps not implemented yet"

    let uninstall args =
      Gstr.pe "uninstall not implemented yet"

    let pkg_list args =
      Jark.nfa "jark.package" ~f:"list" ~fmt:ResHash ()

    let _ =
      register_fn "install" install [
        "-p|--package <package> [-v|--version <version>]" ;
        "Install the relevant version of package from clojars"] ;

      register_fn "uninstall" uninstall [
        "-p|--package <package>";
        "Uninstall the package"];

      register_fn "versions" versions [
        "-p|--package <package>" ;
        "List the versions of package installed"];

      register_fn "deps" deps [
        "-p|--package <package> [-v|--version <version>]";
        "Print the library dependencies of package\n"];

      register_fn "search" search [
        "-p|--package <package>";
        "Search clojars for package\n"];

      register_fn "latest" latest [
        "-p|--package <package>" ;
        "Print the latest version of the package" ];

      register_fn "list" pkg_list ["List all packages installed\n"];

      alias_fn "list" ["ls"; "installed"]

    let dispatch cmd arg =
      Gopt.opts := (Glist.list_to_hashtbl arg);
      Plugin.dispatch registry cmd arg

end
