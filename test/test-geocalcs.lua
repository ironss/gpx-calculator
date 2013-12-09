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

function Test_geocalcs:test_calculate_t_points()
	local trk = 
	{  
		{
		  ["lon"] = 3.012077721372,
		  ["lat"] = -0.75910954296501,
		  ["time"] = 1335729885,
		},
		{
		  ["lon"] = 3.0120696579509,
		  ["lat"] = -0.75910428952396,
		  ["time"] = 1335730114,
		},
		{
		  ["lon"] = 3.0120728519034,
		  ["lat"] = -0.75909678460818,
		  ["time"] = 1335730150,
		},
		{
		  ["lon"] = 3.0120696404976,
		  ["lat"] = -0.75908924478581,
		  ["time"] = 1335730197,
		},
		{
		  ["lon"] = 3.01206148981,
		  ["lat"] = -0.75908400879806,
		  ["time"] = 1335730230,
		},
		{
		  ["lon"] = 3.0120544386798,
		  ["lat"] = -0.75907755107982,
		  ["time"] = 1335730257,
		},
		{
		  ["lon"] = 3.01204723047,
		  ["lat"] = -0.75907126789452,
		  ["time"] = 1335730300,
		},
		{
		  ["lon"] = 3.0120427624271,
		  ["lat"] = -0.75906397241824,
		  ["time"] = 1335730331,
		},
		{
		  ["lon"] = 3.0120473177365,
		  ["lat"] = -0.75905676420843,
		  ["time"] = 1335730366,
		},
		{
		  ["lon"] = 3.0120418374026,
		  ["lat"] = -0.75904997487764,
		  ["time"] = 1335730401,
		},
		{
		  ["lon"] = 3.012030702202,
		  ["lat"] = -0.75905095226202,
		  ["time"] = 1335730440,
		},
		{
		  ["lon"] = 3.0120240001377,
		  ["lat"] = -0.75905711327428,
		  ["time"] = 1335730479,
		},
		{
		  ["lon"] = 3.0120133536292,
		  ["lat"] = -0.75905517595881,
		  ["time"] = 1335730517,
		},
		{
		  ["lon"] = 3.0120059010733,
		  ["lat"] = -0.75904925929265,
		  ["time"] = 1335730551,
		},
		{
		  ["lon"] = 3.0120099676905,
		  ["lat"] = -0.7590418940032,
		  ["time"] = 1335730590,
		},
		{
		  ["lon"] = 3.0119982565312,
		  ["lat"] = -0.75903660565557,
		  ["time"] = 1335730643,
		},
		{
		  ["lon"] = 3.0119888666598,
		  ["lat"] = -0.75903227723903,
		  ["time"] = 1335730667,
		},
		{
		  ["lon"] = 3.0119797909477,
		  ["lat"] = -0.75902761720992,
		  ["time"] = 1335730704,
		},
		{
		  ["lon"] = 3.0119708374087,
		  ["lat"] = -0.75902313171375,
		  ["time"] = 1335730729,
		},
		{
		  ["lon"] = 3.0119609413918,
		  ["lat"] = -0.75901960614866,
		  ["time"] = 1335730768,
		},
		{
		  ["lon"] = 3.011951167548,
		  ["lat"] = -0.75901602822369,
		  ["time"] = 1335730805,
		},
		{
		  ["lon"] = 3.0119421092892,
		  ["lat"] = -0.75901143800776,
		  ["time"] = 1335730848,
		},
		{
		  ["lon"] = 3.011931061355,
		  ["lat"] = -0.75900862802766,
		  ["time"] = 1335730888,
		},
		{
		  ["lon"] = 3.0119207290058,
		  ["lat"] = -0.75900585295415,
		  ["time"] = 1335730911,
		},
		{
		  ["lon"] = 3.0119108853488,
		  ["lat"] = -0.75900196086992,
		  ["time"] = 1335730946,
		},
		{
		  ["lon"] = 3.0119023506888,
		  ["lat"] = -0.75899712630789,
		  ["time"] = 1335730973,
		},
		{
		  ["lon"] = 3.0118926117516,
		  ["lat"] = -0.75899319931707,
		  ["time"] = 1335731010,
		},
		{
		  ["lon"] = 3.0118818081635,
		  ["lat"] = -0.75899113982856,
		  ["time"] = 1335731048,
		},
		{
		  ["lon"] = 3.0118712838281,
		  ["lat"] = -0.75899368800926,
		  ["time"] = 1335731083,
		},
		{
		  ["lon"] = 3.0118649831895,
		  ["lat"] = -0.75900016318079,
		  ["time"] = 1335731115,
		},
		{
		  ["lon"] = 3.0118578098863,
		  ["lat"] = -0.75900632419305,
		  ["time"] = 1335731148,
		},
		{
		  ["lon"] = 3.0118483152952,
		  ["lat"] = -0.75901032099704,
		  ["time"] = 1335731193,
		},
		{
		  ["lon"] = 3.0118467794054,
		  ["lat"] = -0.75901827969842,
		  ["time"] = 1335731226,
		},
		{
		  ["lon"] = 3.0118439345187,
		  ["lat"] = -0.75902590678726,
		  ["time"] = 1335731256,
		},
		{
		  ["lon"] = 3.0118392221298,
		  ["lat"] = -0.75903342915633,
		  ["time"] = 1335731296,
		},
		{
		  ["lon"] = 3.0118326945984,
		  ["lat"] = -0.75903971234164,
		  ["time"] = 1335731333,
		},
		{
		  ["lon"] = 3.0118277029567,
		  ["lat"] = -0.75904719980413,
		  ["time"] = 1335731371,
		},
		{
		  ["lon"] = 3.0118221004498,
		  ["lat"] = -0.75905393677504,
		  ["time"] = 1335731524,
		},
		{
		  ["lon"] = 3.0118205296535,
		  ["lat"] = -0.75905493161272,
		  ["time"] = 1335731591,
		},
	}

	local expected_t_points = 
	{
		{
		  ["trktime"] = 75,
		  ["time"] = 1335729960,
		  ["speed"] = 0.21898209576554,
		  ["lat"] = -0.75910782240929,
		  ["distance"] = 16.423657182415,
		  ["lon"] = 3.0120750805047,
		},
		{
		  ["trktime"] = 195,
		  ["time"] = 1335730080,
		  ["speed"] = 0.21898209576554,
		  ["lat"] = -0.75910506951289,
		  ["distance"] = 42.701508674279,
		  ["lon"] = 3.012070855135,
		},
		{
		  ["trktime"] = 315,
		  ["time"] = 1335730200,
		  ["speed"] = 1.5265064229474,
		  ["lat"] = -0.75908876878829,
		  ["distance"] = 155.15609381801,
		  ["lon"] = 3.0120688995227,
		},
		{
		  ["trktime"] = 435,
		  ["time"] = 1335730320,
		  ["speed"] = 1.6424996175529,
		  ["lat"] = -0.75906656113677,
		  ["distance"] = 338.48447307847,
		  ["lon"] = 3.0120443478546,
		},
		{
		  ["trktime"] = 555,
		  ["time"] = 1335730440,
		  ["speed"] = 1.3307963121233,
		  ["lat"] = -0.75905095226202,
		  ["distance"] = 509.21125800441,
		  ["lon"] = 3.012030702202,
		},
		{
		  ["trktime"] = 675,
		  ["time"] = 1335730560,
		  ["speed"] = 1.297569757978,
		  ["lat"] = -0.7590475596112,
		  ["distance"] = 672.85825377767,
		  ["lon"] = 3.0120068395285,
		},
		{
		  ["trktime"] = 795,
		  ["time"] = 1335730680,
		  ["speed"] = 1.3905400839443,
		  ["lat"] = -0.75903063993619,
		  ["distance"] = 845.17160304724,
		  ["lon"] = 3.0119856778869,
		},
		{
		  ["trktime"] = 915,
		  ["time"] = 1335730800,
		  ["speed"] = 1.369149166579,
		  ["lat"] = -0.75901651172985,
		  ["distance"] = 1023.721966136,
		  ["lon"] = 3.0119524883338,
		},
		{
		  ["trktime"] = 1035,
		  ["time"] = 1335730920,
		  ["speed"] = 1.4821753023639,
		  ["lat"] = -0.75900485213711,
		  ["distance"] = 1200.1928834026,
		  ["lon"] = 3.0119181977728,
		},
		{
		  ["trktime"] = 1155,
		  ["time"] = 1335731040,
		  ["speed"] = 1.3602763392648,
		  ["lat"] = -0.75899157340993,
		  ["distance"] = 1381.2027290334,
		  ["lon"] = 3.0118840825996,
		},
		{
		  ["trktime"] = 1275,
		  ["time"] = 1335731160,
		  ["speed"] = 1.1287876923629,
		  ["lat"] = -0.75900739001185,
		  ["distance"] = 1558.9653034361,
		  ["lon"] = 3.0118552780024,
		},
		{
		  ["trktime"] = 1395,
		  ["time"] = 1335731280,
		  ["speed"] = 1.3175314562876,
		  ["lat"] = -0.75903042021003,
		  ["distance"] = 1729.4886658338,
		  ["lon"] = 3.0118411070934,
		},
		{
		  ["trktime"] = 1515,
		  ["time"] = 1335731400,
		  ["speed"] = 0.32799808211134,
		  ["lat"] = -0.75904847674753,
		  ["distance"] = 1863.3122925948,
		  ["lon"] = 3.0118266410491,
		},
		{
		  ["trktime"] = 1635,
		  ["time"] = 1335731520,
		  ["speed"] = 0.32799808211134,
		  ["lat"] = -0.75905376064528,
		  ["distance"] = 1902.6720624481,
		  ["lon"] = 3.0118222469215,
		},
   }
	
   for i = 1, #trk - 1 do
      tp1 = trk[i]
      tp2 = trk[i+1]
      tp1.distance = geo.distance_between(tp1.lat, tp1.lon, tp2.lat, tp2.lon, geo.spheroid)
      tp1.bearing = geo.bearing(tp1.lat, tp1.lon, tp2.lat, tp2.lon, geo.spheroid)
      tp1.duration = tp2.time - tp1.time
      tp1.speed = tp1.distance / tp1.duration
   end

   local actual_t_points = geo.calculate_t_points(trk, 120)

   assertEquals(#actual_t_points, #expected_t_points)
   for i = 1, #actual_t_points do
      local atp = actual_t_points[i]
      local etp = expected_t_points[i]
   	assertEquals(atp.time, etp.time)
   	assertEquals(atp.trktime, etp.trktime)
   	assertClose(atp.lat, etp.lat, 0.00001)
   	assertClose(atp.lon, etp.lon, 0.00001)
   	assertClose(atp.distance, etp.distance, 0.00001)
   	assertClose(atp.speed, etp.speed, 0.00001)
   end
end


LuaUnit:setOutputType('JUNIT')
os.exit(LuaUnit:run())

