SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpCustomTransitionRule_CheckConsentDate]
  @PolicyBusinessId BIGINT,
  @ErrorMessage VARCHAR(512) OUTPUT
AS    

	Declare @ClientCount tinyint
	Declare @ClientType varchar(10)
	Declare @Owner1Id Bigint 
	Declare @Owner2Id Bigint 
	Declare @Owner1Name Varchar(255) 
	Declare @Owner2Name Varchar(255)
	Declare @Valid1 INT = 0
    Declare @Valid2 INT = 0
	declare @Owner1ConsentDate Datetime  
	declare @Owner2ConsentDate Datetime  

	EXEC spCustomTansitionRuleGetOwners @PolicyBusinessId, 
										@ClientCount OUTPUT, @ClientType OUTPUT,
										@Owner1Id OUTPUT, @Owner1Name OUTPUT, 
										@Owner2Id OUTPUT, @Owner2Name OUTPUT
	SELECT @Owner1ConsentDate = ConsentDate FROM crm.dbo.TMarketing
	Where CRMContactId = @Owner1Id
    SELECT @Owner2ConsentDate = ConsentDate FROM crm.dbo.TMarketing
	Where CRMContactId = @Owner2Id
	
	IF (@Owner1ConsentDate IS NOT NULL)
	BEGIN
		SET @Valid1 = 1
	END  
	IF (@Owner2ConsentDate IS NOT NULL)
	BEGIN
		SET @Valid2 = 1
	END  

    IF (@Valid1 = 0)
        SET @ErrorMessage = 'OWNER1';
    IF (@Valid2 = 0 and @Owner2Id is not null and @Valid1 > 0)
        SET @ErrorMessage = 'OWNER2';
    IF (@Valid2 = 0 and @Owner2Id is not null and @Valid1 = 0)
        SET @ErrorMessage = 'OWNER1+OWNER2';
	
 --Add Owner Data for side bar link generator
    IF(LEN(ISNULL(@ErrorMessage, '')) > 0)
	BEGIN	
		SET @ErrorMessage = @ErrorMessage + '_::Owner1Id=' + CONVERT(varchar(50), ISNULL(@Owner1Id,''))
                                          + '::Owner1Name=' + CONVERT(varchar(255), ISNULL(@Owner1Name,''))
                                          + '::Owner2Id=' + CONVERT(varchar(50), ISNULL(@Owner2Id,''))
                                          + '::Owner2Name=' + CONVERT(varchar(255), ISNULL(@Owner2Name,''))
										  + '::PlanId=' + CONVERT(varchar(20),@PolicyBusinessId);
	END  