SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnCustomGetExpenditureCategory](@Name varchar(255))
RETURNS varchar(255)
BEGIN
	RETURN
		CASE 
			WHEN @Name = 'Mortgage' OR @Name = 'Rent' THEN 'Mortgage'
			WHEN 
				@Name = 'Council Tax' OR @Name = 'Gas' OR @Name = 'Electricity' OR @Name = 'Water' OR 
				@Name = 'Telephone' OR @Name = 'TV/Satellite/Internet' OR @Name = 'Ground Rent' OR 
				@Name = 'Service Charge' OR @Name = 'Mobile Phone' THEN 'Utilities'
			WHEN @Name = 'Personal Loans' OR @Name = 'Secured Personal Loans' THEN 'Loans'
			WHEN @Name = 'Credit/Store Cards' THEN 'Credit Cards'
			WHEN 
				@Name = 'Food and Living Expenses' OR @Name = 'Life Assurance/Pension Plans' OR 
				@Name = 'Car/Travelling Expenses/Season Tickets' OR @Name = 'School Fees' OR 
				@Name = 'Court Ordered Maintenance Payments' OR @Name = 'Voluntary Maintenance Payments' OR 
				@Name = 'Savings' THEN 'Regular Outgoing'
			WHEN 
				@Name = 'Holidays' OR @Name = 'Other Expenditure (inc. Household Goods)' OR @Name = 'Clothes' OR 
				@Name = 'Gym/Club Membership' OR @Name = 'Entertainment' OR @Name = 'Alcohol/Tobacco' THEN 'Non Essential'			
			WHEN
				@Name = 'Monthly Debt Payments To Be Consolidated' OR @Name = 'General Insurance Premiums' THEN 'Consolidated Income'
		END
END
GO
