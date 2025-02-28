/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
// `include "multiplier.v"


module tt_um_example_jjm469 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);


// GPIOs -----------------------------------------------------
// 1 input bit for recv_val
// 1 input bit for send_rdy
// 1 output bit for recv_rdy
// 1 output bit for send_val
// 6 input bits for multiplicand_a
// 6 input bits for multiplicand_b
// 6 output bits for product
// 1 input bit for clk
// 1 input bit for reset
// Total: 14 input bits, 8 output bits, 24 total, 2 unused.

// **Connect IO**
// Inputs
logic [5:0] multiplicand_a;
logic [5:0] multiplicand_b;
logic       recv_val;
logic       send_rdy;

assign multiplicand_a = ui_in[5:0];
assign multiplicand_b = {ui_in[7:6], uio_in[3:0]};
assign recv_val       = uio_in[4];
assign send_rdy       = uio_in[5];

// List all unused inputs to prevent warnings
wire _unused = &{ena, 1'b0,uio_in[7], uio_in[6]};

// Outputs
logic [5:0] product;
logic       recv_rdy;
logic       send_val;

assign uo_out[5:0] = product;
assign uo_out[6]   = recv_rdy;
assign uo_out[7]   = send_val;

// Assign unused output pins to zero
// Note, unused GPIO MUST be assigned zero!
assign uio_out     = '0;


// Assign uio_oe to either 0 or 1 depending on whether the
// pins are inputs or outputs respectively.
assign uio_oe      = '0;


// Module Instanciation --------------------------------------
// This example is a multiplier

fixed_point_iterative_Multiplier #(
  // Set module parameters
  .n(6),
  .d(0),
  .sign(0)
) multiplier (
  // Connect module ports
  .clk(clk),
  .reset(~rst_n),
  .recv_rdy(recv_rdy),
  .recv_val(recv_val),
  .a(multiplicand_a),
  .b(multiplicand_b),
  .send_rdy(send_rdy),
  .send_val(send_val),
  .c(product)
);




endmodule
