///veneer_octal(digit)

/***************************************************
  This should only be called through veneer_script!
 ***************************************************/

vs_rx = vs_x + vs_scale;
vs_ry = vs_y + vs_scale;

if (argument0 & 4) > 0 {
    draw_sprite_ext(vs_sprite, 0, vs_rx, vs_ry, vs_scale, vs_scale, 0, c_white, 1);
}

vs_ry += vs_scale * 3;

if (argument0 & 2) > 0 {
    draw_sprite_ext(vs_sprite, 0, vs_rx, vs_ry, vs_scale, vs_scale, 0, c_white, 1);
}

vs_ry += vs_scale * 3;

if (argument0 & 1) > 0 {
    draw_sprite_ext(vs_sprite, 0, vs_rx, vs_ry, vs_scale, vs_scale, 0, c_white, 1);
}

vs_x += vs_scale * 3;
