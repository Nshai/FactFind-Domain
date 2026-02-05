CREATE TABLE [dbo].[TCRMContactExt]
(
[CRMContactExtId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[CreditedGroupId] [int] NULL,
[ExternalSystemId] [int] NULL,
[ExternalId] [varchar] (100) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCRMContactExt_ConcurrencyId] DEFAULT ((1)),
[ExternalSystem] [varchar] (100) NULL,
[ServicingAdminUserId] [int] NULL,
[ParaplannerUserId] [int] NULL,
[ReportFrequency] [int] NULL,
[ReportStartDate] [datetime] NULL,
[ClientServicingDeliveryMethod] [varchar] (50) NULL,
[TaxReferenceNumber] [varchar](50) NULL,
[IsTargetMarket] [bit] NULL,
[TargetMarketExplanation] [varchar](250) NULL,
[DateClientRestricted] [datetime] NULL
)
GO
ALTER TABLE [dbo].[TCRMContactExt] ADD CONSTRAINT [PK_TCRMContactExt] PRIMARY KEY CLUSTERED  ([CRMContactExtId])
GO
CREATE NONCLUSTERED INDEX [IX_TCRMContactExt_CRMContactId] ON [dbo].[TCRMContactExt] ([CRMContactId])
GO
ALTER TABLE [dbo].[TCRMContactExt] WITH CHECK ADD CONSTRAINT [FK_TCRMContactExt_TCRMContact] FOREIGN KEY ([CRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
