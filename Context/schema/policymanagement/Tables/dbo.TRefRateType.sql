CREATE TABLE [dbo].[TRefRateType]
(
[RefRateTypeId] int NOT NULL IDENTITY(1,1),
[Name] varchar(50) NULL
)
GO

ALTER TABLE [dbo].[TRefRateType] 
ADD CONSTRAINT [PK_TRefRateType] 
PRIMARY KEY NONCLUSTERED  ([RefRateTypeId])
GO
