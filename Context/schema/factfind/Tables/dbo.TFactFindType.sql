CREATE TABLE [dbo].[TFactFindType]
(
[FactFindTypeId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[Descriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[CRMContactType] [tinyint] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFactFindType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFactFindType] ADD CONSTRAINT [PK_TFactFindType] PRIMARY KEY NONCLUSTERED  ([FactFindTypeId]) WITH (FILLFACTOR=80)
GO
