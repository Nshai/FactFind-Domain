SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomDeletePreviousBulkHoldings]  
 @ValScheduleItemId bigint  
AS  
  
SET NOCOUNT ON  
  
BEGIN TRANSACTION  

    DECLARE @StampTime DATETIME = GETDATE(), @StampUser VARCHAR(1) = '0'
  
   --Delete previous records  
   DELETE FROM TValBulkHolding  
    OUTPUT   
      DELETED.ValScheduleItemId, DELETED.CustomerReference, DELETED.PortfolioReference, DELETED.CustomerSubType,   
      DELETED.Title,DELETED.FirstName, DELETED.LastName, DELETED.CorporateName, DELETED.DOB, DELETED.NINumber,   
      DELETED.ClientAddressLine1,DELETED.ClientAddressLine2,DELETED.ClientAddressLine3,DELETED.ClientAddressLine4,  
      DELETED.ClientPostCode,DELETED.AdviserReference, DELETED.AdviserFirstName, DELETED.AdviserLastName, DELETED.CompanyName,   
      DELETED.AdviserPostCode, DELETED.PortfolioId, DELETED.HoldingId, DELETED.PortfolioType, DELETED.Designation, DELETED.FundProviderName,   
      DELETED.FundName, DELETED.ISIN, DELETED.MexId, DELETED.Sedol, DELETED.Quantity, DELETED.EffectiveDate, DELETED.Price,   
      DELETED.PriceDate, DELETED.HoldingValue, DELETED.Currency, DELETED.WorkInProgress, DELETED.CRMContactId,   
      DELETED.PractitionerId, DELETED.PolicyBusinessId, DELETED.[Status],DELETED.IsLatestFG,DELETED.SubPlanReference,  
      DELETED.SubPlanType,DELETED.EpicCode,DELETED.CitiCode,DELETED.GBPBalance,DELETED.ForeignBalance,DELETED.AvailableCash,  
      DELETED.AccountName,DELETED.AccountReference,DELETED.ConcurrencyId,DELETED.ValBulkHoldingId,  
      'D',@StampTime ,@StampUser   
    INTO TValBulkHoldingAudit (  
      ValScheduleItemId, CustomerReference, PortfolioReference, CustomerSubType,   
      Title,FirstName, LastName, CorporateName, DOB, NINumber,   
      ClientAddressLine1,ClientAddressLine2,ClientAddressLine3,ClientAddressLine4,  
      ClientPostCode,AdviserReference, AdviserFirstName, AdviserLastName, CompanyName,   
      AdviserPostCode, PortfolioId, HoldingId, PortfolioType, Designation, FundProviderName,   
      FundName, ISIN, MexId, Sedol, Quantity, EffectiveDate, Price,   
      PriceDate, HoldingValue, Currency, WorkInProgress, CRMContactId,   
      PractitionerId, PolicyBusinessId, [Status],IsLatestFG,SubPlanReference,  
      SubPlanType,EpicCode,CitiCode,GBPBalance,ForeignBalance,AvailableCash,  
      AccountName,AccountReference,ConcurrencyId,ValBulkHoldingId,  
      StampAction,StampDateTime,StampUser )  
   WHERE ValScheduleItemId = @ValScheduleItemId  
   And IsLatestFG = 1  
     
   --Mark the new records as current  
   UPDATE Policymanagement..TValBulkHolding   
   SET IsLatestFG = 1  
   OUTPUT  
      DELETED.ValScheduleItemId, DELETED.CustomerReference, DELETED.PortfolioReference, DELETED.CustomerSubType,   
      DELETED.Title,DELETED.FirstName, DELETED.LastName, DELETED.CorporateName, DELETED.DOB, DELETED.NINumber,   
      DELETED.ClientAddressLine1,DELETED.ClientAddressLine2,DELETED.ClientAddressLine3,DELETED.ClientAddressLine4,  
      DELETED.ClientPostCode,DELETED.AdviserReference, DELETED.AdviserFirstName, DELETED.AdviserLastName, DELETED.CompanyName,   
      DELETED.AdviserPostCode, DELETED.PortfolioId, DELETED.HoldingId, DELETED.PortfolioType, DELETED.Designation, DELETED.FundProviderName,   
      DELETED.FundName, DELETED.ISIN, DELETED.MexId, DELETED.Sedol, DELETED.Quantity, DELETED.EffectiveDate, DELETED.Price,   
      DELETED.PriceDate, DELETED.HoldingValue, DELETED.Currency, DELETED.WorkInProgress, DELETED.CRMContactId,   
      DELETED.PractitionerId, DELETED.PolicyBusinessId, DELETED.[Status],DELETED.IsLatestFG,DELETED.SubPlanReference,  
      DELETED.SubPlanType,DELETED.EpicCode,DELETED.CitiCode,DELETED.GBPBalance,DELETED.ForeignBalance,DELETED.AvailableCash,  
      DELETED.AccountName,DELETED.AccountReference,DELETED.ConcurrencyId,DELETED.ValBulkHoldingId,  
      'U',@StampTime ,@StampUser  
   INTO TValBulkHoldingAudit (  
      ValScheduleItemId, CustomerReference, PortfolioReference, CustomerSubType,   
      Title,FirstName, LastName, CorporateName, DOB, NINumber,   
      ClientAddressLine1,ClientAddressLine2,ClientAddressLine3,ClientAddressLine4,  
      ClientPostCode,AdviserReference, AdviserFirstName, AdviserLastName, CompanyName,   
      AdviserPostCode, PortfolioId, HoldingId, PortfolioType, Designation, FundProviderName,   
      FundName, ISIN, MexId, Sedol, Quantity, EffectiveDate, Price,   
      PriceDate, HoldingValue, Currency, WorkInProgress, CRMContactId, PractitionerId,   
      PolicyBusinessId, [Status],IsLatestFG,SubPlanReference,  
      SubPlanType,EpicCode,CitiCode,GBPBalance,ForeignBalance,AvailableCash,  
      AccountName,AccountReference,ConcurrencyId,ValBulkHoldingId,  
      StampAction,StampDateTime,StampUser )  
   Where ValScheduleItemId = @ValScheduleItemId  
   And IsLatestFG = 0  

    DELETE FROM TValSchedulePolicy
        OUTPUT
            DELETED.ValScheduleId,   
            DELETED.PolicyBusinessId,   
            DELETED.ClientCRMContactId,   
            DELETED.UserCredentialOption,   
            DELETED.PortalCRMContactId,   
            DELETED.ConcurrencyId,  
            DELETED.ValSchedulePolicyId,  
            'D',  
            @StampTime ,  
            @StampUser
        INTO TValSchedulePolicyAudit (  
            ValScheduleId,   
            PolicyBusinessId,   
            ClientCRMContactId,   
            UserCredentialOption,   
            PortalCRMContactId,   
            ConcurrencyId,  
            ValSchedulePolicyId,  
            StampAction,  
            StampDateTime,  
            StampUser)  
    WHERE ValScheduleId IN
        (SELECT s.ValScheduleId 
        FROM TValSchedule s WITH (NOLOCK)  
                INNER JOIN TValScheduleItem i WITH (NOLOCK)  ON s.ValScheduleId = i.ValScheduleId and i.ValScheduleItemid = @ValScheduleItemId )
 
COMMIT


GO
