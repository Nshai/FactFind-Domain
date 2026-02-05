SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveIndigoClientByIndigoClientId]
	@IndigoClientId bigint
AS

Select * 
From Administration.dbo.TIndigoClient As [IndigoClient]
Where [IndigoClient].IndigoClientId = @IndigoClientId
GO
