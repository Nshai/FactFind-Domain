Create Procedure SpNCustomPartySecurityGetIdsDefaults
	@DefaultRightMask tinyint output
As

Select @DefaultRightMask = 3

Return 0




