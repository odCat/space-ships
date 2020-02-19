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
    shuttle_position, ufo_position: pointtype;
    shuttle_size, ufo_size: word;
    shuttle, ufo: pointer;
    key_code: char;

procedure init_graph;
var
    grdriver, grmode: integer;
begin
    grdriver:= detect;
    initgraph(grdriver, grmode, 'C:\BP\BGI');
end;

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
    temp[2].x:= corner.x + 40;
    temp[2].y:= corner.y + 110;
    drawpoly(3, temp);

    rectangle(corner.x, corner.y + 110, corner.x + 40, corner.y + 120);
end;

procedure draw_shuttle_right_wing(corner: pointtype);
var
    temp: tripoints;
begin
    temp[0].x:= corner.x + 70;
    temp[0].y:= corner.y + 75;
    temp[1].x:= corner.x + 110;
    temp[1].y:= corner.y + 110;
    temp[2].x:= corner.x + 70;
    temp[2].y:= corner.y + 110;
    drawpoly(3, temp);

    rectangle(corner.x + 70, corner.y + 110, corner.x + 110, corner.y + 120);
end;

procedure draw_shuttle_body(corner: pointtype);
var
    temp: tripoints;
begin
    rectangle(corner.x + 40, corner.y + 30, corner.x + 70, corner.y + 120);

    temp[0].x:= corner.x + 40;
    temp[0].y:= corner.y + 30;
    temp[1].x:= corner.x + 35;
    temp[1].y:= corner.y + 120;
    temp[2].x:= corner.x + 40;
    temp[2].y:= corner.y + 120;
    drawpoly(3, temp);
    
    temp[0].x:= corner.x + 70;
    temp[0].y:= corner.y + 30;
    temp[1].x:= corner.x + 75;
    temp[1].y:= corner.y + 120;
    temp[2].x:= corner.x + 70;
    temp[2].y:= corner.y + 120;
    drawpoly(3, temp);
end;

procedure draw_shuttle_tail(corner: pointtype);
var
    temp: tripoints;
begin
    line(corner.x + 55, corner.y + 75, corner.x + 55, corner.y + 120);
end;

procedure draw_shuttle(shuttle: pointtype);
begin
    draw_shuttle_tip(shuttle);
    draw_shuttle_left_wing(shuttle);
    draw_shuttle_right_wing(shuttle);
    draw_shuttle_body(shuttle);
    draw_shuttle_tail(shuttle);
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

procedure find_center(corner: pointtype; ship_height: integer;
                      var center: pointtype);
begin
    center.x:= corner.x + ship_width div 2;
    center.y:= corner.y + ship_height div 2;
end;

function find_radius(corner: pointtype; ship_height: integer): integer;
begin
    find_radius:= trunc(sqrt(sqr(ship_width div 2 ) +
                             sqr(ship_height div 2)));
end;

procedure explosion(center:pointtype; radius: integer);
begin
    fillellipse(center.x, center.y, radius, radius);
end;

procedure destroy_ship(position: pointtype; ship_height: integer);
var
    center: pointtype;
    radius: integer;
begin
    find_center(position, ship_height, center);
    radius:= find_radius(position, ship_height);

    explosion(center, round(radius/4));
    delay(500);
    explosion(center, round(radius/2));
    delay(500);
    explosion(center, round(radius/3/4));
    delay(500);
    explosion(center, radius);
    delay(500);

    setcolor(black);
    setfillstyle(1, black);
    explosion(center, radius + 1);
    setfillstyle(1, white);
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

procedure wait_and_exit;
begin
    delay(2000);
    key_code:= #27;
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
            destroy_ship(ufo_pos, ufo_height);
            wait_and_exit;
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
            destroy_ship(shuttle_pos, shuttle_height);
            wait_and_exit;
            break;
        end;

        putimage(ufo_pos.x + 55, ufo_pos.y + 63, projectile^, xorput);
        ufo_pos.y:= ufo_pos.y + 10;
        putimage(ufo_pos.x + 55, ufo_pos.y + 63, projectile^, xorput);
        delay(100);
    end;
    setcolor(white);
end;

procedure close_graph_mode;
begin
    freemem(shuttle, shuttle_size);
    freemem(ufo, ufo_size);
    closegraph;
end;

begin
    init_graph;

    shuttle_position.x:= 1;
    shuttle_position.y:= getmaxy - shuttle_height;
    draw_shuttle(shuttle_position);
    shuttle_size:= imagesize(shuttle_position.x, shuttle_position.y,
                             shuttle_position.x + ship_width,
                             shuttle_position.y + shuttle_height);

    getmem(shuttle, shuttle_size);
    getimage(shuttle_position.x, shuttle_position.y,
             shuttle_position.x + ship_width,
             shuttle_position.y + shuttle_height, shuttle^);

    ufo_position.x:= getmaxx - ship_width;
    ufo_position.y:= 1;
    draw_ufo(ufo_position);
    ufo_size:= imagesize(ufo_position.x, ufo_position.y,
                         ufo_position.x + ship_width,
                         ufo_position.y + ufo_height);

    getmem(ufo, ufo_size);
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
            #97: begin { A }
                move_ship(ufo_position, ufo_height, -step, ufo);
            end;
            #100: begin { D }
                move_ship(ufo_position, ufo_height, step, ufo);
            end;
            #115, #119: begin { S, W }
                ufo_fire(ufo_position, shuttle_position);
            end;
        end;
    until key_code = #27; { ESCAPE }

    close_graph_mode;
end.
