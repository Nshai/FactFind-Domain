SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_CRSClient_DialogSearchColumnList]
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
	NULL AS [PartyId],     
	NULL AS [ClientFullName],   
	NULL AS [LastOrCorporateName],    
	NULL AS [CurrentAdviserName],     
	NULL AS [AddressLine1],
	NULL AS [Postcode]
GO
