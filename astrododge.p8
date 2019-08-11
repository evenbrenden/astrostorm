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
    draw_stars()
    draw_asteroids()
    draw_ship()
    rect(0, 0, 127, 127, 7)
end

function draw_stars()
    for star in pairs(stars) do
        pset(star.x, star.y, star.colour)
    end
end

function draw_ship()
    spr(ship.sprite, ship.x, ship.y)
end

function draw_asteroids()
    for asteroid in pairs(asteroids) do
        spr(16, asteroid.x, asteroid.y)
    end
end

stars = {}
asteroids = {}
ship = { sprite = 0, x = 10, y = 64, w = 8, h = 4 }
t = 0

function _update()
    t += 1
    spawn_stars()
    move_stars()
    clean_up_stars()
    spawn_asteroids()
    move_asteroids()
    clean_up_asteroids()
    move_ship()
    animate_ship()
    detect_collisions()
end

function spawn_stars()
    if (t % spawn_star_every == 0) then
        stars[{
            x = 128,
            y = rnd(128),
            speed = rnd(star_max_speed) + star_min_speed,
            colour = random_color()
        }] = true
    end
end

function move_stars()
    for star in pairs(stars) do
        star.x -= star.speed
    end
end

function clean_up_stars()
    for star in pairs(stars) do
        if (star.x < 0) then
            stars[star] = nil
        end
    end
end

function random_color()
    return star_colors[ceil(rnd(#star_colors))]
end

function spawn_asteroids()
    if (t % spawn_asteroid_every == 0) then
        asteroids[{
            x = 128,
            y = rnd(128),
            w = 8,
            h = 8,
            speed = rnd(asteroid_max_speed) + asteroid_min_speed,
        }] = true
    end
end

function move_asteroids()
    for asteroid in pairs(asteroids) do
        asteroid.x -= asteroid.speed
    end
end

function clean_up_asteroids()
    for asteroid in pairs(asteroids) do
        if (asteroid.x < 0) then
            asteroids[asteroid] = nil
        end
    end
end

function move_ship()
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
    if (ship.x < 1) then
        ship.x = 1
    elseif (ship.x > 119) then
        ship.x = 119
    end
    if (ship.y < -1) then
        ship.y = -1
    elseif (ship.y > 121) then
        ship.y = 121
    end
end

function animate_ship()
    local num_sprites = 3
    local sprite_period = 2
    if (t % sprite_period == 0) then
        ship.sprite = (ship.sprite + 1) % num_sprites
    end
end

function detect_bounding_box_collision(a, b)

    local real_a_x = a.x + (8 - a.w)/2
    local real_a_y = a.y + (8 - a.h)/2
    local real_b_x = b.x + (8 - b.w)/2
    local real_b_y = b.y + (8 - b.h)/2

    x_dist = abs((real_a_x + a.w/2) - (real_b_x + b.w/2))
    y_dist = abs((real_a_y + a.h/2) - (real_b_y + b.h/2))
    x_sum = a.w/2 + b.w/2
    y_sum = a.h/2 + b.h/2

    return x_dist < x_sum and y_dist < y_sum
end

function detect_collisions()
    for asteroid in pairs(asteroids) do
        if (detect_bounding_box_collision(ship, asteroid)) then
            sfx(0)
        end
    end
end

function _init()
    music(0)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00055550000555500005555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
955cc7c5855cc7c5955cc7c500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
855c6cc5955c6cc5a55c6cc500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
95555550a55555509555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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

