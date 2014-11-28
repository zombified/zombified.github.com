
void setup() {
    size(300, 300); 
    background(255);
    stroke(0);
  
    // draw a 280x280 px grid with 15 lines emphasised every 5 lines 
    CartesianGrid2D g = new CartesianGrid2D();
    g.init(20, 20, 260, 260, 30, 5);
    g.draw();

    // the goal is to project `U` onto `V`    
    float xU = 5;
    float yU = 10;
    float xV = 15;
    float yV = 3;

    g.draw_vector(0, 0, xU, yU, g.transparent, g.green); // call this Vector `U`
    g.draw_vector(0, 0, xV, yV, g.transparent, g.red);   // call this Vector `V`

    g.draw_point(0, 0, 4, g.black, "a"); // call this point `a`

    // find a unit vector of V, aka the "direction" vector being projected onto
    float magV = sqrt(xV*xV + yV*yV);
    float uxV = xV/magV;
    float uyV = yV/magV;

    // then find the dot product
    //float dotVU = (xV*xU + yV*yU)/(xV*xV + yV*yV); // the parametric form, if one of the vectors were to not be normalized
    float udotVU = uxV*xU + uyV*yU;

    // then multiply the dot product by each component of the (normalized) vector being projected onto
    float xb = uxV * udotVU;
    float yb = uyV * udotVU;

    // draw a line connecting the first vector to the vector being projected onto
    g.draw_line(xU, yU, xb, yb, 100);

    // draw the projected point
    g.draw_point(xb, yb, 4, g.blue, "b");
} 