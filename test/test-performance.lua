#! /usr/bin/lua

p = require('performance')

print('Calibrating...')

p.calibrate()
print('Resolution: ', p.clock_resolution)
print('gettime() overhead: ', p.gettime_calibration.ave, p.gettime_calibration.t_total, p.gettime_calibration.n)

