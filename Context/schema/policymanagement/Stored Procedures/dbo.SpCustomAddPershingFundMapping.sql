SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomAddPershingFundMapping]
@sedolFundCode varchar(10),
@fundName varchar(255)
AS  
  
BEGIN  
 
set nocount on

if exists (select 1 from TValBulkPershingFund  where SedolCode = @sedolFundCode)
begin
	select 'Fund mapping already exists!'
end
else
begin
	insert into TValBulkPershingFund(SedolCode, FundName) 
		output inserted.ValBulkPershingFundId, inserted.SedolCode, inserted.FundName, getdate(), '0', 'c'
		into TValBulkPershingFundAudit (ValBulkPershingFundId, SedolCode, FundName, stampdatetime, stampuser, stampaction )
	values (@sedolFundCode, @fundName)
		select 'Fund mapping added'
end

set nocount off

end

GO

