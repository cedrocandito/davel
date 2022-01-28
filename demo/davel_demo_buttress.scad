/*
Usage examples of davel.scad: buttresses.

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

buttress_demo();


module buttress_demo()
{
	union()
	{
		union()
		{
			cube([10,5,10]);
			translate([0,-5,0])
				cube([5,10,10]);
		}

		/* here we are using the "*_points" version, but the basic
		version and the "*_pos" version are also available for buttresses. */
		davel_buttress_pos([5,0,5], 10, [0,-1,0], [1,0,0], 2);
		
	}
}