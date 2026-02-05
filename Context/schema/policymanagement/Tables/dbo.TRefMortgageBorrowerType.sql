CREATE TABLE [dbo].[TRefMortgageBorrowerType]
(
[RefMortgageBorrowerTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[MortgageBorrowerType] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefMortgageBorrowerType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefMortgageBorrowerType] ADD CONSTRAINT [PK_TRefMortgageBorrowerType] PRIMARY KEY CLUSTERED  ([RefMortgageBorrowerTypeId]) WITH (FILLFACTOR=80)
GO
