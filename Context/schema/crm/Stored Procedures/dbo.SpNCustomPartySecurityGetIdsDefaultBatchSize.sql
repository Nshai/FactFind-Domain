Create Procedure SpNCustomPartySecurityGetIdsDefaultBatchSize
	@DeleteBatchSize int output
As

Select @DeleteBatchSize = 100000

Return 0


