CREATE TABLE [dbo].[TRefInsuranceClaimType]
(
[RefInsuranceClaimTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefInsuranceClaimType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefInsuranceClaimType] ADD CONSTRAINT [PK_TRefInsuranceClaimType] PRIMARY KEY CLUSTERED  ([RefInsuranceClaimTypeId])
GO
