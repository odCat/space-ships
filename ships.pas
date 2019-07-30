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
const
    step = 10;
    ship_width = 110;
    ship_height = 120;
var
    grdriver, grmode: integer;
    temp: tripoints;
    shuttle_x, shuttle_y, ufo_x, ufo_y: integer;
    dimension: word;
    shuttle, ufo: pointer;
    key_code: char;

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

    rectangle(x + 70, y + 110, x + 110, y + 120);

    { body }
    rectangle(x + 40, y + 30, x + 70, y + 120);

    temp[0].x:= x + 40;
    temp[0].y:= y + 30;
    temp[1].x:= x + 35;
    temp[1].y:= y + 120;
    temp[2].x:= x + 40;
    temp[2].y:= y + 120;
    drawpoly(3, temp);
    
    temp[0].x:= x + 70;
    temp[0].y:= y + 30;
    temp[1].x:= x + 75;
    temp[1].y:= y + 120;
    temp[2].x:= x + 70;
    temp[2].y:= y + 120;
    drawpoly(3, temp);

    { tail }
    line(x + 55, y + 75, x + 55, y + 120);
end;

procedure draw_ufo(x,y: integer);
begin
    ellipse(x + 55, y + 90, 0, 360, 55, 30);
    ellipse(x + 55, y + 80, 0, 180, 32, 32);
    setcolor(black); setfillstyle(1, black);
    fillellipse(x + 55, y + 80, 31, 31);
end;

procedure move_shuttle(var x: integer; y, step: integer;
                       shuttle:pointer);
begin
    if ((step > 0) and (x + step + ship_width <= getmaxx)) or
       ((step < 0) and (x + step >= 0)) then
    begin
        putimage(x, y, shuttle^, xorput);
        x:= x + step;
        putimage(x, y, shuttle^, xorput);
    end;
end;

begin
    grdriver:= detect;
    initgraph(grdriver, grmode, 'C:\BP\BGI');

    shuttle_x:= 1;
    shuttle_y:= getmaxy - ship_height;
    draw_shuttle(shuttle_x, shuttle_y);
    dimension:= imagesize(shuttle_x, shuttle_y,
                          shuttle_x + ship_width, shuttle_y + ship_height);
    getmem(shuttle, dimension);
    getimage(shuttle_x, shuttle_y, shuttle_x + ship_width,
             shuttle_y + ship_height, shuttle^);

    ufo_x:= getmaxx - ship_width;
    ufo_y:= 1;
    draw_ufo(ufo_x, ufo_y);
    getmem(ufo, dimension);
    getimage(ufo_x, ufo_y, ufo_x + ship_width,
             ufo_y + ship_height, ufo^);

    repeat
        key_code:= readkey;
        if key_code = #0 then
        begin
            key_code:= readkey;
            case key_code of
                #72: begin { UP ARROW }
                    putimage(shuttle_x, shuttle_y, shuttle^, xorput);
                    shuttle_x:= 1;
                    shuttle_y:= getmaxy - ship_height;
                    putimage(shuttle_x, shuttle_y, shuttle^, xorput);
                end;
                #75: begin { LEFT ARROW }
                    move_shuttle(shuttle_x, shuttle_y, -step, shuttle);
                end;
                #77: begin { RIGHT ARROW }
                    move_shuttle(shuttle_x, shuttle_y, step, shuttle);
                end;
            end;
        end;
    until key_code = #27; { ESCAPE }

    closegraph;
end.
