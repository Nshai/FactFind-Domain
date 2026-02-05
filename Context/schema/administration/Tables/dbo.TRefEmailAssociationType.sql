CREATE TABLE [dbo].[TRefEmailAssociationType]
(
[RefEmailAssociationTypeId] [int] NOT NULL IDENTITY(1, 1),
[AssociationTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefEmailAssociationType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefEmailAssociationType] ADD CONSTRAINT [PK_TRefEmailAssociationType] PRIMARY KEY CLUSTERED  ([RefEmailAssociationTypeId])
GO
