SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomCreateFoldersForLocalBuild]
	@RootDirectory varchar(255)

AS

Select @RootDirectory = IsNull(@RootDirectory,'')
If Len(@RootDirectory) = 0 
Begin
	Raiserror('@RootDirectory not set', 16,1)
	return
End

If Right(@RootDirectory,1) <> '\'
	Select @RootDirectory = @RootDirectory + '\'

Declare @TenantName varchar(1000)
Select @TenantName = 'Stuart Cullinan Inc'
If Not Exists( Select * From Administration..TIndigoClient Where Identifier = @TenantName )
Begin
	Select 'This does not appear to be a development machine'
	Return 
End



Declare @Sql varchar(1000),  @Folder varchar(1000), @Output int

---- Log file for automatching
--Select @Folder = @RootDirectory + 'SqlAgentLogs\AM\'
--Select @Sql = 'IF NOT EXIST ' + @Folder + ' MD ' + @Folder
--exec xp_cmdshell @Sql
--
---- Log file for reports nightly
--Select @Folder = @RootDirectory + 'SqlAgentLogs\ReportsNightly\'
--Select @Sql = 'IF NOT EXIST ' + @Folder + ' MD ' + @Folder
--exec xp_cmdshell @Sql
--
---- Log file for interfaces
--Select @Folder = @RootDirectory + 'SqlAgentLogs\Interfaces\'
--Select @Sql = 'IF NOT EXIST ' + @Folder + ' MD ' + @Folder
--exec xp_cmdshell @Sql

-- Interfaces
Select @Folder = @RootDirectory + 'Interfaces\'

Select @Sql = 'IF EXIST ' + @Folder + ' rmdir /s /q ' + @Folder
exec xp_cmdshell @Sql

Select @Sql = ' MD ' + @Folder
exec @Output = xp_cmdshell @Sql

--Select @Sql
GO
