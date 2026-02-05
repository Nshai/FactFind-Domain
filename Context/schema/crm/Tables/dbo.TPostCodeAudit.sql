CREATE TABLE [dbo].[TPostCodeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[PostCodeShortName] [varchar] (4) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_TPostCodeAudit_PostCodeShortName] DEFAULT (' '),
[LatitudeX] [decimal] (18, 8) NOT NULL CONSTRAINT [DF_TPostCodeAudit_LatitudeX] DEFAULT ((0)),
[LongitudeY] [decimal] (18, 8) NOT NULL CONSTRAINT [DF_TPostCodeAudit_LongitudeY] DEFAULT ((0)),
[IsSystemAdded] [bit] NOT NULL CONSTRAINT [DF_TPostCodeAudit_IsSystemAdded] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPostCodeAudit_ConcurrencyId] DEFAULT ((1)),
[PostCodeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPostCodeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPostCodeAudit] ADD CONSTRAINT [PK_TPostCodeAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
