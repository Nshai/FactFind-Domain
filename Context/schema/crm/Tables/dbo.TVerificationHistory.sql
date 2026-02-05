CREATE TABLE [dbo].[TVerificationHistory]
(
[VerificationHistoryId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[UserId] [int] NULL,
[CRMContactId] [int] NULL,
[VerificationDate] [datetime] NULL,
[VerificationResult] [varchar] (MAX) COLLATE Latin1_General_CI_AS NULL,
[AuthenticationId] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ResultDocumentId] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[CertificateDocumentId] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TVerificationHistory_ConcurrencyId] DEFAULT ((1)),
[VerificationIssuer] [nvarchar](50) NULL,
[VerificationReference] [nvarchar](100) NULL,
[VerificationScore] [nvarchar](50) NULL,
[IsManual] [bit] NOT NULL CONSTRAINT [DF_TVerificationHistory_IsManual] DEFAULT ((0)),
[CreatedOn] [datetime] NULL, 
[UpdatedOn] [datetime] NULL,   
)
GO
ALTER TABLE [dbo].[TVerificationHistory] ADD CONSTRAINT [PK_TVerificationHistory] PRIMARY KEY NONCLUSTERED  ([VerificationHistoryId])
GO
CREATE NONCLUSTERED INDEX [IX_TVerificationHistory_CRMContactId] ON [dbo].[TVerificationHistory] ([CRMContactId])
GO
