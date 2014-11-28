
void setup() {
    size(300, 300); 
    background(255);
    stroke(0);
  
    // draw a 280x280 px grid with 15 lines emphasised every 5 lines 
    CartesianGrid2D g = new CartesianGrid2D();
    g.init(20, 20, 260, 260, 30, 5);
    g.draw();
    
    g.draw_vector(0, 0, 10, 8, g.tri_color, g.red);
    g.draw_vector(10, 8, -3, 4, g.tri_color, g.green);

    g.draw_vector(0, 0, 7, 12, g.transparent, g.blue);
} 