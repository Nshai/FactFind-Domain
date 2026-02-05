SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*  
sFrequencyList = "<frequencies>"  
sFrequencyList = sFrequencyList & "<frequency frequencyId='Monthly' frequencyName='Monthly'/>"  
sFrequencyList = sFrequencyList & "<frequency frequencyId='Daily' frequencyName='Daily' />"  
sFrequencyList = sFrequencyList & "<frequency frequencyId='Weekly' frequencyName='Weekly' />"  
sFrequencyList = sFrequencyList & "<frequency frequencyId='Fortnightly' frequencyName='Fortnightly' />"  
sFrequencyList = sFrequencyList & "<frequency frequencyId='Bi-Annually' frequencyName='Bi-Annually' />"  
sFrequencyList = sFrequencyList & "<frequency frequencyId='Quarterly' frequencyName='Quarterly' />"  
sFrequencyList = sFrequencyList & "<frequency frequencyId='Half Yearly' frequencyName='Half Yearly' />"  
sFrequencyList = sFrequencyList & "<frequency frequencyId='Annually' frequencyName='Annually' />"  
sFrequencyList = sFrequencyList & "</frequencies>"  
*/  

CREATE PROCEDURE [dbo].[SpCustomRetrieveCommonProviderScheduleFrequencies]  
 @IndigoClientId bigint, @RefProdProviderIds varchar(255)  
  
As  

/*
declare @IndigoClientId bigint, @RefProdProviderIds varchar(255) 
select @IndigoClientId = 644, @RefProdProviderIds = '349'
*/

--20/01/2009 - Mod to lookup linked providers via union sql

  
--This Sp retrieves the common frequencies across all providerids thats passed in  
--NB: To change the order in which the frequencies are listed just change the order of the case statements below  
  
Select   
 ''  
 + case min(AllowMonthly) when 1 then '<frequency frequencyId="Monthly" frequencyName="Monthly" />' else '' end  
 + case min(AllowDaily) when 1 then '<frequency frequencyId="Daily" frequencyName="Daily" />' else '' end  
 + case min(AllowWeekly) when 1 then '<frequency frequencyId="Weekly" frequencyName="Weekly" />' else '' end  
 + case min(AllowFortnightly) when 1 then '<frequency frequencyId="Fortnightly" frequencyName="Fortnightly" />' else '' end  
 + case min(AllowBiAnnually) when 1 then '<frequency frequencyId="Bi-Annually" frequencyName="Bi-Annually" />' else '' end  
 + case min(AllowQuarterly) when 1 then '<frequency frequencyId="Quarterly" frequencyName="Quarterly" />' else '' end  
 + case min(AllowHalfYearly) when 1 then '<frequency frequencyId="Half Yearly" frequencyName="Half Yearly" />' else '' end  
 + case min(AllowAnnually) when 1 then '<frequency frequencyId="Annually" frequencyName="Annually" />' else '' end  
   
 as FrequencyList  
from TValProviderIndigoClientFrequency   
where indigoclientid = @IndigoClientId and RefProdProviderId In (Select convert(int,Value) from dbo.FnSplit(@RefProdProviderIds,','))  
group by indigoclientid

Union 

Select   
 ''  
 + case min(AllowMonthly) when 1 then '<frequency frequencyId="Monthly" frequencyName="Monthly" />' else '' end  
 + case min(AllowDaily) when 1 then '<frequency frequencyId="Daily" frequencyName="Daily" />' else '' end  
 + case min(AllowWeekly) when 1 then '<frequency frequencyId="Weekly" frequencyName="Weekly" />' else '' end  
 + case min(AllowFortnightly) when 1 then '<frequency frequencyId="Fortnightly" frequencyName="Fortnightly" />' else '' end  
 + case min(AllowBiAnnually) when 1 then '<frequency frequencyId="Bi-Annually" frequencyName="Bi-Annually" />' else '' end  
 + case min(AllowQuarterly) when 1 then '<frequency frequencyId="Quarterly" frequencyName="Quarterly" />' else '' end  
 + case min(AllowHalfYearly) when 1 then '<frequency frequencyId="Half Yearly" frequencyName="Half Yearly" />' else '' end  
 + case min(AllowAnnually) when 1 then '<frequency frequencyId="Annually" frequencyName="Annually" />' else '' end  
   
 as FrequencyList  
from TValProviderIndigoClientFrequency a
inner join TValLookUp b on a.RefProdProviderId = b.mappedRefProdProviderId
where a.indigoclientid = @IndigoClientId and b.RefProdProviderId In (Select convert(int,Value) from dbo.FnSplit(@RefProdProviderIds,','))  
group by indigoclientid



GO
