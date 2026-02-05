CREATE TABLE [dbo].[TAssetNotesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EquityAvailableYN] [bit] NULL,
[EquityAvailableDetails] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[AssetNotesId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TAssetNot__Concu__681E60A5] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAssetNotesAudit] ADD CONSTRAINT [PK_TAssetNotesAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
