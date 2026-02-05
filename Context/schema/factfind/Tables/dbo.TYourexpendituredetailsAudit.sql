CREATE TABLE [dbo].[TYourexpendituredetailsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Amount] [money] NULL,
[Frequency] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Owner] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Description] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[CRMContactId2] [int] NULL,
[YourexpendituredetailsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TYourexpendituredetailsAudit_ConcurrencyId] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TYourexpendituredetailsAudit] ADD CONSTRAINT [PK_TYourexpendituredetailsAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TYourexpendituredetailsAudit_YourexpendituredetailsId_ConcurrencyId] ON [dbo].[TYourexpendituredetailsAudit] ([YourexpendituredetailsId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
