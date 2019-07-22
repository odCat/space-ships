{
 Space Ships - Video game in which two spaceships battle

 Copyright (C) 2019 Mihai Gătejescu (gus666xe@gmail.com)

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

program ships;
uses crt, graph;
type
    tripoints = array [0.. 2] of pointtype;
var
    grdriver, grmode: integer;
    temp: tripoints;
begin
    grdriver:= detect;
    initgraph(grdriver, grmode, 'C:\BP\BGI');

    repeat
        { tip }
        temp[0].x:= 45;
        temp[0].y:= 390;
        temp[1].x:= 60;
        temp[1].y:= 360;
        temp[2].x:= 75;
        temp[2].y:= 390;
        drawpoly(3, temp);

        temp[1].y:= 370;
        drawpoly(3, temp);
        temp[1].y:= 375;
        drawpoly(3, temp);

        temp[0].x:= 45;
        temp[0].y:= 390;
        temp[1].x:= 40;
        temp[1].y:= 479;
        temp[2].x:= 45;
        temp[2].y:= 479;
        drawpoly(3, temp);

        { left wing }
        temp[0].x:= 5;
        temp[0].y:= 470;
        temp[1].x:= 45;
        temp[1].y:= 435;
        temp[2].x:= 45; { why donesn't print this vertex }
        temp[2].y:= 470;
        drawpoly(3, temp);

        rectangle(5, 470, 45, 479);

        { right wing }
        temp[0].x:= 75;
        temp[0].y:= 435;
        temp[1].x:= 115;
        temp[1].y:= 470;
        temp[2].x:= 75;
        temp[2].y:= 470;
        drawpoly(3, temp);

        rectangle(75, 470, 115, 479);

        { body }
        rectangle(45, 390, 75, 479);

        temp[0].x:= 45;
        temp[0].y:= 390;
        temp[1].x:= 45;
        temp[1].y:= 479;
        temp[2].x:= 40;
        temp[2].y:= 479;
        drawpoly(3, temp);
        
        temp[0].x:= 75;
        temp[0].y:= 390;
        temp[1].x:= 80;
        temp[1].y:= 479;
        temp[2].x:= 75;
        temp[2].y:= 479;
        drawpoly(3, temp);

        { tail }
        line(60, 435, 60, 479);
    until keypressed;

    closegraph;
end.
