# scarab

State Machine functionality:

To get it to work:
  1. Add 1 main simple node wherever you need the state machine
  2. Attach to it the state_machine.gd
  3. To this main node add as many new nodes as you need which will hold the scripts for the other states (when creating these scripts they need to extend State)
  4. Connect and use them VIA the new calls, you can find them in the state.gd script.

New calls are used to interact with the state machine and new states. They are as follows:
  1. state_enter() equivalent to _enter(), it's called whenever the character enters a new state
  2. state_exit () same thing, it's called before a character enters a new state
  3. state_update(delta) equivalent to _process(delta)
  4. state_physics_update(delta) equivalent to _physics_process(delta)

If the above names are not convenient they can be modified by refactoring them in the state.gd script and state_machine.gd script wherever they are used.

A simple usage of these states can be seen in the base_enemy scene.
Good luck
