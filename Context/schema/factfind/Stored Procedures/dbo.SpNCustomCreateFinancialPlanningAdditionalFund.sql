SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateFinancialPlanningAdditionalFund]  
 @StampUser varchar (255),  
 @FundId bigint,   
 @FinancialPlanningId bigint,   
 @UnitQuantity bigint,   
 @UnitPrice money,  
 @FundDetails varchar(255)  = ''
AS  
  
  
DECLARE @FinancialPlanningAdditionalFundId bigint, @Result int  , @indigoclientid bigint
     
--Need to set the Fund details if they are null
if(@FundDetails = '') begin

select @indigoclientid = ff.IndigoClientId from TFinancialPlanning fp
						 inner join TFactfind ff on fp.FactFindId = ff.factfindid
						 where financialplanningid = @FinancialPlanningId

select  @FundDetails = cast(FundunitId as varchar(50)) + '~' +			
		cast(f.reffundtypeid as varchar(50)) + '~' +			
		'1~' + 
		'0~' + 
		cast(f.FundSectorId as varchar(50)) + '~' +
		FundSectorName + '~' +
		cast(@indigoclientid as varchar(50)) + '~' +
		cast(f.FundSectorId as varchar(50)) + '~' +		
		FundSectorName
from fund2..TFundUnit fu
inner join fund2..TFund f on f.fundid = fu.fundid
inner join fund2..TFundSector s on s.FundSectorId = f.FundSectorId
where	fundunitid = @FundId

end

   
INSERT INTO TFinancialPlanningAdditionalFund  
(FundId, FinancialPlanningId, UnitQuantity, UnitPrice, FundDetails, ConcurrencyId)  
VALUES(@FundId, @FinancialPlanningId, @UnitQuantity, @UnitPrice,@FundDetails, 1)  
  
SELECT @FinancialPlanningAdditionalFundId = SCOPE_IDENTITY(), @Result = @@ERROR  
IF @Result != 0 GOTO errh  
  
  
Execute @Result = dbo.SpNAuditFinancialPlanningAdditionalFund @StampUser, @FinancialPlanningAdditionalFundId, 'C'  
  
IF @Result  != 0 GOTO errh  
  
Execute dbo.SpNRetrieveFinancialPlanningAdditionalFundByFinancialPlanningAdditionalFundId @FinancialPlanningAdditionalFundId  
  
IF @@ERROR != 0 GOTO errh  
  
RETURN (0)  
  
errh:  
RETURN (100)
GO
