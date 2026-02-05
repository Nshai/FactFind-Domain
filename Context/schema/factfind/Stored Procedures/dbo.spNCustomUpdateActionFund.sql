SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomUpdateActionFund]    
    
@ActionFundId bigint,    
@PercentageAllocation decimal(18,9),    
@RegularContributionPercentage decimal(18,2),
@StampUser varchar(50)    
    
as    
    
exec spNAuditActionFund @StampUser, @ActionFundId, 'U'    
    
update TActionFund    
set  PercentageAllocation = @PercentageAllocation    ,
RegularContributionPercentage = @RegularContributionPercentage
where actionfundid = @actionfundId
GO
