class CartesianGrid2D {
    int xoff, yoff; // in pixels
    int gwidth, gheight; // in pixels
    int lines;
    float x_spacing;
    float y_spacing;
    int emphasis; // per number of lines

    int[] tri_color = [100, 100, 100, 80];
    int[] transparent = [0, 0, 0, 0];
    int[] white = [255, 255, 255, 255];
    int[] black = [0, 0, 0, 255];
    int[] red = [255, 0, 0, 255];
    int[] green = [0, 255, 0, 255];
    int[] blue = [0, 0, 255, 255];
    int[] light_grey = [0, 0, 0, 255];

    void init(int offset_x, int offset_y, int grid_width, int grid_height, int number_of_lines, int line_emphasis) {
        xoff = offset_x;
        yoff = offset_y;
        gwidth = grid_width;
        gheight = grid_height;
        lines = number_of_lines;
        x_spacing = gwidth / lines;
        y_spacing = gheight / lines;
        emphasis = line_emphasis;
    }

    void draw() {
        strokeCap(SQUARE);
        strokeWeight(1);
        noFill();
        stroke(210);
        float xpos, ypos;
        for(int l = 0; l < lines; l++) {
            xpos = l * x_spacing;
            ypos = l * y_spacing;
            
            if(emphasis > 0 && l > 0 && (l % emphasis) == 0) {
                strokeWeight(2);
            }
            else {
                strokeWeight(1);
            }
            
            line(xoff+xpos, yoff, xoff+xpos, yoff+gheight);
            line(xoff, yoff+ypos, xoff+gwidth, yoff+ypos);
        }
        // draw the left and bottom lines
        line(xoff+gwidth, yoff, xoff+gwidth, yoff+gheight);
        line(xoff, yoff+gheight, xoff+gwidth, yoff+gheight);
        
        // draw x and y axis
        stroke(170);
        strokeWeight(2);
        float x_center = x_spacing * (lines/2);
        float y_center = y_spacing * (lines/2);
        line(xoff, yoff+y_center, xoff+gwidth, yoff+y_center);
        line(xoff+x_center, yoff, xoff+x_center, yoff+gheight);
        
        // draw axis labels
        fill(160);
        text("x", xoff+gwidth+4, yoff+((lines/2)*y_spacing)+2.5);
        text("y", xoff+((lines/2)*x_spacing)-2.5, yoff-6);
    }
   
    // sx, sy: starting coordinates of the vector
    // vx, vy: the encoded vector
    // triangle_color: what to fill the displayed triangle as
    // vector_color: what to stroke the vector as 
    void draw_vector(int sx, int sy, int vx, int vy, int[] triangle_color, int[] vector_color) {
        int grid_width = gwidth;
        int grid_height = gheight;
        // need to adjust for a 4-quadrant coordinate system
        float coord_offset_x = xoff + (x_spacing * (lines/2));
        float coord_offset_y = yoff + (y_spacing * (lines/2));
        // need to adjust for 4-quadrant coordinate system
        float corrected_sx = sx*x_spacing;
        float corrected_sy = -sy*y_spacing;
        float corrected_vx = vx*x_spacing;
        float corrected_vy = -vy*y_spacing;

        // calculate the 3 points of the triangle
        float x1, y1, x2, y2, x3, y3;
        x1 = corrected_sx+coord_offset_x; y1 = corrected_sy+coord_offset_y;
        x2 = corrected_sx+corrected_vx+coord_offset_x; y2 = corrected_sy+coord_offset_y;
        x3 = corrected_sx+corrected_vx+coord_offset_x; y3 = corrected_sy+corrected_vy+coord_offset_y;
        // draw the triangle
        noStroke();
        if(triangle_color[3] == 0) {
            noFill();
        }
        else {
            fill(triangle_color[0], triangle_color[1], triangle_color[2], triangle_color[3]);
        }
        triangle(x1, y1, x2, y2, x3, y3);
    
        // draw the hypotenuse (aka the conceptulization of a vector)
        stroke(vector_color[0], vector_color[1], vector_color[2], vector_color[3]);
        strokeWeight(2);
        line(x1, y1, x3, y3);
        
        // and the hypotenuse arrow head to show vector direction
        bool easterly, northerly;
        easterly = vx > 0;
        northerly = vy > 0;
        // the angle is based on the "SOHCAHTOA" mnemonic, we are
        // using TOA, which, to solve for the angle, means the use
        // of the _inverse_ tangent of the opposite (vy) and
        // adjacent (vx) angles. luckily, this value is returned
        // in radians
        float rad180 = radians(180);
        float rad360 = radians(360);
        float angle = -abs(atan(vy / vx));
        // since the _angle_ is the angle of the triangle created by the
        // vector encoding, we need to adjust the angle for rotation based
        // on the distance (in degrees) the vector is rotated in around
        // the origin
        if(!easterly && northerly) { angle = rad180 - angle; }
        else if(!easterly && !northerly) { angle = rad180 + angle; }
        else if(easterly && !northerly) { angle = rad360 - angle; }
        float arrow_width = 5;
        float magnitude = sqrt(vx*vx + vy*vy)*x_spacing;
        pushMatrix();
            // fourth: center about the presented grid instead of the
            // canvas' grid
            translate(corrected_sx+coord_offset_x, corrected_sy+coord_offset_y);
            
            // third: rotate around origin (of the canvas, not the grid that's
            // been created) the calculated angle of the hypotenuse
            rotate(angle);
        
            // second: translate east the magnitude of the vector
            translate(magnitude, 0);
            // first: rotate arrowhead 45 degrees to point east (remember,
            // it's being rotated in the canvas' space not the conceptual
            // grid space being displayed)
            rotate(radians(-45));
        
            // (since the hypotenuse itself only shows magnitude)
            noStroke();
            fill(vector_color[0], vector_color[1], vector_color[2], vector_color[3]);
    
            // draw the arrow in a fixed location, since it's rotated
            // and transformed to the correct spot
            triangle(-arrow_width, 0, 0, 0, 0, -arrow_width);
        popMatrix();
    }

    void draw_point(float x, float y, int r, int[] color, string label) {
        float coord_offset_x = xoff + (x_spacing * (lines/2));
        float coord_offset_y = yoff + (y_spacing * (lines/2));
        float corrected_x = coord_offset_x + (x * x_spacing);
        float corrected_y = coord_offset_y + (-y * y_spacing);

        noStroke();
        fill(color[0], color[1], color[2], color[3]);
        ellipse(corrected_x, corrected_y, r*2, r*2);
        noFill();
        stroke(color[0], color[1], color[2], color[3]);
        text(label, corrected_x + 4, corrected_y + 10);
    }

    void draw_line(float x1, float y1, float x2, float y2, int color) {
        float coord_offset_x1 = xoff + (x_spacing * (lines/2));
        float coord_offset_y1 = yoff + (y_spacing * (lines/2));
        float corrected_x1 = coord_offset_x1 + (x1 * x_spacing);
        float corrected_y1 = coord_offset_y1 + (-y1 * y_spacing);
        float coord_offset_x2 = xoff + (x_spacing * (lines/2));
        float coord_offset_y2 = yoff + (y_spacing * (lines/2));
        float corrected_x2 = coord_offset_x2 + (x2 * x_spacing);
        float corrected_y2 = coord_offset_y2 + (-y2 * y_spacing);
        noFill();
        stroke(color);
        strokeCap(SQUARE);
        strokeWeight(1);
        line(corrected_x1, corrected_y1, corrected_x2, corrected_y2);
    }
}