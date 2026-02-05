CREATE TABLE [dbo].[TRefUnitType]
(
[RefUnitTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[UnitType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [bit] NULL CONSTRAINT [DF_TRefUnitType_RetireFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefUnitType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefUnitType] ADD CONSTRAINT [PK_TRefUnitType] PRIMARY KEY NONCLUSTERED  ([RefUnitTypeId]) WITH (FILLFACTOR=80)
GO
