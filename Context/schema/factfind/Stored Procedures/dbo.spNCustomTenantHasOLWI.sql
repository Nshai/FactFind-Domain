SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomTenantHasOLWI]    
    
@indigoclientid bigint      
  
as    
    
    
--check the tenant has access first    
if(select isnull(allowaccess,0)    
 from policymanagement..TApplicationLink a    
 inner join policymanagement..TRefApplication b on b.refapplicationid = a.refapplicationid    
 where applicationname = 'Legal and General Bond Illustration' and        
   indigoclientid = @indigoclientid) = 1  begin    
select 1  
       
end       
   else   
select 0  
     
GO
