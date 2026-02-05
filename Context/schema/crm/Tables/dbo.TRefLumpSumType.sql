CREATE TABLE [dbo].[TRefLumpSumType](
	[RefLumpSumTypeId] [int] NOT NULL,
	[TypeName] [varchar](50) NOT NULL
)

ALTER TABLE [dbo].[TRefLumpSumType] ADD CONSTRAINT [PK_TRefLumpSumType] PRIMARY KEY NONCLUSTERED  ([RefLumpSumTypeId])
GO