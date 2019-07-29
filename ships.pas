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

procedure draw_shuttle(x, y: integer);
begin
    { tip }
    temp[0].x:= x + 40;
    temp[0].y:= y + 30;
    temp[1].x:= x + 55;
    temp[1].y:= y;
    temp[2].x:= x + 70;
    temp[2].y:= y + 30;
    drawpoly(3, temp);

    temp[1].y:= y + 10;
    drawpoly(3, temp);
    temp[1].y:= y + 17;
    drawpoly(3, temp);

    temp[0].x:= x + 40;
    temp[0].y:= y + 30;
    temp[1].x:= x + 35;
    temp[1].y:= y + 120;
    temp[2].x:= x + 40;
    temp[2].y:= y + 120;
    drawpoly(3, temp);

    { left wing }
    temp[0].x:= x;
    temp[0].y:= y + 110;
    temp[1].x:= x + 40;
    temp[1].y:= y + 75;
    temp[2].x:= x + 40; { why donesn't print this vertex }
    temp[2].y:= y + 110;
    drawpoly(3, temp);

    rectangle(x, y + 110, x + 40, y + 120);

    { right wing }
    temp[0].x:= x + 70;
    temp[0].y:= y + 75;
    temp[1].x:= x + 110;
    temp[1].y:= y + 110;
    temp[2].x:= x + 70;
    temp[2].y:= y + 110;
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
end;

begin
    grdriver:= detect;
    initgraph(grdriver, grmode, 'C:\BP\BGI');

    repeat
        draw_shuttle(0, 360);
    until keypressed;

    closegraph;
end.
