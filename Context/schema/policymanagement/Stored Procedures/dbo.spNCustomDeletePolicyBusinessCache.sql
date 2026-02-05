SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[spNCustomDeletePolicyBusinessCache] @PolicyBusinessId bigint
AS

Delete From TpolicyBusinessCache where PolicyBusinessId = @PolicyBusinessId

GO
