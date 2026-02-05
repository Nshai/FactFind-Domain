CREATE TABLE [dbo].[TRefChangeBasisType]
(
[RefChangeBasisTypeId] [int] NOT NULL IDENTITY(1, 1),
[ChangeBasisTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[OrigoRef] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RetireFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefChange_ConcurrencyId_1__63] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefChangeBasisType] ADD CONSTRAINT [PK_TRefChangeBasisType_2__63] PRIMARY KEY NONCLUSTERED  ([RefChangeBasisTypeId]) WITH (FILLFACTOR=80)
GO
