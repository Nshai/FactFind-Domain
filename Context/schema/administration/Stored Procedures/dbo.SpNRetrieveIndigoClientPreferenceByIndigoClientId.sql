SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveIndigoClientPreferenceByIndigoClientId]
	@IndigoClientId bigint
AS

Select * 
From Administration.dbo.TIndigoClientPreference As [IndigoClientPreference]
Where [IndigoClientPreference].IndigoClientId = @IndigoClientId
GO
