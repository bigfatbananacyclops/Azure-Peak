/obj/item/gun/ballistic/revolver
	name = "\improper .357 revolver"
	desc = "" //usually used by syndicates
	icon_state = "revolver"
	load_sound = 'sound/blank.ogg'
	fire_sound = 'sound/blank.ogg'
	eject_sound = 'sound/blank.ogg'
	vary_fire_sound = TRUE
	fire_sound_volume = 90
	dry_fire_sound = 'sound/blank.ogg'
	casing_ejector = FALSE
	internal_magazine = TRUE
	bolt_type = BOLT_TYPE_NO_BOLT
	tac_reloads = FALSE
	var/spin_delay = 10
	var/recent_spin = 0
	var/has_openable_cylinder = FALSE
	var/cylinder_open = FALSE
	var/cylinder_open_sound = 'sound/blank.ogg'
	var/cylinder_close_sound = 'sound/blank.ogg'
	var/cylinder_spin_sound = 'sound/blank.ogg'
	var/cylinder_sound_volume = 50




/obj/item/gun/ballistic/revolver/chamber_round(spin_cylinder = TRUE)
	if(spin_cylinder)
		chambered = magazine.get_round(TRUE)
	else
		chambered = magazine.stored_ammo[1]

/obj/item/gun/ballistic/revolver/shoot_with_empty_chamber(mob/living/user as mob|obj)
	..()
	chamber_round(TRUE)

/obj/item/gun/ballistic/revolver/get_ammo(countchambered = FALSE, countempties = TRUE)
	var/boolets = 0 //mature var names for mature people
	if (chambered && countchambered)
		boolets++
	if (magazine)
		boolets += magazine.ammo_count(countempties)
	return boolets

// opening cylinder
/obj/item/gun/ballistic/revolver/attack_self(mob/living/user)
	if(!has_openable_cylinder) // Revolvers without this mechanic keep their original behavior.
		return ..()

	cylinder_open = !cylinder_open	// Toggle between open and closed.

	if(cylinder_open)
		to_chat(user, span_notice("I open [src]'s cylinder."))
		playsound(src, cylinder_open_sound, cylinder_sound_volume, TRUE)
	else
		to_chat(user, span_notice("I close [src]'s cylinder."))
		playsound(src, cylinder_close_sound, cylinder_sound_volume, TRUE)

	update_icon()
	return TRUE

/obj/item/gun/ballistic/revolver/attackby(obj/item/A, mob/user, params)
	// Block ammunition from being inserted while the cylinder is closed.
	if(has_openable_cylinder && !cylinder_open)
		if(istype(A, /obj/item/ammo_casing) || istype(A, /obj/item/ammo_box))
			to_chat(user, span_warning("Fool. I must open [src]'s cylinder before loading it!"))
			return TRUE


	return ..()

/obj/item/gun/ballistic/revolver/can_shoot()
	// An open cylinder cannot fire.
	if(has_openable_cylinder && cylinder_open)
		return FALSE


	return ..()

/obj/item/gun/ballistic/revolver/proc/spin_cylinder() //randomizes bullet order
	if(!magazine || !magazine.stored_ammo.len)
		chambered = null
		return

	var/rotations = rand(1, magazine.stored_ammo.len)

	for(var/i in 1 to rotations)
		chamber_round(TRUE)

/obj/item/gun/ballistic/revolver/proc/unload_cylinder(mob/user)
	chambered = null
	var/num_unloaded = 0
	for(var/obj/item/ammo_casing/CB in get_ammo_list(FALSE, TRUE))
		CB.forceMove(drop_location())
		CB.bounce_away(FALSE, NONE)
		num_unloaded++
		var/turf/T = get_turf(drop_location())
		if(T && is_station_level(T.z))
			SSblackbox.record_feedback("tally", "station_mess_created", 1, CB.name)
	if(num_unloaded)
		to_chat(user, span_notice("I remove [(num_unloaded == 1) ? "the" : "[num_unloaded]"] [cartridge_wording]\s from [src]."))
		playsound(user, eject_sound, eject_sound_volume, eject_sound_vary)
		update_icon()
	else
		to_chat(user, span_warning("[src] is empty!"))

// Right-click spins a closed cylinder and unloads an open cylinder.
/obj/item/gun/ballistic/revolver/attack_right(mob/user)
	if(!has_openable_cylinder)
		return ..()

	if(!user.is_holding(src))
		return TRUE

	if(cylinder_open)
		unload_cylinder(user)
		return TRUE

	if(recent_spin > world.time)
		return TRUE

	recent_spin = world.time + spin_delay
	spin_cylinder()

	user.visible_message(
		span_notice("[user] spins the [src]'s cylinder."),
		span_notice("I spin the [src]'s cylinder.")
	)
	playsound(src, cylinder_spin_sound, cylinder_sound_volume, TRUE)
	return TRUE

