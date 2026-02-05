SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveFactFindTypeByIndigoClientIdAndCRMContactType]
	@IndigoClientId bigint,
	@CRMContactType tinyint
AS

Select * 
From FactFind.dbo.TFactFindType As [FactFindType]
Where [FactFindType].IndigoClientId = @IndigoClientId And [FactFindType].CRMContactType = @CRMContactType
GO
