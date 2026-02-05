CREATE TABLE [dbo].[TRefAcceptanceStatus]
(
[RefAcceptanceStatusId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (8000) COLLATE Latin1_General_CI_AS NOT NULL,
[ShowTimeAs] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefAcceptanceStatus_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefAcceptanceStatus] ADD CONSTRAINT [PK_TRefAcceptanceStatus_RefAcceptanceStatusId] PRIMARY KEY NONCLUSTERED  ([RefAcceptanceStatusId]) WITH (FILLFACTOR=80)
GO
