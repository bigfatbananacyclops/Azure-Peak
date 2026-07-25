/// A minimal, single-seat land vehicle built on the same riding component used by mounts.
/// The dinghy icon is temporary until the runabout receives dedicated directional sprites.
/obj/vehicle/ridden/scrap_runabout
	name = "reclaimed corporate runabout"
	desc = "An obsolete corporate utility chassis rebuilt with mismatched scrap panels, exposed cabling, and a questionably secured drive unit. Despite appearances, the controls still respond."
	icon = 'icons/obj/boat.dmi'
	icon_state = "dinghy"
	color = "#8f7860"
	max_integrity = 250
	movedelay = 3
	legs_required = 0
	arms_required = 1
	fall_off_if_missing_arms = FALSE

/obj/vehicle/ridden/scrap_runabout/Initialize(mapload)
	. = ..()
	var/datum/component/riding/riding_component = LoadComponent(/datum/component/riding)
	riding_component.vehicle_move_delay = movedelay
	riding_component.drive_verb = "drive"
	riding_component.ride_check_rider_incapacitated = TRUE
	riding_component.ride_check_rider_restrained = TRUE
	riding_component.forbid_turf_typecache = typecacheof(/turf/open/water/ocean/deep)
	riding_component.set_riding_offsets(RIDING_OFFSET_ALL, list(
		TEXT_NORTH = list(0, 3),
		TEXT_SOUTH = list(0, 3),
		TEXT_EAST = list(0, 3),
		TEXT_WEST = list(0, 3),
	))
