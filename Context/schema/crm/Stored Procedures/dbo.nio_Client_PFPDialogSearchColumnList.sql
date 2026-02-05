SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_Client_PFPDialogSearchColumnList]
	@TenantId bigint,  
		@FirstName varchar(255) = NULL,  
		@LastName varchar(255) = NULL,   
		@PlanTypeId bigint = NULL,  
		@RefProdProviderId bigint = NULL,  
		@ServicingAdviserPartyId bigint = NULL,  		
		@ProductName varchar(50) = NULL,  
		@ServiceStatusId bigint = NULL,
		@RefFundManager bigint = Null,
		@UserId bigint,
		@_TopN int = 0		
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
	NULL AS [PartyId],     
	NULL AS [ClientFullName],      
	NULL AS [CurrentAdviserName],     
	NULL AS [AddressLine1],
	NULL AS [Postcode]
GO
