alter table gartneri.Gartner.maaler
	add Constraint C_MaalerType
		Check (MaalerType IN('Temperatur', 'Vand', 'Gødning', 'Lys'))