@echo off
REM Noise filter: fits a local surface around each point, drops points too far from it.
REM RADIUS  spherical neighbourhood used for the surface fit
REM REL     max error relative to the local spread (use ABS for an absolute distance)
REM RIP     remove isolated points
cd "C:\Program Files\CloudCompare"
CloudCompare -O "%~1" -C_EXPORT_FMT LAS -NOISE RADIUS 0.4 REL 1.0 RIP
