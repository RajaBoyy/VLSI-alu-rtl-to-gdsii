# Physical design experiment plan

## Baseline
Run the unchanged 20 ns / 40% configuration. Preserve logs, generated SDC, metrics, and tool/PDK versions. Verify simulation, mapped sequential-cell count, clock recognition, timing coverage, and physical checks.

## Controlled experiments
First sweep target periods of 25, 20, and 15 ns at 40% utilization. Then sweep utilization of 30%, 40%, and 50% at 20 ns. Reuse the baseline instead of running it twice. Keep RTL, PDK, tool version, IO assumptions, and placement seed/settings fixed. Copy config.json into a separate versioned configuration for each run; retain the RTL path relative to that file or adjust it explicitly.

| Question | Evidence to examine |
|---|---|
| Does a tighter clock cause upsizing or buffering? | Cell area, cell mix, setup WNS/TNS |
| Does density increase routing pressure? | Congestion reports, wire length, routing violations |
| What is the clock-tree cost? | Clock buffers, skew, insertion delay |
| Do routing parasitics change the critical path? | Placement vs extracted timing paths |
| Is the design physically consistent? | DRC, LVS, antenna checks |

These are questions to test; no trend is assumed in advance. Report timing at each analyzed corner and distinguish setup from hold. Area alone is not a power measurement. If a run fails, record the failing step and retain the evidence.

## Engineering discussion
Explain which ALU operation and path dominate timing, why the chosen IO budget is reasonable, and how resizing/buffering affect area and congestion. Discuss why this small block is useful for methodology practice but does not demonstrate large-SoC scale, multi-voltage implementation, or MCMM signoff by itself.
