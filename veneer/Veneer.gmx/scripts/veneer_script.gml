///veneer_script(string, top_left_x, top_left_y, line_thickness, brush_sprite)

/***************************************************
  Must be called in Draw events only.
  line_thickness should be a multiple of 3.
  brush_sprite is a 1px x 1px dot of any color.
 ***************************************************/

vs_alpha = 'abcdefghijklmnopqrstuvwxyz';
vs_numeral = '12345670';
vs_special = '.?! ~';
vs_string = argument0;
vs_x = argument1;
vs_y = argument2;
vs_scale = argument3;
vs_sprite = argument4;
vs_row = 0;
vs_new_word = true;

// BEGIN: remove bad chars
for (vs_i = string_length(vs_string); vs_i > 0; vs_i--)
{
    if (string_pos(string_char_at(string_lower(vs_string), vs_i), vs_alpha) == 0
        && string_pos(string_char_at(vs_string, vs_i), vs_numeral) == 0
        && string_pos(string_char_at(vs_string, vs_i), vs_special) == 0)
    {
        vs_string = string_delete(vs_string, vs_i, 1);
    }
}
// END

// BEGIN: add more spaces, remove bad spaces
vs_string = string_replace_all(vs_string, '.', ' .');
vs_string = string_replace_all(vs_string, '?', ' ?');
vs_string = string_replace_all(vs_string, '!', ' !');
vs_string = string_replace_all(vs_string, '.', '. ');
vs_string = string_replace_all(vs_string, '?', '? ');
vs_string = string_replace_all(vs_string, '!', '! ');
vs_string = string_replace_all(vs_string, '~', ' ~');

while (string_pos('  ', vs_string) != 0)
{
    vs_string = string_replace_all(vs_string, '  ', ' ');
}

if (string_char_at(vs_string, 1) == ' ')
{
    vs_string = string_delete(vs_string, 1, 1);
}

if (string_char_at(vs_string, string_length(vs_string)) == ' ')
{
    vs_string = string_delete(vs_string, string_length(vs_string), 1);
}
vs_string = string_replace_all(vs_string, '~ ', '~');
// END

// BEGIN: display chars
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
// END

