CREATE TABLE [dbo].[TUsage]
(
[UsageId] [int] NOT NULL IDENTITY(1, 1),
[Page] [varchar] (500) COLLATE Latin1_General_CI_AS NOT NULL,
[Querystring] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[Timestampe] [datetime] NOT NULL CONSTRAINT [DF_TUsage_Timestampe] DEFAULT (getdate())
)
GO
ALTER TABLE [dbo].[TUsage] ADD CONSTRAINT [PK_TUsage] PRIMARY KEY CLUSTERED  ([UsageId]) WITH (FILLFACTOR=80)
GO
