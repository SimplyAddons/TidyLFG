local E = select(2, ...):unpack()

-- all realms are sorted by popularity (based on wowprogress.com)
-- so that we can improve performance wherever possible.
-- this is because strfind() will return on the first match found.

-- oceanic realms
E.REALMS_OCE = {
	"Barthilas",
	"Frostmourne",
	"Jubei'Thos",
	"Nagrand",
	"Aman'Thul",
	"Caelestrasz",
	"Dath'Remar",
	"Dreadmaul",
	"Gundrak",
	"Khaz'goroth",
	"Saurfang",
	"Thaurissan",
}

-- brazilian regional realms
E.REALMS_BRAZIL = {
	"Azralon",
	"Nemesis",
	"Gallywix",
	"Goldrinn",
	"Tol Barad",
}

-- latin regional realms
E.REALMS_LATIN = {
	"Ragnaros",
	"Quel'Thalas",
	"Drakkari",
}

-- US regional realms
-- note: its easier to compare not, than to list all US realms
-- this list is for convenience, so we dont have to iterate
-- through multiple tables. it will also be faster.
E.REALMS_US = {
	"Barthilas",
	"Frostmourne",
	"Jubei'Thos",
	"Ragnaros",
	"Quel'Thalas",
	"Azralon",
	"Nagrand",
	"Aman'Thul",
	"Caelestrasz",
	"Dath'Remar",
	"Dreadmaul",
	"Gundrak",
	"Khaz'goroth",
	"Saurfang",
	"Thaurissan",
	"Nemesis",
	"Gallywix",
	"Goldrinn",
	"Tol Barad",
	"Drakkari",
}