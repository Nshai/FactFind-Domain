SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[spCustomCreateGroupingForNewTenant]
(
@NewTenantId BIGINT
,@SourceTenantId BIGINT
)
AS
BEGIN
declare @TopGroupingName varchar(64)

select top 1 @TopGroupingName=Identifier FROM Administration..TGrouping 
WHERE IndigoClientId=@SourceTenantId and ParentId is null
order by GroupingId desc -- From live data, the most recent is the one in use

set @TopGroupingName=isnull(@TopGroupingName,'Organisation')

-- Create the default Grouping. This is needed nevertheless.
exec administration..spCreateGrouping '0', @TopGroupingName, NULL, 1, @NewTenantId    

-- Create more grouping from Source tenant if they exist there.
Insert into administration..TGrouping (Identifier,ParentId,IsPayable,IndigoClientId,ConcurrencyId)        
Select Identifier,ParentId,IsPayable,@NewTenantId,1 from administration..TGrouping         
where IndigoClientId=@SourceTenantId
AND Identifier != @TopGroupingName
order by groupingid asc        

-- Insert into the audit
INSERT INTO TGroupingAudit (Identifier,ParentId,IsPayable,IndigoClientId,ConcurrencyId,GroupingId,StampAction,StampDateTime, StampUser)  
SELECT Identifier,ParentId,IsPayable,IndigoClientId,ConcurrencyId,GroupingId, 'C', GETDATE(), '999999'
from administration..TGrouping         
WHERE IndigoClientId=@SourceTenantId
AND Identifier != @TopGroupingName

-- Set the hierarchy for these groupings from the base indigoclientid's groupings
if exists(select * from administration..TGrouping where indigoclientid=@NewTenantId and ISNULL(parentid,0)=0)        
begin        
 -- lets copy the hierarchy        
 --for each group check the name and find the parent, update the record with the parent        
 Declare @SourceGroupingId bigint, @SourceParentGroupingId bigint, @NewTenantGroupingId bigint, @NewTenantParentGroupingId bigint        
        
 DECLARE grouping_cursor CURSOR        
    FOR SELECT GroupingId, ParentId FROM Administration..TGrouping A where indigoclientid=@SourceTenantId and ISNULL(parentid,0)>0        
 OPEN grouping_cursor        
        
 FETCH NEXT FROM grouping_cursor Into @SourceGroupingId ,@SourceParentGroupingId         
        
 WHILE @@FETCH_STATUS = 0        
    BEGIN        
  -- we know this group has a parent        
  SELECT @NewTenantGroupingId=GroupingId FROM Administration..TGrouping where identifier in (Select Identifier from administration..TGrouping where groupingid=@SourceGroupingId) and IndigoClientId=@NewTenantId        
  SELECT @NewTenantParentGroupingId=GroupingId FROM Administration..TGrouping where identifier in (Select Identifier from administration..TGRouping where groupingid=@SourceParentGroupingId) and IndigoClientId=@NewTenantId        
          
  Update Administration..TGrouping Set ParentId=@NewTenantParentGroupingId where GroupingId=@NewTenantGroupingId        
        
  FETCH NEXT FROM grouping_cursor Into @SourceGroupingId ,@SourceParentGroupingId              
    END        
         
 CLOSE grouping_cursor         
    DEALLOCATE grouping_cursor        
end        



END

GO
