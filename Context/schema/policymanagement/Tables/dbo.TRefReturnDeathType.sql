CREATE TABLE [dbo].[TRefReturnDeathType]
(
[RefReturnDeathTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefReturnDeathTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [bit] NOT NULL CONSTRAINT [DF_TRefReturnDeathType_RetireFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefReturnDeathType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefReturnDeathType] ADD CONSTRAINT [PK_TRefReturnDeathType] PRIMARY KEY NONCLUSTERED  ([RefReturnDeathTypeId]) WITH (FILLFACTOR=80)
GO
