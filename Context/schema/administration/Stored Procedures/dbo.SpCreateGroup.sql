SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateGroup]  
 @StampUser varchar (255),  
 @Identifier varchar(64) ,   
 @GroupingId bigint,   
 @ParentId bigint = NULL,   
 @CRMContactId bigint = NULL,   
 @IndigoClientId bigint,   
 @LegalEntity bit = 0,   
 @GroupImageLocation varchar(500)  = NULL,   
 @AcknowledgementsLocation varchar(500)  = NULL,   
 @FinancialYearEnd datetime = NULL,   
 @ApplyFactFindBranding bit = 1,   
 @VatRegNbr varchar(50)  = NULL,   
 @AuthorisationText varchar(500)  = NULL   
AS  
  
SET NOCOUNT ON  
  
DECLARE @tx int  
SELECT @tx = @@TRANCOUNT  
IF @tx = 0 BEGIN TRANSACTION TX  
  
BEGIN  
   
 DECLARE @GroupId bigint  
     
   
 INSERT INTO TGroup (  
  Identifier,   
  GroupingId,   
  ParentId,   
  CRMContactId,   
  IndigoClientId,   
  LegalEntity,   
  GroupImageLocation,   
  AcknowledgementsLocation,   
  FinancialYearEnd,   
  ApplyFactFindBranding,   
  VatRegNbr,   
  AuthorisationText,   
  ConcurrencyId)  
    
 VALUES(  
  @Identifier,   
  @GroupingId,   
  @ParentId,   
  @CRMContactId,   
  @IndigoClientId,   
  @LegalEntity,   
  @GroupImageLocation,   
  @AcknowledgementsLocation,   
  @FinancialYearEnd,   
  @ApplyFactFindBranding,   
  @VatRegNbr,   
  @AuthorisationText,  
  1)  
  
 SELECT @GroupId = SCOPE_IDENTITY()  
   
 INSERT INTO TGroupAudit (  
  Identifier,   
  GroupingId,   
  ParentId,   
  CRMContactId,   
  IndigoClientId,   
  LegalEntity,   
  GroupImageLocation,   
  AcknowledgementsLocation,   
  FinancialYearEnd,   
  ApplyFactFindBranding,   
  VatRegNbr,   
  AuthorisationText,   
  ConcurrencyId,  
  GroupId,  
  StampAction,  
     StampDateTime,  
     StampUser)  
 SELECT    
  Identifier,   
  GroupingId,   
  ParentId,   
  CRMContactId,   
  IndigoClientId,   
  LegalEntity,   
  GroupImageLocation,   
  AcknowledgementsLocation,   
  FinancialYearEnd,   
  ApplyFactFindBranding,   
  VatRegNbr,   
  AuthorisationText,   
  ConcurrencyId,  
  GroupId,  
  'C',  
     GetDate(),  
     @StampUser  
 FROM TGroup  
 WHERE GroupId = @GroupId  
 EXEC SpRetrieveGroupById @GroupId  
  
IF @@ERROR != 0 GOTO errh  
IF @tx = 0 COMMIT TRANSACTION TX  
  
END  
RETURN (0)  
  
errh:  
  IF @tx = 0 ROLLBACK TRANSACTION TX  
  RETURN (100)
GO
