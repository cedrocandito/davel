/*
Library to draw (or, better, substract) simple bevel borders.
*/


module davel_bevel(length, n1, n2, r=2, offset=0.01, $fa=$fa, $fn=$fn, $fs=$fs)
{
	assert(is_list(n1));
	assert(is_list(n2));
	
	n1n = n1 / norm(n1);
	n2n = n2 / norm(n2);
	
	assert(n1n != n2n);
	
	dir = cross(n1, n2);
	
	assert(norm(dir) > 0);
	
	dirn = dir / norm(dir);
	
	nt = n1n + n2n;
	
	assert(norm(nt) > 0);
	
	ntn = nt / norm(nt);
	ang = 90 - acos(n2n * ntn);
	c = -ntn * r / sin(ang);
	ptang1 = c + n1n * r;
	ptang2 = c + n2n * r;
		
	newz = dirn;
	newx = ntn;
	newy = cross(newz, newx);
	
	m = davel_matrix_from_columns4([newx, newy, newz]);
	m_inv = davel_transpose3(davel_matrix4_to_3(m));
	
	c_flat = davel_matrix_product_vector3(m_inv, c);
	ptang1_flat = davel_matrix_product_vector3(m_inv, ptang1);
	ptang2_flat = davel_matrix_product_vector3(m_inv, ptang2);
	
	multmatrix(m)
	{
		linear_extrude(height=length, center=true)
		{
			translate([offset, 0, 0])
			{
				difference()
				{
					polygon([
						[0, 0],
						[ptang1_flat[0], ptang1_flat[1]],
						[ptang2_flat[0], ptang2_flat[1]]
					]);
					
					translate(c_flat) circle(r=r);
				}
			}
		}
	}
}


module davel_bevel_pos(pos, length, n1, n2, r, $fa=$fa, $fn=$fn, $fs=$fs)
{
	translate(pos) davel_bevel(length, n1, n2, r);
}


module davel_cube_bevel(size, r, front=true, back=true, top=true, bottom=true, left=true, right=true, $fa=$fa, $fn=$fn, $fs=$fs)
{
	if (top && left)
		davel_bevel_pos([0, size[1]/2, size[2]], size[1], [-1,0,0], [0,0,1], r);
	if (top && right)
		davel_bevel_pos([size[0], size[1]/2, size[2]], size[1], [1,0,0], [0,0,1], r);
	if (bottom && left)
		davel_bevel_pos([0, size[1]/2, 0], size[1], [-1,0,0], [0,0,-1], r);
	if (bottom && right)
		davel_bevel_pos([size[0], size[1]/2, 0], size[1], [1,0,0], [0,0,-1], r);
	
	if (front && top)
		davel_bevel_pos([size[0]/2, 0, size[2]], size[0], [0,-1,0], [0,0,1], r);
	if (front && bottom)
		davel_bevel_pos([size[0]/2, 0, 0], size[0], [0,-1,0], [0,0,-1], r);
	if (back && top)
		davel_bevel_pos([size[0]/2, size[1], size[2]], size[0], [0,1,0], [0,0,1], r);
	if (back && bottom)
		davel_bevel_pos([size[0]/2, size[1], 0], size[0], [0,1,0], [0,0,-1], r);
	
	if (front && left)
		davel_bevel_pos([0, 0, size[2]/2], size[2], [0,-1,0], [-1,0,0], r);
	if (front && right)
		davel_bevel_pos([size[0], 0, size[2]/2], size[2], [0,-1,0], [1,0,0], r);
	if (back && left)
		davel_bevel_pos([0, size[1], size[2]/2], size[2], [0,1,0], [-1,0,0], r);
	if (back && right)
		davel_bevel_pos([size[0], size[1], size[2]/2], size[2], [0,1,0], [1,0,0], r);
}


function davel_transpose4(m) = [
	[m[0][0],m[1][0],m[2][0],m[3][0]],
    [m[0][1],m[1][1],m[2][1],m[3][1]],
	[m[0][2],m[1][2],m[2][2],m[3][2]],
	[m[0][3],m[1][3],m[2][3],m[3][3]]
];

function davel_transpose3(m) = [
	[m[0][0],m[1][0],m[2][0]],
    [m[0][1],m[1][1],m[2][1]],
	[m[0][2],m[1][2],m[2][2]]
];

function davel_matrix_product_vector3(m,v) = [
	m[0][0]*v[0] + m[0][1]*v[1] + m[0][2]*v[2],
	m[1][0]*v[0] + m[1][1]*v[1] + m[1][2]*v[2],
	m[2][0]*v[0] + m[2][1]*v[1] + m[2][2]*v[2]
];

function davel_matrix_from_rows3(rows) = [rows[0], rows[1], rows[2]];

function davel_matrix_from_columns3(columns) = davel_transpose3(davel_matrix_from_rows3(columns));

function davel_matrix_from_rows4(rows) = [
	concat(rows[0],0),
	concat(rows[1],0),
	concat(rows[2],0),
	[0,0,0,1]
];

function davel_matrix_from_columns4(columns) = davel_transpose4(davel_matrix_from_rows4(columns));

function davel_matrix3_to_4(m) = davel_matrix_from_rows4([m[0], m[1], m[2]]);

function davel_matrix4_to_3(m) = [
	[m[0][0], m[0][1], m[0][2]],
	[m[1][0], m[1][1], m[1][2]],
	[m[2][0], m[2][1], m[2][2]]
];



module davel_debug_draw_origin(alpha = 1.0)
{
	$fn = 16;
	union()
	{
		color("blue", alpha)
			cylinder(r=0.1,h=2);
		color("red", alpha)
			rotate([0,90,0])
				cylinder(r=0.1,h=2);
		color("green", alpha)
			rotate([-90,0,0])
				cylinder(r=0.1,h=2);
	}		
}

module davel_debug_draw_vector(v, with_ball=false)
{
	vl = norm(v);	// length
	b = acos(v[2] / vl);	// right scension
	c = atan2(v[1],v[0]);     // azimuth
	rotate([0,b,c])
		cylinder(r=0.03, h = vl);
	if (with_ball)
		translate(v)
			sphere(d=0.15, $fn=25);
}