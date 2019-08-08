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

procedure draw_ufo1(x,y: integer);
begin
    ellipse(x + 55, y + 90, 0, 180, 55, 20);
    ellipse(x + 55, y + 90, 0, 180, 53, 18);
    ellipse(x + 55, y + 80, 0, 180, 32, 32);
    ellipse(x + 55, y + 80, 180, 185, 32, 32);
    ellipse(x + 55, y + 80, 355, 360, 32, 32);
    setcolor(black); setfillstyle(1, black);
    fillellipse(x + 55, y + 80, 31, 31);
    setcolor(white);
    ellipse(x + 55, y + 90, 180, 360, 55, 20);
    ellipse(x + 55, y + 90, 180, 360, 53, 18);
    ellipse(x + 57, y + 88, 0, 360, 6, 6);
    ellipse(x + 73, y + 86, 0, 360, 5, 5);
    ellipse(x + 38, y + 85, 0, 360, 5, 5);
    ellipse(x + 55, y + 30, 251, 289, 55, 24);
end;

procedure draw_ufo2(x, y: integer);
begin
    ellipse(x + 55, y + 27, 0, 180, 27, 27);
    rectangle(x + 28, y + 27, x + 83, y + 32);
    line(x, y + 47, x + 28, y + 32);
    line(x, y + 47, x + 110, y + 47);
    line(x + 83, y + 32, x + 110, y + 47);
    line(x, y + 47, x + 28, y + 62);
    line(x + 28, y + 62, x + 83, y + 62);
    line(x + 83, y + 62, x + 110, y + 47);
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

procedure shuttle_fire(x, y: integer);
begin
    line(x + 55, y - 1, x + 55, y - 6);
end;

procedure ufo_fire(x, y: integer);
begin
end;

procedure reset_ships(var shuttle_x, ufo_x: integer;
        shuttle_y, ufo_y: integer; shuttle, ufo: pointer);
begin
    putimage(shuttle_x, shuttle_y, shuttle^, xorput);
    shuttle_x:= 1;
    shuttle_y:= getmaxy - ship_height;
    putimage(shuttle_x, shuttle_y, shuttle^, xorput);
    putimage(ufo_x, ufo_y, ufo^, xorput);
    ufo_x:= getmaxx - ship_width;
    ufo_y:= 1;
    putimage(ufo_x, ufo_y, ufo^, xorput);
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
    draw_ufo2(ufo_x, ufo_y);
    getmem(ufo, dimension);
    getimage(ufo_x, ufo_y, ufo_x + ship_width,
             ufo_y + ship_height, ufo^);

    repeat
        key_code:= readkey;
        case key_code of
            #0: begin
                key_code:= readkey;
                case key_code of
                    #72: begin { UP ARROW }
                        { TODO: Move to a rest function }
                        {
                        putimage(shuttle_x, shuttle_y, shuttle^, xorput);
                        shuttle_x:= 1;
                        shuttle_y:= getmaxy - ship_height;
                        putimage(shuttle_x, shuttle_y, shuttle^, xorput);
                        putimage(ufo_x, ufo_y, ufo^, xorput);
                        ufo_x:= getmaxx - ship_width;
                        ufo_y:= 1;
                        putimage(ufo_x, ufo_y, ufo^, xorput);
                        }
                        {
                        shuttle_fire(shuttle_x, shuttle_y);
                        }
                        reset_ships(shuttle_x, ufo_x, shuttle_y, ufo_y,
                                    shuttle, ufo);
                    end;
                    #75: begin { LEFT ARROW }
                        move_shuttle(shuttle_x, shuttle_y, -step, shuttle);
                    end;
                    #77: begin { RIGHT ARROW }
                        move_shuttle(shuttle_x, shuttle_y, step, shuttle);
                    end;
                end;
            end;
            #97: begin { A }
                move_shuttle(ufo_x, ufo_y, -step, ufo);
            end;
            #100: begin { D }
                move_shuttle(ufo_x, ufo_y, step, ufo);
            end;
        end;
    until key_code = #27; { ESCAPE }

    closegraph;
end.
