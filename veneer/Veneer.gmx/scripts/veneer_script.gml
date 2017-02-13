#define veneer_script
///veneer_script(string, top_left_x, top_left_y, line_thickness, brush_sprite, sprite_frame)

/***************************************************
  Must be called in Draw events only.
  line_thickness should be a multiple of 3.
  brush_sprite is a 1px x 1px dot of any color.
 ***************************************************/

vs_alpha = 'abcdefghijklmnopqrstuvwxyz';
vs_numbers = '12345670';
vs_special = '.?! ~#';
vs_string = argument0;
vs_x = argument1;
vs_y = argument2;
vs_scale = argument3;
vs_sprite = argument4;
vs_subimg = argument5;
vs_row = 0;
vs_new_word = true;

/* BEGIN: remove bad chars */
for (vs_i = string_length(vs_string); vs_i > 0; vs_i--)
{
    if (string_pos(string_char_at(string_lower(vs_string), vs_i), vs_alpha) == 0
        && string_pos(string_char_at(vs_string, vs_i), vs_numbers) == 0
        && string_pos(string_char_at(vs_string, vs_i), vs_special) == 0)
    {
        vs_string = string_delete(vs_string, vs_i, 1);
    }
}
/* END */

/* BEGIN: add more spaces, remove bad spaces */
// add spaces before special chars
vs_string = string_replace_all(vs_string, '.', ' .');
vs_string = string_replace_all(vs_string, '?', ' ?');
vs_string = string_replace_all(vs_string, '!', ' !');
vs_string = string_replace_all(vs_string, '~', ' ~');

// get rid of double spaces
while (string_pos('  ', vs_string) != 0)
{
    vs_string = string_replace_all(vs_string, '  ', ' ');
}

// remove space after tilde
vs_string = string_replace_all(vs_string, '~ ', '~');

// get rid of characters that mess up numbers
for (vs_i = string_length(vs_string); vs_i > 0; vs_i--)
{
    // remove tildes not in front of letters
    if (string_char_at(vs_string, vs_i) == "~"
        && (vs_i == string_length(vs_string)
            || string_pos(string_char_at(string_lower(vs_string), vs_i+1), vs_alpha) == 0))
    {
        vs_string = string_delete(vs_string, vs_i, 1);
    }
    
    // remove space after numbers
    if (string_pos(string_char_at(vs_string, vs_i), vs_numbers) != 0
        && vs_i < string_length(vs_string)
        && string_char_at(vs_string, vs_i+1) == " ")
    {
        vs_string = string_delete(vs_string, vs_i+1, 1);
    }
    // remove space before numbers
    if (string_pos(string_char_at(vs_string, vs_i), vs_numbers) != 0
        && vs_i > 1
        && string_char_at(vs_string, vs_i-1) == " ")
    {
        vs_string = string_delete(vs_string, vs_i-1, 1);
        vs_i--;
    }
}
// add spaces after special chars
vs_string = string_replace_all(vs_string, '.', '. ');
vs_string = string_replace_all(vs_string, '?', '? ');
vs_string = string_replace_all(vs_string, '!', '! ');

// get rid of double spaces again
while (string_pos('  ', vs_string) != 0)
{
    vs_string = string_replace_all(vs_string, '  ', ' ');
}

// get rid of spaces at start and end
if (string_char_at(vs_string, 1) == ' ')
{
    vs_string = string_delete(vs_string, 1, 1);
}
if (string_char_at(vs_string, string_length(vs_string)) == ' ')
{
    vs_string = string_delete(vs_string, string_length(vs_string), 1);
}

// get rid of spaces next to new lines
vs_string = string_replace_all(vs_string, ' #', '#');
vs_string = string_replace_all(vs_string, '# ', '#');
/* END */

/* BEGIN: display chars */
vs_string_lower = string_lower(vs_string);

for (vs_i = 1; vs_i <= string_length(vs_string); vs_i++)
{
    switch (string_char_at(vs_string, vs_i))
    {
        case ' ':
            vs_x += vs_scale * 3;
            vs_new_word = true;
            break;
        case '~':
            vs_row = 1;
            vs_new_word = false;
            break;
        case '#':
            vs_x = argument1;
            vs_y += vs_scale * 9;
            vs_new_word = true;
            break;
        case '.':
            vs_row = 2;
            veneer_char(0, 0, 0);
            vs_new_word = true;
            break;
        case '?':
            vs_row = 1;
            veneer_char(0, 0, 0);
            vs_new_word = true;
            break;
        case '!':
            vs_row = 0;
            veneer_char(0, 0, 0);
            vs_new_word = true;
            break;
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
            if (!vs_new_word)
            {
                vs_x += vs_scale * 3;
            }
            veneer_octal(real(string_char_at(vs_string_lower, vs_i)));
            vs_new_word = true;
            break;
        default:
            vs_code = ord(string_char_at(vs_string_lower, vs_i)) - ord('a') + 1;
            vs_code = base_convert(string(vs_code), 10, 3);
            while (string_length(vs_code) < 3)
            {
                vs_code = '0' + vs_code;
            }
            if (vs_new_word == true)
            {
                if (ord(string_char_at(vs_string_lower, vs_i))
                    != ord(string_char_at(vs_string, vs_i)))
                {
                    vs_row = 0;
                }
                else
                {
                    vs_row = 2;
                }
            }
            veneer_char(real(string_char_at(vs_code, 1)),
                real(string_char_at(vs_code, 2)),
                real(string_char_at(vs_code, 3)));
            vs_new_word = false;
            break;
    }
}
/* END */


