SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_Custom_Update_CampaignData]
	@CampaignDataId Bigint = 0,
	@StampUser varchar (255),
	@CampaignId bigint, 
	@Description varchar(255) = NULL, 
	@Cost money = NULL,
	@ConcurrencyId bigint,
	@PartyId bigint
AS

BEGIN
	-- Update the campaign
	If @CampaignDataId > 0 
		BEGIN

			-- Insert into Audit
			INSERT INTO TCampaignDataAudit   
			( CampaignId, Description, Cost, ConcurrencyId, CampaignDataId, StampAction, StampDateTime, StampUser)   
			Select CampaignId, Description, Cost, ConcurrencyId, CampaignDataId, 'U', GetDate(), @StampUser  
			FROM TCampaignData  
			WHERE CampaignDataId = @CampaignDataId  

			-- Update the main table
			UPDATE T1
			SET T1.CampaignId = @CampaignId, T1.Description = @Description, T1.Cost = @Cost, T1.ConcurrencyId = T1.ConcurrencyId + 1
			FROM TCampaignData T1
			WHERE  T1.CampaignDataId = @CampaignDataId 

		END
	ELSE
		BEGIN
			
			-- Insert new row into the table
			INSERT INTO TCampaignData(CampaignId, Description, Cost, ConcurrencyId)
			VALUES(@CampaignId, @Description, @Cost, 1)
						
			-- Update TCrmContact table with this new campaign info
			DECLARE @insCampaignDataId BigInt
			SELECT @insCampaignDataId = SCOPE_IDENTITY()
			UPDATE TCRMContact SET CampaignDataId = @insCampaignDataId WHERE CRMContactId = @PartyId
			
			-- Insert into Audit
			INSERT INTO TCampaignDataAudit   
			( CampaignId, Description, Cost, ConcurrencyId, CampaignDataId, StampAction, StampDateTime, StampUser)   
			Select CampaignId, Description, Cost, ConcurrencyId, CampaignDataId, 'C', GetDate(), @StampUser  
			FROM TCampaignData  
			WHERE CampaignDataId = @insCampaignDataId  
		END

END
GO
