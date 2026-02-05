CREATE TABLE [dbo].[TRefPensionForecastAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefPensionForecastDescription] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPensionForecastAudit_ConcurrencyId] DEFAULT ((0)),
[RefPensionForecastId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefPensionForecastAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefPensionForecastAudit] ADD CONSTRAINT [PK_TRefPensionForecastAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRefPensionForecastAudit_RefPensionForecastId_ConcurrencyId] ON [dbo].[TRefPensionForecastAudit] ([RefPensionForecastId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
