module Server =
  struct

    open Optiontypes
    open Ntypes
    open Printf
    open Gstr
    open Glist
    open Gnet
    open Jark
    open Config
    module C = Config
    open Options
    open Gfile

    let usage cmd  =
      match cmd with
        | "start"   ->  [" [-p|--port=<9000>] [-j|--jvm-opts=<opts>] [--log=<path>]" ;
                         "   Start a local Jark server. Takes optional JVM options as a \" delimited string"]
        | "stop"    ->  [" [-n|--name=<vm-name>]";
                         "   Shuts down the current instance of the JVM (Run only on the server)"];
        | "install" ->  [" [--install_root=<path> (default:~/.cljr)] [--clojure_version=<1.3.0|1.2.1> (default:1.3.1)] [--force=<true|false> (default:false)]";
                          "   Install server components"];
        | "info"    ->  [" Display Jark server information"]
        | _         ->  ["Unknown command"]

    let cmd_usage cmd () = 
      Gstr.pe (Gstr.unlines (usage cmd))

    let all_usage () =
      let f cmd = 
        Gstr.pe cmd;
        Gstr.pe (Gstr.unlines (usage cmd)) in
      List.map f ["install"; "start"; "stop"; "info"];
      ()

    let load path =
      let apath = (Gfile.abspath path) in
      if (Gfile.exists apath) then
        Jark.nfa "jark.plugin.ns" ~f:"load" ~a:[apath] ()
      else begin
        Printf.printf "File not found %s\n" apath;
        ()
      end

    let cljr_lib () =
      Gfile.path [ C.platform.cljr ; "lib" ]

    let server_jar_url ver ()  =
      let jar =
        sprintf "jark-0.4.0-clojure-%s-standalone.jar" ver
      in
      let git_base = "https://github.com/downloads/icylisper/jark-server" in
      let url xs = String.concat "/" xs in
      url [git_base; jar]

    (* write out project.clj *)
    let setup_cljr () =
      let file = Gfile.path [C.platform.cljr ; "project.clj"] in
      let f = open_out(file) in
      let project_clj_string = Gstr.unlines [
        "(leiningen.core/defproject cljr.core/cljr-repo";
        "\"1.0.0\"";
        ":description \"cljr is a Clojure REPL and package management system.\"";
        ":dependencies [[org.clojure/clojure \"1.3.0\"]";
        "  [swank-clojure \"1.4.0\"]]";
        "  [org.clojure/java.classpath \"0.1.0\"]]";
        "  [org.clojure/data.json \"0.1.1\"]]";
        "  [org.clojure/tools.namespace \"0.1.0\"]]";
        "  [org.clojure/tools.nrepl \"0.0.5\"]]";
        "  [clj-http \"0.2.7\"]]";
        "  [server-socket \"1.0.0\"]]";
        ":classpath [\"./src/\" \"./\"]";
        ":repositories nil)";
      ]
      in
      fprintf f "%s\n" project_clj_string;
      close_out f

    (* commands *)

    let install () =
      (* check if jar already exists *)
      let o = C.get_server_opts () in
      C.check_valid_clojure_version o.clojure_version ();
      let install_location = C.server_jar o.install_root o.server_version o.clojure_version () in
      if Gfile.exists install_location then
        Gstr.pe ("Latest version already installed: " ^ install_location)
      else begin
        (* ensure install directories exist *)
        Gfile.mkdir o.install_root;
        Gfile.mkdir (C.cljr_lib o.install_root ());

        (* write out project.clj for cljr *)
        setup_cljr ();
        (* download jar *)
        let url = (server_jar_url o.clojure_version ()) in
        let out = Gnet.http_get o.http_client url  install_location in
        match out with 
          | 0 -> Gstr.pe ("Installed server to " ^ install_location)
          | _ -> Gstr.pe ("Failed to download server jar")
      end

    let uninstall args =
      Gstr.pe "Removed jark configs successfully"

    let info args =
      Jark.pfa "server" ~f:"info" ~a:args ()

    let clients args = 
      Jark.pfa "server" ~f:"clients" ~a:args ()

    let version args = 
      Jark.pfa "server" ~f:"version" ~a:args ()

    let cp_boot () =
      C.read_config ();
      C.classpath ()

    let outp log_file () =
      match log_file with 
        | ""  -> ""
        |  _  -> "&> " ^ log_file

    let start_cmd jvm_opts port log_file =
      let outp = outp log_file () in
      String.concat " " ["java"; (Gstr.uq jvm_opts) ; "-cp"; cp_boot (); "jark.server"; port; " "; outp; " &"]

    let start () =
      let opts = C.get_server_opts () in
      let jvm_opts = opts.jvm_opts in
      let env = C.get_env () in
      let port = string_of_int env.port in
      let c = start_cmd jvm_opts port opts.log_file in
      print_endline c;
      ignore (Sys.command c);
      Unix.sleep 3;
      printf "Started JVM on port %s\n" port
    
    let get_pid () =
      let msg = "(jark.server/pid)" in
      let pid = Gstr.strip (Jark.eval ~out:true ~value:false msg ()) in
      Gstr.maybe_int (Jark.value_of pid)

    let stop () =
      (* FIXME: Ensure that stop is issued only on the server *)
      match get_pid () with
        | None -> print_endline "Could not get pid of JVM"
        | Some pid ->
          begin
            printf "Stopping JVM with pid: %d\n" pid;
            Unix.kill pid Sys.sigkill;
          end

    let dispatch args () =
      match args with
        | "start"   :: []   -> start ()
        | "stop"    :: []   -> stop ()
        | "install" :: []   -> install ()
        | cmd       :: args -> Jark.nfa "jark.server" ~f:cmd ~a:args ()

end
