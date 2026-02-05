SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
Modification History (most recent first)
Date        Modifier             Issue       Description
----        ---------            -------     -------------
20230119    Aswani kumar P       IOSE22-1143 Added salutation as search parameter
*/

CREATE PROCEDURE [dbo].[nio_SpSearchClientOnSdbGetColumnList]    
 @TenantId bigint,      
 @CorporateName  varchar(255) = Null,    
 @FirstName varchar(255) = Null,    
 @MiddleName varchar(200) = NULL,    
 @LastName varchar(255) = Null,
 @DOB date = Null,    
 @PlanTypeId bigint = 0,    
 @PolicyNumber varchar(50) = Null,    
 @PlanStatusId bigint = 0,
 @RefProdProviderId bigint = 0,    
 @ServicingAdviserPartyId bigint = 0,    
 @ProductName varchar(50) = Null,    
 @SequentialRefType varchar(50) = Null,    
 @SequentialRef varchar(50)=Null,    
 @AdviceCaseName varchar(255)=Null,    
 @ServiceStatusId bigint = Null,    
 @RefFundManager varchar(50) = Null,    
 @Fund varchar(50) = Null,    
 @Postcode varchar(50) = Null,    
 @PrimaryRef varchar(50) = Null, --    
 @IncludeDeleted bit = 0, --    
 @AdviserGroupId bigint = Null, --    
 @CreditedGroupId bigint = Null, -- 
 @GroupId bigint = Null,
 @SecondaryRef varchar(50) = Null, --    
 @PortalReference varchar(100) = Null,    
 @ExcludeDeceased bit = 0,
 @FeeCategoryId BIGINT = 0,    
 @FeeTypeId BIGINT = 0,    
 @FeeChargingTypeId BIGINT = 0,    
 @FeeDueDateFrom varchar(12) = '%',    
 @FeeDueDateTo varchar(12) = '%',    
 @FeeInvoiceDateFrom varchar(12) = '%',    
 @FeeInvoiceDateTo varchar(12) = '%',          
 @FeeDateToClientFrom varchar(12) = '%',    
 @FeeDateToClientTo varchar(12) = '%',     
 @FeeServiceCaseCategoryId BIGINT = 0,     
 @FeeStatusId BIGINT = 0,     
 @FeePaidById BIGINT = 0,    
 @LoggedInUserIsSuperUserOrSuperViewer bit,    
 @_UserId bigint,    
 @AdviceCategoryId BIGINT = Null,
 @PlanType varchar(255) = '%',
 @PlanCategory varchar(255) = '%',
 @PlanNumber varchar(50) = '%',
 @_TopN int = 0,
 @EmailAddress varchar(100) = null,
 @PhoneNumber varchar(50) = Null,
 @Salutation varchar(50) = null,
 @NINumber varchar(100) = Null,
 @SellingAdviserPartyId int = 0,
 @ClientSegmentId bigint = Null
AS    
    
-- Exec nio_SpSearchClientOnSdbGetColumnList @TenantId = 0, @LoggedInUserIsSuperUserOrSuperViewer = 0, @_UserId = 0, @_TopN = 0    
    
    
Select    
 '' As 'Owner 1.Id',    
 '' As 'Owner 1.Servicing Adviser.Full Name',    
 '' As 'Owner 1.Last Name',    
 '' As 'Owner 1.Middle Name',    
 '' As 'Owner 1.First Name',
 '' As 'Owner 1.DOB',         
 '' As 'Owner 1.Corporate Name', 
 '' as 'Id',    
 '' as 'FeeId',    
 '' as 'RetainerId',    
 '' as 'FeeInvoiceId',    
 '' AS 'Policy Number',   
 '' AS 'PlanStatusId',
 '' AS 'Product Name',        
 '' AS 'Plan Type',    
 '' AS 'Owner 1.Client Reference',    
 '' AS 'Sequential Ref',    
 -- '' AS 'RightMask',          
 -- '' AS 'AdvancedMask',    
 -- '' As 'Owner 1.Address Line 1',    
 '' As 'Owner 1.Client Secondary Reference',    
 '' As 'Plan Status',    
 '' As 'Owner 1.Client Type',    
 '' As 'Owner 1.Credited Group',
 '' As 'Owner 1.Group', 
 '' As 'In Force Date',    
 '' As 'Owner 1.Deleted',    
 '' AS 'InvoiceSequentialRef'
     
 -- Export    
 , '' As 'Owner 1.Title'    
 , '' As 'Owner 1.Address Line 1'    
 , '' As 'Owner 1.Address Line 2'    
 , '' As 'Owner 1.Address Line 3'    
 , '' As 'Owner 1.Address Line 4'    
 , '' As 'Owner 1.City / Town'    
 , '' As 'Owner 1.County'    
 , '' As 'Owner 1.Country'    
 , '' As 'Owner 1.PostCode'    
 , '' As 'Owner 1.Home Telephone Number'    
 , '' As 'Owner 1.Mobile Number'    
 , '' As 'Owner 1.Fax Number'    
 , '' As 'Owner 1.Email Address'    
 , '' As 'Owner 1.WebSite'    
 , '' As 'Provider.Name'    
 , '' As 'Plan Status Date'    
 , '' As 'Portal Reference'
, '' As 'Owner 1.Fee.Selling Adviser.Full Name'
 ,'' AS 'Owner 1.Fee.ReferenceNumber',  
 '' AS 'Owner 1.Fee.FeeCategory',  
 '' AS 'Owner 1.Fee.Type',    
 '' AS 'Owner 1.Fee.ChargingType',    
 '' AS 'Owner 1.PercentageOfFee',  
 '' AS 'Owner 1.Fee.NetAmount',  
 '' AS 'Owner 1.Fee.VATExempt',
 '' AS 'Owner 1.Fee.VAT',
 '' AS 'Owner 1.Fee.TotalAmount',
 '' AS 'Owner 1.Fee.FeeNumberPayments', 
 '' AS 'Owner 1.Fee.StartDate',
  '' AS 'Owner 1.Fee.EndDate', 
  '' AS 'Owner 1.Fee.FeeFrequency', 
  '' AS 'Owner 1.Fee.InvoiceDate', 
 '' As 'InvoiceDate', 
      '' AS 'Owner 1.Fee.PaidBy', 
 '' AS 'Owner 1.Fee.Status',     
'' AS 'Owner 1.Fee.PaymentStatus',     
 '' AS 'Owner 1.Fee.RelatedPlanReference',    
 '' AS 'Owner 1.Fee.Id',
   '' AS 'Owner 1.Fee.ServiceCaseCategory',
  '' AS 'Owner 1.Fee.ServiceCaseName',
    '' AS 'Owner 1.ServiceStatus',
    '' AS 'Owner 1.Fee.RelatedProductProvider'
 , '' AS 'Owner 1.Fee.AdviceCategory'
 , '' AS 'Owner 1.Fee.PlanType'
 , '' AS 'Owner 1.Fee.PlanCategory'
 , '' As 'Owner 1.ClientCategory'
 , '' AS 'Owner2'
 , '' AS 'IsConsultancy'
 , '' AS 'IsFeeEnded'
 , '' AS 'Owner 1.Fee.PlanNumber'
 , '' AS 'Owner 1.Fee.FeeRecurring'
 , '' AS 'NINumber'
 , '' AS 'ClientSegmentId'

  
     
    
Where 1=2    
    
    
    
    


GO