#define veneer_char
///veneer_char(dy1, dy2, dy3)

/***************************************************
  This should only be called through veneer_script!
 ***************************************************/

vs_end_row = (vs_row + argument0) % 3;
vs_rx = vs_x + vs_scale;
vs_ry = vs_y + vs_scale * (3 * vs_row + 1);
vs_dx = 3 * vs_scale;
vs_dy = vs_y + vs_scale * (3 * vs_end_row + 1) - vs_ry;

draw_sprite_ext(vs_sprite, vs_subimg, vs_rx, vs_ry, vs_scale, vs_scale, 0, c_white, 1);
repeat (9)
{
    vs_rx += vs_dx / 9;
    vs_ry += vs_dy / 9;
    draw_sprite_ext(vs_sprite, vs_subimg, vs_rx, vs_ry, vs_scale, vs_scale, 0, c_white, 1);
}

vs_row = vs_end_row;
vs_end_row = (vs_row + argument1) % 3;
vs_dx = 0;
vs_dy = vs_y + vs_scale * (3 * vs_end_row + 1) - vs_ry;

repeat (9)
{
    vs_rx += vs_dx / 9;
    vs_ry += vs_dy / 9;
    draw_sprite_ext(vs_sprite, vs_subimg, vs_rx, vs_ry, vs_scale, vs_scale, 0, c_white, 1);
}

vs_row = vs_end_row;
vs_end_row = (vs_row + argument2) % 3;
vs_dx = 3 * vs_scale;
vs_dy = vs_y + vs_scale * (3 * vs_end_row + 1) - vs_ry;

repeat (9)
{
    vs_rx += vs_dx / 9;
    vs_ry += vs_dy / 9;
    draw_sprite_ext(vs_sprite, vs_subimg, vs_rx, vs_ry, vs_scale, vs_scale, 0, c_white, 1);
}

vs_row = vs_end_row;
vs_x += vs_scale * 6;

#define veneer_octal
///veneer_octal(digit)

/***************************************************
  This should only be called through veneer_script!
 ***************************************************/

vs_rx = vs_x + vs_scale;
vs_ry = vs_y + vs_scale;

if (argument0 & 4) > 0
{
    draw_sprite_ext(vs_sprite, vs_subimg, vs_rx, vs_ry, vs_scale, vs_scale, 0, c_white, 1);
}

vs_ry += vs_scale * 3;

if (argument0 & 2) > 0
{
    draw_sprite_ext(vs_sprite, vs_subimg, vs_rx, vs_ry, vs_scale, vs_scale, 0, c_white, 1);
}

vs_ry += vs_scale * 3;

if (argument0 & 1) > 0
{
    draw_sprite_ext(vs_sprite, vs_subimg, vs_rx, vs_ry, vs_scale, vs_scale, 0, c_white, 1);
}

vs_ry += vs_scale * 2;
draw_sprite_ext(vs_sprite, vs_subimg, vs_rx, vs_ry - 1, vs_scale, 1, 0, c_white, 1);

vs_x += vs_scale * 3;


#define veneer_script_fast
///veneer_script_fast(string, top_left_x, top_left_y, line_thickness, brush_sprite, sprite_frame)

/***************************************************
  Must be called in Draw events only.
  line_thickness should be a multiple of 3.
  brush_sprite is a 1px x 1px dot of any color.
  
  about 2x speedup from veneer_script
  put spaces before .?!~ and after .?!
  only put ~ before a letter
  don't use bad characters
 ***************************************************/

/*vs_alpha = 'abcdefghijklmnopqrstuvwxyz';
vs_numbers = '12345670';
vs_special = '.?! ~#';*/
vs_string = argument0;
vs_x = argument1;
vs_y = argument2;
vs_scale = argument3;
vs_sprite = argument4;
vs_subimg = argument5;
vs_row = 0;
vs_new_word = true;

