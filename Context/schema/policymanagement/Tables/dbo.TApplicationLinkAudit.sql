CREATE TABLE [dbo].[TApplicationLinkAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[RefApplicationId] [int] NOT NULL,
[MaxLicenceCount] [int] NULL,
[CurrentLicenceCount] [int] NULL,
[AllowAccess] [bit] NOT NULL CONSTRAINT [DF_TApplicationLinkAudit_AllowAccess] DEFAULT ((0)),
[WealthLinkEnabled] [bit] NOT NULL CONSTRAINT [DF_TApplicationLinkAudit_WealthLinkEnabled] DEFAULT ((0)),
[ExtranetURL] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ReferenceCode] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TApplicationLinkAudit_ConcurrencyId] DEFAULT ((1)),
[ApplicationLinkId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TApplicationLinkAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IntegratedSystemConfigRole] [int] NULL,
[SystemArchived] [bit] NOT NULL CONSTRAINT [DF_TApplicationLinkAudit_SystemArchived] DEFAULT(0)
)
GO
ALTER TABLE [dbo].[TApplicationLinkAudit] ADD CONSTRAINT [PK_TApplicationLinkAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
