SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create Procedure [dbo].[SpCustomConfigureCEFrequencyForActiveICs]    
@IndigoClientId bigint
AS    
  
    
SET NOCOUNT OFF      
    
Declare @RefProdProviderId bigint
  
/*  
-- For Testing  
  
drop table #temp_TValProviderIndigoClientFrequency  
Create Table #temp_TValProviderIndigoClientFrequency   
(  
 RefProdProviderId bigint,  
 IndigoClientId bigint,  
 AllowDaily tinyint,  
 AllowWeekly tinyint,  
 AllowFortnightly tinyint,  
 AllowMonthly tinyint,  
 AllowBiAnnually tinyint,  
 AllowQuarterly tinyint,  
 AllowHalfYearly tinyint,  
 AllowAnnually tinyint  
)  
*/  
  
SET NOCOUNT ON    
    
DECLARE @tx int    
SELECT @tx = @@TRANCOUNT    
IF @tx = 0 BEGIN TRANSACTION TX    
    
BEGIN    
--236	- Scottish Widow
--294	- Prudential
--1543	- Citi Quilter
--1555	- Ascentric
--1814  - Novia

IF Exists (SELECT 1 FROM TValProviderIndigoClientFrequency with (nolock) WHERE IndigoClientId = @IndigoClientId  )
BEGIN
	INSERT INTO TValProviderIndigoClientFrequencyAudit (  
	  RefProdProviderId, IndigoClientId, AllowDaily, AllowWeekly, AllowFortnightly, AllowMonthly, AllowBiAnnually,  
	  AllowQuarterly, AllowHalfYearly, AllowAnnually, ConcurrencyId, ValProviderIndigoClientFrequencyId,  
	  StampAction, StampDateTime, StampUser)  
	  
	SELECT  
	  RefProdProviderId, IndigoClientId, AllowDaily, AllowWeekly, AllowFortnightly, AllowMonthly, AllowBiAnnually,  
	  AllowQuarterly, AllowHalfYearly, AllowAnnually, ConcurrencyId, ValProviderIndigoClientFrequencyId,  
	  'D', GetDate(), '0'  
	FROM TValProviderIndigoClientFrequency    
	Where IndigoClientId = @IndigoClientId

	DELETE 
		FROM TValProviderIndigoClientFrequency
		WHERE IndigoClientId = @IndigoClientId
END
  
Insert Into TValProviderIndigoClientFrequency (RefProdProviderId, IndigoClientId,   
 AllowDaily, AllowWeekly, AllowFortnightly, AllowMonthly, AllowBiAnnually, AllowQuarterly, AllowHalfYearly, AllowAnnually, ConcurrencyId)  
  
Select r.RefProdProviderId, @IndigoClientId,   
	--Daily
	Case When (r.RefProdProviderId = 294 or r.RefProdProviderId = 236 or r.RefProdProviderId = 1543 or r.RefProdProviderId = 1555 or r.RefProdProviderId = 878) Then 0 Else 1 End, 
	--Weekly
	1, 
	--Fortnightly
	Case When (r.RefProdProviderId = 1543 or r.RefProdProviderId = 1555 or r.RefProdProviderId = 1814 or r.RefProdProviderId = 878) Then 0 Else 1 End, 
	--Monthly
	Case When (r.RefProdProviderId = 1543 or r.RefProdProviderId = 1555 or r.RefProdProviderId = 1814 or r.RefProdProviderId = 878) Then 0 Else 1 End, 
	--BiAnnually
	Case When (r.RefProdProviderId = 1543 or r.RefProdProviderId = 1555 or r.RefProdProviderId = 1814 or r.RefProdProviderId = 878) Then 0 Else 1 End, 
	--Quarterly
	Case When (r.RefProdProviderId = 1543 or r.RefProdProviderId = 1555 or r.RefProdProviderId = 1814 or r.RefProdProviderId = 878) Then 0 Else 1 End, 
	--HalfYearly
	Case When (r.RefProdProviderId = 1543 or r.RefProdProviderId = 1555 or r.RefProdProviderId = 1814 or r.RefProdProviderId = 878) Then 0 Else 1 End, 
	--Annually
	Case When (r.RefProdProviderId = 1543 or r.RefProdProviderId = 1555 or r.RefProdProviderId = 1814 or r.RefProdProviderId = 878) Then 0 Else 1 End, 

	1 --last 1 is the ConcurrencyId  
From policymanagement..tvalproviderconfig r with(nolock)  
  
  
INSERT INTO TValProviderIndigoClientFrequencyAudit (  
  RefProdProviderId, IndigoClientId, AllowDaily, AllowWeekly, AllowFortnightly, AllowMonthly, AllowBiAnnually,  
  AllowQuarterly, AllowHalfYearly, AllowAnnually, ConcurrencyId, ValProviderIndigoClientFrequencyId,  
  StampAction, StampDateTime, StampUser)  
  
SELECT  
  RefProdProviderId, IndigoClientId, AllowDaily, AllowWeekly, AllowFortnightly, AllowMonthly, AllowBiAnnually,  
  AllowQuarterly, AllowHalfYearly, AllowAnnually, ConcurrencyId, ValProviderIndigoClientFrequencyId,  
  'C', GetDate(), '0'  
FROM TValProviderIndigoClientFrequency    
Where IndigoClientId = @IndigoClientId
    
IF @@ERROR != 0 GOTO errh    
IF @tx = 0 COMMIT TRANSACTION TX    
    
END    
RETURN (0)    
    
errh:    
  IF @tx = 0 ROLLBACK TRANSACTION TX    
  RETURN (100)    
  
  
--Original Code  
/*     
  
Declare @RefProdProviderId bigint, @IndigoClientId bigint  
  
--Use a cursor to loop through all providers    
declare c_Providers cursor for      
select a.RefProdProviderId    
from policymanagement..tvalproviderconfig a with(nolock)    
  
    
open c_Providers      
fetch next from c_Providers into @RefProdProviderId    
    
while @@fetch_status=0      
begin      
    
 -- inner loop    
 declare c_IndigoClients cursor for    
 select a.indigoclientid    
 from administration..tindigoclient a with(nolock)    
 where a.status = 'active'      
      
 open c_IndigoClients      
 fetch next from c_IndigoClients into @IndigoClientId      
      
 while @@fetch_status=0      
 begin      
    
  if not exists(select 1 from TValProviderIndigoClientFrequency     
   where RefProdProviderId = @RefProdProviderId    
   and IndigoClientId = @IndigoClientId)    
  begin    
    
   --If @RefProdProviderId = 294 -- Pru - don;t allow Daily  
   --If @RefProdProviderId = 236 -- Scottish Life - don;t allow Daily  
   If @RefProdProviderId = 294 or @RefProdProviderId = 236  
    exec SpCreateValProviderIndigoClientFrequency '0', @RefProdProviderId, @IndigoClientId, 0,1,1,1,1,1,1,1    
   else    
    exec SpCreateValProviderIndigoClientFrequency '0', @RefProdProviderId, @IndigoClientId, 1,1,1,1,1,1,1,1    
  end    
      
  fetch next from c_IndigoClients into @IndigoClientId      
   end    
    
 close c_IndigoClients      
 deallocate c_IndigoClients      
    
fetch next from c_Providers into @RefProdProviderId      
end    
    
close c_Providers      
deallocate c_Providers      
      
*/ 
GO
