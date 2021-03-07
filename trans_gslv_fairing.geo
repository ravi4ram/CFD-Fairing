// -----------------------------------------------
// GSLV-Mk3 2D-fairing
// Author: Ravi
// -----------------------------------------------

// fairing diameter
fairing_dia = 5;

// fairing mesh size
h = 1;
l = 1;

// farfield size
H = 5;
F = 20 * fairing_dia;
// fairing size ratios
R = 0.5 * fairing_dia;		// fairing radius
rn = 0.266 * fairing_dia;	// nose radius
Lc = 0.75 * fairing_dia;    // cylinder length
Lf = 0.2576 * fairing_dia;  // frustum length
Re = 0.8208 * fairing_dia/2;// frustum end radius
rho = 10;                   // ogive radius				
// ogive length
Lo = Sqrt( (rho * fairing_dia) - R^2);

// tangency point (circle meets ogive)
xo = ( Lo - Sqrt((rho - rn)^2 - (rho - R)^2) );
yt = ( (rn * (rho - R) ) / (rho - rn) );
xt = ( xo - Sqrt(rn^2 - yt^2) );
xa = (xo - rn);

// 2D -> z = 0
z = 0;
// sphere section	
Point(210) = {xo, 0, z, h * 0.01};
Point(1) = {xa, 0, z, h * 0.01};
Point(2) = {xt, yt, z, h * 0.01};
Point(3) = {xt, -yt, z, h * 0.01};
Circle(301) = {2, 210, 1};
Circle(302) = {1, 210, 3};

// ogive section
x = Lo; y1 = (rho-R); y2 = -(rho-R);
Point(211) = {x, y1, z, h * 0.01};
Point(212) = {x, y2, z, h * 0.01};
x = Lo; y1 = R; y2 = -R;
Point(4) = {x, y1, z, h * 0.01};
Point(5) = {x, y2, z, h * 0.01};
Circle(303) = {4, 212, 2};
Circle(304) = {3, 211, 5};

// cylinder section
x = (Lo+Lc); y1 = R; y2 = -R;
Point(6) = {x, y1, z, h * 0.01};
Point(7) = {x, y2, z, h * 0.01};
Line(401) = {6, 4};
Line(402) = {5, 7};

// frustum section
x = (Lo+Lc+Lf); y1 = Re; y2 = -Re;
Point(8) = {x, y1, z, h * 0.01};
Point(9) = {x, y2, z, h * 0.01};
Line(403) = {8, 6};
Line(404) = {7, 9};

// booster section
Le = 2.0 * fairing_dia;
x = (Lo+Lc+Lf+Le); y1 = Re; y2 = -Re;
Point(10) = {x, y1, z, h * 0.01};
Point(11) = {x, y2, z, h * 0.01};
Line(405) = {10, 8};
Line(406) = {9, 11};
Line(407) = {11, 10};
Line Loop(501) = {407, 405, 403, 401, 303, 301, 302, 304, 402, 404, 406};

// farfield	
Point(213) = {0, 0, 0, H};
Point(13) = {-F, 0, 0, H};
Point(14) = {0, F, 0, H};
Point(15) = {F, 0, 0, H};
Point(16) = {0, -F, 0, H};
Circle(305) = {15, 213, 14};
Circle(306) = {14, 213, 13};
Circle(307) = {13, 213, 16};
Circle(308) = {16, 213, 15};
Line Loop(502) = {305, 306, 307, 308};

// boundaries
Plane Surface(1001) = {501, 502};
Physical Surface(1) = {1001};
Physical Line("FAIRING") = {407, 405, 403, 401, 303, 301, 302, 304, 402, 404, 406};
Physical Line("FARFIELD") = {305, 306, 307, 308};

// mesh options
Mesh.Smoothing = 10;
