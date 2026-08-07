/obj/item/ammo_casing
	name = "bullet casing"
	desc = ""
	icon_state = "s-casing"
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY

	var/bullet_stack_amount = 0                 //How many bullets you can stack of this caliber
	var/bullet_stack_icon_prefix                //Icon state prefix change
	var/bullet_stack_add_sound = 'sound/foley/coinphy (1).ogg'
	var/bullet_stack_remove_sound = 'sound/foley/coinphy (1).ogg'
	var/bullet_stack_spill_sound = 'sound/foley/coinphy (1).ogg'

	var/fire_sound = null						//What sound should play when this ammo is fired
	var/caliber = null							//Which kind of guns it can be loaded into
	var/projectile_type = null					//The bullet type to create when New() is called
	var/obj/projectile/BB = null 				//The loaded bullet
	var/pellets = 1								//Pellets for spreadshot
	var/variance = 0							//Variance for inaccuracy fundamental to the casing
	var/randomspread = 0						//Randomspread for automatics
	var/delay = 0								//Delay for energy weapons
	var/click_cooldown_override = 0				//Override this to make your gun have a faster fire rate, in tenths of a second. 4 is the default gun cooldown.
	var/firing_effect_type = null	//the visual effect appearing when the ammo is fired.
	var/heavy_metal = TRUE
	var/harmful = TRUE //pacifism check for boolet, set to FALSE if bullet is non-lethal
	var/charge_time_mult = 1 // Multiplier on weapon charge time. <1 = faster, >1 = slower.

/obj/item/ammo_casing/spent
	name = "spent bullet casing"
	BB = null

/obj/item/ammo_stack
	name = "ammunition stack"
	desc = "A small stack of ammunition rounds."
	w_class = WEIGHT_CLASS_TINY
	drop_sound = null
	pickup_sound = null

	var/amount = 2
	var/obj/item/ammo_casing/ammo_type

/obj/item/ammo_stack/proc/update_stack()
	var/max_amount = get_max_stack_amount()
	amount = clamp(amount, 2, max_amount)

	icon = initial(ammo_type.icon)
	icon_state = "[initial(ammo_type.bullet_stack_icon_prefix)]-[amount]"
	name = "[amount] [initial(ammo_type.name)]\s"

// get method for max_stack_amount
/obj/item/ammo_stack/proc/get_max_stack_amount()
	return initial(ammo_type.bullet_stack_amount)

// add one individual round to stack
/obj/item/ammo_stack/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/round = I

		// only accept exact ammo type that also arent casings
		if(round.type != ammo_type)
			return ..()

		if(!round.BB)
			to_chat(user, span_warning("This one is already spent."))
			return TRUE

		if(amount >= get_max_stack_amount())
			to_chat(user, span_warning("You cannot hold any more rounds in your hand."))
			return TRUE

		//// The round is being consumed, so clear it from the active hand.
		if(!user.temporarilyRemoveItemFromInventory(round))
			return TRUE

		qdel(round)
		amount++
		update_stack()

		playsound(
			src,
			initial(ammo_type.bullet_stack_add_sound),
			60,
			TRUE
		)
		return TRUE

	// combine another ammo stack with this one.
	if(istype(I, /obj/item/ammo_stack))
		var/obj/item/ammo_stack/other_stack = I

		// dont combine different calibers
		if(other_stack.ammo_type != ammo_type)
			return ..()

		var/available_space = get_max_stack_amount() - amount

		if(available_space <= 0)
			to_chat(user, span_warning("You cannot hold any more rounds!"))
			return TRUE

		var/transfer_amount = min(available_space, other_stack.amount) // how many bullets you can transfer from your other stack.
		var/remaining_amount = other_stack.amount - transfer_amount // other stacks new state.

		// If the other stack will disappear or become one round,
		// clear it from the active hand before deleting it.
		if(remaining_amount <= 1)
			if(!user.temporarilyRemoveItemFromInventory(other_stack))
				return TRUE

		amount += transfer_amount
		other_stack.amount = remaining_amount
		update_stack()

		if(other_stack.amount <= 0)
			qdel(other_stack)

		else if(other_stack.amount == 1) // if other stack remains becomes 1, erase stack, make singular
			var/obj/item/ammo_casing/remaining_round = new ammo_type(user)
			qdel(other_stack)

			if(!user.put_in_active_hand(remaining_round))
				remaining_round.forceMove(user.drop_location())

		else
			other_stack.update_stack()

		playsound(
			src,
			initial(ammo_type.bullet_stack_add_sound),
			60,
			TRUE
		)
		return TRUE

	return ..()

