CREATE TABLE [dbo].[TKfi]
(
[KfiId] [int] NOT NULL IDENTITY(1, 1),
[KfiGroupId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[QuoteMortgageSourceId] [int] NOT NULL,
[Status] [varchar] (32) COLLATE Latin1_General_CI_AS NULL,
[XmlSentId] [int] NULL,
[XmlResponseId] [int] NULL,
[KfiDocVersionId] [int] NULL,
[ComplianceSummaryDocVersionId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TKfi_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TKfi] ADD CONSTRAINT [PK_TKfi] PRIMARY KEY NONCLUSTERED  ([KfiId])
GO
