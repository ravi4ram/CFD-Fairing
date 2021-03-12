// -----------------------------------------------
// PSLV 2D-fairing
// Author: Ravi
// -----------------------------------------------

// fairing diameter
fairing_dia = 4;

// fairing mesh size
h = 1;
l = 1;

// farfield size
H = 5;
F = 20 * fairing_dia;
// fairing size ratios
R = 0.5 * fairing_dia;      // fairing radius
rn = 0.294 * fairing_dia;   // nose radius
Lc = 1.5 * fairing_dia;     // cylinder length
Lf = 0.153 * fairing_dia;   // frustum length
Re = 0.7 * fairing_dia/2;   // frustum end radius
			
// cone length
theta_nose = (15) * (Pi/180);
Lo = R / Tan(theta_nose);

// tangency point (circle meets cone)
xt = (Lo^2 / R) * Sqrt( rn^2 / (R^2 + Lo^2) );
yt = xt * (R / Lo);
xo = xt + Sqrt( rn^2 - yt^2);
xa = (xo - rn);

// z co-ordinate
z = 0;
// sphere section	
Point(210) = {xo, 0, z, h * 0.01};
x = xt; y1 = yt; y2 = -yt;
Point(1) = {xt, yt, z, h * 0.01};
Point(2) = {xt, -yt, z, h * 0.01};
Circle(301) = {1, 210, 2};

// cone section
x = Lo; y1 = R; y2 = -R;
Point(3) = {x, y1, z, h * 0.01};
Point(4) = {x, y2, z, h * 0.01};
Line(401) = {3, 1};
Line(402) = {2, 4};

// cylinder section
x = (Lo+Lc); y1 = R; y2 = -R;
Point(5) = {x, y1, z, h * 0.01};
Point(6) = {x, y2, z, h * 0.01};
Line(403) = {5, 3};
Line(404) = {4, 6};

// frustum section
x = (Lo+Lc+Lf); y1 = Re; y2 = -Re;
Point(7) = {x, y1, z, h * 0.01};
Point(8) = {x, y2, z, h * 0.01};
// frustum
Line(405) = {7, 5};
Line(406) = {6, 8};

//  booster section
Le = 2.0 * fairing_dia;
x = (Lo+Lc+Lf+Le); y1 = Re; y2 = -Re;
Point(9) = {x, y1, z, h * 0.01};
Point(10) = {x, y2, z, h * 0.01};
Line(407) = {9, 7};
Line(408) = {8, 10};
Line(409) = {10, 9};
Line Loop(501) = {409, 407, 405, 403, 401, 301, 402, 404, 406, 408};

// farfield section	
Point(211) = {0, 0, 0, H};
Point(13) = {-F, 0, 0, H};
Point(14) = {0, F, 0, H};
Point(15) = {F, 0, 0, H};
Point(16) = {0, -F, 0, H};
Circle(305) = {15, 211, 14};
Circle(306) = {14, 211, 13};
Circle(307) = {13, 211, 16};
Circle(308) = {16, 211, 15};
Line Loop(502) = {305, 306, 307, 308};

// boundaries
Plane Surface(1001) = {501, 502};
Physical Surface(1) = {1001};
Physical Line("FAIRING") = {409, 407, 405, 403, 401, 301, 402, 404, 406, 408};
Physical Line("FARFIELD") = {305, 306, 307, 308};

// mesh options
Mesh.Smoothing = 10;
