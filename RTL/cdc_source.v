`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project   : CDC Handshake
// Module    : cdc_source
// Description:
//   Source clock-domain logic for transferring 8-bit data
//   across an asynchronous clock boundary using a
//   request/acknowledge handshake.
//
// Author    : Niharika Naik
//////////////////////////////////////////////////////////////////////////////////

module cdc_source(
		input clk_A, rst_A, start,ack_B,
    		input [7:0] data_A,
		output reg req_A , 
                output reg [7:0]data_hold
		);
wire ack_A;
reg ack_ff1 ,ack_ff2;

parameter IDLE = 2'b00 , SEND = 2'b01 , DONE =2'b10 ;
reg [1:0] state , next_state;

always @(posedge clk_A)begin  	//state reg

 	if (rst_A)begin
 	       state <= IDLE;
     	    end
        else 
 	      state <= next_state;
 end 

always @(posedge clk_A)begin   //data reg

	if (rst_A)
		data_hold <= 8'd0;
        else if (state == IDLE && start)
                data_hold <= data_A;
end


always @(posedge clk_A)begin   //SYNCHRONIZER
	
    	   if (rst_A) begin
       		ack_ff1 <= 1'b0;
      		ack_ff2 <= 1'b0;
               end

           else begin
     	    	ack_ff1 <= ack_B;
       	   	ack_ff2 <= ack_ff1;
               end
    end

assign ack_A = ack_ff2;

always @(*)begin		//next state

next_state = state ;

case (state)

	IDLE : begin 
		   if (start)
			next_state = SEND;
		    else 
			next_state =  IDLE;
		end

        SEND : begin 
		   if (ack_A)
			next_state = DONE;
		    else 
			next_state = SEND;
		end

        DONE : begin 
		   if (ack_A)
			next_state = DONE;
		    else 
			next_state =  IDLE;
		end
	default: next_state = IDLE;
			
  endcase 			
end

always @(*)begin     		// state logic

case (state)

	IDLE : begin 
		 req_A = 1'b0; 
  
		end

        SEND : begin 
		  req_A = 1'b1; 
		end

        DONE : begin 
		   req_A = 1'b0;
                   
		   
		end

	default: req_A = 1'b0;
			
  endcase 			
end

endmodule







