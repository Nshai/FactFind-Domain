SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpNCustomRetrieveActiveIndigoClients]  
as  
  
Select * from TIndigoClient where status='active'
order by identifier asc
GO
