turtles-own [
  activity?
  collision-counter
]
globals [numberOfMoshpitters numberOfActiveMoshpitters total-time-ticks total-time-to-become-active count-active-red ]
breed [active-moshpitters active-moshpitter]
breed [inactive-moshpitters inactive-moshpitter]
breed [characters characters-person]


;---------------- setting up the world and characters ----------------------

to setup
  clear-all
  reset-ticks
  set numberOfMoshpitters inactiveMoshpitters
  set numberOfActiveMoshpitters activeMoshpitters
  setupMoshpitters
  setup-stage
  setupCharacters
  setup-walls
  set total-time-to-become-active 0

end

to setup-stage ; This function sets up the blue stage in the top middle of the screen
  let xMin -8
  let xMax 8
  let yMin 12
  let yMax 17

  ;loop around and draw the blue stage
  let i 0
  repeat (xMax - xMin + 1) [
    let x xMin + i
    let j 0
    repeat (yMax - yMin + 1) [
      let y yMin + j
      ask patches with [pxcor = x and pycor = y] [set pcolor blue]
      set j j + 1
    ]
    set i i + 1
  ]
end

to setupCharacters ; This function sets up the three singers on the stage
create-characters 1
[
set shape "person lumberjack"
set size 2.5
set color grey
setxy -5 14
]

create-characters 2
[
set shape "person lumberjack"
set size 2.5
set color grey
setxy 5 14

]

create-characters 3
[
set shape "person lumberjack"
set size 2.5
set color grey
setxy 0 14
]
end

to setup-walls ; This function sets the blue square wall around the venue
  ask patches with [abs pxcor = max-pxcor] ; left and right walls
    [ set pcolor blue ]
  ask patches with [abs pycor = max-pycor] ; Top and bottom walls
    [ set pcolor blue ]
end

to setupMoshpitters
  let centerX 0
  let centerY 5
  let spread 5
  let maxSpread 10

  set total-time-ticks 0
  set count-active-red 0


  create-active-moshpitters numberOfActiveMoshpitters
  [
    set shape "circle"
    set size 1.5
    set color red

   let newX (centerX + random-float spread - spread / 2) ; Calculate a random x coordinate within the spread around the centerX
   let newY (centerY + random-float spread - spread / 2) ; Calculate a random y coordinate within the spread around the centerY

    ; If the newX and newY are within the maxSpread, set the moshpitter's xy position
   if abs(newX - centerX) <= maxSpread and abs(newY - centerY) <= maxSpread [
     setxy newX newY
    ]

    set activity? true
    set collision-counter 0
  ]

  let centerXInactive 0
  let centerYInactive -5
  let spreadInactive 20

  ; This sets a maximum of 650 to the sliders
 if (inactiveMoshpitters + numberOfActiveMoshpitters > 650) [
    set inactiveMoshpitters 650 - numberOfActiveMoshpitters]


  create-inactive-moshpitters inactiveMoshpitters
  [
    set shape "circle"
    set size 1.5
    set color grey

    ; Calculate a random x coordinate within the spreadInactive around the centerXInactive
    setxy (centerXInactive + random-float spreadInactive - spreadInactive / 2)

    ; Calculate a random y coordinate within the spreadInactive around the centerYInactive
    (centerYInactive + random-float spreadInactive - spreadInactive / 2)
    set activity? false

  ; This sets a maximum of 650 to the sliders
    if (inactiveMoshpitters + numberOfActiveMoshpitters > 650) [
      set inactiveMoshpitters 650 - numberOfActiveMoshpitters]

  ]



end


;---------------- setting up the behaviours of the agents ----------------------


to check-collision ; Check for collisions between active and inactive moshpitters
  ask active-moshpitters [
    let potential-colliders inactive-moshpitters with [distance myself <= 1.5] ; Identify potential colliders - inactive moshpitters within a distance of 1.5

    ; If there are any potential colliders ask them to increment the collision counter
    if any? potential-colliders [
      ask potential-colliders [
        set collision-counter collision-counter + 1

        ; If the collision counter reaches 5 or more set activity status to true and color to red
        if collision-counter >= 5 [
          set activity? true
          set color red
          set total-time-ticks total-time-ticks + ticks ; Add the total number of ticks to the collider's total time ticks and increment the count of active moshpitters
          set count-active-red count-active-red + 1

        ]
      ]
    ]
  ]
end


; This code implements the "jitter" procedure for the inactive-moshpitters.

