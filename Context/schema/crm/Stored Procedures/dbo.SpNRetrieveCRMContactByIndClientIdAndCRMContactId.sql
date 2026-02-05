SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveCRMContactByIndClientIdAndCRMContactId]
	@IndClientId bigint,
	@CRMContactId bigint
AS

Select * 
From CRM.dbo.TCRMContact As [CRMContact]
Where [CRMContact].IndClientId = @IndClientId And [CRMContact].CRMContactId = @CRMContactId
GO
