/*
 * PuzzleFlow System — Gyroid Lattice Module
 * The Bachmann Protocol™
 * 
 * Generates pressure-responsive lattice structures with internal fluid channels
 * Based on Triply Periodic Minimal Surface (TPMS) mathematics
 * 
 * Author: Yassine Drani
 * Date: February 2026
 * License: CC BY-NC-ND 4.0
 */

// === PARAMETERS ===

// Unit cell size (mm)
cell_size = 10;

// Wall thickness (mm) - affects pressure response
wall_thickness = 1.2;

// Number of cells in each direction
cells_x = 5;
cells_y = 5;
cells_z = 3;

// Resolution (higher = smoother but slower)
$fn = 30;

// === GYROID APPROXIMATION ===
// True gyroid: sin(x)cos(y) + sin(y)cos(z) + sin(z)cos(x) = 0
// We approximate with union of twisted surfaces

module gyroid_unit_cell(size, thickness) {
    // Approximation using rotated sine waves
    intersection() {
        cube([size, size, size], center=true);
        
        union() {
            // XY plane wave
            for(z = [-size/2 : size/10 : size/2]) {
                translate([0, 0, z])
                linear_extrude(height=thickness, center=true)
                offset(r=thickness/2)
                polygon([
                    for(t = [0:5:360]) 
                    [size/2 * sin(t + z*36), size/2 * cos(t)]
                ]);
            }
            
            // YZ plane wave
            for(x = [-size/2 : size/10 : size/2]) {
                translate([x, 0, 0])
                rotate([0, 90, 0])
                linear_extrude(height=thickness, center=true)
                offset(r=thickness/2)
                polygon([
                    for(t = [0:5:360]) 
                    [size/2 * sin(t + x*36), size/2 * cos(t)]
                ]);
            }
        }
    }
}

// === SIMPLE LATTICE ALTERNATIVE ===
// If gyroid is too complex, use this simpler lattice

module channel_lattice(size, wall, channel_diameter) {
    difference() {
        cube([size, size, size], center=true);
        
        // X-direction channel
        cylinder(h=size*2, d=channel_diameter, center=true);
        
        // Y-direction channel
        rotate([90, 0, 0])
        cylinder(h=size*2, d=channel_diameter, center=true);
        
        // Z-direction channel
        rotate([0, 90, 0])
        cylinder(h=size*2, d=channel_diameter, center=true);
    }
}

// === PRESSURE-RESPONSIVE CELL ===
// Hexagonal honeycomb - expands under pressure

module honeycomb_cell(size, wall) {
    difference() {
        // Outer hexagon
        cylinder(h=size, d=size, $fn=6, center=true);
        
        // Inner void
        cylinder(h=size+1, d=size-wall*2, $fn=6, center=true);
    }
}

// === LATTICE ARRAY GENERATOR ===

module lattice_array(type="channel") {
    for(x = [0 : cells_x-1]) {
        for(y = [0 : cells_y-1]) {
            for(z = [0 : cells_z-1]) {
                translate([
                    x * cell_size, 
                    y * cell_size, 
                    z * cell_size
                ]) {
                    if(type == "gyroid") {
                        gyroid_unit_cell(cell_size, wall_thickness);
                    } else if(type == "honeycomb") {
                        honeycomb_cell(cell_size, wall_thickness);
                    } else {
                        channel_lattice(cell_size, wall_thickness, cell_size/2);
                    }
                }
            }
        }
    }
}

// === FLUID PORT CONNECTOR ===

module fluid_port(diameter=8, height=15) {
    difference() {
        union() {
            // Base flange
            cylinder(h=3, d=diameter*1.5, center=false);
            
            // Tube
            cylinder(h=height, d=diameter, center=false);
        }
        
        // Inner channel
        translate([0, 0, -1])
        cylinder(h=height+2, d=diameter-2, center=false);
    }
}

// === RENDER ===

// Uncomment one of these to render:

// Option 1: Simple channel lattice (fast render)
lattice_array("channel");

// Option 2: Honeycomb lattice (medium render)
// lattice_array("honeycomb");

// Option 3: Gyroid approximation (slow render)
// lattice_array("gyroid");

// Option 4: Single fluid port
// translate([0, 0, cells_z * cell_size])
// fluid_port();

echo("PuzzleFlow Lattice Generator");
echo("Cell size:", cell_size, "mm");
echo("Array dimensions:", cells_x * cell_size, "x", cells_y * cell_size, "x", cells_z * cell_size, "mm");
