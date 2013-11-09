/mob/living/carbon/alien/humanoid/empress/large
	name = "alien empress"
	caste = "e"
	maxHealth = 700
	health = 700
	icon_state = "empress_s"
	status_flags = CANPARALYSE
	heal_rate = 5
	plasma_rate = 20
	icon = 'icons/mob/alienhuge.dmi'
	icon_state = "empress_s"
	pixel_x = -32
	move_delay_add = 3

/mob/living/carbon/alien/humanoid/empress/large/update_icons()
	lying_prev = lying	//so we don't update overlays for lying/standing unless our stance changes again
	update_hud()		//TODO: remove the need for this to be here
	overlays.Cut()
	if(lying)
		if(resting)					icon_state = "empress_sleep"
		else						icon_state = "empress_l"
		for(var/image/I in overlays_lying)
			overlays += I
	else
		icon_state = "empress_s"
		for(var/image/I in overlays_standing)
			overlays += I


/mob/living/carbon/alien/humanoid/empress/New()
	var/datum/reagents/R = new/datum/reagents(100)
	reagents = R
	R.my_atom = src

	//there should only be one queen
	for(var/mob/living/carbon/alien/humanoid/empress/E in living_mob_list)
		if(E == src)		continue
		if(E.stat == DEAD)	continue
		if(E.client)
			name = "alien grand princess ([rand(1, 999)])"	//if this is too cutesy feel free to change it/remove it.
			break

	real_name = src.name
	verbs.Add(/mob/living/carbon/alien/humanoid/proc/corrosive_acid,/mob/living/carbon/alien/humanoid/proc/neurotoxin,/mob/living/carbon/alien/humanoid/proc/resin)
	verbs -= /mob/living/carbon/alien/verb/alien_ventcrawl
	..()

/mob/living/carbon/alien/humanoid/empress

	handle_regular_hud_updates()

		..() //-Yvarov

		if (src.healths)
			if (src.stat != 2)
				switch(health)
					if(250 to INFINITY)
						src.healths.icon_state = "health0"
					if(175 to 250)
						src.healths.icon_state = "health1"
					if(100 to 175)
						src.healths.icon_state = "health2"
					if(50 to 100)
						src.healths.icon_state = "health3"
					if(0 to 50)
						src.healths.icon_state = "health4"
					else
						src.healths.icon_state = "health5"
			else
				src.healths.icon_state = "health6"

/mob/living/carbon/alien/humanoid/empress/verb/lay_egg()

	set name = "Lay Egg (75)"
	set desc = "Lay an egg to produce huggers to impregnate prey with."
	set category = "Alien"

	if(locate(/obj/effect/alien/egg) in get_turf(src))
		src << "There's already an egg here."
		return

	if(powerc(75,1))//Can't plant eggs on spess tiles. That's silly.
		adjustToxLoss(-75)
		for(var/mob/O in viewers(src, null))
			O.show_message(text("\green <B>[src] has laid an egg!</B>"), 1)
		new /obj/effect/alien/egg(loc)
	return