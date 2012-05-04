#! /usr/bin/lua

geo = require("geocalcs")

require("luaunit")

Test_geocalcs = {}

local eps = 0.001

function Test_geocalcs:test_distance_between()
   assert_close(geo.distance_between(0.0, 0.0, 0.0, 0.0, geo.spheroid),     0, eps)
   assert_close(geo.distance_between(0.0, 0.1, 0.0, 0.0, geo.spheroid), 637810, eps)
   assert_close(geo.distance_between(0.0, 0.0, 0.0, 0.1, geo.spheroid), 637810, eps)
   
   assert_close(geo.distance_between(math.rad(-43.490587), math.rad(172.564695), 
                                     math.rad(-43.490644), math.rad(172.564605), geo.spheroid),
                                     9.6483874243976, eps)
end


function Test_geocalcs:test_bearing()
   assert_close(geo.bearing(0.0, 0.0,  0.1,  0.0, geo.spheroid), math.rad(0) , eps)
   assert_close(geo.bearing(0.0, 0.0,  0.0,  0.1, geo.spheroid), math.rad(90), eps)
   assert_close(geo.bearing(0.0, 0.0, -0.1,  0.0, geo.spheroid), math.rad(180), eps)
   assert_close(geo.bearing(0.0, 0.0,  0.0, -0.1, geo.spheroid), math.rad(270), eps)

   assert_close(geo.bearing(math.rad(-43.490587), math.rad(172.564695), 
                            math.rad(-43.490644), math.rad(172.564605), geo.spheroid),
                            math.rad(228.87976757496), eps)
end


function Test_geocalcs:test_destination()
   lat, lon = geo.destination(0.0, 0.0,  637810,  math.rad(0), geo.spheroid)
   assert_close(lat, 0.1, eps)
   assert_close(lon, 0.0, eps)

   lat, lon = geo.destination(0.0, 0.0,  637810,  math.rad(90), geo.spheroid)
   assert_close(lat, 0.0, eps)
   assert_close(lon, 0.1, eps)

   lat, lon = geo.destination(0.0, 0.0,  637810,  math.rad(180), geo.spheroid)
   assert_close(lat, -0.1, eps)
   assert_close(lon,  0.0, eps)

   lat, lon = geo.destination(0.0, 0.0,  637810,  math.rad(270), geo.spheroid)
   assert_close(lat,  0.0, eps)
   assert_close(lon, -0.1, eps)
   
   lat, lon = geo.destination(math.rad(-43.490587), math.rad(172.564695),
                              9.6483874243976, math.rad(228.87976757496), geo.spheroid)
   assert_close(math.deg(lat), -43.490644, 0.000001)
   assert_close(math.deg(lon), 172.564605, 0.000001)
end

LuaUnit:run()

