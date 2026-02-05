SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.nio_SpCustomSearchClientFullSecure
	(
		@TenantId bigint,  
		@CorporateName  varchar(255) = NULL,  
		@FirstName varchar(255) = NULL,  
		@LastName varchar(255) = NULL,   
		@PlanTypeId bigint = 0,  
		@PolicyNumber varchar(50) = NULL,  
		@RefProdProviderId bigint = 0,  
		@AdviserCRMContactId bigint = 0,  --@AdviserId bigint = 0,  		
		@ProductName varchar(50) = NULL,  
		@SequentialRefType varchar(50) = NULL,  
		@SequentialRef varchar(50)=NULL, 
		@AdviceCaseName varchar(255)=NULL, 
		@_UserId bigint,
		@_TopN int = 0		
	)

AS      
      
-- Limit rows returned?  
IF (@_TopN > 0) SET ROWCOUNT @_TopN  

/* Added by Pranav 20-02-2009 */
/* Retrieve adviserid/practitionerid from @AdviserCRMContactId */
declare @AdviserId bigint
if @AdviserCRMContactId > 0
	select @AdviserId = PractitionerId from dbo.TPractitioner where CRMContactId =@AdviserCRMContactId 		
/* end */

-- SuperUser and SuperViewer processing 
-- (Need to do this because NIO does not pass the @_UserId as a negated value for SuperUsers and SuperViewers
-- A negative Id results in Entity Security being overridden
IF(@_UserId > 0) BEGIN

	IF EXISTS (SELECT 1 FROM Administration..TUser WHERE UserId = @_UserId AND (SuperUser = 1 OR SuperViewer = 1)) 
		SET @_UserId = @_UserId * -1

END

If ISNULL(@SequentialRef,'')!=''
	Begin  
	 IF @SequentialRefType='PlanIOBRef'  
	  BEGIN  
	   exec dbo.nio_SpCustomSearchClientFullSecureByPolicyNo @TenantId, '', @SequentialRef, @_UserId, @_TopN  
	  END  
	 ELSE IF @SequentialRefType='FeeIOFRef'  
	  BEGIN  
	   exec dbo.nio_SpCustomSearchClientFullSecureByFee @TenantId, @SequentialRef, @_UserId, @_TopN  
	  END  
	 ELSE IF @SequentialRefType= 'RetainerIORRef'  
	  BEGIN  
	   exec dbo.nio_SpCustomSearchClientFullSecureByRetainer @TenantId, @SequentialRef, @_UserId, @_TopN  
	  END 
	 ELSE IF  @SequentialRefType= 'AdviceCaseRef'  
	 BEGIN  
	   exec dbo.nio_SpCustomSearchClientFullSecureByAdviceCase @TenantId, @SequentialRef, @AdviceCaseName,@_UserId, @_TopN  
	 END 	  
	End
	  
else if ISNULL(@AdviceCaseName,'')!=''
	Begin
		exec dbo.nio_SpCustomSearchClientFullSecureByAdviceCase @TenantId, @SequentialRef, @AdviceCaseName, @_UserId, @_TopN  	
	End
	
--Name Searching  
Else If @PlanTypeId = 0 And IsNull(@PolicyNumber,'') = '' And @RefProdProviderId = 0 And IsNull(@ProductName,'') = '' And ISNULL(@SequentialRef,'')=''  
	Begin  
	 If @CorporateName Is Null Set @CorporateName = ''  
	 If @FirstName Is Null Set @FirstName = ''  
	 If @LastName Is Null Set @LastName = ''  
	 	  
		exec dbo.nio_SpCustomSearchClientFullSecureByName @TenantId, @CorporateName, @FirstName, @LastName, @AdviserId, @_UserId, @_TopN  
	 
	End  
	
-- Policy Number Searching  
Else If @PlanTypeId = 0 And IsNull(@PolicyNumber,'') <> '' And @RefProdProviderId = 0 And @AdviserId = 0   
 And IsNull(@ProductName,'') = '' And IsNull(@CorporateName,'') = '' And IsNull(@FirstName,'') = ''  
 And IsNull(@LastName,'') = ''  
	Begin  
	 exec dbo.nio_SpCustomSearchClientFullSecureByPolicyNo @TenantId, @PolicyNumber, @SequentialRef, @_UserId, @_TopN  
	End  
	
-- Default Search  
Else  
	Begin  
	 exec nio_SpCustomSearchClientFullSecureDefault @TenantId, @CorporateName, @FirstName, @LastName,   
	  @PlanTypeId, @PolicyNumber, @RefProdProviderId, @AdviserId, @ProductName, @SequentialRef,  
	  @_UserId, @_TopN  
	End
GO
