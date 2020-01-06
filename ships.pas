{
 Space Ships - Video game in which two spaceships battle

 Copyright (C) 2019, 2020 Mihai Gătejescu (gus666xe@gmail.com)

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
    shuttle_height = 120;
    ufo_height = 63;
var
    grdriver, grmode: integer;
    shuttle_x, shuttle_y, ufo_x, ufo_y: integer;
    shuttle_position, ufo_position: pointtype;
    dimension: word;
    shuttle, ufo: pointer;
    key_code: char;

procedure draw_shuttle(shuttle: pointtype);
var
    temp: tripoints;
begin
    { tip }
    temp[0].x:= shuttle.x + 40;
    temp[0].y:= shuttle.y + 30;
    temp[1].x:= shuttle.x + 55;
    temp[1].y:= shuttle.y;
    temp[2].x:= shuttle.x + 70;
    temp[2].y:= shuttle.y + 30;
    drawpoly(3, temp);

    temp[1].y:= shuttle.y + 10;
    drawpoly(3, temp);
    temp[1].y:= shuttle.y + 17;
    drawpoly(3, temp);

    { left wing }
    temp[0].x:= shuttle.x;
    temp[0].y:= shuttle.y + 110;
    temp[1].x:= shuttle.x + 40;
    temp[1].y:= shuttle.y + 75;
    temp[2].x:= shuttle.x + 40; { why donesn't print this vertex }
    temp[2].y:= shuttle.y + 110;
    drawpoly(3, temp);

    rectangle(shuttle.x, shuttle.y + 110, shuttle.x + 40, shuttle.y + 120);

    { right wing }
    temp[0].x:= shuttle.x + 70;
    temp[0].y:= shuttle.y + 75;
    temp[1].x:= shuttle.x + 110;
    temp[1].y:= shuttle.y + 110;
    temp[2].x:= shuttle.x + 70;
    temp[2].y:= shuttle.y + 110;
    drawpoly(3, temp);

    rectangle(shuttle.x + 70, shuttle.y + 110, shuttle.x + 110, shuttle.y + 120);

    { body }
    rectangle(shuttle.x + 40, shuttle.y + 30, shuttle.x + 70, shuttle.y + 120);

    temp[0].x:= shuttle.x + 40;
    temp[0].y:= shuttle.y + 30;
    temp[1].x:= shuttle.x + 35;
    temp[1].y:= shuttle.y + 120;
    temp[2].x:= shuttle.x + 40;
    temp[2].y:= shuttle.y + 120;
    drawpoly(3, temp);
    
    temp[0].x:= shuttle.x + 70;
    temp[0].y:= shuttle.y + 30;
    temp[1].x:= shuttle.x + 75;
    temp[1].y:= shuttle.y + 120;
    temp[2].x:= shuttle.x + 70;
    temp[2].y:= shuttle.y + 120;
    drawpoly(3, temp);

    { tail }
    line(shuttle.x + 55, shuttle.y + 75, shuttle.x + 55, shuttle.y + 120);
end;

{ deprecated }
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

procedure draw_ufo2(ufo_position: pointtype);
begin
    ellipse(ufo_position.x + 55, ufo_position.y + 27, 0, 180, 27, 27);
    rectangle(ufo_position.x + 28, ufo_position.y + 27, ufo_position.x + 83,
              ufo_position.y + 32);
    line(ufo_position.x, ufo_position.y + 47, ufo_position.x + 28,
         ufo_position.y + 32);
    line(ufo_position.x, ufo_position.y + 47, ufo_position.x + 110,
         ufo_position.y + 47);
    line(ufo_position.x + 83, ufo_position.y + 32, ufo_position.x + 110,
         ufo_position.y + 47);
    line(ufo_position.x, ufo_position.y + 47, ufo_position.x + 28,
         ufo_position.y + 62);
    line(ufo_position.x + 28, ufo_position.y + 62, ufo_position.x + 83,
         ufo_position.y + 62);
    line(ufo_position.x + 83, ufo_position.y + 62, ufo_position.x + 110,
         ufo_position.y + 47);
end;

procedure move_ship(var x: integer; y, step: integer;
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

procedure explode(x, y, ship_height: integer);
begin
    bar(x, y, x + ship_width, y + ship_height);
    delay(100);
    setfillstyle(1, black);
    bar(x, y, x + ship_width, y + ship_height);
    setfillstyle(1, white);
end;

function shuttle_is_hit(shuttle_x, shuttle_y, ufo_x, ufo_y: integer): boolean;
begin
    shuttle_is_hit:= (ufo_y > getmaxy - shuttle_height)
                     and (ufo_x > shuttle_x - 55) and
                     (ufo_x < shuttle_x - 55 + ship_width);
end;

function ufo_is_hit(shuttle_x, shuttle_y, ufo_x, ufo_y: integer): boolean;
begin
    ufo_is_hit:= ((shuttle_y < ufo_height) and
                  (shuttle_x > ufo_x - 55) and
                  (shuttle_x < ufo_x - 55 + ship_width));
end;

procedure shuttle_fire(shuttle_pos, ufo_pos: pointtype);
var
    dimension: word;
    projectile: pointer;
begin
    setcolor(lightred);
    line(shuttle_pos.x + 55, shuttle_pos.y - 1,
         shuttle_pos.x + 55, shuttle_pos.y - 11);
    dimension:= imagesize(shuttle_pos.x + 55, shuttle_pos.y - 1,
                          shuttle_pos.x + 55, shuttle_pos.y - 11);
    getmem(projectile, dimension);
    getimage(shuttle_pos.x + 55, shuttle_pos.y - 1,
             shuttle_pos.x + 55, shuttle_pos.y - 11, projectile^);

    while shuttle_pos.y > 0 do
    begin
        if (ufo_is_hit(shuttle_pos.x, shuttle_pos.y, ufo_pos.x, ufo_pos.y)) then
        begin
            explode(ufo_pos.x, ufo_pos.y, ufo_height);
            break;
        end;

        putimage(shuttle_pos.x + 55, shuttle_pos.y - 11, projectile^, xorput);
        shuttle_pos.y:= shuttle_pos.y - 10;
        putimage(shuttle_pos.x + 55, shuttle_pos.y - 11, projectile^, xorput);
        delay(100);
    end;
    setcolor(white);
end;

procedure ufo_fire(ufo_x, ufo_y, shuttle_x, shuttle_y: integer);
var
    dimension: word;
    projectile: pointer;
begin
    setcolor(yellow);
    line(ufo_x + 55, ufo_y + 63, ufo_x + 55, ufo_y + 73);
    dimension:= imagesize(ufo_x + 55, ufo_y + 63, ufo_x + 55, ufo_y + 73);
    getmem(projectile, dimension);
    getimage(ufo_x + 55, ufo_y + 63, ufo_x + 55, ufo_y + 73, projectile^);

    while ufo_y < getmaxy - 10 do
    begin
        if (shuttle_is_hit(shuttle_x, shuttle_y, ufo_x, ufo_y)) then
        begin
            explode(shuttle_x, shuttle_y, shuttle_height);
            break;
        end;

        putimage(ufo_x + 55, ufo_y + 63, projectile^, xorput);
        ufo_y:= ufo_y + 10;
        putimage(ufo_x + 55, ufo_y + 63, projectile^, xorput);
        delay(100);
    end;
    setcolor(white);
end;

procedure reset_ships(var shuttle_x, ufo_x: integer;
        shuttle_y, ufo_y: integer; shuttle, ufo: pointer);
begin
    setfillstyle(1, black);
    bar(shuttle_x, shuttle_y, shuttle_x + ship_width,
        shuttle_y + shuttle_height);
    shuttle_x:= 1;
    shuttle_y:= getmaxy - shuttle_height;
    putimage(shuttle_x, shuttle_y, shuttle^, xorput);

    bar(ufo_x, ufo_y, ufo_x + ship_width, ufo_y + ufo_height);
    ufo_x:= getmaxx - ship_width;
    ufo_y:= 1;
    putimage(ufo_x, ufo_y, ufo^, xorput);
    setfillstyle(1, white);
end;

begin
    grdriver:= detect;
    initgraph(grdriver, grmode, 'C:\BP\BGI');

    { deprecated }
    shuttle_x:=1;
    shuttle_y:= getmaxy - shuttle_height;

    shuttle_position.x:= 1;
    shuttle_position.y:= getmaxy - shuttle_height;
    draw_shuttle(shuttle_position);
    dimension:= imagesize(shuttle_position.x, shuttle_position.y,
                          shuttle_position.x + ship_width,
                          shuttle_position.y + shuttle_height);

    getmem(shuttle, dimension);
    getimage(shuttle_position.x, shuttle_position.y,
             shuttle_position.x + ship_width,
             shuttle_position.y + shuttle_height, shuttle^);

    { deprecated }
    ufo_x:= getmaxx - ship_width;
    ufo_y:= 1;

    ufo_position.x:= getmaxx - ship_width;
    ufo_position.y:= 1;
    draw_ufo2(ufo_position);
    getmem(ufo, dimension);
    getimage(ufo_position.x, ufo_position.y, ufo_position.x + ship_width,
             ufo_position.y + ufo_height, ufo^);

    repeat
        key_code:= readkey;
        case key_code of
            #0: begin
                key_code:= readkey;
                case key_code of
                    #72: begin { UP ARROW }
                        shuttle_fire(shuttle_position, ufo_position);
                    end;
                    #75: begin { LEFT ARROW }
                        move_ship(shuttle_x, shuttle_y, -step, shuttle);
                    end;
                    #77: begin { RIGHT ARROW }
                        move_ship(shuttle_x, shuttle_y, step, shuttle);
                    end;
                end;
            end;
            #32: begin { SPACE }
                reset_ships(shuttle_x, ufo_x, shuttle_y, ufo_y,
                            shuttle, ufo);
            end;
            #49: begin { 1 }
                explode(shuttle_x, shuttle_y, 0);
                explode(ufo_x, ufo_y, 1);
            end;
            #97: begin { A }
                move_ship(ufo_x, ufo_y, -step, ufo);
            end;
            #100: begin { D }
                move_ship(ufo_x, ufo_y, step, ufo);
            end;
            #115, #119: begin
                ufo_fire(ufo_x, ufo_y, shuttle_x, shuttle_y);
            end;
        end;
    until key_code = #27; { ESCAPE }

    closegraph;
end.
