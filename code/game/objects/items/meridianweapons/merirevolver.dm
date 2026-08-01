/*
first revolver


 */


/obj/projectile/bullet/c44kron
	name = ".44 Kron caliber round"
	damage = 40
	armor_penetration = 10
	speed = 0.7
/obj/item/ammo_casing/c44kron
	name = ".44 Kron casing"
	desc = "A compact metallic cartridge made for a Meridian revolver."
	icon = 'icons/meridian/ammo/ammo.dmi'
	icon_state = "44kron-1"
	caliber = ".44 Kron"
	projectile_type = /obj/projectile/bullet/c44kron
	click_cooldown_override = 5

/obj/item/ammo_casing/c44kron/update_icon()
    . = ..()
    icon_state = BB ? "44kron-1" : "44kron-0"

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
	fire_sound = 'sound/meridian/gunshot/asakura-werke.ogg'
	eject_sound = 'sound/blank.ogg'
	dry_fire_sound = 'sound/blank.ogg'
	load_sound = list(
		'sound/meridian/gunsounds/revload1.ogg',
		'sound/meridian/gunsounds/revload2.ogg',
		'sound/meridian/gunsounds/revload3.ogg',
		'sound/meridian/gunsounds/revload4.ogg',
		'sound/meridian/gunsounds/revload5.ogg'
	)

	mag_type = /obj/item/ammo_box/magazine/internal/c44kron
	cartridge_wording = "cartridge"
