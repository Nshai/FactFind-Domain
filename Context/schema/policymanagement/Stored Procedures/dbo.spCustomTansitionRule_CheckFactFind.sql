SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[spCustomTansitionRule_CheckFactFind] 
	@Owner1Id bigint, 
	@Owner2Id bigint = null, 
	@Owner1Name varchar(150), 
	@Owner2Name varchar(150)= null,
	@ClientCount int,
	@FactFindId bigint OUTPUT, 
	@FactFindPrimaryOwnerId bigint OUTPUT,
	@ErrorMessage varchar(max) OUTPUT
AS

--Get the fact find details
Exec spCustomTansitionRuleGetFactFind @Owner1Id, @Owner2Id, @FactFindId OUTPUT, @FactFindPrimaryOwnerId OUTPUT
	
	--IF NO FACT FIND FOUND
	If ISNULL(@FactFindId, 0) = 0
	Begin	
		If @ClientCount = 1
		Begin
			SELECT @ErrorMessage = 'FACTFINDREQUIRED_' + 
				'Owner1Id=' + CONVERT(varchar(20),@Owner1Id) + '::'+  
				'Owner1Name=' + @Owner1Name
				
			RETURN			
		End
		
		If @ClientCount > 1
		Begin
			SELECT @ErrorMessage = 'JOINTFACTFINDREQUIRED_' + 
				'Owner1Id=' + CONVERT(varchar(20),@Owner1Id) + '::'+  
				'Owner1Name=' + @Owner1Name + '::'+  
				'Owner2Id=' + CONVERT(varchar(20),@Owner2Id) + '::'+  
				'Owner2Name=' + @Owner2Name
				
			RETURN		
		End	
		
	End
