`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project   : CDC Handshake
// Module    : cdc_destination
// Description:
//   Destination clock-domain logic for receiving data
//   through a request/acknowledge CDC handshake.
//
// Author    : Niharika Naik
//////////////////////////////////////////////////////////////////////////////////

module cdc_destination (  input clk_B, rst_B, req_A ,
    		input [7:0] data_hold,
		    output reg ack_B ,
		    output reg [7:0] data_B
		);

reg req_ff1, req_ff2;

wire req_B;
assign req_B = req_ff2;

parameter IDLE = 2'b00 , CAPTURE = 2'b01 , ACK =2'b10 ;
reg [1:0] state , next_state;

always @(posedge clk_B)begin  	//state reg

 	if (rst_B)begin
 	       state <= IDLE;
     	    end
        else 
 	      state <= next_state;
 end 

always @(posedge clk_B)begin   // data reg

	if (rst_B)
	    data_B <= 8'b0;
	else if (state == CAPTURE)
             data_B <=  data_hold;	
end


always @(posedge clk_B)begin   //SYNCHRONIZER
	
    	   if (rst_B) begin
       		 req_ff1 <= 1'b0;
      		  req_ff2 <= 1'b0;
              end
           else begin
     	    req_ff1 <= req_A;
       	    req_ff2 <= req_ff1;
               end
    end

always @(*)begin		//next state

next_state = state ;

case (state)

	IDLE : begin 
		   if (req_B)
			next_state = CAPTURE;
		    else 
			next_state =  IDLE;
		end

        CAPTURE : begin 
			next_state = ACK;
		  end

        ACK : begin 
		   if (req_B)
			next_state = ACK;
		    else 
			next_state = IDLE;
		end
	default: next_state = IDLE;
			
  endcase 			
end

always @(*)begin     		// state logic

case (state)

	IDLE    : begin 
		    ack_B= 1'b0; 
	           end

        CAPTURE : begin 
		  ack_B = 1'b0; 
		  end

        ACK      : begin 
		   ack_B = 1'b1;  
		   end

	default: ack_B = 1'b0;
			
  endcase 			
end

endmodule