/obj/item/ammo_casing/Initialize()
	. = ..()
	if(projectile_type)
		BB = new projectile_type(src)
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)
	setDir(pick(GLOB.alldirs))
	update_icon()

/obj/item/ammo_casing/Destroy()
	. = ..()

	var/turf/T = get_turf(src)
	if(T && !BB && is_station_level(T.z))
		SSblackbox.record_feedback("tally", "station_mess_destroyed", 1, name)

/obj/item/ammo_casing/update_icon()
	..()
	icon_state = "[initial(icon_state)]"

//proc to magically refill a casing with a new projectile
/obj/item/ammo_casing/proc/newshot() //For energy weapons, syringe gun, shotgun shells and wands (!).
	if(!BB)
		BB = new projectile_type(src, src)

/obj/item/ammo_casing/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/other_round = I

		// values below disable stacking for this caliber
		if(bullet_stack_amount < 2)
			return ..()

		//only stack the same ammo subtype
		if(other_round.type != type)
			return ..()

		// both cartridges must be lives.
		if(!BB || !other_round.BB)
			return ..()

		var/obj/item/ammo_stack/new_stack = new(drop_location())
		new_stack.ammo_type = type
		new_stack.amount = 2
		new_stack.update_stack()

		// Remove the attacking round from the active hand before deleting it.
		if(!user.temporarilyRemoveItemFromInventory(other_round))
			qdel(new_stack)
			return TRUE

		qdel(other_round)
		qdel(src)

		// Put the newly created stack into the now-empty active hand.
		if(!user.put_in_active_hand(new_stack))
			new_stack.forceMove(user.drop_location())

		playsound(
			user,
			initial(new_stack.ammo_type.bullet_stack_add_sound),
			60,
			TRUE
		)
		return TRUE

	if(istype(I, /obj/item/ammo_box))
		var/obj/item/ammo_box/box = I
		if(isturf(loc))
			var/boolets = 0
			for(var/obj/item/ammo_casing/bullet in loc)
				if (box.stored_ammo.len >= box.max_ammo)
					break
				if (bullet.BB)
					if (box.give_round(bullet, 0))
						boolets++
				else
					continue
			if (boolets > 0)
				box.update_icon()
				to_chat(user, "<span class='notice'>I collect [boolets] shell\s. [box] now contains [box.stored_ammo.len] shell\s.</span>")
			else
				to_chat(user, "<span class='warning'>I fail to collect anything!</span>")
	else
		return ..()

/obj/item/ammo_casing/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	bounce_away(FALSE, NONE)
	. = ..()

/obj/item/ammo_casing/proc/bounce_away(still_warm = FALSE, bounce_delay = 3)
	if(!heavy_metal)
		return
	update_icon()
	SpinAnimation(10, 1)
	var/turf/T = get_turf(src)
	if(still_warm && T && T.bullet_sizzle)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), src, 'sound/blank.ogg', 20, 1), bounce_delay) //If the turf is made of water and the shell casing is still hot, make a sizzling sound when it's ejected.
	else if(T && T.bullet_bounce_sound)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), src, T.bullet_bounce_sound, 20, 1), bounce_delay) //Soft / non-solid turfs that shouldn't make a sound when a shell casing is ejected over them.
