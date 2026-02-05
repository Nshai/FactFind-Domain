CREATE TABLE [dbo].[TRefPFPSecureMessageStatus]
(
[RefPFPSecureMessageStatusId] [int] NOT NULL IDENTITY(1, 1),
[StatusName] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPFPSecureMessageStatus_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefPFPSecureMessageStatus] ADD CONSTRAINT [PK_TRefPFPSecureMessageStatus] PRIMARY KEY CLUSTERED  ([RefPFPSecureMessageStatusId])
GO
