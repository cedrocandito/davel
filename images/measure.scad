/*
Usage examples of davel.scad: bevel with colours and labels.

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

use <davel/davel.scad>

$fa=3;
$fs=0.1;

bevel_labels_demo();

n1=[0,-1,0];
n2=[1,0,0];
l=10;
r=2;
bo=0.4;
so=0.4;
sep_scale=1.02;
vector_scale=3;
offsets=false;
measures=true;
dot_r=0.1;

module bevel_labels_demo()
{
	if (measures)
	{
		color("red") sphere(r=dot_r, $fn=30);
		
		color("green")
		{
			translate ([0,0,-l/2]) sphere(r=dot_r, $fn=30);
			translate ([0,0,l/2]) sphere(r=dot_r, $fn=30);
		}
		
		color("blue") translate ([0,0,-l/2]) cylinder(r=dot_r/4, h=l);
		
		color("lightblue") scale(vector_scale) davel_debug_draw_vector(n1);
		color("orange") scale(vector_scale) davel_debug_draw_vector(n2);
	}
	
	if (offsets)
	{
		color("green", alpha=0.3) difference()
		{
			davel_bevel(l, n1, n2, r, back_offset=bo, side_offset=so);
			davel_bevel(l, n1, n2, r+0.1, back_offset=bo+0.01, side_offset=0);
		}
		
		color("red", alpha=0.3) difference()
		{
			davel_bevel(l, n1, n2, r, back_offset=bo, side_offset=0);
			davel_bevel(l, n1, n2, r+0.1, back_offset=0, side_offset=0.01);
		}
	}
	
	color(alpha=0.6) davel_bevel(l, n1, n2, r, back_offset=0.01, side_offset=0);

}