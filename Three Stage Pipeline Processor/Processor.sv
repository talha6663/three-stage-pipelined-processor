module Processor (
    input logic clk,
    input logic rst
);
    //control signals

    logic        sel_pc;
    logic        sel_opr_a;
    logic        sel_opr_b;
    logic        sel_m;
    logic [ 2:0] imm_type;
    
    logic [ 1:0] sel_wb_id;
    logic [ 1:0] sel_wb_im;

    logic        rf_en_id;
    logic        rf_en_im;


    //operation signals
    logic [31:0] pc_out_if;
    logic [31:0] pc_out_id;
    logic [31:0] pc_out_im;
    logic [31:0] inst_if;
    logic [31:0] inst_id;
    logic [ 4:0] rs2;
    logic [ 4:0] rs1;
    logic [ 4:0] rd_id;
    logic [ 4:0] rd_im;
    logic [ 6:0] opcode;
    logic [ 2:0] func3;
    logic [ 6:0] func7;
    logic [31:0] addr;
    logic [31:0] wdata;
    logic [31:0] rdata;
    logic [31:0] rdata1;
    logic [31:0] rdata2_id;
    logic [31:0] rdata2_im;
    logic [ 3:0] aluop;
    logic [31:0] imm;
    logic [31:0] opr_res_id;
    logic [31:0] opr_res_im;

    logic [31:0] mux_out_pc;
    logic [31:0] mux_out_opr_a;
    logic [31:0] mux_out_opr_b;
    logic [ 2:0] br_type;
    logic        br_taken;
    logic        rd_en_id;
    logic        rd_en_im;
    logic        wr_en_id;
    logic        wr_en_im;
    logic [ 2:0] mem_type_id;
    logic [ 2:0] mem_type_im;

    // pc selection mux
    assign mux_out_pc = sel_pc ? opr_res_id : (pc_out_if + 32'd4);


// FETCH

    PC PC_i
    (
        .clk    ( clk            ),
        .rst    ( rst            ),
        .pc_in  ( mux_out_pc     ),
        .pc_out ( pc_out_if      )
    );

    inst_mem inst_mem_i
    (
        .addr   ( pc_out_if       ),
        .data   ( inst_if         )
    );

    always_ff @(posedge clk) 
    begin
        if (rst)
        begin
            inst_id <= 0;
            pc_out_id <= 0;
        end
        else
        begin
            inst_id <= inst_if;
            pc_out_id <= pc_out_if;
        end
    end

    
    
// DECODE

    inst_decode inst_decode_i
    (
        .inst   ( inst_id         ),
        .rd     ( rd_id           ),
        .rs1    ( rs1             ),
        .rs2    ( rs2             ),
        .opcode ( opcode          ),
        .func3  ( func3           ),
        .func7  ( func7           )
    );

    reg_file reg_file_i
    (
        .clk    ( clk             ),
        .rs2    ( rs2             ),
        .rs1    ( rs1             ),
        .rd     ( rd_im           ),
        .wdata  ( wdata           ),
        .rdata1 ( rdata1          ),
        .rdata2 ( rdata2_id       ),
        .rf_en  ( rf_en_im        )

    );

     // controller
    controller controller_i
    (
        .opcode    ( opcode         ),
        .func7     ( func7          ),
        .func3     ( func3          ),
        .rf_en     ( rf_en_id       ),
        .sel_opr_a ( sel_opr_a      ),
        .sel_opr_b ( sel_opr_b      ),
        .sel_pc    ( sel_pc         ),
        .sel_wb    ( sel_wb_id      ),
        .imm_type  ( imm_type       ),
        .aluop     ( aluop          ),
        .br_type   ( br_type        ),
        .br_taken  ( br_taken       ),
        .rd_en     ( rd_en_id       ),
        .wr_en     ( wr_en_id       ),
        .mem_type  ( mem_type_id    )
    );

    // immediate generator
    imm_gen imm_gen_i
    (
        .inst      ( inst_id        ),
        .imm_type  ( imm_type       ),
        .imm       ( imm            )
    );

// EXECUTE

    // operand a selection mux
    assign mux_out_opr_a = sel_opr_a ? pc_out_id : rdata1;

    // operand b selection mux
    assign mux_out_opr_b = sel_opr_b ? imm    : rdata2_id;

     alu alu_i
    (
        .aluop    ( aluop          ),
        .opr_a    ( mux_out_opr_a  ),
        .opr_b    ( mux_out_opr_b  ),
        .opr_res  ( opr_res_id     )
    );



    Branch_comp Branch_comp_i
    (
        .br_type   ( br_type        ),
        .opr_a     ( mux_out_opr_a  ),
        .opr_b     ( mux_out_opr_b  ),
        .br_taken  ( br_taken       )
    );


always_ff @(posedge clk) 
    begin
        if (rst)
        begin
            pc_out_im <= 0;
            opr_res_im <= 0;
            rdata2_im <= 0;
            rd_im <= 0;
            mem_type_im <= 0;

            // Control Signals
            rf_en_im <= 0;
            sel_wb_im <= 0;
            wr_en_im <= 0;
            rd_en_im <= 0;
        end
        else
        begin
            pc_out_im <= pc_out_id;
            opr_res_im <= opr_res_id;
            rdata2_im <= rdata2_id;
            rd_im <= rd_id;

            // Control Signals
            rf_en_im <= rf_en_id;
            sel_wb_im <= sel_wb_id;
            wr_en_im <= wr_en_id;
            rd_en_im <= rd_en_id;
            mem_type_im <= mem_type_id;
        end
    end

// MEMORY

    data_mem data_mem_i
    (
        .clk       ( clk            ),
        .rd_en     ( rd_en_im       ),
        .wr_en     ( wr_en_im       ),
        .mem_type  ( mem_type_im    ),
        .addr      ( opr_res_im     ),
        .wdata     ( rdata2_im      ),
        .rdata     ( rdata          )
    );

// WRITEBACK

    always_comb
    begin
        case(sel_wb_im)
            2'b00: wdata = opr_res_im;
            2'b01: wdata = rdata;
            2'b10: wdata = pc_out_im + 32'd4;
            2'b11: wdata = 32'd0;
        endcase
    end

endmodule