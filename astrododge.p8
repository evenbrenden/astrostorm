pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- astro dodge
-- by evenbrenden

star_max_speed = 6
star_min_speed = 1
spawn_star_every = 3
star_colors = { 5, 9, 10 }

asteroid_max_speed = 1
asteroid_min_speed = 1
spawn_asteroid_every = 10

function _draw()
    cls()
    draw_objects()
    draw_ship()
    rect(0, 0, 127, 127, 7)
end

function draw_objects()
    for object in pairs(objects) do
        object.render(object.x, object.y)
    end
end

function draw_ship()
    spr(ship.sprite, ship.x, ship.y)
end

function _update()
    live_time += 1
    spawn_stars()
    spawn_asteroids()
    move_objects()
    clean_up_objects()
    move_ship()
    animate_ship()
    detect_collisions()
    check_death()
end

function spawn_stars()
    if live_time % spawn_star_every == 0 then
        local colour = random_color()
        objects[{
            x = 128,
            y = rnd(128),
            speed = rnd(star_max_speed) + star_min_speed,
            render = function (x, y) pset(x, y, colour) end,
            collide = false
        }] = true
    end
end

function spawn_asteroids()
    if live_time % spawn_asteroid_every == 0 then
        objects[{
            x = 128,
            y = rnd(128),
            w = 8,
            h = 8,
            speed = rnd(asteroid_max_speed) + asteroid_min_speed,
            render = function (x, y) spr(16, x, y) end,
            collide = true
        }] = true
    end
end

function move_objects()
    for object in pairs(objects) do
        object.x -= object.speed
    end
end

function clean_up_objects()
    for object in pairs(objects) do
        if object.x < 0 then
            objects[object] = nil
        end
    end
end

function move_ship()

    if not ship.alive then
        return
    end

    local speed = 2
    if btn(0) then
        ship.x -= speed
    end
    if btn(1) then
        ship.x += speed
    end
    if btn(2) then
        ship.y -= speed
    end
    if btn(3) then
        ship.y += speed
    end

    if ship.x < 0 then
        ship.x = 0
    elseif ship.x > 128 - ship.w then
        ship.x = 128 - ship.w
    end
    if ship.y < -ship.h/2 then
        ship.y = -ship.h/2
    elseif ship.y > 128 - ship.h*(3/2) then
        ship.y = 128 - ship.h*(3/2)
    end
end

function animate_ship()
    local num_sprites = 3
    if ship.alive then
        ship.sprite = (ship.sprite + 1) % num_sprites
    elseif dead_time <= 2 then
        ship.sprite = 3 + dead_time
    end
end

function detect_bounding_box_collision(a, b)

    local real_a_x = a.x + (8 - a.w)/2
    local real_a_y = a.y + (8 - a.h)/2
    local real_b_x = b.x + (8 - b.w)/2
    local real_b_y = b.y + (8 - b.h)/2

    local x_dist = abs((real_a_x + a.w/2) - (real_b_x + b.w/2))
    local y_dist = abs((real_a_y + a.h/2) - (real_b_y + b.h/2))
    local x_sum = a.w/2 + b.w/2
    local y_sum = a.h/2 + b.h/2

    return x_dist < x_sum and y_dist < y_sum
end

function detect_collisions()

    if not ship.alive then
        return
    end

    for object in pairs(objects) do
        if object.collide and detect_bounding_box_collision(ship, object) then
            collide()
        end
    end
end

function collide()
    sfx(0)
    music(-1)
    ship.alive = false
end

function check_death()
    if not ship.alive then
        dead_time += 1
        if dead_time == 4*30 then
            reset()
        end
    end
end

function random_color()
    return star_colors[ceil(rnd(#star_colors))]
end

function reset()
    objects = {}
    ship = { sprite = 0, x = 10, y = 64, w = 8, h = 4, alive = true }
    live_time = 0
    dead_time = 0
    music(0)
end

function _init()
    reset()
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0005555000055550000555500008a9800005a0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
955cc7c5855cc7c5955cc7c5a89a87a8a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
855c6cc5955c6cc5a55c6cc58588698a0008090a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
95555550a55555509555555098aa89a090a000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00454400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04041440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40044444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40454054000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
45454444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
444404d4000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
054d4440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00444500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00020000003500a350043501b35015350043500430000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000200051200512005220053200542005520056200572005720056200552005420053200522005120001202012025120252202532025420255202562025720257202562025520254202532025220251202512
011000200751207512075220753207542075520756207572075720756207552075420753207522075120751205512055120552205532055420555205562055720557205562055520554205532055220551205512
__music__
02 01024344

