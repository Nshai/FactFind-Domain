SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spCustomDeletePolicyBusinessCache] @PolicyBusinessId bigint  
AS  

return
  
--Delete From TpolicyBusinessCache where PolicyBusinessId=@PolicyBusinessId  
GO
