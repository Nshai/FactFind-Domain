SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnCustomDoesPolicyBusinessFundWithAttributesExists] 
(@PolicyBusinessId bigint, @FundId bigint, @FromFeedFg bit, @EquityFg bit, @FundAttributes varchar(255))
      
      
RETURNS bit
AS

BEGIN


      declare @AttributesList table (RefFundAttributeId bigint, AttributeName varchar(255), DoesExists bit)

      if exists(select 1 from TPolicyBusinessFund where PolicyBusinessId = @PolicyBusinessId and FundId = @FundId and FromFeedFg = @FromFeedFg and EquityFg = @EquityFg)
      begin
            --Ok so the fund exists now check if it has the macthing attributes
      
            --check for passed in atts being null - no atts but the fund exists - so return true
            if (@FundAttributes is null)
                  RETURN 1
            
            --store passed in atts
            insert into @AttributesList (RefFundAttributeId, AttributeName, DoesExists)
            select distinct RefFundAttributeId, AttributeName, 0
            from  
                  treffundattribute trfa
            where trfa.AttributeName in ( select convert(varchar(255),Value) from dbo.FnSplit(@FundAttributes,',') )
            
            --update any matching ones
            update A
            set DoesExists = 1
            from
                  @AttributesList A
            where
                  A.RefFundAttributeId In 
                  --Get Attributes              
                  (Select trfa.RefFundAttributeId
                  From 
                        TPolicyBusinessFund pbf
                        inner join tpolicybusinessfundattribute tpbfatt on pbf.PolicyBusinessFundId = tpbfatt.PolicyBusinessFundId
                        inner join treffundattribute trfa on trfa.reffundattributeid = tpbfatt.reffundattributeid 
                   Where
                        pbf.PolicyBusinessId = @PolicyBusinessId and pbf.FundId = @FundId and pbf.FromFeedFg = @FromFeedFg and pbf.EquityFg = @EquityFg
                  )

            --select *from @AttributesList
            
            if not exists(select 1 from @AttributesList where DoesExists = 0)
                  RETURN 1
            else
                  RETURN 0
      end
      
      RETURN 0

END
GO
