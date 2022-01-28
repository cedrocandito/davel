/*
Usage examples of davel.scad: non rectangular bevels and buttresses.

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
$fs=0.2;

bevel_demo();


module bevel_demo()
{

	difference()
	{
		cube([10,10,10]);
		
		// front right corner: basic bevel
		translate([10,0,5])
			#davel_bevel(10, [0,-1,0], [1,0,0], 2);
		
		// back right corner: "pos" version
		#davel_bevel_pos([10,10,5], 10, [0,1,0], [1,0,0], 2);
		
		// back left corner: "point" version
		#davel_bevel_points([0,10,0], [0,10,10], [-1,0,0], [0,1,0], 2);
		
		// front left corner: larger (more visible) offsets
		#davel_bevel_points([0,0,0], [0,0,10], [-1,0,0], [0,-1,0], 2, back_offset=1, side_offset=1);
	}	
}