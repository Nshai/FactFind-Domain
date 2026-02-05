CREATE TABLE [dbo].[TProviderAudit_NotUsed]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ProviderName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[FeedId] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[FundTypeId] [int] NOT NULL,
[Address_Line_1] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Address_Line_2] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[City] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Country] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Postcode_1] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Postcode_2] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Telephone_Nbr] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Fax_Nbr] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[EmailAddress] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[WebAddress] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_TProviderAudit_UpdatedDate] DEFAULT (getdate()),
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TProviderAudit_CreatedDate] DEFAULT (getdate()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TProviderAudit_ConcurrencyId] DEFAULT ((1)),
[ProviderId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TProviderAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TProviderAudit_NotUsed] ADD CONSTRAINT [PK_TProviderAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
