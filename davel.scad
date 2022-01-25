/*
Library to draw simple bevel borders and buttresses.

By Davide Orlandi - davide[at]davideorlandi.it

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
		published by the Free Software Foundation, either version 3 of
		the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public
		License along with this program.  If not, see
		<http://www.gnu.org/licenses/>.
*/


/* -------- bevel ----- */

module davel_bevel(length, n1, n2, r, side_offset=0.1, back_offset = 0.1)
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
	
	ptang1_off = ptang1 + n1n * back_offset;
	ptang2_off = ptang2 + n2n * back_offset;
	origin_off = ntn * back_offset;
	profile = [origin_off, ptang1_off, ptang1, ptang2, ptang2_off];
	
	// rotate the points so that what was the axis of the bevel (dir) is
	// now the z axis and the normal of the bevel (ntn) is now the x
	// axis.
	profile_derotated = davel_matrix_product_vectors3(m_inv,profile);
	c_derotated = davel_matrix_product_vector3(m_inv, c);
	
	// create a 2d list of point to use for polygon()
	profile_flat = davel_vectors3_to_2(profile_derotated);
	
	multmatrix(m)
	{
		linear_extrude(height=length + side_offset*2, center=true)
		{
			difference()
			{
				#polygon(profile_flat);
				
				translate(c_derotated) circle(r=r);
			}
		}
	}
}

module davel_box_bevel(size, r, center=false, front=true, back=true, top=true, bottom=true, left=true, right=true, round_vert=true, side_offset = 0.1, back_offset = 0.1)
{	
	translate(center ? -size/2 : [0,0,0])
	{
		union()
		{
			if (top && left)
				davel_bevel_pos([0, size[1]/2, size[2]], size[1], [-1,0,0], [0,0,1], r, side_offset, back_offset);
			if (top && right)
				davel_bevel_pos([size[0], size[1]/2, size[2]], size[1], [1,0,0], [0,0,1], r, side_offset, back_offset);
			if (bottom && left)
				davel_bevel_pos([0, size[1]/2, 0], size[1], [-1,0,0], [0,0,-1], r, side_offset, back_offset);
			if (bottom && right)
				davel_bevel_pos([size[0], size[1]/2, 0], size[1], [1,0,0], [0,0,-1], r, side_offset, back_offset);
			
			if (front && top)
				davel_bevel_pos([size[0]/2, 0, size[2]], size[0], [0,-1,0], [0,0,1], r, side_offset, back_offset);
			if (front && bottom)
				davel_bevel_pos([size[0]/2, 0, 0], size[0], [0,-1,0], [0,0,-1], r, side_offset, back_offset);
			if (back && top)
				davel_bevel_pos([size[0]/2, size[1], size[2]], size[0], [0,1,0], [0,0,1], r, side_offset, back_offset);
			if (back && bottom)
				davel_bevel_pos([size[0]/2, size[1], 0], size[0], [0,1,0], [0,0,-1], r, side_offset, back_offset);
			
			if (front && left)
				davel_bevel_pos([0, 0, size[2]/2], size[2], [0,-1,0], [-1,0,0], r, side_offset, back_offset);
			if (front && right)
				davel_bevel_pos([size[0], 0, size[2]/2], size[2], [0,-1,0], [1,0,0], r, side_offset, back_offset);
			if (back && left)
				davel_bevel_pos([0, size[1], size[2]/2], size[2], [0,1,0], [-1,0,0], r, side_offset, back_offset);
			if (back && right)
				davel_bevel_pos([size[0], size[1], size[2]/2], size[2], [0,1,0], [1,0,0], r, side_offset, back_offset);
			
			if (round_vert)
			{
				if (bottom && front && left)
					davel_round_vertex([0,0,0], [-1,-1,-1], r);
				if (bottom && front && right)
					davel_round_vertex([size[0],0,0], [1,-1,-1], r);
				if (top && front && left)
					davel_round_vertex([0,0,size[2]], [-1,-1,1], r);
				if (top && front && right)
					davel_round_vertex([size[0],0,size[2]], [1,-1,1], r);
				if (bottom && back && left)
					davel_round_vertex([0,size[1],0], [-1,1,-1], r);
				if (bottom && back && right)
					davel_round_vertex([size[0],size[1],0], [1,1,-1], r);
				if (top && back && left)
					davel_round_vertex([0,size[1],size[2]], [-1,1,1], r);
				if (top && back && right)
					davel_round_vertex([size[0],size[1],size[2]], [1,1,1], r);
			}
		}
	}
}

module davel_bevel_pos(pos, length, n1, n2, r, side_offset=0.1, back_offset = 0.1)
{
	translate(pos) davel_bevel(length, n1, n2, r, side_offset=side_offset, back_offset=back_offset);
}

module davel_bevel_points(p1, p2, n1, n2, r, side_offset=0.1, back_offset = 0.1)
{
	davel_bevel_pos(p1, norm(p2-p1), n1, n2, r, side_offset=side_offset, back_offset=back_offset);
}

/* ----- buttress ----- */

module davel_buttress(length, n1, n2, r, side_offset=0, back_offset = 0.1)
{
	davel_bevel(length, -n1, -n2, r, side_offset=side_offset, back_offset=back_offset);
}

module davel_buttress_pos(pos, length, n1, n2, r, side_offset=0, back_offset=0.1)
{
	translate(pos) davel_buttress(length, n1, n2, r, side_offset=side_offset, back_offset=back_offset);
}

module davel_buttress_points(p1, p2, n1, n2, r, side_offset=0, back_offset=0.1)
{
	davel_buttress_pos(p1, norm(p2-p1), n1, n2, r, side_offset=side_offset, back_offset=back_offset);
}

module davel_box_buttress(size, r, center=false, front=true, back=true, top=true, bottom=true, left=true, right=true, round_vert=true, back_offset=0.1)
{
	davel_box_bevel(size, r, center, front, back, top, bottom, left, right, round_vert, side_offset=0, back_offset=back_offset);
}


// ===================== functions and "private" modules =====================

module davel_round_vertex(pos, dir, r)
{
	translate(pos - dir * r)
	{
		difference()
		{
			translate(dir * r / 2) cube(r, center=true);
			sphere(r=r);
		}
	}
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

function davel_matrix_product_vectors3(m,vectors) = [
	for (v=vectors) davel_matrix_product_vector3(m,v)
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

function davel_vector3_to_2(v) = [v[0], v[1]];

function davel_vectors3_to_2(vectors) = [ for(v=vectors) davel_vector3_to_2(v) ];



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