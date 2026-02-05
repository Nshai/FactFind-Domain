SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VPlanActionHistory]  
  
AS  
  
SELECT  
 pah.*,  
 u.CRMContactId As ChangedByCRMContactId  
FROM PolicyManagement.dbo.TPlanActionHistory pah  
left JOIN Administration.dbo.TUser u ON pah.ChangedByUserId = u.UserId  




GO
