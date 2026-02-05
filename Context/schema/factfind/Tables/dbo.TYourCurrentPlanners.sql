CREATE TABLE [dbo].[TYourCurrentPlanners]
(
[YourCurrentPlannersId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Type] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Name] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ContactNumber] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Address] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TYourCurr__Concu__6C23FBB3] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TYourCurrentPlanners_CRMContactId] ON [dbo].[TYourCurrentPlanners] ([CRMContactId])
GO