to jitter
  ; This is to check if the agent is not on the blue patches
   if ([pcolor] of patch xcor ycor = blue) [
    move-to one-of patches with [pcolor != blue ]
  ]

  ; Then, the x and y coordinates of the agent are slightly randomized by adding a random value between -0.5 and 0.5.
  ; The x and y values are only updated if they remain within the boundaries defined by `min-pxcor` and `max-pxcor`.

  let randomX (-0.5 + random-float 1)
  if (xcor + randomX >= min-pxcor) and (xcor + randomX <= max-pxcor) [    set xcor (xcor + randomX)  ]
  let randomY (-0.5 + random-float 1)
  if (ycor + randomY >= min-pycor) and (ycor + randomY <= max-pycor) [    set ycor (ycor + randomY)  ]
end

to jitterActivemoshpitters
let myXcor xcor
let myYcor ycor
let maxSpread 2

; This is to check if the agent is not on the blue patches
if ([pcolor] of patch xcor ycor = blue)  [
move-to one-of patches with [pcolor != blue ]
]

let closestNeighbor one-of patches with [pcolor = red or pcolor = grey]
 if closestNeighbor = nobody [ ; If there is no red or grey neighbor, then jitter randomly untill you do find a closest neighbour
    let randomX random-float maxSpread * 2 - maxSpread
    let randomY random-float maxSpread * 2 - maxSpread

 ; Check if xcor + randomX is within the bounds of the world
 if (myXcor + randomX >= (min-pxcor + maxSpread)) and (myXcor + randomX <= (max-pxcor - maxSpread)) [set xcor (myXcor + randomX)]
 ; Check if ycor + randomY is within the bounds of the world
 if (myYcor + randomY >= (min-pycor + maxSpread)) and (myYcor + randomY <= (max-pycor - maxSpread)) [set ycor (myYcor + randomY)]
  ]

if closestNeighbor != nobody [ ; Jitter towards closestNeighbor
let targetXcor (mean [xcor] of closestNeighbor)
let targetYcor (mean [ycor] of closestNeighbor)
let randomX ((targetXcor - myXcor) * 0.5 + random-float 1 - 0.5)


; Check if xcor + randomX is within the bounds of the world
if (myXcor + randomX >= (min-pxcor + maxSpread)) and (myXcor + randomX <= (max-pxcor - maxSpread)) [
set xcor (myXcor + randomX)
]
]
end

;---------------- Go function ----------------------

to go
ask inactive-moshpitters [jitter  ]
ask active-moshpitters [ jitterActivemoshpitters check-collision ]
  tick
  if inactive-moshpitter-counter = 0 [ stop ] ;stop the plot when all the moshpitters are active




end

;---------------- Report functions ----------------------



to-report avg-moshpit-time ;report the average time it takes for all moshpitters to become active
  ask inactive-moshpitters with [activity? = false] [
     set total-time-to-become-active total-time-to-become-active + ticks
    ]
  if active-moshpitter-counter > 0 [    report total-time-to-become-active / active-moshpitter-counter  ]
  report 0
end

to-report percentage-inactive-Moshpitters ;report the percentage of inactive moshpitters
  ifelse any? turtles
  [ report (count turtles with [ activity? = false ] / count turtles) * 100 ]
  [ report 0 ]
end


to-report percentage-active-Moshpitters ;report the percentage of active moshpitters
  ifelse any? turtles
  [ report (count turtles with [ activity? = true ] / count turtles) * 100 ]
  [ report 0 ]
end

to-report active-moshpitter-counter ;report the number of active moshpitters
  ifelse any? turtles
  [ report (count turtles with [ activity? = true ]  )]
  [ report 0 ]
end

to-report inactive-moshpitter-counter ;report the number of inactive moshpitters
  ifelse any? turtles
  [ report (count turtles with [ activity? = false ]  )]
  [ report 0 ]
end
@#$#@#$#@
GRAPHICS-WINDOW
131
10
620
500
-1
-1
15.52
1
10
1
1
1
0
1
1
1
-15
15
-15
15
0
0
1
ticks
30.0

BUTTON
30
13
96
46
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
31
58
97
91
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
631
10
1026
43
inactiveMoshpitters
inactiveMoshpitters
0
650
87.0
1
1
NIL
HORIZONTAL

PLOT
631
192
833
343
Average Moshpit Time 
Ticks
Average-Time
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"All Inactive" 1.0 0 -13791810 true "" "plot avg-moshpit-time"

