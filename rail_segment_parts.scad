include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>


module rail_segment()
{
	fillet = 1;
	side_joiner_len = 2;

	color([0.9, 0.7, 1.0])
	prerender(convexity=20)
	union() {
		difference() {
			union() {
				// Bottom.
				up(rail_thick/2) yrot(90)
					sparse_strut(h=rail_width, l=rail_length, thick=rail_thick, maxang=45, strut=10, max_bridge=500);

				// Walls.
				zrot_copies([0, 180]) {
					up((rail_height+3)/2) {
						right((rail_spacing+joiner_width)/2) {
							if (wall_style == "crossbeams")
								sparse_strut(h=rail_height+3, l=rail_length-10, thick=joiner_width, strut=5);
							if (wall_style == "thinwall")
								thinning_wall(h=rail_height+3, l=rail_length-10, thick=joiner_width, strut=5, bracing=false);
							if (wall_style == "corrugated")
								corrugated_wall(h=rail_height+3, l=rail_length-10, thick=joiner_width, strut=5);
						}
					}
				}

				// Rail backing.
				xspread(rail_spacing+joiner_width)
					up(rail_height+groove_height/2-fillet)
						rcube(size=[joiner_width, rail_length, groove_height+fillet], r=fillet, center=true, $fn=12);

				// Side Supports
				up(rail_height/4) {
					yspread(rail_length-2*5-5) {
						difference() {
							cube(size=[rail_width-joiner_width, 4, rail_height/2], center=true);
							xspread(rail_width/3, n=3) {
								cube(size=[16, 11, 12], center=true);
							}
						}
					}
				}
			}

			// Rail grooves.
			up(rail_height+groove_height/2) {
				xflip_copy() {
					left((rail_width-joiner_width)/2) {
						xflip_copy() {
							right(joiner_width/2) {
								// main groove
								scale([tan(groove_angle),1,1]) yrot(45) {
									cube(size=[groove_height*sqrt(2)/2,rail_length+1,groove_height*sqrt(2)/2], center=true);
								}

								// fillets
								facelen = groove_height/2/sin(90-groove_angle);
								yflip_copy() {
									fwd(rail_length/2) {
										left(facelen*sin(groove_angle)) {
											difference() {
												zflip_copy() {
													left(fillet) {
														yrot(-groove_angle) {
															right(fillet) {
																down(facelen*1.5/2) {
																	cube([fillet*2, fillet*2, facelen*1.5], center=true);
																}
															}
														}
													}
												}
												zflip_copy() {
													left(fillet) {
														yrot(-groove_angle) {
															right(fillet) {
																down(facelen) {
																	back(fillet) left(fillet) {
																		cylinder(r=fillet, h=facelen*3, center=true, $fn=12);
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}

			// Clear space for joiners.
			up(rail_height/2) {
				joiner_quad_clear(xspacing=rail_spacing+joiner_width, yspacing=rail_length-0.05, h=rail_height, w=joiner_width, clearance=5, a=joiner_angle);
			}


			// Side half joiners
			up(rail_height/2/2) {
				back(rail_length/2-10) {
					zring(r=rail_spacing/2+joiner_width+side_joiner_len-0.05, n=2) {
						zrot(-90) {
							chamfer(chamfer=3, size=[joiner_width, 2*(side_joiner_len+joiner_width/2), rail_height/2], edges=[[0,0,0,0], [1,1,0,0], [0,0,0,0]]) {
								half_joiner_clear(h=rail_height/2, w=joiner_width, a=joiner_angle);
							}
						}
					}
				}
			}

			// Shrinkage stress relief
			up(rail_thick/2) {
				yspread(17.5, n=7) {
					cube(size=[rail_width+1, 1, rail_thick-2], center=true);
				}
				xspread(22, n=5) {
					yspread(rail_length-10) {
						cube(size=[1, 17.5*2, rail_thick-2], center=true);
					}
				}
			}
		}

		// Side half joiners
		up(rail_height/2/2) {
			back(rail_length/2-10) {
				zring(r=rail_spacing/2+joiner_width+side_joiner_len, n=2) {
					zrot(-90) {
						chamfer(chamfer=3, size=[joiner_width, 2*(side_joiner_len+joiner_width/2), rail_height/2], edges=[[0,0,0,0], [1,1,0,0], [0,0,0,0]]) {
							half_joiner2(h=rail_height/2, w=joiner_width, l=side_joiner_len+joiner_width/2, a=joiner_angle);
						}
					}
				}
			}
		}

		// Snap-tab joiners.
		up(rail_height/2) {
			joiner_quad(xspacing=rail_spacing+joiner_width, yspacing=rail_length, h=rail_height, w=joiner_width, l=6, a=joiner_angle);
		}
	}
}
//!rail_segment();



module rail_segment_parts() { // make me
	rail_segment();
}



rail_segment_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

