# Piputer -- OpenSCAD Clamshell Computer

## Overview

3D-printable clamshell laptop enclosure designed in OpenSCAD. Houses a Raspberry Pi 5, Pimoroni NVMe Base, Waveshare UPS 3S (3-cell Li-ion), MC-8017 keyboard, and Elecrow 7" 1024x600 IPS touchscreen. Uses EeePC-style spring-strip friction hinges.

## Project Structure

- `main.scad` -- Top-level assembly; sets `open_angle` and wires bottom + display units
- `bottom_asm.scad` -- Bottom unit assembly (shell, keyboard cover, PCBs, base-side hinges)
- `display_asm.scad` -- Display lid assembly (shell, back cover, LCD, lid-side hinges)
- `bottom.scad` -- Bottom enclosure shell (stepped profile: front 20mm, rear 35mm)
- `top.scad` -- Display lid shell (bezel face up in print orientation)
- `top_cover.scad` -- Removable back plate for display lid
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
| barrel_z | 30 mm | Hinge barrel Z position |
| hinge_rise | 7 mm | Barrel height above mount plate |

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

## OpenSCAD Conventions

- Use `use <./file.scad>` (not `include`) to import modules without executing top-level geometry
- Each file has a standalone preview call at the bottom (e.g., `bottom();`) for individual testing
- `eps = 0.01` is used throughout for boolean-operation clearance (prevents z-fighting)
- `$fn` controls facet count; set per-cylinder or globally as needed
- German variable names appear in `hinge_eeepc.scad` (e.g., `breite`=width, `laenge`=length, `dicke`=thickness, `loch`=hole, `anzahl`=count)

## Editing Guidelines

- When modifying dimensions, check all dependent files -- parameters like `D_front`, `barrel_z`, and hinge geometry propagate across multiple files via hardcoded values (not a single config file)
- Hinge geometry is derived from `hinge_rise` and `winkel` (angle) -- changing these recalculates `laenge_b`, `barrel_y_off`, and `barrel_z_off` automatically
- Mount hole positions must stay synchronized between `bottom.scad` standoffs, `kb_cover.scad` clearance holes, and `hinge_eeepc.scad` hole patterns
- The display lid uses a mirror+translate+rotate sequence in `main.scad` to animate the hinge -- verify with `open_angle=0` (closed) when changing hinge geometry
- Hardware references: M2.5 heat-inserts (3.5mm bore), M2.5 clearance holes (2.7mm), M3 inserts (4.5mm bore)

## Hardware BOM

- Raspberry Pi 5
- Pimoroni NVMe Base (HAT format, M.2 Key-M)
- Waveshare UPS Module 3S + 3x 18650 cells
- MC-8017 keyboard (220x118mm)
- Elecrow 7" IPS touchscreen (180x124x10mm, active area 154.21x85.92mm)
- 2x EeePC-style spring-strip friction hinges
- M2.5 heat-set inserts, M2.5 screws, M2.5 spacers (7mm board-to-board)
- M3 heat-set inserts, M3 screws (display back plate)
