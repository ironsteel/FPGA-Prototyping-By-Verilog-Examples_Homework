// Listing 14.5
module text_screen_top
   (
    input wire clk, btn_set, btn_up, btn_down, btn_right, btn_left,
    input wire [6:0] sw,
    output wire hsync, vsync,
    output wire [2:0] rgb
   );

   // signal declaration
   wire [9:0] pixel_x, pixel_y;
   wire video_on, pixel_tick;
   reg [2:0] rgb_reg;
   wire [2:0] rgb_next;
	reg master_clk; //50mhz clock
   // body
   // instantiate vga sync circuit
   vga_sync vsync_unit
      (.clk(master_clk), .reset(), .hsync(hsync), .vsync(vsync),
       .video_on(video_on), .p_tick(pixel_tick),
       .pixel_x(pixel_x), .pixel_y(pixel_y));
   // font generation circuit
   text_screen_gen text_gen_unit
      (.clk(master_clk), .video_on(video_on),
       .btn_set(btn_set),.btn_up(btn_up),.btn_down(btn_down),.btn_right(btn_right),.btn_left(btn_left), .sw(sw), .pixel_x(pixel_x),
       .pixel_y(pixel_y), .text_rgb(rgb_next));
   // rgb buffer
   always @(posedge clk)
      if (pixel_tick)
         rgb_reg <= rgb_next;
	
	always @(posedge clk)
      master_clk <= master_clk + 1;
	
   // output
   assign rgb = rgb_reg;
endmodule
