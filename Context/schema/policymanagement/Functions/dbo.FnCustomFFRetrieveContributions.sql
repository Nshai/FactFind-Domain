SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE  FUNCTION  dbo.FnCustomFFRetrieveContributions(@PolicyBusinessId bigint)
RETURNS varchar(1000)
AS
BEGIN

	Declare @Contributions varChar(8000), @LumpSum money, @RegularPremium money

	SELECT 
		@LumpSum = ISNULL(TotalLumpSum, 0), 
		@RegularPremium = ISNULL(TotalRegularPremium, 0)
	FROM
		PolicyManagement..TPolicyBusiness
	WHERE PolicyBusinessId = @PolicyBusinessId

	IF @LumpSum != 0 
		SELECT @Contributions = CONVERT(VARCHAR(25), @LumpSum) + ' Lump Sum'
	
	IF @RegularPremium != 0 
		SELECT @Contributions = ISNULL((@Contributions + ' | '), '') + CONVERT(VARCHAR(25), @RegularPremium) + ' Regular Premium'

	Select @Contributions = IsNull((@Contributions + ' | '), '')  + Convert(varchar(25), Amount) + ' ' + LTrim(RTrim(FrequencyName))
	From PolicyManagement..TPolicyMoneyIn A
	Inner Join PolicyManagement..TRefFrequency B
		On A.RefFrequencyId = B.RefFrequencyId
	Where PolicyBusinessId = @PolicyBusinessId
	
	--There is carriage returns in the TRefFrequency.FrequencyName field
	Set @Contributions = Replace(@Contributions, char(10), '')
	Set @Contributions = Replace(@Contributions, char(13), '')
	
	RETURN (@Contributions)
END
GO
