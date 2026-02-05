SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveAllocatedThemeWithByTenantIdAndIsActive]
	@TenantId bigint,
	@IsActive bit
AS

Select * 
From Administration.dbo.TAllocatedTheme As [AllocatedTheme]
Inner Join Administration.dbo.TTheme As [Theme]
	On [AllocatedTheme].ThemeId = [Theme].ThemeId
Where [AllocatedTheme].TenantId = @TenantId And [AllocatedTheme].IsActive = @IsActive
GO
