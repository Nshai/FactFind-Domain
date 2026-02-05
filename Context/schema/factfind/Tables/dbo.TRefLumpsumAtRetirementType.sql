CREATE TABLE [dbo].[TRefLumpsumAtRetirementType](
	[RefLumpsumAtRetirementTypeId] [int] IDENTITY(1,1) NOT NULL,
	[TypeName] [varchar](50) NOT NULL
)

ALTER TABLE [dbo].[TRefLumpsumAtRetirementType] ADD CONSTRAINT [PK_TRefLumpsumAtRetirementType] PRIMARY KEY NONCLUSTERED  ([RefLumpsumAtRetirementTypeId])
GO
