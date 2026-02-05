SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnCustomRetrievePolicyBusinessFundWithAttributes]   
(@PolicyBusinessId bigint, @FundId bigint, @FromFeedFg bit, @EquityFg bit, @FundAttributes varchar(255))  

RETURNS bigint  
AS  

BEGIN  
  
 declare @AttributesList table (PolicyBusinessFundId bigint, RefFundAttributeId bigint, AttributeName varchar(255), HasAttribute bit)  
 declare @PolicyBusinessFundId bigint  
   
 if (IsNull(@FundAttributes,'') = '')  
  set @FundAttributes = ''  

 if exists(select 1 from TPolicyBusinessFund with (nolock) where PolicyBusinessId = @PolicyBusinessId and FundId = @FundId and FromFeedFg = @FromFeedFg and EquityFg = @EquityFg)
 begin  
  --Ok so the fund exists now check if it has the macthing attributes  
    
  --check for passed in atts being null - no atts but the fund exists - so return true  
  if (@FundAttributes = '')  
  begin  
   Select @PolicyBusinessFundId = PolicyBusinessFundId   
   From TPolicyBusinessFund tpbf with(nolock) 
   Where PolicyBusinessId = @PolicyBusinessId  
   and FundId = @FundId and FromFeedFg = @FromFeedFg and EquityFg = @EquityFg  
     
   RETURN @PolicyBusinessFundId  
  end  

End

return 0
	 
END
GO
