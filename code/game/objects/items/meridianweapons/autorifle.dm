/*
 * Meridian firearms
 *
 * This uses the codebase's native gun autoclick support. While the left mouse
 * button is held, /client/MouseDown repeatedly clicks at `automatic` deciseconds.
 */

/obj/projectile/bullet/c68x43mm
	name = "6.8×43mm HC caliber round"
	damage = 30
	armor_penetration = 10
	speed = 0.7

/obj/item/ammo_casing/c68x43mm
	name = "6.8×43mm HC casing"
	desc = "A compact metallic cartridge made for a Meridian automatic rifle."
	caliber = "6.8x43mm HC"
	projectile_type = /obj/projectile/bullet/c68x43mm
	click_cooldown_override = 2

/obj/item/ammo_box/magazine/asakura
	name = "Asakura HX-77A rifle magazine"
	desc = "A detachable twenty-round box magazine."
	ammo_type = /obj/item/ammo_casing/c68x43mm
	caliber = "6.8x43mm HC"
	max_ammo = 20
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/gun/ballistic/automatic/meridian
	name = "Asakura HX-77A"
	desc = "A compact, magazine-fed automatic rifle of Asakura manufacture."
	icon_state = "arg"
	item_state = "arg"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	force = 15

	// Holding left click repeats the shot every two deciseconds.
	automatic = 2
	spread = 4
	randomspread = TRUE

	mag_type = /obj/item/ammo_box/magazine/asakura
	magazine_wording = "box magazine"
	cartridge_wording = "cartridge"
	bolt_type = BOLT_TYPE_LOCKING
	semi_auto = TRUE
	mag_display = FALSE
	empty_indicator = FALSE

	fire_sound = 'sound/blank.ogg'
	dry_fire_sound = 'sound/blank.ogg'
	load_sound = 'sound/blank.ogg'
	load_empty_sound = 'sound/blank.ogg'
	eject_sound = 'sound/blank.ogg'
	eject_empty_sound = 'sound/blank.ogg'
	rack_sound = 'sound/blank.ogg'
	lock_back_sound = 'sound/blank.ogg'
	bolt_drop_sound = 'sound/blank.ogg'

/obj/item/gun/ballistic/automatic/meridian/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Hold left click while using a ranged intent to fire automatically.")
