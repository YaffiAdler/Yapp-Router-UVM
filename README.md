# YAPP Router — UVM Verification Environment

A SystemVerilog / UVM verification environment for the **YAPP Router**, a packet router with one
input port, three output channels and a host bus for its configuration registers.
Built as part of the Qualcomm Chip Verification Bootcamp, based on the Cadence
*SystemVerilog Accelerated Verification with UVM* training.

## The DUT

```
                 +-------------------+
   YAPP input -->|                   |--> Channel 0
                 |    YAPP Router    |--> Channel 1
   HBUS ------->|                   |--> Channel 2
                 +-------------------+
```

- A packet has a header byte `{length[5:0], addr[1:0]}`, a payload of 1–63 bytes and a parity byte.
- The 2-bit address picks the output channel (0–2). Address 3 is illegal and is dropped.
- Packets longer than the `maxpktsize` register, or sent while the router is disabled, are dropped.
- Registers are programmed over the HBUS (host bus).

## Environment

```
router_tb (uvm_env)
├── yapp       YAPP UVC           — drives packets into the router
├── chan0..2   Channel UVC x3     — collect packets from the outputs
├── hbus       HBUS UVC           — reads/writes router registers
├── clk_rst    Clock & Reset UVC  — clock and reset generation
├── mcseq      Multichannel sequencer (YAPP + HBUS)
└── router     Router module
    ├── ref_model   Reference model — mirrors registers, filters invalid packets
    └── sb          Scoreboard      — per-channel queues, compares expected vs. actual
```

- **Reference model** — receives YAPP packets and HBUS transactions, keeps a mirror of
  `maxpktsize` and `router_en`, and forwards only the packets the router should route.
- **Scoreboard** — queues expected packets by address and compares them, in order, with the
  packets collected on each output channel.
- **Functional coverage** — the YAPP monitor covers length ranges, addresses (legal/illegal)
  and parity, with a length × address × bad-parity cross.

## Repository Layout

```
.
├── yapp/sv/              YAPP UVC (packet, sequences, driver, monitor, agent, interface)
├── channel/sv/           Channel UVC
├── hbus/sv/              HBUS UVC
├── clock_and_reset/sv/   Clock & Reset UVC
├── router/               Reference model, scoreboard and router module env
└── tb/                   Testbench top, test library, multichannel sequencer, run file
```

## Tests

| Test | Description |
|------|-------------|
| `simple_mcseq_test` | Multichannel sequence: programs `maxpktsize` over HBUS, checks it, and sends YAPP traffic (default) |
| `simple_test` | YAPP packets to addresses 0, 1, 2 with channel and clock/reset sequences |
| `yapp_012_test` | One packet to each legal address |
| `exhaustive_seq_test` | Runs every YAPP sequence in order |
| `incr_payload_test` | Packet with an incrementing payload |
| `short_packet_test` | Factory override to `short_yapp_packet` (length < 15) |
| `set_config_test` | Builds the YAPP agent as passive through `config_db` |

## Running

Requires Cadence Xcelium with UVM (`$UVMHOME` set).

The YAPP Router RTL comes from the Cadence training and is not included in this repository.
Set the DUT path at the end of `tb/run.f` to your local copy of `yapp_router.sv`.

```bash
cd tb
xrun -f run.f
```

To run another test, change `+UVM_TESTNAME` in `tb/run.f`.
