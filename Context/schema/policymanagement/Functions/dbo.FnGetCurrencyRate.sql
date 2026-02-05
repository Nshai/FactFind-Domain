SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION dbo.FnGetCurrencyRate(
   @SourceCurrency VARCHAR(3) -- ISO currency to convert from
  ,@TargetCurrency VARCHAR(3) -- ISO currency to convert to
) RETURNS [decimal] (18, 10)

/*
	Assumptions:
		1) If either the @SourceCurrency or @TargetCurrency is null 
			then the function will return null
		2) If either the @SourceCurrency or @TargetCurrency is empty string (i.e.'') 
			then they will be treated as though they are the same as the base currency i.e. equal to 1.00
*/

BEGIN

Declare @BaseCurrency varchar(3)
Declare @SourceCurrencyRate DECIMAL (18, 10) = null
Declare @TargetCurrencyRate DECIMAL (18, 10) = null

Declare @DefaultBaseCurrencyRate DECIMAL(18, 10) = 1.0 -- default to 1

Declare @GBPCurrency char(3) = 'GBP'
Declare @GBXCurrency char(3) = 'GBX'
Declare @GBXToGBPRateMultiplier DECIMAL(18, 10) = 100.0

DECLARE @CrossRate DECIMAL(18,10)


--validate parameters
If @SourceCurrency is null
	Return Null

If @TargetCurrency is null
	Return Null


--trim source and target currency codes
Set @SourceCurrency = TRIM(@SourceCurrency)
Set @TargetCurrency = TRIM(@TargetCurrency)

--if @SourceCurrency is the same as @TargetCurrency
If @SourceCurrency = @TargetCurrency
	Return 1.0


--Get BaseCurrency
Select @BaseCurrency = administration.dbo.FnGetRegionalCurrency()

If @BaseCurrency is null
	Set @BaseCurrency = @GBPCurrency

--if @SourceCurrency is empty string assume its @BaseCurrency
If @SourceCurrency = ''
	Set @SourceCurrency = @BaseCurrency

--if @TargetCurrency is empty string assume its @BaseCurrency
If @TargetCurrency = ''
	Set @TargetCurrency = @BaseCurrency


--Set SourceCurrencyRate based on SourceCurrency in order - DefaultBaseCurrency, Lookup, GBX if not found
If @SourceCurrency = @BaseCurrency
	Set @SourceCurrencyRate = @DefaultBaseCurrencyRate
Else 
Begin
	Select @SourceCurrencyRate = Rate 
	From Administration..TCurrencyRate WITH(NOLOCK)
	Where IndigoClientId = 0 
	And CurrencyCode = @SourceCurrency
	
	If @SourceCurrencyRate is null and @SourceCurrency = @GBXCurrency
		Select @SourceCurrencyRate = Rate * @GBXToGBPRateMultiplier
		From Administration..TCurrencyRate WITH (NOLOCK)
		Where IndigoClientId = 0 
		And CurrencyCode = @GBPCurrency
	
	If @SourceCurrencyRate is null
		Return Null
End

--Set TargetCurrencyRate based on TargetCurrency in order - DefaultBaseCurrency, Lookup, GBX if not found
If @TargetCurrency = @BaseCurrency
	Set @TargetCurrencyRate = @DefaultBaseCurrencyRate
Else 
Begin
	Select @TargetCurrencyRate = Rate 
	From Administration..TCurrencyRate WITH(NOLOCK)
	Where IndigoClientId = 0 
	And CurrencyCode = @TargetCurrency

	If @TargetCurrencyRate is null and @TargetCurrency = @GBXCurrency
		Select @TargetCurrencyRate = Rate * @GBXToGBPRateMultiplier
		From Administration..TCurrencyRate WITH(NOLOCK)
		Where IndigoClientId = 0 
		And CurrencyCode = @GBPCurrency

	If @TargetCurrencyRate is null
		Return Null
End

--Calculate result
Set @CrossRate = @TargetCurrencyRate / @SourceCurrencyRate

Return @CrossRate

END
Go
