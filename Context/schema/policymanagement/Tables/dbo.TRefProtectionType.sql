CREATE TABLE [dbo].[TRefProtectionType]
(
[RefProtectionTypeId] int NOT NULL IDENTITY(1,1),
[Name] varchar(50) NULL
)
GO

ALTER TABLE [dbo].[TRefProtectionType] 
ADD CONSTRAINT [PK_TRefProtectionType] 
PRIMARY KEY NONCLUSTERED  ([RefProtectionTypeId])
GO
