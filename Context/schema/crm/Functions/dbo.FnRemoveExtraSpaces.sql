SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Description: This function returns matched address from TAddressStore
-- =============================================
CREATE FUNCTION [dbo].[FnRemoveExtraSpaces]
(
	@Input varchar(1000)
)  
RETURNS varchar(1000)
AS  
BEGIN
	DECLARE @Output varchar(1000)			
	DECLARE @charComb varchar(2) = char(16) + char(17), @charCombBack varchar(2) = char(17) + char(16)
	SET @Output = RTRIM(LTRIM(replace(replace(replace(@Input,' ',@charComb),@charCombBack,''),@charComb,' ')))
	RETURN @output
END
GO