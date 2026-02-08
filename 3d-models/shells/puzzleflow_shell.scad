/*
 * PuzzleFlow System — Parametric Foot Shell Generator
 * The Bachmann Protocol™
 * 
 * Generates inner/outer foot shells that can be customized to patient foot scan
 * Designed for DLP/FDM 3D printing
 * 
 * Author: Yassine Drani
 * Date: February 2026
 * License: CC BY-NC-ND 4.0
 */

// === PATIENT PARAMETERS ===
// Adjust these to match patient foot measurements

// Foot dimensions (mm)
foot_length = 260;      // Heel to toe
foot_width = 100;       // At widest point (metatarsal)
foot_height = 65;       // Ankle to sole
heel_width = 60;        // Width at heel

// Shell parameters
shell_gap = 15;         // Gap between inner and outer shell (for lattice)
wall_thickness = 2;     // Shell wall thickness
toe_opening = 0.3;      // 0-1, how much of toe is open (for wound observation)

// Resolution
$fn = 50;

// === FOOT PROFILE GENERATOR ===

function foot_profile(length, width, heel_w) = [
    // Heel (back)
    [0, heel_w/2],
    [0, -heel_w/2],
    
    // Arch (medial side curves in)
    [length*0.3, -width/2 + 10],
    [length*0.5, -width/2],
    
    // Ball of foot (widest)
    [length*0.7, -width/2],
    [length*0.75, -width/2 + 5],
    
    // Toes
    [length*0.9, -width/3],
    [length, 0],
    [length*0.9, width/3],
    
    // Ball of foot (lateral)
    [length*0.75, width/2 - 5],
    [length*0.7, width/2],
    
    // Midfoot (lateral)
    [length*0.5, width/2 - 5],
    [length*0.3, heel_w/2],
];

// === INNER SHELL (contacts foot) ===

module inner_shell() {
    difference() {
        // Solid foot shape
        linear_extrude(height=foot_height, scale=0.8)
        offset(r=5)  // Smooth corners
        polygon(foot_profile(foot_length, foot_width, heel_width));
        
        // Hollow out
        translate([0, 0, wall_thickness])
        linear_extrude(height=foot_height, scale=0.78)
        offset(r=3)
        polygon(foot_profile(foot_length-10, foot_width-10, heel_width-10));
        
        // Top opening (for foot insertion)
        translate([foot_length*0.2, 0, foot_height*0.6])
        cube([foot_length*0.7, foot_width, foot_height], center=true);
    }
}

// === OUTER SHELL ===

module outer_shell() {
    shell_length = foot_length + shell_gap*2;
    shell_width = foot_width + shell_gap*2;
    shell_heel = heel_width + shell_gap*2;
    
    difference() {
        // Outer solid
        linear_extrude(height=foot_height + shell_gap, scale=0.75)
        offset(r=8)
        polygon(foot_profile(shell_length, shell_width, shell_heel));
        
        // Hollow (leave walls)
        translate([0, 0, wall_thickness])
        linear_extrude(height=foot_height + shell_gap + 10, scale=0.73)
        offset(r=6)
        polygon(foot_profile(shell_length - wall_thickness*2, 
                            shell_width - wall_thickness*2, 
                            shell_heel - wall_thickness*2));
        
        // Toe observation window
        if(toe_opening > 0) {
            translate([shell_length*0.85, 0, foot_height/2])
            scale([1, 1.5, 1.2])
            sphere(d=shell_width * toe_opening);
        }
    }
}

// === COMBINED VISUALIZATION ===

module puzzleflow_shell_assembly() {
    // Inner shell (blue)
    color("LightBlue", 0.7)
    inner_shell();
    
    // Outer shell (orange, transparent)
    color("Orange", 0.4)
    outer_shell();
    
    // Note: Lattice goes between inner and outer shells
}

// === FLUID PORT LOCATIONS ===

module port_markers() {
    // Ankle (water in)
    translate([foot_length*0.15, foot_width/2 + shell_gap, foot_height*0.7])
    color("Blue")
    sphere(d=10);
    
    // Toe (water out)
    translate([foot_length*0.8, 0, foot_height*0.8])
    color("Red")
    sphere(d=10);
    
    // Heel (phantom muscle control)
    translate([0, 0, foot_height/2])
    color("Green")
    sphere(d=10);
}

// === RENDER OPTIONS ===

// Uncomment one:

// Full assembly visualization
puzzleflow_shell_assembly();
port_markers();

// Inner shell only (for STL export)
// inner_shell();

// Outer shell only (for STL export)
// outer_shell();

echo("PuzzleFlow Shell Generator");
echo("Foot dimensions:", foot_length, "x", foot_width, "x", foot_height, "mm");
echo("Shell gap for lattice:", shell_gap, "mm");
echo("Wall thickness:", wall_thickness, "mm");
