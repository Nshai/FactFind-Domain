CREATE TABLE [dbo].[CalMonth]
(
[MonthID] [int] NOT NULL IDENTITY(1, 1),
[MonthStart] [datetime] NULL,
[NextMonth] [datetime] NULL,
[MonthDescr] [char] (6) COLLATE Latin1_General_CI_AS NULL,
[MonthName] [char] (3) COLLATE Latin1_General_CI_AS NULL,
[YearMonth] [int] NULL,
[MonthNum] [int] NULL
)
GO
ALTER TABLE [dbo].[CalMonth] ADD CONSTRAINT [PK_CalMonth] PRIMARY KEY CLUSTERED  ([MonthID]) WITH (FILLFACTOR=100)
GO
CREATE UNIQUE NONCLUSTERED INDEX [CalMonth_Dates] ON [dbo].[CalMonth] ([MonthStart], [NextMonth]) INCLUDE ([MonthDescr]) WITH (FILLFACTOR=100)
GO
