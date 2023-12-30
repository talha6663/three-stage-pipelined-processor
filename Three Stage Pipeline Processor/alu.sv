module alu (
    input  logic [ 3:0] aluop,
    input  logic [31:0] opr_a,
    input  logic [31:0] opr_b,
    output logic [31:0] opr_res
);
    
    logic sra;
    
    always_comb
    begin 
        case(aluop)
            4'b0000: opr_res = opr_a  +  opr_b;                                    
            4'b0001: opr_res = opr_a  -  opr_b;                                     
            4'b0010: opr_res = opr_a  << opr_b[4:0];                                
            4'b0011: opr_res = ($signed(opr_a) < $signed(opr_b)) ? 32'b1 : 32'b0;   
            4'b0100: opr_res = (opr_a  <  opr_b) ? 32'b1 : 32'b0;                   
            4'b0101: opr_res = opr_a  ^  opr_b;                                   
            4'b0110: opr_res = opr_a  >> opr_b[4:0];                                
            4'b0111: 
                    begin
                    sra = opr_a[31]==1? 1'b1:1'b0;
                    if(sra)
                    begin
                        opr_res = $signed(opr_a) >>> opr_b[4:0];
                    end
                    else
                    begin
                        opr_res = opr_a  >> opr_b[4:0];                                 
                    end
                    end
            4'b1000: opr_res = opr_a  |  opr_b;                                   
            4'b1001: opr_res = opr_a  &  opr_b;                                     
            4'b1010: opr_res = opr_b;                                    
            default: opr_res = 32'b0;                                               
        endcase

    end
    
endmodule