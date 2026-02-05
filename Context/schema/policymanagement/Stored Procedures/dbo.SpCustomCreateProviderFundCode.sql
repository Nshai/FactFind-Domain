SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomCreateProviderFundCode]
@RefProdProviderId bigint,
@ProviderFundCode varchar(50), 
@FundCode varchar(50), 
@FundCodeType varchar(50)

AS

DECLARE @FundId bigint
DECLARE @FundTypeId bigint
DECLARE @MappedRefProdProviderId bigint


IF @FundCodeType NOT IN ('sedol', 'mex', 'isin', 'citi')
BEGIN
	print 'Invalid fund code type (''' + @FundCodeType + '''). Must be ''sedol'', ''mex'', ''isin'' or ''citi'''
	return
END


SET @MappedRefProdProviderId = (
	SELECT MappedRefProdProviderId
	FROM TValLookup 
	WHERE RefProdProviderId = @RefProdProviderId 
	)

IF @MappedRefProdProviderId IS NOT NULL
	set @RefProdProviderId = @MappedRefProdProviderId

-- look up the fund details
SELECT @FundId = fu.FundUnitId, @FundTypeId = f.RefFundTypeId
FROM Fund2..TFund f
JOIN Fund2..TFundUnit fu On fu.FundId = f.FundId
WHERE
( 
	(@FundCodeType = 'sedol' AND fu.SedolCode = @FundCode)
	OR
	(@FundCodeType = 'mex' AND fu.MexCode = @FundCode)
	OR
	(@FundCodeType = 'isin' AND fu.ISINCode = @FundCode)
	OR
	(@FundCodeType = 'citi' AND fu.CitiCode = @FundCode)
)

IF @FundId IS NULL
BEGIN
	print 'Cannot find fund with ' + @FundCodeType + ' code ''' + @FundCode + ''', cannot continue. But thanks for trying.'
	return
END



IF NOT EXISTS (
	SELECT 1 
	FROM PolicyManagement..TProviderFundCode 
	WHERE RefProdProviderId = @RefProdProviderId
	AND FundId = @FundId
	)
BEGIN
	INSERT INTO TProviderFundCode (RefProdProviderId, ProviderFundCode, FundId, FundTypeId, ConcurrencyId)
	VALUES (@RefProdProviderId, @ProviderFundCode, @FundId, @FundTypeId, 1)

	INSERT INTO TProviderFundCodeAudit (RefProdProviderId, ProviderFundCode, FundId, FundTypeId, ConcurrencyId, ProviderFundCodeId, StampAction, StampDateTime, StampUser)
	SELECT RefProdProviderId, ProviderFundCode, FundId, FundTypeId, ConcurrencyId, ProviderFundCodeId, 'U', getdate(), '0'
	FROM PolicyManagement..TProviderFundCode 
	WHERE RefProdProviderId = @RefProdProviderId
	AND FundId = @FundId
END

ELSE

BEGIN
	INSERT INTO TProviderFundCodeAudit (RefProdProviderId, ProviderFundCode, FundId, FundTypeId, ConcurrencyId, ProviderFundCodeId, StampAction, StampDateTime, StampUser)
	SELECT RefProdProviderId, ProviderFundCode, FundId, FundTypeId, ConcurrencyId, ProviderFundCodeId, 'U', getdate(), '0'
	FROM PolicyManagement..TProviderFundCode 
	WHERE RefProdProviderId = @RefProdProviderId
	AND FundId = @FundId

	UPDATE TProviderFundCode
	SET ProviderFundCode = @ProviderFundCode,
	ConcurrencyId = ConcurrencyId + 1
	WHERE RefProdProviderId = @RefProdProviderId
	AND FundId = @FundId 
END
GO
