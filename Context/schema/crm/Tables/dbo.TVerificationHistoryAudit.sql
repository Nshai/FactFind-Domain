CREATE TABLE [dbo].[TVerificationHistoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NULL,
[CRMContactId] [int] NULL,
[VerificationDate] [datetime] NULL,
[VerificationResult] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[AuthenticationId] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ResultDocumentId] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[CertificateDocumentId] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TVerificationHistoryAudit_ConcurrencyId] DEFAULT ((1)),
[VerificationHistoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TVerificationHistoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[VerificationIssuer] [nvarchar](50) NULL,
[VerificationReference] [nvarchar](100) NULL,
[VerificationScore] [nvarchar](50) NULL,
[IsManual] [bit] NULL CONSTRAINT [DF_TVerificationHistoryAudit_IsManual] DEFAULT ((0)),
[CreatedOn] [datetime] NULL, 
[UpdatedOn] [datetime] NULL,   
)
GO
ALTER TABLE [dbo].[TVerificationHistoryAudit] ADD CONSTRAINT [PK_TVerificationHistoryAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TVerificationHistoryAudit_VerificationHistoryId_ConcurrencyId] ON [dbo].[TVerificationHistoryAudit] ([VerificationHistoryId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