/* BEGIN: remove bad chars */
/*for (vs_i = string_length(vs_string); vs_i > 0; vs_i--)
{
    if (string_pos(string_char_at(string_lower(vs_string), vs_i), vs_alpha) == 0
        && string_pos(string_char_at(vs_string, vs_i), vs_numbers) == 0
        && string_pos(string_char_at(vs_string, vs_i), vs_special) == 0)
    {
        vs_string = string_delete(vs_string, vs_i, 1);
    }
}
/* END */

/* BEGIN: add more spaces, remove bad spaces */
/*// add spaces before special chars
vs_string = string_replace_all(vs_string, '.', ' .');
vs_string = string_replace_all(vs_string, '?', ' ?');
vs_string = string_replace_all(vs_string, '!', ' !');
vs_string = string_replace_all(vs_string, '~', ' ~');

// get rid of double spaces
while (string_pos('  ', vs_string) != 0)
{
    vs_string = string_replace_all(vs_string, '  ', ' ');
}

// remove space after tilde
vs_string = string_replace_all(vs_string, '~ ', '~');

// get rid of characters that mess up numbers
for (vs_i = string_length(vs_string); vs_i > 0; vs_i--)
{
    // remove tildes not in front of letters
    if (string_char_at(vs_string, vs_i) == "~"
        && (vs_i == string_length(vs_string)
            || string_pos(string_char_at(string_lower(vs_string), vs_i+1), vs_alpha) == 0))
    {
        vs_string = string_delete(vs_string, vs_i, 1);
    }
    
    // remove space after numbers
    if (string_pos(string_char_at(vs_string, vs_i), vs_numbers) != 0
        && vs_i < string_length(vs_string)
        && string_char_at(vs_string, vs_i+1) == " ")
    {
        vs_string = string_delete(vs_string, vs_i+1, 1);
    }
    // remove space before numbers
    if (string_pos(string_char_at(vs_string, vs_i), vs_numbers) != 0
        && vs_i > 1
        && string_char_at(vs_string, vs_i-1) == " ")
    {
        vs_string = string_delete(vs_string, vs_i-1, 1);
        vs_i--;
    }
}
// add spaces after special chars
vs_string = string_replace_all(vs_string, '.', '. ');
vs_string = string_replace_all(vs_string, '?', '? ');
vs_string = string_replace_all(vs_string, '!', '! ');

// get rid of double spaces again
while (string_pos('  ', vs_string) != 0)
{
    vs_string = string_replace_all(vs_string, '  ', ' ');
}

// get rid of spaces at start and end
if (string_char_at(vs_string, 1) == ' ')
{
    vs_string = string_delete(vs_string, 1, 1);
}
if (string_char_at(vs_string, string_length(vs_string)) == ' ')
{
    vs_string = string_delete(vs_string, string_length(vs_string), 1);
}

// get rid of spaces next to new lines
vs_string = string_replace_all(vs_string, ' #', '#');
vs_string = string_replace_all(vs_string, '# ', '#');
/* END */

/* BEGIN: display chars */
vs_string_lower = string_lower(vs_string);

for (vs_i = 1; vs_i <= string_length(vs_string); vs_i++)
{
    switch (string_char_at(vs_string, vs_i))
    {
        case ' ':
            vs_x += vs_scale * 3;
            vs_new_word = true;
            break;
        case '~':
            vs_row = 1;
            vs_new_word = false;
            break;
        case '#':
            vs_x = argument1;
            vs_y += vs_scale * 9;
            vs_new_word = true;
            break;
        case '.':
            vs_row = 2;
            veneer_char(0, 0, 0);
            vs_new_word = true;
            break;
        case '?':
            vs_row = 1;
            veneer_char(0, 0, 0);
            vs_new_word = true;
            break;
        case '!':
            vs_row = 0;
            veneer_char(0, 0, 0);
            vs_new_word = true;
            break;
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
            if (!vs_new_word)
            {
                vs_x += vs_scale * 3;
            }
            veneer_octal(real(string_char_at(vs_string_lower, vs_i)));
            vs_new_word = true;
            break;
        default:
            vs_code = ord(string_char_at(vs_string_lower, vs_i)) - ord('a') + 1;
            vs_code = base_convert(string(vs_code), 10, 3);
            while (string_length(vs_code) < 3)
            {
                vs_code = '0' + vs_code;
            }
            if (vs_new_word == true)
            {
                if (ord(string_char_at(vs_string_lower, vs_i))
                    != ord(string_char_at(vs_string, vs_i)))
                {
                    vs_row = 0;
                }
                else
                {
                    vs_row = 2;
                }
            }
            veneer_char(real(string_char_at(vs_code, 1)),
                real(string_char_at(vs_code, 2)),
                real(string_char_at(vs_code, 3)));
            vs_new_word = false;
            break;
    }
}
/* END */