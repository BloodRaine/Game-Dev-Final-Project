{
    if (instance_exists(obj_vivian)) {
        if (distance_to_point(obj_vivian.x,obj_vivian.y) <= 150) {
            aggro = true
            friction = 0
            motion_add(point_direction(x,y,obj_vivian.x,obj_vivian.y),1)
            if (speed >= 2) speed = 2
        } else {
            aggro = false
            motion_add(point_direction(x,y,self.loc_x,self.loc_y),1)
            //path_start(path1, 0.5, path_action_continue,true)
            if (speed >= 2) speed = 2
        }
    }
}
