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
    shuttle_position, ufo_position: pointtype;
    dimension: word;
    shuttle, ufo: pointer;
    key_code: char;

procedure draw_shuttle_tip(corner: pointtype);
var
    temp: tripoints;
begin
    temp[0].x:= corner.x + 40;
    temp[0].y:= corner.y + 30;
    temp[1].x:= corner.x + 55;
    temp[1].y:= corner.y;
    temp[2].x:= corner.x + 70;
    temp[2].y:= corner.y + 30;
    drawpoly(3, temp);

    temp[1].y:= corner.y + 10;
    drawpoly(3, temp);
    temp[1].y:= corner.y + 17;
    drawpoly(3, temp);
end;

procedure draw_shuttle_left_wing(corner: pointtype);
var
    temp: tripoints;
begin
    temp[0].x:= corner.x;
    temp[0].y:= corner.y + 110;
    temp[1].x:= corner.x + 40;
    temp[1].y:= corner.y + 75;
    temp[2].x:= corner.x + 40; { why donesn't print this vertex }
    temp[2].y:= corner.y + 110;
    drawpoly(3, temp);

    rectangle(corner.x, corner.y + 110, corner.x + 40, corner.y + 120);
end;

procedure draw_shuttle_right_wing(corner: pointtype);
var
    temp: tripoints;
begin
    temp[0].x:= shuttle.x + 70;
    temp[0].y:= shuttle.y + 75;
    temp[1].x:= shuttle.x + 110;
    temp[1].y:= shuttle.y + 110;
    temp[2].x:= shuttle.x + 70;
    temp[2].y:= shuttle.y + 110;
    drawpoly(3, temp);

    rectangle(shuttle.x + 70, shuttle.y + 110, shuttle.x + 110, shuttle.y + 120);
end;

procedure draw_shuttle(shuttle: pointtype);
var
    temp: tripoints;
begin
    draw_shuttle_tip(shuttle);

    draw_shuttle_left_wing(shuttle);

    draw_shuttle_right_wing(shuttle);

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

procedure draw_ufo(ufo_position: pointtype);
begin
    ellipse(ufo_position.x + 55, ufo_position.y + 27, 0, 180, 27, 27);
    rectangle(ufo_position.x + 28, ufo_position.y + 27,
              ufo_position.x + 83, ufo_position.y + 32);
    line(ufo_position.x, ufo_position.y + 47,
         ufo_position.x + 28, ufo_position.y + 32);
    line(ufo_position.x, ufo_position.y + 47,
         ufo_position.x + 110, ufo_position.y + 47);
    line(ufo_position.x + 83, ufo_position.y + 32,
         ufo_position.x + 110, ufo_position.y + 47);
    line(ufo_position.x, ufo_position.y + 47,
         ufo_position.x + 28, ufo_position.y + 62);
    line(ufo_position.x + 28, ufo_position.y + 62,
         ufo_position.x + 83, ufo_position.y + 62);
    line(ufo_position.x + 83, ufo_position.y + 62,
         ufo_position.x + 110, ufo_position.y + 47);
end;

procedure delete_ship(position: pointtype; height: integer);
begin
    setfillstyle(1, black);
    bar(position.x, position.y, position.x + ship_width, position.y + height);
    setfillstyle(1, white);
end;

function ship_can_move(position: pointtype; step: integer): boolean;
begin
    ship_can_move:= ((step > 0) and (position.x + step + ship_width <= getmaxx)) or
                    ((step < 0) and (position.x + step >= 0));
end;
procedure move_ship(var position: pointtype; ship_height, step: integer;
                    ship:pointer);
begin
    if (ship_can_move(position, step)) then
    begin
        delete_ship(position, ship_height);
        position.x:= position.x + step;
        putimage(position.x, position.y, ship^, xorput);
    end;
end;

procedure explode(position: pointtype; ship_height: integer);
begin
    bar(position.x, position.y, position.x + ship_width, position.y + ship_height);
    delay(150);
    delete_ship(position, ship_height);
end;

function shuttle_is_hit(shuttle_pos, projectile: pointtype): boolean;
begin
    shuttle_is_hit:= (projectile.y > getmaxy - shuttle_height)
                     and (projectile.x > shuttle_pos.x - 55) and
                     (projectile.x < shuttle_pos.x - 55 + ship_width);
end;

function ufo_is_hit(projectile, ufo_position: pointtype): boolean;
begin
    ufo_is_hit:= ((projectile.y < ufo_height) and
                  (projectile.x > ufo_position.x - 55) and
                  (projectile.x < ufo_position.x - 55 + ship_width));
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
        if (ufo_is_hit(shuttle_pos, ufo_pos)) then
        begin
            explode(ufo_pos, ufo_height);
            break;
        end;

        putimage(shuttle_pos.x + 55, shuttle_pos.y - 11, projectile^, xorput);
        shuttle_pos.y:= shuttle_pos.y - 10;
        putimage(shuttle_pos.x + 55, shuttle_pos.y - 11, projectile^, xorput);
        delay(100);
    end;
    setcolor(white);
end;

procedure ufo_fire(ufo_pos, shuttle_pos: pointtype);
var
    dimension: word;
    projectile: pointer;
begin
    setcolor(yellow);
    line(ufo_pos.x + 55, ufo_pos.y + 63, ufo_pos.x + 55, ufo_pos.y + 73);
    dimension:= imagesize(ufo_pos.x + 55, ufo_pos.y + 63,
                          ufo_pos.x + 55, ufo_pos.y + 73);
    getmem(projectile, dimension);
    getimage(ufo_pos.x + 55, ufo_pos.y + 63,
             ufo_pos.x + 55, ufo_pos.y + 73, projectile^);

    while ufo_pos.y < getmaxy - 10 do
    begin
        if (shuttle_is_hit(shuttle_pos, ufo_pos)) then
        begin
            explode(shuttle_pos, shuttle_height);
            break;
        end;

        putimage(ufo_pos.x + 55, ufo_pos.y + 63, projectile^, xorput);
        ufo_pos.y:= ufo_pos.y + 10;
        putimage(ufo_pos.x + 55, ufo_pos.y + 63, projectile^, xorput);
        delay(100);
    end;
    setcolor(white);
end;

procedure reset_ships(var shuttle_pos, ufo_pos: pointtype; shuttle, ufo: pointer);
begin
    setfillstyle(1, black);
    bar(shuttle_pos.x, shuttle_pos.y, shuttle_pos.x + ship_width,
        shuttle_pos.y + shuttle_height);
    shuttle_pos.x:= 1;
    shuttle_pos.y:= getmaxy - shuttle_height;
    putimage(shuttle_pos.x, shuttle_pos.y, shuttle^, xorput);

    bar(ufo_pos.x, ufo_pos.y, ufo_pos.x + ship_width, ufo_pos.y + ufo_height);
    ufo_pos.x:= getmaxx - ship_width;
    ufo_pos.y:= 1;
    putimage(ufo_pos.x, ufo_pos.y, ufo^, xorput);
    setfillstyle(1, white);
end;

begin
    grdriver:= detect;
    initgraph(grdriver, grmode, 'C:\BP\BGI');

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

    ufo_position.x:= getmaxx - ship_width;
    ufo_position.y:= 1;
    draw_ufo(ufo_position);
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
                        move_ship(shuttle_position, shuttle_height, -step, shuttle);
                    end;
                    #77: begin { RIGHT ARROW }
                        move_ship(shuttle_position, shuttle_height, step, shuttle);
                    end;
                end;
            end;
            #32: begin { SPACE }
                reset_ships(shuttle_position, ufo_position, shuttle, ufo);
            end;
            #49: begin { 1 }
                explode(shuttle_position, 0);
                explode(ufo_position, 1);
            end;
            #97: begin { A }
                move_ship(ufo_position, ufo_height, -step, ufo);
            end;
            #100: begin { D }
                move_ship(ufo_position, ufo_height, step, ufo);
            end;
            #115, #119: begin
                ufo_fire(ufo_position, shuttle_position);
            end;
        end;
    until key_code = #27; { ESCAPE }

    closegraph;
end.
