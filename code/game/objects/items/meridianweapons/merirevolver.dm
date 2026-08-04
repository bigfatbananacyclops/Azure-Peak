/*
first revolver


 */


/obj/projectile/bullet/c44kron
	name = ".44 Kron caliber round"
	damage = 40
	armor_penetration = 10
	speed = 0.7
/obj/item/ammo_casing/c44kron
	name = ".44 Kron round"
	desc = "A compact metallic cartridge made for an Asakura revolver."
	icon = 'icons/meridian/ammo/ammo.dmi'
	icon_state = "44kron-1"
	caliber = ".44 Kron"
	projectile_type = /obj/projectile/bullet/c44kron
	click_cooldown_override = 5

/obj/item/ammo_casing/c44kron/update_icon()
	.=..()
	if(BB)
		name = ".44 Kron round"
		desc = "A compact metallic cartridge made for an Asakura revolver."
		icon_state = "44kron-1"
	else
		name = "spent .44 Kron casing"
		desc = "An empty metallic casing from a fired .44 Kron round."
		icon_state = "44kron-0"


/obj/item/ammo_box/magazine/internal/c44kron
	ammo_type = /obj/item/ammo_casing/c44kron
	caliber = ".44 Kron"
	max_ammo = 6

/obj/item/gun/ballistic/revolver/asakura
	name = "X12 Asakura-Werke Series E"
	desc = "A compact revolver with electronics manufactured by Asakura-Werke."
	icon = 'icons/meridian/weapons/sidearms.dmi'
	icon_state = "asakura-werke"
	//item_state = "arg"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACKPACK | ITEM_SLOT_HIP
	force = 10
	recoil = 1
	fire_sound = 'sound/meridian/gunshot/asakurashot.ogg'
	fire_sound_volume = 100
	eject_sound = 'sound/meridian/gunsounds/rev_eject_sound.ogg'
	dry_fire_sound = 'sound/meridian/gunsounds/rev_dryfire.ogg'
	cylinder_open_sound = 'sound/meridian/gunsounds/revopen.ogg'
	cylinder_close_sound = 'sound/meridian/gunsounds/revclose.ogg'
	cylinder_spin_sound = 'sound/meridian/gunsounds/revspin.ogg'
	load_sound = list(
		'sound/meridian/gunsounds/revload1.ogg',
		'sound/meridian/gunsounds/revload2.ogg',
		'sound/meridian/gunsounds/revload3.ogg',
		'sound/meridian/gunsounds/revload4.ogg',
		'sound/meridian/gunsounds/revload5.ogg'
	)

	mag_type = /obj/item/ammo_box/magazine/internal/c44kron
	cartridge_wording = "cartridge"
	has_openable_cylinder = TRUE

/obj/item/gun/ballistic/revolver/asakura/update_icon()
	. = ..()
	icon_state = cylinder_open ? "asakura-werke-open" : "asakura-werke"
