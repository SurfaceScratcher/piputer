# Piputer -- OpenSCAD Clamshell Computer

## Overview

3D-printable clamshell laptop enclosure designed in OpenSCAD. Houses a Raspberry Pi 5, Pimoroni NVMe Base, Waveshare UPS 3S (3-cell Li-ion), MC-8017 keyboard, and Elecrow 7" 1024x600 IPS touchscreen. Uses EeePC-style spring-strip friction hinges.

## Project Structure

- `params.scad` -- **Central parameters file** (all shared dimensions, included by every other file)
- `main.scad` -- Top-level assembly; sets `open_angle` and wires bottom + display units
- `bottom_asm.scad` -- Bottom unit assembly (shell, keyboard cover, PCBs, base-side hinges)
- `display_asm.scad` -- Display lid assembly (shell, back cover, LCD, lid-side hinges)
- `bottom.scad` -- Bottom enclosure shell (stepped profile: front 20mm, rear 35mm)
- `top.scad` -- Display lid shell (bezel face up in print orientation)
- `top_cover.scad` -- Removable back plate for display lid (uses M3 inserts, not M2.5)
- `kb_cover.scad` -- Keyboard cover plate with key cutout and hinge screw clearance
- `hinge_eeepc.scad` -- Parametric spring-strip hinge (base half + lid half)
- `mounts.scad` -- Shared standoff/pad/hole modules (`mount4_standoffs`, etc.)
- `piMount.scad` / `usvMount.scad` / `kbMount.scad` -- Board-specific mount wrappers
- `rpi5.scad` / `nvme.scad` / `usv.scad` / `display.scad` -- Component visualization models

## Coordinate Conventions

- Origin: front-left-bottom corner of the bottom shell
- X: left-right (W=226mm)
- Y: front-back (D=200mm total; D_front=130mm keyboard zone, D_rear=70mm electronics zone)
- Z: bottom-up
- Hinge barrel axis: Y=130 (step wall), Z=30 (barrel_z)
- `open_angle`: 0=closed, 120=typical open

## Key Dimensions

All shared dimensions live in `params.scad`. Key values:

| Parameter | Value | Description |
|-----------|-------|-------------|
| W | 226 mm | Enclosure width |
| D_front | 130 mm | Keyboard zone depth |
| D_rear | 70 mm | Electronics zone depth |
| H_front | 20 mm | Front zone height |
| H_rear | 35 mm | Rear zone height |
| wall | 2 mm | Shell wall thickness |
| floor_t | 3 mm | Floor thickness |
| kb_t | 3 mm | Keyboard cover thickness |
| back_t | 5 mm | Display back plate thickness |
| barrel_z | 30 mm | Hinge barrel Z (computed: H_front + kb_t + hinge_rise) |
| thickness | 1.5 mm | Hinge arm/plate thickness |
| width | 7.4 mm | Hinge arm/barrel width |
| bend_angle | 70 deg | Spring-strip bend angle |

## Build & Preview

Render the full assembly:
```
openscad main.scad
```

Individual parts for printing:
```
openscad bottom.scad
openscad top.scad
openscad kb_cover.scad
openscad top_cover.scad
```

Test hinge at various angles (edit `preview_angle` in `display_asm.scad`):
```
openscad display_asm.scad
```

## OpenSCAD Conventions

- `params.scad` uses `include` (not `use`) so all globals are available
- Module files use `use <./file.scad>` to import modules without executing top-level geometry
- Each file has a standalone preview call at the bottom (e.g., `bottom();`)
- `eps = 0.01` is defined once in `params.scad` for boolean-operation clearance
- `$fn` controls facet count; set per-cylinder or globally

## Editing Guidelines

- **Change dimensions in `params.scad`** -- they propagate to all files via `include`
- Hinge geometry is derived from `hinge_rise` and `bend_angle` -- changing these auto-recalculates `arm_len`, `barrel_y_off`, and `barrel_z_off`
- Port cutouts in `bottom.scad` are parametrized from `rpi_oy` -- moving the RPi moves the ports
- The display lid uses a mirror+translate+rotate sequence in `main.scad` -- verify with `open_angle=0` (closed) when changing hinge geometry
- M2.5 hardware used everywhere except `top_cover.scad` which uses M3 for display PCB lash screws (documented in file)

## Hardware BOM

- Raspberry Pi 5
- Pimoroni NVMe Base (HAT format, M.2 Key-M)
- Waveshare UPS Module 3S + 3x 18650 cells
- MC-8017 keyboard (220x118mm)
- Elecrow 7" IPS touchscreen (180x124x10mm, active area 154.21x85.92mm)
- 2x EeePC-style spring-strip friction hinges
- M2.5 heat-set inserts, M2.5 screws, M2.5 spacers (7mm board-to-board)
- M3 heat-set inserts, M3 screws (display back plate lash bores only)