TEXTBOX
360
61
510
79
Stage
11
0.0
1

TEXTBOX
96
234
246
252
Exit
11
0.0
1

TEXTBOX
349
515
499
533
Entrance
11
0.0
1

SLIDER
631
50
1027
83
activeMoshpitters
activeMoshpitters
0
650
5.0
1
1
NIL
HORIZONTAL

MONITOR
631
90
831
135
Active Moshpitters Counter
active-moshpitter-counter
17
1
11

MONITOR
631
142
832
187
% Active Moshpitters
percentage-active-Moshpitters
17
1
11

MONITOR
843
90
1028
135
Inactive Moshpitter Counter
inactive-moshpitter-counter
17
1
11

MONITOR
843
143
1029
188
% Inactive Moshpitters
percentage-inactive-Moshpitters
17
1
11

PLOT
631
347
1032
500
Moshpitters Count
Ticks
Amount of Moshpitters
0.0
100.0
0.0
100.0
true
true
"" ""
PENS
"Inactive" 1.0 0 -11053225 true "" "plot inactive-moshpitter-counter"
"Active" 1.0 0 -5298144 true "" "plot active-moshpitter-counter"

PLOT
842
192
1030
342
Total Moshpit Time
Ticks
Total Time
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -5825686 true "" "plot total-time-to-become-active"

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

lander
true
0
Polygon -7500403 true true 45 75 150 30 255 75 285 225 240 225 240 195 210 195 210 225 165 225 165 195 135 195 135 225 90 225 90 195 60 195 60 225 15 225 45 75

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

music notes 1
false
0
Polygon -7500403 true true 75 210 96 212 118 218 131 229 135 238 135 243 131 251 118 261 96 268 75 270 55 268 33 262 19 251 15 242 15 238 19 229 33 218 54 212
Rectangle -7500403 true true 120 90 135 255
Polygon -7500403 true true 225 165 246 167 268 173 281 184 285 193 285 198 281 206 268 216 246 223 225 225 205 223 183 217 169 206 165 197 165 193 169 184 183 173 204 167
Polygon -7500403 true true 120 60 120 105 285 45 285 0
Rectangle -7500403 true true 270 15 285 195

music notes 3
false
0
Polygon -7500403 true true 135 195 156 197 178 203 191 214 195 223 195 228 191 236 178 246 156 253 135 255 115 253 93 247 79 236 75 227 75 223 79 214 93 203 114 197
Rectangle -7500403 true true 180 30 195 225
Polygon -7500403 true true 194 66 210 80 242 93 271 94 293 84 301 68 269 69 238 60 213 46 197 34 193 30

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -5825686 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -5825686 true false 195 90 240 150 225 180 165 105
Polygon -5825686 true false 105 90 60 150 75 180 135 105

person lumberjack
false
0
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -8630108 true false 60 196 90 211 114 155 120 196 180 196 187 158 210 211 240 196 195 91 165 91 150 106 150 135 135 91 105 91
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -16777216 true false 174 90 181 90 180 195 165 195
Polygon -16777216 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -16777216 true false 126 90 119 90 120 195 135 195
Line -16777216 false 135 165 165 165
Line -16777216 false 135 135 165 135
Line -16777216 false 90 135 120 135
Line -16777216 false 105 120 120 120
Line -16777216 false 180 120 195 120
Line -16777216 false 180 135 210 135
Line -16777216 false 90 150 105 165
Line -16777216 false 225 165 210 180
Line -16777216 false 75 165 90 180
Line -16777216 false 210 150 195 165
Line -16777216 false 180 105 210 180
Line -16777216 false 120 105 90 180
Line -16777216 false 150 135 150 165
Polygon -11221820 true false 100 30 104 44 189 24 185 10 173 10 166 1 138 -1 111 3 109 28
Polygon -16777216 true false 60 210 75 255 45 225 45 195
Circle -7500403 true true 30 195 30

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>avg-moshpit-time</metric>
    <metric>active-moshpitter-counter</metric>
    <metric>inactive-moshpitter-counter</metric>
    <metric>percentage-inactive-Moshpitters</metric>
    <metric>percentage-active-Moshpitters</metric>
    <metric>total-time-to-become-active</metric>
    <enumeratedValueSet variable="activeMoshpitters">
      <value value="1"/>
      <value value="2"/>
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="inactiveMoshpitters">
      <value value="650"/>
      <value value="325"/>
      <value value="162"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
