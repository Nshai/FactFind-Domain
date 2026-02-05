SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION  [dbo].[FnCustomGetTermQuoteValue](@TermType VARCHAR(255), @TermValue INT,  @SummaryXML VARCHAR(1000)) 
RETURNS VARCHAR(330)  


AS
BEGIN

	DECLARE @termReturnValue VARCHAR(330)  
	DECLARE @tempTermValue VARCHAR(300)
	DECLARE @tempTermTypeValue VARCHAR(20)
	DECLARE @tempSummaryXML XML
	
	IF @SummaryXML IS NOT NULL
	SELECT @tempSummaryXML = TRY_CONVERT(XML, @SummaryXML)

	IF (@TermType IS NULL AND @TermValue IS NULL AND @tempSummaryXML IS NULL) RETURN @termReturnValue;
	
	IF @TermType IS NULL
		SELECT @TermType = @tempSummaryXML.value('(/QuoteSummary/term/@type)[1]', 'varchar(10)')
	
	SELECT @TermType = LOWER(@TermType)

	SELECT @tempTermValue = @tempSummaryXML.value('(/QuoteSummary/term)[1]', 'varchar(300)')
	
	SELECT @tempTermTypeValue = @tempSummaryXML.value('(/QuoteSummary/termType)[1]', 'varchar(20)')
	
	
	IF @TermType = 'age'
	RETURN(SELECT CONCAT('until age ', ISNULL(@TermValue, @tempTermValue)))

	IF @TermType = 'year'
	RETURN (SELECT CONCAT(@TermValue, ' years (period)'))

	IF @TermType = 'years'
	RETURN (SELECT  CONCAT(@tempTermValue, ' years ', NULLIF(@tempTermTypeValue, '')))

	IF @TermType IS NULL AND ISNUMERIC(@tempTermValue) = 1
	RETURN (SELECT CONCAT(@tempTermValue, ' years (' + NULLIF(@tempTermTypeValue, '') + ')'))
	
	RETURN (@tempTermValue)

END

GO


