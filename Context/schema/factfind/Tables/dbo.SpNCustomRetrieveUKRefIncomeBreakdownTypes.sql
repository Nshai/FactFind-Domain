SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomRetrieveUKRefIncomeBreakdownTypes]
AS
BEGIN

	DECLARE @FactFindRemoveLookupIncomeTypePreference VARCHAR(10) = 'false';
	DECLARE @FactFindRemoveLookupIncomeTypes TABLE(TypeName VARCHAR(500))
 
	INSERT INTO @FactFindRemoveLookupIncomeTypes
	VALUES 
	  ('Court Order Maintenance')
	, ('Bedroom Rental')
	, ('Allowance')
	, ('London/Large Town Allowance')
	, ('Mortgage Subsidy')
	, ('Benefits')
	, ('Paternal Pay')
	, ('Sick Pay')

	SELECT @FactFindRemoveLookupIncomeTypePreference = ISNULL(LOWER(Value), 'false')
	FROM administration..TIndigoClientPreference 
	WHERE PreferenceName = 'FactFindRemoveLookupIncomeType'
	
	SELECT 
		1 AS TAG,
		NULL AS Parent,
		RD.Name AS [IncomeType!1!Name]
	FROM 
		factfind..TRefData RD
		LEFT JOIN @FactFindRemoveLookupIncomeTypes RLIT ON RLIT.TypeName = RD.Name
	WHERE 
		RD.Type = 'income' AND RD.Property = 'category' AND RD.RegionCode = 'GB' AND RD.Attributes LIKE '%Person%' AND
		(@FactFindRemoveLookupIncomeTypePreference != 'true' OR (@FactFindRemoveLookupIncomeTypePreference = 'true' and RLIT.TypeName IS NULL))
	ORDER BY 
		CAST(JSON_VALUE(REPLACE(Attributes, '\', ''),'$.ordinal') AS INT) 
	FOR XML EXPLICIT
END
GO