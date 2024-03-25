/* Automatically generated by Ferrum HDL. */

// src/lib.rs: 60
module top
(
    // Inputs
    input wire clk,
    input wire rst,
    // Outputs
    output reg _led$0,
    output reg _led$1,
    output reg _led$2,
    output reg _led$3
);

    reg [1:0] _reg;
    initial begin
        _reg = 2'd0;
    end
    always @(posedge clk) begin
        if (!rst)
            _reg <= 2'd0;
        else
            _reg <= _$1;
    end

    wire _reg$0;
    wire _reg$1;
    assign _reg$0 = _reg[1];

    assign _reg$1 = _reg[0];

    wire cast;
    assign cast = 1;

    wire succ;
    assign succ = _reg$0 + cast;

    wire cast_1;
    assign cast_1 = 0;

    wire _out$1;
    assign _out$1 = _reg$0 == cast_1;

    wire [1:0] _$1;
    assign _$1 = {
        succ,
        _out$1
    };

    reg [11:0] _reg_1;
    initial begin
        _reg_1 = 12'd15;
    end
    always @(posedge clk) begin
        if (!rst)
            _reg_1 <= 12'd15;
        else if (_reg$1)
            _reg_1 <= _$2;
    end

    wire [3:0] _reg$0_1;
    wire [7:0] _reg$1_1;
    assign _reg$0_1 = _reg_1[11:8];

    assign _reg$1_1 = _reg_1[7:0];

    wire [3:0] cast_2;
    assign cast_2 = 1;

    wire [3:0] counter;
    assign counter = _reg$0_1 + cast_2;

    wire [3:0] cast_3;
    assign cast_3 = 0;

    wire change;
    assign change = counter == cast_3;

    // src/lib.rs: 41
    wire [7:0] _mux$0;
    state_shift __mod (
        // Inputs
        ._self(_reg$1_1),
        // Outputs
        ._mux$0_2(_mux$0)
    );

    // src/lib.rs: 39
    wire [7:0] mux;
    state_change __mod_1 (
        // Inputs
        ._self(_reg$1_1),
        // Outputs
        .mux(mux)
    );

    // src/lib.rs: 38
    reg [7:0] state;
    always @(*) begin
        case (change)
            1'd0: state = _mux$0;
            default: state = mux;
        endcase
    end

    wire [11:0] _$2;
    assign _$2 = {
        counter,
        state
    };

    wire [6:0] left;
    assign left = _reg$1_1[6:0];

    wire [3:0] slice;
    assign slice = left[6:3];

    wire _slice$0;
    wire _slice$1;
    wire _slice$2;
    wire _slice$3;
    assign _slice$0 = slice[3];

    assign _slice$1 = slice[2];

    assign _slice$2 = slice[1];

    assign _slice$3 = slice[0];

    wire [6:0] right;
    assign right = _reg$1_1[6:0];

    wire [3:0] slice_1;
    assign slice_1 = right[3:0];

    wire _slice$0_1;
    wire _slice$1_1;
    wire _slice$2_1;
    wire _slice$3_1;
    assign _slice$0_1 = slice_1[3];

    assign _slice$1_1 = slice_1[2];

    assign _slice$2_1 = slice_1[1];

    assign _slice$3_1 = slice_1[0];

    // src/state.rs: 51
    wire discr;
    assign discr = _reg$1_1[7];

    // src/state.rs: 51
    always @(*) begin
        case (discr)
            1'd0: begin
                _led$0 = _slice$0;
                _led$1 = _slice$1;
                _led$2 = _slice$2;
                _led$3 = _slice$3;
            end
            default: begin
                _led$0 = _slice$0_1;
                _led$1 = _slice$1_1;
                _led$2 = _slice$2_1;
                _led$3 = _slice$3_1;
            end
        endcase
    end

endmodule

// src/state.rs: 36
module state_change
(
    // Inputs
    input wire [7:0] _self,
    // Outputs
    output reg [7:0] mux
);

    wire [7:0] _$1;
    assign _$1 = 248;

    wire [7:0] _$2;
    assign _$2 = 15;

    // src/state.rs: 37
    wire discr;
    assign discr = _self[7];

    // src/state.rs: 37
    always @(*) begin
        case (discr)
            1'd0: mux = _$1;
            default: mux = _$2;
        endcase
    end

endmodule

// src/state.rs: 43
module state_shift
(
    // Inputs
    input wire [7:0] _self,
    // Outputs
    output reg [7:0] _mux$0_2
);

    wire _$1;
    assign _$1 = 0;

    wire _$2;
    assign _$2 = 0;

    wire [6:0] left;
    assign left = _self[6:0];

    wire [6:0] cast;
    assign cast = 0;

    wire out;
    assign out = left == cast;

    wire _$3;
    assign _$3 = 0;

    wire [6:0] cast_1;
    assign cast_1 = 1;

    wire [6:0] _$4;
    assign _$4 = left << cast_1;

    wire [6:0] cast_2;
    assign cast_2 = 15;

    // src/state.rs: 45
    reg [6:0] _mux$0;
    always @(*) begin
        case (out)
            1'd0: _mux$0 = _$4;
            default: _mux$0 = cast_2;
        endcase
    end

    wire _$5;
    assign _$5 = 0;

    wire [7:0] _$6;
    assign _$6 = {
        _$5,
        _mux$0
    };

    wire _$7;
    assign _$7 = 0;

    wire [6:0] right;
    assign right = _self[6:0];

    wire [6:0] cast_3;
    assign cast_3 = 0;

    wire out_1;
    assign out_1 = right == cast_3;

    wire _$8;
    assign _$8 = 0;

    wire [6:0] cast_4;
    assign cast_4 = 1;

    wire [6:0] _$9;
    assign _$9 = right >> cast_4;

    wire [6:0] cast_5;
    assign cast_5 = 120;

    // src/state.rs: 46
    reg [6:0] _mux$0_1;
    always @(*) begin
        case (out_1)
            1'd0: _mux$0_1 = _$9;
            default: _mux$0_1 = cast_5;
        endcase
    end

    wire _$10;
    assign _$10 = 1;

    wire [7:0] _$11;
    assign _$11 = {
        _$10,
        _mux$0_1
    };

    wire _$12;
    assign _$12 = 0;

    // src/state.rs: 44
    wire discr;
    assign discr = _self[7];

    // src/state.rs: 44
    always @(*) begin
        case (discr)
            1'd0: _mux$0_2 = _$6;
            default: _mux$0_2 = _$11;
        endcase
    end

endmodule

