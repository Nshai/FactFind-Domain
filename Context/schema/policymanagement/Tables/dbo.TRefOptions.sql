CREATE TABLE [dbo].[TRefOptions]
(
[RefOptionsId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefOptionsName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RetireFg] [bit] NOT NULL CONSTRAINT [DF_TRefOptions_RetireFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefOptions_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefOptions] ADD CONSTRAINT [PK_TRefOptions] PRIMARY KEY NONCLUSTERED  ([RefOptionsId]) WITH (FILLFACTOR=80)
GO
