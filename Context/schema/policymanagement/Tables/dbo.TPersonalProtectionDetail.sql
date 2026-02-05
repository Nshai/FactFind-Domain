CREATE TABLE [dbo].[TPersonalProtectionDetail]
(
[PersonalProtectionDetailId] [int] NOT NULL IDENTITY(1, 1),
[ProtectionId] [int] NOT NULL,
[SumAssured] [decimal] (18, 0) NULL,
[CoverTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_PersonalProtectionDetail_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPersonalProtectionDetail] ADD CONSTRAINT [PK_PersonalProtectionDetail] PRIMARY KEY CLUSTERED  ([PersonalProtectionDetailId])
GO
