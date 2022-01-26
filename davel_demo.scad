/*
Usage examples of davel.scad.

Bt Davide Orlandi - davide[at]davideorlandi.it

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

use <davel/davel.scad>

$fa=3;
$fs=0.2;

box_w = 10;
box_l = 13;
box_h = 7;
box_r_out = 1.2;
box_r_in = 0.8;
box_thickness = 1.5;
box_size_outer = [box_w, box_l, box_h];
box_size_inner = [box_w-box_thickness*2, box_l-box_thickness*2, box_h];

object_width = 7;
bevel_r = 2;
object_separation = object_width * 1.5;

translate([-object_separation, 0, 0])
	demo_buttress();

translate([-object_separation*2, 0, 0])
	demo_buttress_pos();

translate([-object_separation*3, 0, 0])
	demo_buttress_points();

translate([-box_w/2, -box_l/2, 0])
	demo_box();

translate([object_separation, 0, 0])
	demo_bevel();

translate([object_separation*2, 0, 0])
	demo_bevel_pos();

translate([object_separation*3, 0, 0])
	demo_bevel_points();

translate([0,0,10])
davel_debug_draw_origin();

// ???? demo non retto
// ???? demo offset


module demo_box()
{
	difference()
	{
		// external box (beveled)
		difference()
		{
			cube([box_w,box_l,box_h]);
			// no back on the back side
			davel_box_bevel([box_w,box_l,box_h], box_r_out, back=false);
		}
		
		// inner box (carved out)
		// A subtracted bevel is a buttress :-)
		translate([box_thickness,box_thickness,box_thickness])
		{
			difference()
			{
				cube(box_size_inner);
				davel_box_bevel(box_size_inner, box_r_in, top=false);
			}
		}
	}
}

module demo_bevel()
{
	difference()
	{
		bevel_support_object();
		translate([object_width/2, -object_width/2, object_width/2])
			#davel_bevel(object_width, [1,0,0], [0,-1,0], bevel_r);
	}
}

module demo_bevel_pos()
{
	difference()
	{
		bevel_support_object();
			#davel_bevel_pos(
				[object_width/2, -object_width/2, object_width/2],
				object_width, [1,0,0], [0,-1,0], bevel_r);
	}
}

module demo_bevel_points()
{
	difference()
	{
		bevel_support_object();
			#davel_bevel_points(
				[object_width/2, -object_width/2, 0],
				[object_width/2, -object_width/2, object_width],
				[1,0,0], [0,-1,0], bevel_r);
	}
}

module demo_buttress()
{
	union()
	{
		buttress_support_object();
		translate([0,0,object_width/2])
			#davel_buttress(object_width, [1,0,0], [0,-1,0], bevel_r);
	}
}

module demo_buttress_pos()
{
	union()
	{
		buttress_support_object();
		#davel_buttress_pos([0,0,object_width/2], object_width, [1,0,0], [0,-1,0], bevel_r);
	}
}

module demo_buttress_points()
{
	union()
	{
		buttress_support_object();
		#davel_buttress_points([0,0,0], [0,0,object_width], [1,0,0], [0,-1,0], bevel_r);
	}
}

module buttress_support_object()
{
	union()
	{
		translate([-object_width/2, 0, 0])
			cube([object_width, object_width/2, object_width]);
		translate([-object_width/2, -object_width/2, 0])
			cube([object_width/2, object_width, object_width]);
	}
}

module bevel_support_object()
{
	union()
	{
		translate([-object_width/2, -object_width/2, 0])
			cube([object_width, object_width, object_width]);
	}
}