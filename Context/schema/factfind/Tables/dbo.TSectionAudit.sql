CREATE TABLE [dbo].[TSectionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[Descriptor] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[DataStore] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[DisplayType] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[LockType] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[Path] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[PdfAttributeSet] [varchar] (32) COLLATE Latin1_General_CI_AS NULL,
[Ordinal] [tinyint] NULL,
[NavigationId] [int] NULL,
[IndigoClientId] [int] NULL,
[PdfHide] [bit] NULL,
[PdfOrientation] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSectionAudit_ConcurrencyId] DEFAULT ((1)),
[SectionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TSectionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSectionAudit] ADD CONSTRAINT [PK_TSectionAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
