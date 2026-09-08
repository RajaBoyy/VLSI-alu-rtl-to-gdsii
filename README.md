# 32-bit ALU — RTL to GDSII

An independent VLSI physical design portfolio project by **Raja Thunga**.

**Current status:** Starter RTL, self-checking testbench, and OpenLane 2 configuration are prepared. Simulation, synthesis, routing, STA, DRC, and LVS have **not been run** in the authoring environment. No timing, area, power, or signoff results are claimed.

## Architecture
Two 32-bit inputs and a 3-bit operation selector feed combinational ALU logic and a registered output. Inputs are sampled on each rising edge when `valid_in` is high. The corresponding result is available after that edge. `valid_out` follows the sampled valid input; the result holds during invalid cycles. Active-high synchronous reset clears both outputs and takes priority over valid.

| Opcode | Operation |
|---|---|
| 0 | Addition modulo 2^32 |
| 1 | Subtraction modulo 2^32 |
| 2 | Bitwise AND |
| 3 | Bitwise OR |
| 4 | Bitwise XOR |
| 5 | Logical left shift by b[4:0] |
| 6 | Logical right shift by b[4:0] |
| 7 | Signed less-than, result 0 or 1 |

No carry or overflow flag is exposed. The longest functional paths are input-to-register paths through ALU logic. There is no input-register pipeline stage; IO delay assumptions therefore materially affect timing.

## Repository
- `rtl/alu32.v`: synthesizable design
- `tb/tb_alu32.v`: directed and randomized simulation checks
- `config.json`: OpenLane 2 / SKY130 baseline
- `docs/experiments.md`: timing and utilization study
- `results/README.md`: evidence checklist and unfilled results
- `.github/workflows/sim.yml`: simulation CI

## Simulate
Install Icarus Verilog and GNU Make, then run:

```sh
make sim
```

The testbench checks all operations, signed boundary cases, overflow/wraparound, shift-count truncation, reset priority, and invalid-cycle output retention. Expected success output: `PASS: 844 checked cycles`. This is the expected test count, not a recorded pass.

## Run physical implementation
Install OpenLane 2 using its official supported environment and SKY130 PDK setup. From this project directory, inside that environment:

```sh
openlane config.json
```

The configuration specifies a **20 ns target** and **40% core utilization**. These are starting assumptions, not measured performance. The standard flow covers synthesis, floorplanning, placement, CTS, routing, extraction, and configured physical checks. Review the actual step list and reports for the installed release.

The baseline uses OpenLane's default generated timing constraints. Inspect generated SDC, input/output delays, clock uncertainty, and output loading before interpreting timing. Replace default interface assumptions with documented system requirements for a more realistic study. Reset is synchronous and must remain timed; do not add a blanket false path on reset.

Record the exact OpenLane version, PDK revision, standard-cell library, configuration, and command for every experiment. The configuration has not been validated by OpenLane in this package.

## Portfolio evidence
Follow [the experiment plan](docs/experiments.md), then populate [the results](results/README.md). Add a routed-layout screenshot, setup/hold reports, cell-area/utilization figures, and DRC/LVS summaries. Review timing coverage and unconstrained paths before reporting closure. Power analysis needs explicit activity and modeling assumptions.

## References
- [OpenLane 2 installation and first design](https://openlane2.readthedocs.io/en/latest/getting_started/newcomers/index.html)
- [Design configuration](https://openlane2.readthedocs.io/en/latest/reference/configuration.html)
- [Flow variables](https://openlane2.readthedocs.io/en/latest/reference/common_flow_vars.html)

All RTL is educational and independent of employer designs. No foundry files or proprietary project material are included.
