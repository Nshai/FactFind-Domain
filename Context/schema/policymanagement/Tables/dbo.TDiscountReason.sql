CREATE TABLE [dbo].[TDiscountReason]
(
[DiscountReasonId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Descriptor] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NOT NULL,
[_CreatedByUserId] [int] NULL,
[_CreatedDate] [datetime] NULL,
[_LastUpdatedByUserId] [int] NULL,
[_LastUpdatedDate] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDiscountReason_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TDiscountReason] ADD CONSTRAINT [PK_TDiscountReason] PRIMARY KEY NONCLUSTERED  ([DiscountReasonId]) WITH (FILLFACTOR=80)
GO
