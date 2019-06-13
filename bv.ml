(**
 * Build instructions
 *
 * ocamlc graphics.cma bv.ml
 *)
open Graphics

type box_type = 
   | Invalid_box_type
   | Empty_box_type
   | Fill_box_type  

let make_box () =
  let arr = Array.make_matrix 7 7 Invalid_box_type in
  Array.mapi (fun i a -> Array.mapi (fun j b -> 
     if i=3 && j=3 then   Empty_box_type
     else if (i>=2 && i <=4) then  Fill_box_type
     else if (j>=2 && j <=4) then  Fill_box_type
     else Invalid_box_type
  ) a ) arr

let open_window = 
      open_graph " 350X350+200+200";
      set_window_title "Brain Vita"

          (* no way of setting background color; resizing shows white *)
let clear_window color = 
  let fg = foreground in
  set_color color;
  fill_rect 0 0 (size_x ()) (size_y ());
  set_color fg

let draw_grid arr w h = 
      (* w and h are flipped from perspective of the matrix *)
  set_color red;
  Array.iteri (fun i a -> 
    Array.iteri (fun j b -> 
       let x = i*(w-1) in
       let y = j*(h-1) in
       match b with 
       | Empty_box_type -> draw_circle (x+w/2) (y+h/2) (w/2)
       | Fill_box_type -> fill_circle (x+w/2) (y+h/2) (w/2 -2)
       | Invalid_box_type -> ()
     ) a
  ) arr

let selected = ref None

let locate_indexi arr  x y w h= 
    let i = x/(w-1) and j = y/(h-1) in
    if i>=0 && j>=0 && i<7 && j<7 then
      match arr.(i).(j) with
        | Empty_box_type | Fill_box_type -> Some (i,j)
        | Invalid_box_type -> None
     else
        None

        (** we know that (i1,j1) and (i2,j2) point to a filled or empty slots
         * because both are the result of locate_indexi
         *)
let move arr i1 j1 i2 j2 =
   if ((i1=i2 && abs (j1-j2) = 2) || 
      (j1=j2 && abs (i1-i2) = 2)) && 
      arr.(i2).(j2) = Empty_box_type &&
      arr.((i1+i2)/2).((j1+j2)/2) = Fill_box_type then
        begin 
          Array.set arr.((i1+i2)/2) ((j1+j2)/2)  Empty_box_type ;
          Array.set arr.(i1) (j1)  Empty_box_type ;
          Array.set arr.(i2) (j2)  Fill_box_type ;
          true 
        end
   else false

let draw_selected i j w h= 
       let x = i*(w-1) in
       let y = j*(h-1) in
       begin
       draw_circle (x+w/2) (y+h/2) (w/2);
       fill_circle (x+w/2) (y+h/2) (w/2 - 4)
       end

  let rec event_loop arr = 
    (* there's no resize event so polling in required *)
    let wx' = ref  (size_x ())  and wy' = ref  (size_y ()) in 
      begin 
        if !wx' > !wy' then wx' := !wy' else wy' := !wx';
        clear_window white;
        draw_grid arr (!wx'/7) (!wy'/7);
        match !selected with 
        | None -> ()
        | Some (i,j) -> draw_selected i j (!wx'/7) (!wy'/7)
    end;
    let _ = wait_next_event [Button_down] in
    let x,y = mouse_pos () in 
        (
          match !selected with 
        | None -> selected := locate_indexi arr x y (!wx'/7) (!wy'/7)
        | Some (i,j) -> 
            match locate_indexi arr x y (!wx'/7) (!wy'/7) with
            | None -> () 
            | Some (i2,j2) ->
                selected := if move arr i j i2 j2 then  None
                else if arr.(i2).(j2)= Fill_box_type then Some(i2,j2) else None
        );
     event_loop arr

    let () =
      open_window;
      try event_loop  (make_box()) 
      with Graphic_failure _ -> print_endline "Exiting..."

                                          

