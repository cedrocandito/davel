/*
Usage examples of davel.scad: box.

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

use <../davel.scad>

$fa=3;
$fs=0.15;

box_w = 10;
box_l = 13;
box_h = 7;
box_r_out = 1.2;
box_r_in = 0.8;
box_thickness = 1.5;
box_size_outer = [box_w, box_l, box_h];
box_size_inner = [box_w-box_thickness*2, box_l-box_thickness*2, box_h];

demo_box();


module demo_box()
{
	difference()
	{
		// external box (beveled)
		difference()
		{
			cube([box_w,box_l,box_h]);
			// no bevel on the back side
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