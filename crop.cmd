@echo off
REM Beauty mask: clips the cloud to a survey boundary polygon in plan view.
REM GLOBAL_SHIFT  keeps large projected coordinates within floating point precision
REM Z             axis to ignore, so the polygon applies in plan view
REM 20            vertex count, followed by each vertex as an x y pair
REM Replace the shift values and the vertex list with your own survey boundary.
cd "C:\Program Files\CloudCompare"
CloudCompare -O -GLOBAL_SHIFT <easting> <northing> 0 "%~1" -C_EXPORT_FMT LAS ^
  -CROP2D Z 20 <x1> <y1> <x2> <y2> <x3> <y3> <x4> <y4> <x5> <y5> <x6> <y6> ^
  <x7> <y7> <x8> <y8> <x9> <y9> <x10> <y10> <x11> <y11> <x12> <y12> ^
  <x13> <y13> <x14> <y14> <x15> <y15> <x16> <y16> <x17> <y17> <x18> <y18> ^
  <x19> <y19> <x20> <y20>
