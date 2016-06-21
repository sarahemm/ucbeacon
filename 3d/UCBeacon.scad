$fa = 1;
$fs = 1;

drain_od = 50;
drain_id = 45;

tube_od = inch_to_mm(8);
tube_id = inch_to_mm(7.764);
tube_height = 80;

body_od = inch_to_mm(10);
body_height = 30;

base_od = inch_to_mm(10);
base_height = 15;

pcb_od = inch_to_mm(8.25);
pcb_height = inch_to_mm(0.062);

battery_type = 18650;
battery_diameter = floor(battery_type / 1000);
battery_length = (battery_type / 1000 - battery_diameter) * 100;        

battery_spacing = 60;

seal_height = 5;

bolt_od = 4;
bolt_head_dia = 6;
bolt_head_height = 3;

solar_height = 5;
solar_spacing = 10;
solar_od = 160;
solar_angle = 15;

difference() {
  union() {
    // glow ring
    color([1, 1, 1, 0.5]) {
        translate([0, 0, base_height + pcb_height])
        difference() {
            cylinder(tube_height, d=tube_od);
            translate([0, 0, -1])
                cylinder(tube_height + 2, d=tube_id);
        }
    }

    // body
    color([1, 1, 0.75, 0.75]) {
        translate([0, 0, base_height])
            difference() {
                cylinder(body_height, d=body_od);
                translate([0, 0, -1])
                    cylinder(body_height + 2, d=tube_od);
        }
    }

    // PCB
    color([0.75, 1, 0.75, 0.75]) {
        translate([0, 0, base_height])
            cylinder(pcb_height, d=pcb_od);
    }

    // base
    color([0.75, 0.75, 1, 0.75]) {
        cylinder(base_height, d=base_od);
    }

    // batteries
    color([0.25, 0.25, 1, 0.75]) {
        translate([battery_spacing, battery_length/2, base_height + pcb_height + battery_diameter/2])            rotate([90, 0, 0])
                cylinder(battery_length, d=battery_diameter);
        
        translate([-battery_spacing, battery_length/2, base_height + pcb_height + battery_diameter/2])
            rotate([90, 0, 0])
                cylinder(battery_length, d=battery_diameter);
    }

    // weather sealing inner ring
    color([0, 0, 0, 0.5]) {
        translate([0, 0, base_height + pcb_height + battery_diameter])
            cylinder(seal_height, d=tube_id);
    }
    
    // bolts
    body_thickness = (body_od/2 - tube_od/2) / 2;
    bolt_location = tube_od/2 + body_thickness;
    bolt_length = base_height + body_height + bolt_head_height;
    // bolts
    translate([bolt_location, 0, 0])
        bolt(bolt_length);
    translate([0, bolt_location, 0])
        bolt(bolt_length);
    translate([-bolt_location, 0, 0])
        bolt(bolt_length);
    translate([0, -bolt_location, 0])
        bolt(bolt_length);
    
    // solar panel
    color([0.2, 0.2, 0.2, 0.6])
        translate([0, 0, tube_height + solar_spacing])
            rotate([0, solar_angle, 0])
                cylinder(solar_height, d=solar_od);

    // solar panel mounting bolts
    solar_bolt_length = tube_height + solar_spacing + pcb_height - base_height - battery_diameter + seal_height;
    translate([solar_od/4, 0, base_height + pcb_height + battery_diameter])
        bolt(solar_bolt_length - (solar_angle * sin(solar_od/4)));
    translate([0, solar_od/4, base_height + pcb_height + battery_diameter])
        bolt(solar_bolt_length);
    translate([-solar_od/4, 0, base_height + pcb_height + battery_diameter])
        bolt(solar_bolt_length + (solar_angle * sin(solar_od/4)));
    translate([0, -solar_od/4, base_height + pcb_height + battery_diameter])
        bolt(solar_bolt_length);
    

    // drain outer
    translate([0, 0, -0.01])
        color([1, 1, 1, 0.75])
            cylinder(base_height + pcb_height + battery_diameter + seal_height + 0.02, d=drain_od);
  }

  // drain inner (hole)
  translate([0, 0, -2])
      color([1, 1, 1, 0.75])
          cylinder(base_height + pcb_height + battery_diameter + seal_height + 5, d=drain_id);
}

function inch_to_mm(inch) = inch * 2.54 * 10;

module bolt(bolt_length) {
    color([0.8, 0.8, 0.8, 0.75]) {
        // bolt
        translate([0, 0, -bolt_head_height]) {
            cylinder(bolt_length, d=bolt_od);
            // bottom bolt head
            cylinder(bolt_head_height, d=bolt_head_dia, $fn=6);
            // top bolt head
            translate([0, 0, bolt_length])
                cylinder(bolt_head_height, d=bolt_head_dia, $fn=6);
    
        }
    }
}