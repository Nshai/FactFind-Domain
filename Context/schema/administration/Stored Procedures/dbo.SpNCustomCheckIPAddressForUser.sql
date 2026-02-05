SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpNCustomCheckIPAddressForUser] (@userName varchar(255), @ipaddress varchar(25))
as
begin

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    DECLARE @isValidIpAddressUser bit = 0 
    DECLARE @recordCount bigint = 0
    DECLARE @tenantId bigint = 0
    
    If (@userName Is Not Null And Len(@userName)>0)
		Begin
			
			--Get Tenant Id for User
			Select @tenantId = IndigoClientId
			From administration..TUser u
			Where u.Identifier = @userName
			
			If (@tenantId Is Not Null And @tenantId>0)
			Begin
			
				--Check If Tenant White Ip Address configured
				Select @recordCount = COUNT(tw.TenantWhiteIPAddressConfigId)
				From administration..TTenantWhiteIPAddressConfig tw
				Where tw.TenantId = @tenantId
				And tw.IsArchievd = 0
				
				IF (@recordCount >0)
					Begin
					
					Select @recordCount = 0
					
					Select @recordCount = COUNT(tw.TenantWhiteIPAddressConfigId)
					From administration..TTenantWhiteIPAddressConfig tw
					Where tw.TenantId = @tenantId
					And tw.IsArchievd = 0
					And dbo.FnCustomFormatIpAddress(@ipaddress) 
					Between dbo.FnCustomFormatIpAddress(tw.IPAddressRangeStart) 
					AND dbo.FnCustomFormatIpAddress(tw.IPAddressRangeEnd)
					
					If @recordCount > 0 
						Begin
						 Select @isValidIpAddressUser = 1
						End
					Else
						Begin
						 Select @isValidIpAddressUser = 0
						End
				End
				Else
					Begin
						Select @isValidIpAddressUser = 1
					End
			End
			Else
				Begin
					Select @isValidIpAddressUser = 1
				End
		End
		Else
			Begin
				Select @isValidIpAddressUser = 1
			End
		Select @isValidIpAddressUser as [IsValidIpAddressUser]
End    






GO
