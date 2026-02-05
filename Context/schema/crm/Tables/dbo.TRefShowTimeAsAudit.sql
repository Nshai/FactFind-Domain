CREATE TABLE [dbo].[TRefShowTimeAsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Color] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[FreeFG] [bit] NOT NULL,
[IndClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefShowTimeAsId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefShowTi_StampDateTime_1__51] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefShowTimeAsAudit] ADD CONSTRAINT [PK_TRefShowTimeAsAudit_2__51] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefShowTimeAsAudit_RefShowTimeAsId_ConcurrencyId] ON [dbo].[TRefShowTimeAsAudit] ([RefShowTimeAsId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
