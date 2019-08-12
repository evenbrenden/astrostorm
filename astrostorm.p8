pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- astro storm
-- by evenbrenden

function _init()

    star_max_speed = 6
    star_min_speed = 1
    spawn_star_interval = 3
    star_colors = { 5, 9, 10 }

    objects = {}
    tick = 0
    music(0)

    splash, live, dead = 0, 1, 2
    state = splash
end

function _draw()
    cls()
    if state == splash then
        draw_objects()
        draw_title()
    end
    if state == live then
        draw_objects()
        draw_ship(0)
    end
    if state == dead then
        draw_objects()
        draw_ship(32)
        print_score()
    end
    rect(0, 0, 127, 127, 7)
end

function draw_title()
    local vertical_offset = 26
    spr(64, 32, vertical_offset, 8, 8)
    spr(72, 32, 32 + vertical_offset, 8, 8)
    local msg = "hit any key 2 start"
    print(msg, 64 - 2*#msg, 79 + vertical_offset, 9)
end

function draw_objects()
    for object in pairs(objects) do
        object.render(object.x, object.y)
    end
end

function draw_ship(offset)
    spr(ship.sprite + offset, ship.x, ship.y)
end

function print_score()
    local score = "u lasted " .. seconds_alive .. " seconds"
    if seconds_alive >= 120 then
        score = "wow " .. score .. "!"
    end
    print(score, 64 - 2*#score, 64 - 2, 9)
end

function _update()
    tick += 1
    if state == splash then
        spawn_stars()
        move_objects()
        clean_up_objects()
        start_game()
    end
    if state == live then
        update_difficulty()
        spawn_stars()
        spawn_asteroids()
        move_objects()
        clean_up_objects()
        move_ship()
        detect_collisions()
        animate_live_ship()
    end
    if state == dead then
        spawn_stars()
        spawn_asteroids()
        move_objects()
        clean_up_objects()
        animate_dead_ship()
        reset_after_a_while()
    end
end

function start_game()
    if
        btn(0) or
        btn(1) or
        btn(2) or
        btn(3) or
        btn(4) or
        btn(5)
    then
        reset()
    end
end

function update_difficulty()
    local interval = 15*30
    if tick % interval == 0 and tick != 0 then
        asteroid_max_speed = 0.5
        asteroid_max_speed = min(asteroid_max_speed, 4)
        asteroid_min_speed += 0.25
        asteroid_min_speed = min(asteroid_min_speed, 4)
        spawn_asteroid_interval -= 5
        if spawn_asteroid_interval <= 4 then
            spawn_asteroid_interval = 4
        end
    end
end

function spawn_stars()
    if tick % spawn_star_interval == 0 then
        local colour = random_color()
        objects[{
            x = 128,
            y = rnd(128),
            speed = rnd(star_max_speed - star_min_speed) + star_min_speed,
            render = function (x, y) pset(x, y, colour) end,
            collidable = false
        }] = true
    end
end

function random_color()
    return star_colors[ceil(rnd(#star_colors))]
end

function spawn_asteroids()
    if tick % spawn_asteroid_interval == 0 then
        objects[{
            x = 128,
            y = rnd(128),
            w = 8,
            h = 8,
            speed = rnd(asteroid_max_speed + asteroid_min_speed) + asteroid_min_speed,
            render = function (x, y) spr(16, x, y) end,
            collidable = true
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
    for object in pairs(objects) do
        if object.collidable and detect_bounding_box_collision(ship, object) then
            collide()
        end
    end
end

function collide()
    sfx(0)
    music(-1)
    seconds_alive = flr(tick/30)
    tick = 0
    state = dead
end

function animate_live_ship()
    local num_live_sprites = 4
    local live_interval = 4
    if tick % live_interval == 0 then
        ship.sprite = (ship.sprite + 1) % num_live_sprites
    end
end

function animate_dead_ship()
    local num_dead_sprites = 4
    local dead_interval = 1
    if
        tick % dead_interval == 0 and
        tick <= num_dead_sprites
    then
        ship.sprite = tick
    end
end

function reset_after_a_while()
    if tick >= 3*30 then
        music(0)
        reset()
    end
end

function reset()

    asteroid_max_speed = 1
    asteroid_min_speed = 0.5
    spawn_asteroid_interval = 30

    objects = {}
    ship = { sprite = 0, x = 10, y = 64, w = 8, h = 5 }
    tick = 0
    state = live
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00555500005555000055550000555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05cc7c5005c7cc50057ccc5005ccc750000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05c6cc50056ccc5005ccc65005cc6c50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555555555555555555555555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555555555555555555555555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00aaaa00009999000088880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0aaaaaa0099999900888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0aaaaaa0099999900888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
aaaaaaaa999999998888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
aaaaaaaa999999998888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00065555550000655555555555065555555555506555555555550655555555550000000000000000000000000000000000000000000000000000000000000000
00065555550000655555555555065555555555506555555555550655555555550045444444000004544444400000454444440000045444444000004500004400
00655555555000655555555555065555555555506555555555550655555555550444144014400044414401440004441440144000444144014400044410021440
00655555555000655555555555065555555555506555555555550655555555554d444444444404d444444444404d444444444404d444444444404d4440144444
06555555555500655555555555065555555555506555555555550655555555554045405440540404540544054040454054405404045405440540404540544054
06555555555500655555555555065555555555506555555555550655555555554145444444440454544444444045454444444404145444444440424540544444
6555555555555065555555555506555555555550655555555555065555555555444404d404d40444404d404d40444404d404d40444404d404d404444401414d0
6555555555555065555555555506555555555550655555555555065555555555452d444044440452d444044440452d444244440452d444044440452d40d44444
65555555555550655555555555065555555555506555555555550655555555550444450545040444445504504044444500450404444450145040444441244504
6555556755555065555666666606667555556660655555675555065555675555444404d444400044404d444400444404d444440444404d444440444444444444
6555550655555065555000000000006555550000655555065555065555065555454d4400000000004444420000054d444444440144d410444440454d44444444
65555506555550655555555555000065555500006555550655550655550655555444412000000000440444000054444104044400544400404440544440440444
65555506555550655555555555000065555500006555550655550655550655554445444444400000044444000044454004444105445400444410444544444441
65555506555550655555555555000065555500006555550655550655550655554404144014440000414404000044044004144404404400414440440414401444
65555506555550655555555555000065555500006555550655550655550655554044444444440000444444000040444004444404044402444440404444444444
65555506555550655555555555000065555500006555550655550655550655554145405440540000440540000041454001405404145444440540414540544054
65555506555550655555555555000065555500006555550655550655550655554545444444440000444444000045454004444404404442044440454544444444
6555550655555065555555555500006555550000655555065555065555065555444404d404d40000404d4400004444400404d405444444444410444404d404d4
655555555555506555555555550000655555000065555555555506555506555544444504450400000444040000454d2004444400445441d44240454d44404444
6555555555555065555555555500006555550000655555555555065555065555444404dd44440000245044000044444004450404545444444440444445044504
6555555555555065555555555500006555550000655555555555065555065555044d444444440000404d4400004444400444440444404d404d40444404d44444
655555555555507666666555550000655555000065555555555506555506555500000052414400005444410000144d400144440454d44d4444d0144d44444444
65555555555550000000055555000065555500006555555555550655550655550000014444240000445524000041544002414404444444454100415444444144
65555555555550655555555555000065555500006555555566660655550655550445444444440000400444000040442024442404444454500000404444522424
6555555555555065555555555500006555550000655555555000065555555555440414401440000044444400004445444444440444544441000044545d454444
65555567555550655555555555000065555500006555555555000655555555554404444444450000414404000044041440144004404114444000445404404440
655555065555506555555555550000655555000065555555555006555555555544444444dd44000004444000004404444444440440444444420044440440d444
65555506555550655555555555000065555500006555555555550655555555554045405440540000440544000040454054405404045445404d00404205404054
65555506555550655555555555000065555500006555565555550655555555554545444444440000444444000045454444444404545410444410454404204444
6555550655555065555555555500006555550000655550655555065555555555444404d004d40000144d140000444404d004d404444400245440444404d044d4
6555550655555065555555555500006555550000655550065555065555555555054d4440444000000444400000054d444044400144d400044440d54404402445
76666607666660766666666666000076666600007666600066660766666666660044454445000000005400000000444544450000544000014400045005400140
__sfx__
00020000003500a350043501b35015350043500430000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000200051200512005220053200542005520056200572005720056200552005420053200522005120001202012025120252202532025420255202562025720257202562025520254202532025220251202512
011000200751207512075220753207542075520756207572075720756207552075420753207522075120751205512055120552205532055420555205562055720557205562055520554205532055220551205512
__music__
02 01024344

