SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec SpCustomSearchClientFullSecure 99,default,default,default,default,default,default,7288,default,default,default,default,default,default,default,default,-14120,250

CREATE PROCEDURE [dbo].[SpCustomSearchClientFullSecure]  
 @IndigoClientId bigint,  
 @CorporateName  varchar(255) = NULL,  
 @FirstName varchar(255) = NULL,  
 @LastName varchar(255) = NULL,   
 @PlanTypeId bigint = 0,  
 @PolicyNumber varchar(50) = NULL,  
 @RefProdProviderId bigint = 0,  
 @PractitionerId bigint = 0,  
 @ProductName varchar(50) = NULL,  
 @SequentialRefType varchar(50) = NULL,  
 @SequentialRef varchar(50)=NULL, 
 @AdviceCaseName varchar(255)=NULL, 
 @ServiceStatus varchar(50) = NULL,
 @RefFundManager varchar(50) = NULL,
 @Fund varchar(50) = NULL,
 @Postcode varchar(50) = NULL,
 @_UserId bigint,  
 @_TopN int = 0  
AS    

--  
--If ISNULL(@AdviceCaseName,'')!=''
--Begin
--	exec dbo.SpCustomSearchClientFullSecureByAdviceCase @IndigoClientId, @SequentialRef, @AdviceCaseName, @_UserId, @_TopN  
--End
--  

If ISNULL(@SequentialRef,'')!=''
Begin  

	
 IF @SequentialRefType='PlanIOBRef'  
  BEGIN  
   exec dbo.SpCustomSearchClientFullSecureByPolicyNo @IndigoClientId, '', @SequentialRef, @_UserId, @_TopN  
  END  
 ELSE IF @SequentialRefType='FeeIOFRef'  
  BEGIN  
   exec dbo.SpCustomSearchClientFullSecureByFee @IndigoClientId, @SequentialRef, @_UserId, @_TopN  
  END  
 ELSE IF @SequentialRefType= 'RetainerIORRef'  
  BEGIN  
   exec dbo.SpCustomSearchClientFullSecureByRetainer @IndigoClientId, @SequentialRef, @_UserId, @_TopN  
  END 
 ELSE IF  @SequentialRefType= 'AdviceCaseRef'  
 BEGIN  

   exec dbo.SpCustomSearchClientFullSecureByAdviceCase @IndigoClientId, @SequentialRef, @AdviceCaseName,@_UserId, @_TopN  
 END 
  
End  
else if ISNULL(@AdviceCaseName,'')!=''
Begin
	exec dbo.SpCustomSearchClientFullSecureByAdviceCase @IndigoClientId, @SequentialRef, @AdviceCaseName, @_UserId, @_TopN  	
End
--Name Searching  
Else If @PlanTypeId = 0 And IsNull(@PolicyNumber,'') = '' And @RefProdProviderId = 0 And IsNull(@ProductName,'') = '' And ISNULL(@SequentialRef,'')=''  
Begin  
 If @CorporateName Is Null Set @CorporateName = ''  
 If @FirstName Is Null Set @FirstName = ''  
 If @LastName Is Null Set @LastName = ''   
 
	exec dbo.SpCustomSearchClientFullSecureByName @IndigoClientId, @CorporateName, @FirstName, @LastName, @PractitionerId, @ServiceStatus, @RefFundManager, @Fund, @Postcode, @_UserId, @_TopN  
End  
-- Policy Number Searching  
Else If @PlanTypeId = 0 And IsNull(@PolicyNumber,'') <> '' And @RefProdProviderId = 0 And @PractitionerId = 0   
 And IsNull(@ProductName,'') = '' And IsNull(@CorporateName,'') = '' And IsNull(@FirstName,'') = ''  
 And IsNull(@LastName,'') = ''  
Begin  
 exec dbo.SpCustomSearchClientFullSecureByPolicyNo @IndigoClientId, @PolicyNumber, @SequentialRef, @_UserId, @_TopN  
End  
-- Default Search  
Else  
Begin   
 exec SpCustomSearchClientFullSecureDefault @IndigoClientId, @CorporateName, @FirstName, @LastName,   
  @PlanTypeId, @PolicyNumber, @RefProdProviderId, @PractitionerId, @ProductName, @SequentialRef,  
  @ServiceStatus,@RefFundManager,@Fund,@Postcode,
  @_UserId, @_TopN  
End


GO
