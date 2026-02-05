CREATE TABLE [dbo].[TFullQuotePropertyDetailsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FullQuoteId] [int] NOT NULL,
[PropertytobeMortgagedId] [int] NULL,
[HouseType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PropertyType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Bedrooms] [int] NULL,
[DiningRooms] [int] NULL,
[AdditionalRooms] [int] NULL,
[Kitchens] [int] NULL,
[Bathrooms] [int] NULL,
[numfloors] [int] NULL,
[FloorInBlock] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[FlatsInBlock] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[TenureType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Walls] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Roof] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TFullQuotePropertyDetailsAudit_ConcurrencyId] DEFAULT ((1)),
[FullQuotePropertyDetailsId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFullQuotePropertyDetailsAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFullQuotePropertyDetailsAudit] ADD CONSTRAINT [PK_TFullQuotePropertyDetailsAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFullQuotePropertyDetailsAudit_FullQuotePropertyDetailsId_ConcurrencyId] ON [dbo].[TFullQuotePropertyDetailsAudit] ([FullQuotePropertyDetailsId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
