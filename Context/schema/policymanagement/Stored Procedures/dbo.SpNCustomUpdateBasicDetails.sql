SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateBasicDetails]            
@PolicyBusinessId bigint,           
@CRMContactId bigint,          
@StampUser varchar(255),          
@TnCCoachId bigint=NULL,          
@CRMContactId2 bigint=NULL,          
@AdditionalOwner1 bigint=NULL,          
@AdditionalOwner2 bigint=NULL,          
@ProductName varchar(255)=NULL,          
@PolicyNumber varchar(255)=NULL,          
@PolicyStartDate datetime=NULL,            
@PolicyEndDate datetime=NULL,          
@ExpectedPaymentDate datetime=NULL,          
@BaseCurrency varchar(50)=NULL,          
@ProviderAddress bigint=NULL,          
@AgencyNumber varchar(255)=NULL,          
@PortalReference varchar(50)=NULL,          
@MortgageId bigint=NULL,          
@PriceValuation decimal(10,2)=NULL,          
@Loan decimal(10,2)=NULL,          
@LTV decimal(10,2)=NULL,          
@LoanPurpose varchar(50)=NULL,          
@ReviewDiaryDate datetime=NULL,          
@ApplicationSubmitted datetime=NULL,          
@CompletionDate datetime=NULL,          
@ExchangeDate datetime=NULL,          
@OfferIssued datetime=NULL,          
@ValuationInstructed datetime=NULL,              
@RepaymentMethod bigint=NULL,          
@ValuationDate datetime=NULL,          
@ValuationReceived datetime=NULL,          
@RepaymentAmount decimal(10,2)=NULL,          
@MortgageTerm int=NULL,          
@InterestOnlyAmount decimal(10,2)=NULL,          
@AssetsId bigint=NULL,          
@MortgageTermMonths smallint=NULL,          
@MortgageBorrower bigint=NULL,          
@Deposit decimal(10,2)=NULL,            
@AddressStoreId bigint=NULL,          
@PropertyValue decimal(10,2)=NULL,          
@IsCurrentResidence bit=NULL,          
@IsResdidenceAfterComplete bit=NULL    ,    
@ReportNotes varchar(4000) = NULL  ,
@StatusFg bit=NULL,   
@SelfCertFg bit=NULL,
@NonStatusFg bit=NULL

          
          
          
          
AS          
          
