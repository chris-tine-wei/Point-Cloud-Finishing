@echo off
REM Noise filter and beauty mask in a single pass, exporting to LAS.
REM Replace the shift values and the vertex list with your own survey boundary.
cd "C:\Program Files\CloudCompare"
CloudCompare -O -GLOBAL_SHIFT <easting> <northing> 0 "%~1" -C_EXPORT_FMT LAS ^
  -NOISE RADIUS 0.4 REL 1.0 RIP ^
  -CROP2D Z 20 <x1> <y1> <x2> <y2> ... <x20> <y20>
