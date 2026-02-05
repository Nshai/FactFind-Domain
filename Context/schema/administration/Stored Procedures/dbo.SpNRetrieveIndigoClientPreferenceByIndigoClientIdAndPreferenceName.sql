SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveIndigoClientPreferenceByIndigoClientIdAndPreferenceName]
	@IndigoClientId bigint,
	@PreferenceName varchar (255)
AS

Select * 
From Administration.dbo.TIndigoClientPreference As [IndigoClientPreference]
Where [IndigoClientPreference].IndigoClientId = @IndigoClientId And [IndigoClientPreference].PreferenceName = @PreferenceName
GO
