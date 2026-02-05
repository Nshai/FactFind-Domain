SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveExtraRiskQuestionsFactFindDefinition]  
	@IndigoClientId bigint  
AS  
select *   
from administration..TRefRiskQuestion   
where isarchived = 0 and createdby = @indigoclientId 
order by Ordinal, question asc
GO