BEGIN           
 DECLARE @tx int          
 SELECT @tx = @@TRANCOUNT          
 IF @tx = 0 BEGIN TRANSACTION TX          
          
          
 DECLARE @Status varchar(255),@ProviderAddressLine1 varchar(1000)      
 SELECT @Status=B.[Name] FROM TStatusHistory A JOIN TStatus B ON A.StatusId=B.StatusId WHERE A.PolicyBusinessId=@PolicyBusinessId AND A.CurrentStatusFG=1          
           
 IF ISNULL(@ProviderAddress,0)!=0          
 BEGIN          
  --SELECT @ProviderAddressLine1=B.AddressLine1 FROM CRM..TAddress A JOIN CRM..TAddressStore B ON A.AddressStoreId=B.AddressStoreId WHERE A.AddressId=@ProviderAddress          
 SELECT @ProviderAddressLine1 =         
  ISNULL(B.AddressLine1,'')         
  + CASE WHEN ISNULL(B.AddressLine2,'') <> '' THEN ', ' + B.AddressLine2 ELSE '' END         
  + CASE WHEN ISNULL(B.AddressLine3,'') <> '' THEN ', ' + B.AddressLine3 ELSE '' END         
  + CASE WHEN ISNULL(B.AddressLine4,'') <> '' THEN ', ' + B.AddressLine4 ELSE '' END         
  + CASE WHEN ISNULL(B.CityTown,'') <> '' THEN ', ' + B.CityTown ELSE '' END         
  + CASE WHEN ISNULL(B.PostCode,'') <> '' THEN ', ' + B.PostCode ELSE '' END         
  + CASE WHEN ISNULL(tel.Value,'') <> '' THEN ', Tel:' + tel.Value ELSE '' END        
  + CASE WHEN ISNULL(fax.Value,'') <> '' THEN ', Fax:' + fax.Value ELSE '' END        
 FROM CRM..TAddress A         
 JOIN CRM..TAddressStore B ON A.AddressStoreId=B.AddressStoreId         
 LEFT JOIN CRM..TContact tel ON tel.CRMContactId = a.CRMContactId AND tel.RefContactType = 'Telephone' and tel.DefaultFg = 1        
 LEFT JOIN CRM..TContact fax ON fax.CRMContactId = a.CRMContactId AND fax.RefContactType = 'Fax' and fax.DefaultFg = 1        
 WHERE A.AddressId=@ProviderAddress        
 END       
      
       
          
 IF @@ERROR!=0 GOTO errh          
          
 EXEC SpNAuditPolicyBusiness @StampUser,@PolicyBusinessId,'U'          
 --Update          
 UPDATE TPolicyBusiness          
 SET PolicyNumber=@PolicyNumber,          
 TnCCoachId=@TnCCoachId,          
 PolicyStartDate=@PolicyStartDate,          
 MaturityDate=@PolicyEndDate,          
 ProviderAddress=@ProviderAddressLine1,          
 BaseCurrency=@BaseCurrency,          
 AgencyNumber=@AgencyNumber,          
 ExpectedPaymentDate=@ExpectedPaymentDate,          
 ProductName=@ProductName,          
 ConcurrencyId=ConcurrencyId + 1           
           
 WHERE PolicyBusinessId=@PolicyBusinessId      
    
 IF @@ERROR != 0 GOTO errh          
          
 --PortalReference          
 --IF ISNULL(@PortalReference,'')!=''-- OR ISNULL(@ReportNotes,'')!=''  --SP Removed for case 27868       
 --BEGIN          
  DECLARE @PolicyBusinessExtId bigint          
  SELECT @PolicyBusinessExtId=PolicyBusinessExtId FROM TPolicyBusinessExt WHERE PolicyBusinessId=@PolicyBusinessId          
          
  EXEC dbo.SpNAuditPolicyBusinessExt @StampUser,@PolicyBusinessExtId,'U'          
  IF @@ERROR!=0 GOTO errh          
          
  Update TPolicyBusinessExt          
   SET PortalReference=@PortalReference,          
 ReportNotes = @ReportNotes,    
  ConcurrencyId=ConcurrencyId + 1          
  WHERE PolicyBusinessExtId=@PolicyBusinessExtId           
  IF @@ERROR!=0 GOTO errh          
 --END          
 --ToDo Policy Owner check if there is a second owner already and update or create.          
 DECLARE @Owner2Id bigint          
 SELECT @Owner2Id=B.PolicyOwnerId          
 FROM TPolicyBusiness A          
 JOIN TPolicyOwner B ON A.PolicyDetailId=B.PolicyDetailId          
 WHERE A.PolicyBusinessId=@PolicyBusinessId          
 AND B.CRMContactId!=@CRMContactId          
          
          
 IF ISNULL(@CRMContactId2,0)>0           
 BEGIN              
  IF ISNULL(@Owner2Id,0)=0          
  BEGIN          
   INSERT TPolicyOwner(CRMContactId,PolicyDetailId,ConcurrencyId)          
   SELECT @CRMContactId2,PolicyDetailId,1          
   FROM TPolicyBusiness          
   WHERE PolicyBusinessId=@PolicyBusinessId          
          
   SELECT @Owner2Id=SCOPE_IDENTITY()          
          
   IF @@ERROR!=0 GOTO errh          
          
   EXEC dbo.SpNAuditPolicyOwner @StampUser,@Owner2Id,'C'          
   IF @@ERROR!=0 GOTO errh          
          
          
  END          
  ELSE           
  BEGIN          
   EXEC dbo.SpNAuditPolicyOwner @StampUser,@Owner2Id,'U'          
   IF @@ERROR!=0 GOTO errh          
             
   UPDATE TPolicyOwner          
   SET CRMContactId=@CRMContactId2,ConcurrencyId=ConcurrencyId + 1          
   WHERE PolicyOwnerId=@Owner2Id          
   IF @@ERROR!=0 GOTO errh          
  END              
 END          
 ELSE           
 BEGIN          
  IF ISNULL(@Owner2Id,0)>0          
            
  EXEC dbo.SpNAuditPolicyOwner @StampUser,@Owner2Id,'D'          
  IF @@ERROR!=0 GOTO errh          
            
  DELETE A          
  FROM TPolicyOwner A          
  JOIN TPolicyBusiness B ON A.PolicyDetailId=B.PolicyDetailId          
  WHERE A.PolicyOwnerId=@Owner2Id          
  AND B.PolicyBusinessId=@PolicyBusinessId          
          
  IF @@ERROR!=0 GOTO errh          
 END          
          
 --Are there any additional owners          
 INSERT TAdditionalOwnerAudit(PolicyBusinessId,CRMContactId,ConcurrencyId,AdditionalOwnerId,StampAction,StampDateTime,StampUser)          
 SELECT PolicyBusinessId,CRMContactId,ConcurrencyId,AdditionalOwnerId,'D',GETDATE(),@StampUser          
 FROM TAdditionalOwner           
 WHERE PolicyBusinessId=@PolicyBusinessId          
          
 DELETE FROM TAdditionalOwner           
 WHERE PolicyBusinessId=@PolicyBusinessId          
           
          
 --Add additonal owner 1          
 IF ISNULL(@AdditionalOwner1,0)!=0          
 BEGIN          
  INSERT TAdditionalOwner(PolicyBusinessId,CRMContactId,ConcurrencyId)          
  SELECT @PolicyBusinessId,@AdditionalOwner1,1          
 END          
 --Add additonal owner 2          
 IF ISNULL(@AdditionalOwner2,0)!=0          
 BEGIN          
  INSERT TAdditionalOwner(PolicyBusinessId,CRMContactId,ConcurrencyId)          
  SELECT @PolicyBusinessId,@AdditionalOwner2,1          
 END          
          
 --Audit them both          
 INSERT TAdditionalOwnerAudit(PolicyBusinessId,CRMContactId,ConcurrencyId,AdditionalOwnerId,StampAction,StampDateTime,StampUser)          
 SELECT PolicyBusinessId,CRMContactId,ConcurrencyId,AdditionalOwnerId,'C',GETDATE(),@StampUser          
 FROM TAdditionalOwner           
 WHERE PolicyBusinessId=@PolicyBusinessId          
          
    IF ISNULL(@MortgageId,0)!=0          
 BEGIN          
  EXEC PolicyManagement..SpNAuditMortgage @StampUser,@MortgageId,'U'          
          
  IF @@ERROR!=0 GOTO errh          
          
  UPDATE TMortgage          
  SET LoanAmount=@Loan,AssetsId=@AssetsId,RefMortgageBorrowerTypeId=@MortgageBorrower,        
  RefMortgageRepaymentMethodId=@RepaymentMethod,CompletionDate=@CompletionDate,          
  ExchangeDate=@ExchangeDate,ReviewDiaryDate=@ReviewDiaryDate,MortgageTerm=@MortgageTerm,          
  MortgageTermMonths=@MortgageTermMonths,ApplicationSubmitted=@ApplicationSubmitted,          
  ValuationInstructed=@ValuationInstructed,ValuationDate=@ValuationDate,ValuationReceived=@ValuationReceived,          
  OfferIssued=@OfferIssued,IsCurrentResidence=@IsCurrentResidence,IsResdidenceAfterComplete=@IsResdidenceAfterComplete,          
  LTV=@LTV,PropertyValue=@PropertyValue,AddressStoreId=@AddressStoreId,          
  LoanPurpose=@LoanPurpose,PriceValuation=@PriceValuation,Deposit=@Deposit,InterestOnlyAmount=@InterestOnlyAmount,          
  RepaymentAmount=@RepaymentAmount,StatusFg=@StatusFg,SelfCertFg=@SelfCertFg,NonStatusFg=@NonStatusFg,ConcurrencyId=ConcurrencyId + 1          
            
  WHERE MortgageId=@MortgageId AND PolicyBusinessId=@PolicyBusinessId          
            
  IF @@ERROR!=0 GOTO errh          
          
 END          
          
 --Update DnPolicyMatching in commissions          
 EXEC SpNCustomManageDnPolicyMatching @PolicyBusinessId,@StampUser          
          
 --Do we need to manage a system event          
 IF ISNULL(CONVERT(VARCHAR(20),@ReviewDiaryDate,103),'')!=''          
 BEGIN          
  EXEC CRM..SpNCustomManagePlanSystemEvent @StampUser,@CRMContactId,@PolicyBusinessId,'Review Diary Date',@ReviewDiaryDate          
 END          
           
 SELECT * FROM TPolicyBusiness WHERE PolicyBusinessId=@PolicyBusinessId          
          
 IF @@ERROR != 0 GOTO errh          
 IF @tx = 0 COMMIT TRANSACTION TX          
          
END          
RETURN (0)          
          
errh:          
  IF @tx = 0 ROLLBACK TRANSACTION TX          
  RETURN (100)    
    
GO
