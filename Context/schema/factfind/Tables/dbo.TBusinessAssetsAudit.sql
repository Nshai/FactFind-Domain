CREATE TABLE [dbo].[TBusinessAssetsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Property] [money] NULL,
[Equipment] [money] NULL,
[Vehicles] [money] NULL,
[BankAndBuilding] [money] NULL,
[OtherInvestments] [money] NULL,
[TotalAssets] [money] NULL,
[Notes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[BusinessAssetsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TBusinessAssetsAudit__ConcurrencyId] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TBusinessAssetsAudit] ADD CONSTRAINT [PK_TBusinessAssetsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
