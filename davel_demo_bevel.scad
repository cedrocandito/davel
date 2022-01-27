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

use <davel.scad>

$fa=3;
$fs=0.2;

non_rectangular_demo();


module non_rectangular_demo()
{
	union()
	{
		difference()
		{
			cylinder(r=10,h=5,$fn=6);
			translate([0,0,-0.01]) cylinder(r=5,h=5.02,$fn=3);
			
			ybev = -10*sqrt(3)/2;
			xbev = -5;
			
			#davel_bevel_points([xbev,ybev,0], [xbev,ybev,5], [0,-1,0], [cos(210),sin(210),0], 2);
		}

		xbut=5;
		ybut=0;

		#davel_buttress_points([xbut,ybut,0], [xbut,ybut,5], [cos(240),sin(240),0], [cos(120),sin(120),0], 1.5);
	}
	
}