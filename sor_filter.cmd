@echo off
REM Statistical outlier removal.
REM Arg 1  number of neighbours for the mean distance estimate
REM Arg 2  standard deviation multiplier
cd "C:\Program Files\CloudCompare"
CloudCompare -O "%~1" -C_EXPORT_FMT LAS -SOR 6 1
