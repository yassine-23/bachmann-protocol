# PuzzleFlow 3D Models

## The Bachmann Protocol™ — 3D Printable Prototype

---

## Directory Structure

```
3d-models/
├── foot-scans/          # Patient foot scan STL files
├── lattice-structures/  # Pressure-responsive lattice generators
│   └── puzzleflow_lattice.scad
├── shells/              # Inner/outer shell generators  
│   └── puzzleflow_shell.scad
└── exports/             # Final STL files for printing
```

---

## Required Software

| Software | Purpose | Download |
|----------|---------|----------|
| **OpenSCAD** | Parametric 3D modeling | [openscad.org](https://openscad.org) |
| **PrusaSlicer** | Slicing for FDM printers | [prusa3d.com/prusaslicer](https://www.prusa3d.com/prusaslicer/) |
| **Meshmixer** | STL repair and merging | [meshmixer.com](https://meshmixer.com) |

---

## Quick Start

### 1. Install OpenSCAD

```bash
# macOS (Homebrew)
brew install --cask openscad

# Or download from openscad.org
```

### 2. Open Files

```bash
open /path/to/lattice-structures/puzzleflow_lattice.scad
open /path/to/shells/puzzleflow_shell.scad
```

### 3. Customize Parameters

Edit the parameters at the top of each file:

**For Lattice:**
- `cell_size` — Size of each lattice cell (default: 10mm)
- `wall_thickness` — Wall thickness (affects flexibility)
- `cells_x/y/z` — Number of cells in each direction

**For Shell:**
- `foot_length` — Patient foot length in mm
- `foot_width` — Patient foot width in mm
- `shell_gap` — Gap between shells for lattice

### 4. Export STL

In OpenSCAD:
1. Press F6 (Render)
2. File → Export → Export as STL

---

## Component Architecture

```
┌─────────────────────────────────────────┐
│         OUTER SHELL (rigid)             │
│  ┌───────────────────────────────────┐  │
│  │    LATTICE LAYER (flexible)       │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │    INNER SHELL (contact)    │  │  │
│  │  │                             │  │  │
│  │  │       [ PATIENT FOOT ]      │  │  │
│  │  │                             │  │  │
│  │  └─────────────────────────────┘  │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

---

## Material Recommendations

| Component | Material | Properties |
|-----------|----------|------------|
| **Outer Shell** | PETG or ABS | Rigid, durable |
| **Inner Shell** | TPU 95A | Flexible, skin-safe |
| **Lattice** | TPU 85A | Highly flexible, pressure-responsive |
| **Fluid Ports** | PLA | Rigid, threading-compatible |

---

## Lattice Options

### 1. Channel Lattice (Simple)
- Interconnected channels in X/Y/Z
- Good for prototyping
- Fast to print

### 2. Honeycomb Lattice (Medium)
- Hexagonal cells
- Natural pressure distribution
- Moderate print time

### 3. Gyroid Lattice (Advanced)
- TPMS structure
- Maximum surface area
- Best for thermal exchange
- Slow to render/print

---

## Getting a Foot Scan

### Option A: Smartphone Scanning
- **3DSHOES App** (iOS) — Free foot scanning
- **Polycam** — General 3D scanning
- **RealityScan** — Unreal Engine scanner

### Option B: Download Sample
- Thingiverse: "Human Foot Model"
- Free3D: "Foot STL"
- Cults3D: "Foot Scan for Orthotic"

### Option C: Custom Scan
- Podiatrist 3D scanner
- Photogrammetry with 50+ photos

---

## Assembly Workflow

1. **Scan patient foot** → foot_scan.stl
2. **Generate inner shell** → Scale to fit scan + 5mm offset
3. **Generate lattice** → Size to fill gap between shells
4. **Generate outer shell** → Scale to fit inner shell + lattice
5. **Add fluid ports** → At ankle, toe, and heel locations
6. **Print components** → Use appropriate materials
7. **Assemble** → Insert lattice between shells
8. **Connect tubing** → To fluid ports

---

## Next Steps

- [ ] Download sample foot scan STL
- [ ] Customize shell parameters
- [ ] Export STL files
- [ ] Print prototype
- [ ] Test fluid flow
- [ ] Iterate design

---

## License

**CC BY-NC-ND 4.0** — The Bachmann Protocol™

All 3D models in this directory are protected by the same license as the main project.
Commercial manufacturing requires written permission.

---

*In memory of Walter Bernhard Bachmann (1942-2026)*
