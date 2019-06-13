# Ocaml Graphics -- What is it good for 

__The graphics library ... built into OCaml ... is more useful as a learning tool than anything else__

-from 'Real World OCaml' by Yaron Minsky, Anil Madhavapeddy & Jason Hickey

### A Quit Introduction
The graphics library that comes with OCaml is of limited use but very simple. Here is ten minute tutorial using an example.
Consider the following code to display a box:

```OCaml
open Graphics
 let () =
 (** 100X100 denotes the size and +10+10 the location *)
 open_graph " 100X100+50+50";
 set_window_title "Test";
 (** set foreground color. There is no way
    to set background color
    *)
 set_color red;
 (** draw rectangle x y width height *)
 draw_rect 10 10 80 80;
 (** wait until mouse button pressed
 otherwise the window will close at once.
 notice that wait_next event returns a status that 
 must be ignored *)
 wait_next_event [Button_down] |> ignore;

 close_graph ()

```
Thus in 8 lines of code we have displayed a box. 

### Some Annoyances

Some of the facilities it lacks are

* No clean way to handle window resize. The only way to do it is through polling which essentially means
that we need a sleep timer to avoid polling continuously. If we don't poll then  window resize can occur 
without the application being aware of it 
* No way handle time-out and mouse-down events concurrently. This means it is not possible to write even 
simple games that require animation
* A GUI is almost impossible. Cannot open a dialog box



Still the module has its uses. For example the attached code is a simple implementation of BrainVita whose rules can be 
read [here](https://thesundayprogrammer.wordpress.com/2011/03/19/brainvita-solution/). 
