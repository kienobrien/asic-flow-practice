Adder architecture: Carry Lookahead


# Utilization
LUT:    35
FF:     31
IO:     33

# Timing
WNS:        1.503 ns
TNS:        0.000 ns
Clk freq:   100MHz

# Worst Setup Path:
Start:          overflow_reg/C
Destination:    overflow

# Power report
Total On-chip Power:        21.998W
Dynamic Power:              0.002W
Device Static Power:        21.996W
Analysis confidence:        Low



## ASIC 101 ALU results

| metric | result |
|--------|-------:|
| Adder architecture |Carry Lookahead Adder|
| Target FPGA | idk lol couldn't find the Spartan-7|
| Clock period | 100MHz|
| LUTs | 35|
| Flip-flops | 31|
| Carry resources | 0|
| WNS | 1.503ns|
| TNS | 0.000ns|
| Total On-Chip Power | 21.998W|
| Dynamic Power | 0.002W|
| Device Static Power | 21.996W|
| Power confidence | Low|




What adder architecture did you choose, and why?

Carry Lookahead Adder because it sounded coool

What is the critical timing path?

It's from overflow_reg/C to overflow

Did the design meet the 100 MHz clock constraint?

Yes, the WNS was 1.503 ns, shorter than the CLK period of 2ns. But a hold failed by 0.075 ns on 4 input ports

What resource appears most important to the arithmetic implementation?

LUTs

How much of the estimated power is dynamic versus static?

Mostly static

What would you change if you wanted to optimize the design for speed?

I would try the Carry Select Adder and see if it's faster than the Carry Lookahead Ader

Why are these FPGA measurements not the same thing as ASIC PPA?

They implement the same logic in very different ways. ASICs are generally a lot more efficient