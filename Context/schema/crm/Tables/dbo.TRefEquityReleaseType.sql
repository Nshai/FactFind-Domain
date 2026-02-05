CREATE TABLE [dbo].[TRefEquityReleaseType]
(
[RefEquityReleaseTypeId] [int] NOT NULL IDENTITY(1, 1),
[EquityReleaseType] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefEquityReleaseType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefEquityReleaseType] ADD CONSTRAINT [PK_TRefEquityReleaseType] PRIMARY KEY NONCLUSTERED  ([RefEquityReleaseTypeId]) WITH (FILLFACTOR=80)
GO
CREATE UNIQUE CLUSTERED INDEX [IDX_UNQ_TRefEquityReleaseType_RefEquityReleaseTypeId] ON [dbo].[TRefEquityReleaseType] ([RefEquityReleaseTypeId]) WITH (FILLFACTOR=80)
GO