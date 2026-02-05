CREATE TABLE [dbo].[TExpectations]
(
[ExpectationsId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NULL,
[FeeId] [int] NOT NULL,
[Date] [datetime] NULL,
[NetAmount] [decimal] (18, 2) NOT NULL,
[TotalAmount] [decimal] (18, 2) NOT NULL,
[CalculatedAmount] [decimal] (18, 2) NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TExpectations_ConcurrencyId] DEFAULT ((1)),
[IsManual] [bit] NOT NULL CONSTRAINT [DF_TExpectations_IsManual] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TExpectations] ADD CONSTRAINT [PK_TExpectations] PRIMARY KEY CLUSTERED  ([ExpectationsId])
GO
CREATE NONCLUSTERED INDEX [IX_Expectations_Fee] ON [dbo].[TExpectations] ([FeeId])
GO
CREATE NONCLUSTERED INDEX [IX_Expectations_PolicyBusiness] ON [dbo].[TExpectations] ([PolicyBusinessId])
GO
CREATE NONCLUSTERED INDEX [IX_Expectations_Tenant] ON [dbo].[TExpectations] ([TenantId])
GO
ALTER TABLE [dbo].[TExpectations] ADD CONSTRAINT [FK_TExpectations_TFee] FOREIGN KEY ([FeeId]) REFERENCES [dbo].[TFee] ([FeeId])
GO
create index IX_TExpectations_PolicyBusinessId_FeeId_TenantId on TExpectations (PolicyBusinessId,FeeId,TenantId) include (Date,NetAmount,TotalAmount,CalculatedAmount,ConcurrencyId) 
GO