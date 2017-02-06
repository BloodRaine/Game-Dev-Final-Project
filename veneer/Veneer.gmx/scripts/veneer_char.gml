///veneer_char(dy1, dy2, dy3)

/***************************************************
  This should only be called through veneer_script!
 ***************************************************/

vs_end_row = (vs_row + argument0) % 3;
vs_rx = vs_x + vs_scale;
vs_ry = vs_y + vs_scale * (3 * vs_row + 1);
vs_dx = 3 * vs_scale;
vs_dy = vs_y + vs_scale * (3 * vs_end_row + 1) - vs_ry;

draw_sprite_ext(vs_sprite, 0, vs_rx, vs_ry, vs_scale, vs_scale, 0, c_white, 1);
repeat (9) {
    vs_rx += vs_dx / 9;
    vs_ry += vs_dy / 9;
    draw_sprite_ext(vs_sprite, 0, vs_rx, vs_ry, vs_scale, vs_scale, 0, c_white, 1);
}

vs_row = vs_end_row;
vs_end_row = (vs_row + argument1) % 3;
vs_dx = 0;
vs_dy = vs_y + vs_scale * (3 * vs_end_row + 1) - vs_ry;

repeat (9) {
    vs_rx += vs_dx / 9;
    vs_ry += vs_dy / 9;
    draw_sprite_ext(vs_sprite, 0, vs_rx, vs_ry, vs_scale, vs_scale, 0, c_white, 1);
}

vs_row = vs_end_row;
vs_end_row = (vs_row + argument2) % 3;
vs_dx = 3 * vs_scale;
vs_dy = vs_y + vs_scale * (3 * vs_end_row + 1) - vs_ry;

repeat (9) {
    vs_rx += vs_dx / 9;
    vs_ry += vs_dy / 9;
    draw_sprite_ext(vs_sprite, 0, vs_rx, vs_ry, vs_scale, vs_scale, 0, c_white, 1);
}

vs_row = vs_end_row;
vs_x += vs_scale * 6;
