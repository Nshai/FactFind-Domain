CREATE TABLE [dbo].[TProductAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RequestXmlMappingId] [int] NULL,
[ResponseXmlMappingId] [int] NULL,
[ProductConnectionSettingId] [int] NULL,
[ProdSubTypeId] [int] NULL,
[VersionNumber] [int] NULL,
[ProductName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[ExpiryDate] [datetime] NULL,
[DateUpdated] [datetime] NULL,
[Extensible] [char] (10) COLLATE Latin1_General_CI_AS NULL,
[PacId] [int] NULL,
[QVTStageId] [int] NULL,
[NBProductId] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[AppDocVersionId] [int] NULL,
[ProductId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TProductAu_StampDateTime_1__76] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TProductAudit] ADD CONSTRAINT [PK_TProductAudit_2__76] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TProductAudit_ProductId_ConcurrencyId] ON [dbo].[TProductAudit] ([ProductId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
