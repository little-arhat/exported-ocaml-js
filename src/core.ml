
(* open CCResult *)

module Html = Dom_html

let jss s = Js.string s

let log s =
  Firebug.console##log (jss s)
let logss s =
  Firebug.console##log s


type x = (int * string * int) [@@deriving jsobject]

let string_of_x = function (i1, s, i2) ->
                           Printf.sprintf "(%d, %s, %d)" i1 s i2

type a = A | B of string | C of x [@@deriving jsobject]

let string_of_a a = match a with
  | A -> "A"
  | B(s) -> Format.sprintf "B(%s)" s
  | C(x) -> Format.sprintf "C(%s)" (string_of_x x)

let throw:(Js.error Js.t -> 'a) = Js.Unsafe.pure_js_expr "caml_raise_constant"
(* (\* external thr : exn -> 'a = "caml_raise_constant" *\) *)

(* let test_x obj = *)
(*   match (x_of obj) with *)
(*   | Ok(tpl) -> Firebug.console##log (jss @@ string_of_x tpl) *)
(*   | Error(msg) -> htrow @@ new%js Js.error_constr (jss msg) *)

(* let test_a obj = *)
(*   match (a_of_js_repr obj) with *)
(*   | Ok(a) -> Firebug.console##log (jss @@ string_of_a a) *)
(*   | Error(msg) -> throw @@ new%js Js.error_constr (jss msg) *)

let test_raise () =
  throw @@ new%js Js.error_constr (Js.string "test")


let export (field : string) value =
  Js.Unsafe.set
    (Js.Unsafe.variable "exports")
    field value

let () =
  let tval = (1, "test", 10) in
  let aval1 = A in
  let aval2 = B("test") in
  let aval3 = C(tval) in
  let () = export "tval" (jsobject_of_x tval) in
  let () = export "aval1" (jsobject_of_a aval1) in
  let () = export "aval2" (jsobject_of_a aval2) in
  let () = export "aval3" (jsobject_of_a aval3) in
  (* let () = export "test_x" @@ Js.Unsafe.callback test_x in *)
  (* let () = export "test_a" @@ Js.Unsafe.callback test_a in *)
  let () = export "test_raise" @@ test_raise in
  let () = export "myerr" @@ new%js Js.error_constr (jss "test error") in
  ()
