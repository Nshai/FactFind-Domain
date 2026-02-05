SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION dbo.FnConvertCurrency(
    @Amount [decimal] (18, 4)  -- amount to convert
  , @SourceCurrency VARCHAR(3) -- ISO currency to convert from
  , @TargetCurrency VARCHAR(3) -- ISO currency to convert to
) RETURNS [decimal] (18, 4)

/*
	Assumptions:
		1) If either the @SourceCurrency or @TargetCurrency is null 
			then the function will return null
		2) If either the @SourceCurrency or @TargetCurrency is empty string (i.e.'') 
			then they will be treated as though they are the same as the base currency i.e. equal to 1.00
*/

BEGIN
	DECLARE @crossRate DECIMAL(18,10);

	--validate parameters
	IF @Amount IS NULL
		RETURN NULL

	IF @SourceCurrency IS NULL
		RETURN NULL

	If @TargetCurrency IS NULL
		RETURN NULL

	SELECT @crossRate = policymanagement.dbo.FnGetCurrencyRate(@SourceCurrency, @TargetCurrency)

	IF @crossRate IS NULL
		RETURN NULL

	RETURN ROUND(@amount * @crossRate, 4)

END
Go
