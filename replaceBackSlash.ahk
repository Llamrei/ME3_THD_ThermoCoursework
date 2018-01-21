SetKeyDelay, 0

^v::
      StringReplace,clipboard,clipboard,\,/,All
      send %clipboard%
   return