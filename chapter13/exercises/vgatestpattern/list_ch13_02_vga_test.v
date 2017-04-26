// Listing 13.2
module vga_test
   (
    input wire clk, reset,
    input wire [2:0] sw,
    output wire hsync, vsync,
    output wire [7:0] rgb
   );

   //signal declaration
   reg [7:0] rgb_reg;
   wire video_on;
	reg master_clk; //50mhz clock

   // instantiate vga sync circuit
   vga_sync vsync_unit
      (.clk(master_clk), .reset(reset), .hsync(hsync), .vsync(vsync),
       .video_on(video_on), .p_tick(), .pixel_x(), .pixel_y());
   // rgb buffer
   always @(posedge clk, posedge reset)
      if (reset)
         rgb_reg <= 0;
      else
		     rgb_reg <= {1'b0,1'b0,1'b0, 1'b1,1'b1,1'b1, 1'b0,1'b0};

//         rgb_reg <= {sw[2],sw[2],sw[2], sw[1],sw[1],sw[1], sw[0],sw[0]};
   // output
   assign rgb = (video_on) ? rgb_reg : 3'b0;
	
	always @(posedge clk)
      master_clk <= master_clk + 1;

endmodule