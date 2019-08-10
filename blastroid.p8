pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- blastroid
-- by evenbrenden

star_max_speed = 6
star_min_speed = 1
spawn_star_every = 3
star_colors = { 5, 9, 10 }

function _draw()
    cls()
    rect(0, 0, 127, 127, 7)
    draw_stars()
end

function draw_stars()
    for star in pairs(stars) do
        pset(star.x, star.y, star.colour)
    end
end

stars = {}
t = 0

function _update()
    t += 1
    spawn_stars()
    move_stars()
    clean_up_stars()
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

function _init()
    music(0)
end
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000200051200512005220053200542005520056200572005720056200552005420053200522005120001202012025120252202532025420255202562025720257202562025520254202532025220251202512
011000200751207512075220753207542075520756207572075720756207552075420753207522075120751205512055120552205532055420555205562055720557205562055520554205532055220551205512
__music__
02 01024344

